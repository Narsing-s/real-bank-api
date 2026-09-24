# Project Glossary

**API** — The HTTP interface exposed by the Mule application.

**APIKit** — MuleSoft tooling used to route HTTP requests according to an API specification such as RAML.

**RAML** — RESTful API Modeling Language. The repository's contract is `src/main/resources/api/real-bank-api.raml`.

**Mule Flow** — A MuleSoft XML-defined processing sequence that receives, transforms, validates or routes data.

**DataWeave** — MuleSoft's transformation language used for payload, variable and integration-data transformations.

**Snowflake** — The database/data platform integrated by the current application.

**Account Number** — The identifier generated for an account by the account-number generation flow.

**Account Status** — The current repository models account state using ACTIVE/INACTIVE behavior.

**Transaction** — A recorded account operation such as deposit or withdrawal, represented by the current API model.

**Frontend** — The browser-based UI under `frontend/` used to interact with the banking API.

**Deployment** — Packaging and running the Mule application in a target environment using the repository's deployment artifacts.

**Correlation Identifier** — An identifier used to connect a request with related application log entries when available.

**Non-Functional Requirement** — A requirement describing qualities such as availability, maintainability, observability, security or compatibility.

**Current-State Documentation** — Documentation describing what is actually represented in the repository today, without implying unimplemented enterprise banking capabilities.

**Source of Truth** — For API behavior, the RAML and implemented Mule flows are authoritative. Documentation explains those artifacts and should not silently redefine them.
