# Render deployment for real-bank-api
# Builds the Mule application in Docker, then runs it with a Mule runtime.

# IMPORTANT: ARG used by FROM must be declared before the first FROM.
ARG MULE_RUNTIME_IMAGE=javastreets/mule:latest

FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /build

COPY pom.xml ./
COPY src ./src

# Build the Mule application only. Do NOT invoke the CloudHub deployment goal.
RUN mvn -B -U clean package -DskipTests

FROM ${MULE_RUNTIME_IMAGE}

USER root

ENV MULE_HOME=/opt/mule \
    MULE_BASE=/opt/mule

RUN mkdir -p /opt/mule/apps /opt/mule/logs

COPY --from=builder /build/target/real-bank-api-1.0.0-SNAPSHOT-mule-application.jar /opt/mule/apps/real-bank-api.jar

# Render supplies PORT at runtime. Pass application properties through
# environment variables so no credentials are stored in Git.
RUN cat > /usr/local/bin/start-real-bank-api.sh <<'EOF'
#!/bin/sh
set -eu

PORT_VALUE="${PORT:-8081}"

exec "${MULE_HOME}/bin/mule" console \
  -M-Dhttp.listner.host=0.0.0.0 \
  -M-Dhttp.listner.port="${PORT_VALUE}" \
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
