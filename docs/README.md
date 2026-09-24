# Documentation

This folder contains the documentation for **real-bank-api**.

## Documents

- [Requirements Document](./requirements.md) — business, functional, API, data, integration, security, and operational requirements derived from the current repository.
- [Architecture](./architecture.md) — high-level MuleSoft/API-led architecture and the role of the frontend, APIKit, Snowflake, email, and external messaging integrations.
- [API Reference](./api-reference.md) — endpoint inventory based on the RAML contract and current implementation structure.
- [Diagrams](./diagrams.md) — quick-reference architecture, account-creation, and deployment diagrams.
- [Testing Guide](./testing.md) — documentation-only test matrix, regression checklist, and test evidence guidance.
- [Configuration & Deployment](./configuration.md) — runtime, environment-variable, deployment-artifact, and verification reference.
- [Troubleshooting](./troubleshooting.md) — common API, integration, frontend, and deployment troubleshooting paths.
- [Glossary](./glossary.md) — simple explanations of project and MuleSoft terms.

## Source of truth

The RAML contract at `src/main/resources/api/real-bank-api.raml` defines the public API contract. The Mule XML flows under `src/main/mule` implement the API behavior.

The documents in this folder describe the repository as it exists; they do not replace the RAML contract or implementation.

All additions in this folder are documentation-only and do not change application code.
