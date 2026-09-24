# Configuration and Deployment Reference

This document describes the repository's configuration and deployment boundaries without modifying application configuration.

## Runtime

- Mule Runtime: 4.9.0
- Java: 17
- API contract: RAML 1.0
- API routing: Mule APIKit
- Primary backend data integration: Snowflake
- Email integration: SMTP/email configuration

## Environment Variables

### Snowflake

- `DB_SF_NAME`
- `DB_SF_WAREHOUSE`
- `DB_SF_DATABASE`
- `DB_SF_SCHEMA`
- `DB_SF_USER`
- `DB_SF_PASSWORD`
- `DB_SF_ROLE`

### Email

- `EMAIL_USERNAME`
- `EMAIL_PASSWORD`

Use deployment secrets for real values. Never put passwords or tokens in documentation.

## Deployment Artifacts

| File | Purpose |
|---|---|
| `Dockerfile` | Container build definition |
| `render.yaml` | Render deployment definition |
| `pom.xml` | Maven build and Mule deployment configuration |
| `mule-artifact.json` | Mule application metadata |
| `.github/workflows/blank.yml` | Repository workflow configuration |

## Pre-Deployment Checklist

1. Required environment variables are present.
2. Database connectivity is available.
3. SMTP/email configuration is available.
4. External messaging dependencies required by the assistance flow are available.
5. HTTP port/base URL settings match the hosting platform.
6. API health endpoint is reachable.

## Post-Deployment Verification

1. Call `GET /health`.
2. Verify the API base path.
3. Verify a safe read operation.
4. Verify database connectivity.
5. Verify notification/email integration when required.
6. Verify frontend-to-API connectivity.
7. Review application logs for startup or dependency errors.

This document describes configuration boundaries only; it does not change deployment configuration.
