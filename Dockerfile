# Render deployment for real-bank-api
# Build the Mule application in Docker, then run the packaged application.

ARG MULE_RUNTIME_IMAGE=javastreets/mule:latest

FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /build

# Mule Maven Plugin requires mule-artifact.json at the project root.
COPY pom.xml ./
COPY mule-artifact.json ./
COPY src ./src

# Build only. No CloudHub/Anypoint deployment is performed in Render.
RUN mvn -B -U clean package -DskipTests

FROM ${MULE_RUNTIME_IMAGE}

USER root

ENV MULE_HOME=/opt/mule \
    MULE_BASE=/opt/mule

RUN mkdir -p /opt/mule/apps /opt/mule/logs

COPY --from=builder /build/target/real-bank-api-1.0.0-SNAPSHOT-mule-application.jar /opt/mule/apps/real-bank-api.jar

RUN cat > /usr/local/bin/start-real-bank-api.sh <<'EOF'
#!/bin/sh
set -eu

PORT_VALUE="${PORT:-8081}"

# Keep the JVM inside Render's small container memory budget.
# Mule has a substantial runtime footprint, so cap heap/metaspace and use SerialGC.
export MULE_JAVA_OPTS="${MULE_JAVA_OPTS:-} -Xms128m -Xmx256m -XX:MaxMetaspaceSize=96m -XX:ReservedCodeCacheSize=32m -XX:+UseSerialGC"

exec "${MULE_HOME}/bin/mule" console \
  -M-Dhttp.listener.host=0.0.0.0 \
  -M-Dhttp.listener.port="${PORT_VALUE}" \
  -M-Ddb.sf.name="${DB_SF_NAME:-}" \
  -M-Ddb.sf.warehouse="${DB_SF_WAREHOUSE:-}" \
  -M-Ddb.sf.database="${DB_SF_DATABASE:-}" \
  -M-Ddb.sf.schema="${DB_SF_SCHEMA:-}" \
  -M-Ddb.sf.user="${DB_SF_USER:-}" \
  -M-Ddb.sf.password="${DB_SF_PASSWORD:-}" \
  -M-Ddb.sf.role="${DB_SF_ROLE:-}" \
  -M-Demail.host="${EMAIL_HOST:-smtp.gmail.com}" \
  -M-Demail.port="${EMAIL_PORT:-587}" \
  -M-Demail.username="${EMAIL_USERNAME:-}" \
  -M-Demail.password="${EMAIL_PASSWORD:-}"
EOF

RUN chmod +x /usr/local/bin/start-real-bank-api.sh

EXPOSE 8081
ENTRYPOINT ["/usr/local/bin/start-real-bank-api.sh"]
