# Mule Runtime 4.9 / Java 17 runtime image for Render
# IMPORTANT: set MULE_HOME and provide a Mule runtime distribution in the build context.
FROM eclipse-temurin:17-jre

ENV MULE_HOME=/opt/mule \
    MULE_APP=/opt/mule/apps/real-bank-api.jar \
    MULE_LOG=/opt/mule/logs

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates unzip \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /opt/mule/apps /opt/mule/logs

# Render builds the Mule application with Maven and copies the resulting artifact here.
COPY target/real-bank-api-1.0.0-SNAPSHOT-mule-application.jar ${MULE_APP}

# Mule application HTTP listener must use Render's PORT when configured in the app.
EXPOSE 10000

CMD ["sh", "-c", "echo 'Mule application artifact found:' ${MULE_APP}; echo 'A Mule 4.9 runtime is required to launch this artifact.'; test -f ${MULE_APP}; exit 1"]
