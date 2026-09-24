# Real Bank API

A MuleSoft-based banking API with a responsive frontend, Snowflake integration, account and transaction operations, notification flows, and deployment configuration.

## What is in this repository?

- MuleSoft API built with Mule Runtime 4.9.0 and Java 17.
- RAML 1.0 API contract with APIKit routing.
- Account creation, lookup, filtering, update, and deactivation.
- Deposit, withdrawal, and transaction-history operations.
- Automatic account-number generation.
- Snowflake-backed data processing.
- Email notification flows.
- WhatsApp assistance flow.
- Responsive static frontend.
- Docker and Render deployment configuration.
- CloudHub 2 deployment configuration through Maven.

## API

The API is routed under `/api`.

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/health` | Health check |
| POST | `/api/accounts` | Create account |
| GET | `/api/accounts` | List/filter accounts |
| GET | `/api/accounts/{accountNumber}` | Get account |
| PATCH | `/api/accounts/{accountNumber}` | Update account |
| DELETE | `/api/accounts/{accountNumber}` | Deactivate account |
| POST | `/api/accounts/{accountNumber}/deposit` | Deposit |
| POST | `/api/accounts/{accountNumber}/withdraw` | Withdraw |
| GET | `/api/accounts/{accountNumber}/transactions` | Transaction history |
| POST | `/api/assistance/whatsapp` | WhatsApp assistance |

The authoritative API contract is [real-bank-api.raml](src/main/resources/api/real-bank-api.raml).

## Frontend

The existing responsive frontend is under [frontend/](frontend/).

It includes:

- Dashboard/account summary
- Account search and ACTIVE/INACTIVE filtering
- Account details
- Account creation
- Deposit and withdrawal
- Transaction/mini-statement view
- Banking assistant
- Mobile-responsive UI

The frontend README documents the API-base configuration.

## Project structure

```text
real-bank-api/
├── .github/                  # GitHub workflows
├── docs/                     # Project documentation
├── exchange-docs/            # Anypoint Exchange documentation
├── frontend/                 # Static responsive frontend
├── src/
│   ├── main/
│   │   ├── mule/             # Mule flows and integrations
│   │   └── resources/
│   │       ├── api/           # RAML contract
│   │       ├── config_properties/
│   │       ├── static/
│   │       └── weave/
│   └── test/                 # Test resources
├── Dockerfile
├── mule-artifact.json
├── pom.xml
├── render.yaml
└── README.md
```

## Documentation

Start with the [Documentation index](docs/README.md).

Key documents:

- [Requirements](docs/requirements.md)
- [Architecture](docs/architecture.md)
- [Diagrams](docs/diagrams.md)
- [API Reference](docs/api-reference.md)
- [Testing Guide](docs/testing.md)
- [Configuration & Deployment](docs/configuration.md)
- [Troubleshooting](docs/troubleshooting.md)
- [Glossary](docs/glossary.md)

The requirements document is derived from the current RAML, Mule flows, frontend, deployment configuration, and project metadata. The documentation does not replace the implementation.

## Runtime and deployment

The project declares:

- Mule Runtime: 4.9.0
- Java: 17

The repository includes:

- `Dockerfile` for container deployment.
- `render.yaml` for Render frontend/API services.
- Mule Maven configuration for CloudHub 2 deployment.

Database, email, and external-service credentials are expected to be supplied through environment configuration.

## Local API

The Mule HTTP listener is configured through the application's properties. The frontend documentation uses:

`http://localhost:8081/api`

as its default API base.

## Important

This is a software project that models banking operations. The documentation describes the current repository behavior and should not be interpreted as a statement that the application provides every control required for a regulated production banking system.

## Documentation-only additions

The files under `docs/` are documentation artifacts. No Mule flow, RAML contract, frontend source, deployment file, or other application code is changed by adding or updating these documents.

## License

MIT
