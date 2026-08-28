# Render deployment for real-bank-api
# Build the Mule application in Docker, then run the packaged application.

ARG MULE_RUNTIME_IMAGE=javastreets/mule:latest

FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /build

COPY pom.xml ./
COPY mule-artifact.json ./
COPY src ./src

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

# Render supplies PORT for Web Services. Mule must bind to all interfaces.
PORT_VALUE="${PORT:-10000}"

# Keep the JVM bounded on small Render instances. Mule also needs native,
# thread and class metadata memory, so the Java heap is intentionally kept
# well below the container limit.
export MULE_JAVA_OPTS="${MULE_JAVA_OPTS:-} -Xms64m -Xmx96m -Xss192k -XX:MaxMetaspaceSize=48m -XX:CompressedClassSpaceSize=12m -XX:ReservedCodeCacheSize=8m -XX:MaxDirectMemorySize=16m -XX:+UseSerialGC -XX:+UseContainerSupport"

# Render health/port detection requires a listener on 0.0.0.0 and the
# dynamically supplied PORT. All application configuration remains external.
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

# Documentation/default only; Render's PORT is the actual listener port.
EXPOSE 10000
ENTRYPOINT ["/usr/local/bin/start-real-bank-api.sh"]
