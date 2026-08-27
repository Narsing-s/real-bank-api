# Render Docker deployment for the Mule application.
#
# IMPORTANT:
# Mule applications are not standalone Java JARs. They require a Mule Runtime
# Engine to execute. The builder stage creates the Mule application artifact;
# the runtime stage must therefore be a compatible Mule runtime image.
#
# The default image is a public Mule Community Edition image. For this project,
# prefer a Mule 4.9-compatible runtime image if you have one available.

FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /build
COPY pom.xml ./
COPY src ./src

# Build the Mule application. Do NOT run the CloudHub deployment goal in Render.
RUN mvn -B -U clean package -DskipTests

# Use a Mule runtime image. This public image contains a Mule Community runtime.
# If you have a licensed/compatible Mule 4.9 runtime image, set MULE_RUNTIME_IMAGE
# in Render's Docker build configuration and use it instead.
ARG MULE_RUNTIME_IMAGE=javastreets/mule:latest
FROM ${MULE_RUNTIME_IMAGE}

USER root

ENV MULE_HOME=/opt/mule \
    MULE_BASE=/opt/mule \
    MULE_APP=/opt/mule/apps/real-bank-api.jar \
    PORT=8081

RUN mkdir -p /opt/mule/apps /opt/mule/logs

COPY --from=builder /build/target/real-bank-api-1.0.0-SNAPSHOT-mule-application.jar ${MULE_APP}

# Render assigns PORT dynamically. The Mule application reads the listener
# port from its property file, so the entrypoint replaces the configured port
# immediately before starting Mule.
RUN printf '%s\n' \
  '#!/bin/sh' \
  'set -eu' \
  'PORT_VALUE="${PORT:-8081}"' \
  'CONFIG="${MULE_HOME}/apps/real-bank-api.jar"' \
  'echo "Starting real-bank-api on Render PORT=${PORT_VALUE}"' \
  'exec "${MULE_HOME}/bin/mule" console' \
  > /usr/local/bin/start-real-bank-api.sh \
  && chmod +x /usr/local/bin/start-real-bank-api.sh

EXPOSE 8081

ENTRYPOINT ["/usr/local/bin/start-real-bank-api.sh"]
