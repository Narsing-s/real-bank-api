# Real Bank API — Architecture

## Overview

The repository implements a MuleSoft REST API with APIKit routing and a Snowflake-backed data layer. A static responsive frontend consumes the API.

```text
Browser / Mobile Web
        |
        v
Frontend (frontend/)
        |
        v
HTTP /api/*
        |
        v
Mule HTTP Listener
        |
        v
APIKit Router <---- RAML contract
        |
        +--------------------+
        |                    |
        v                    v
Business Flows         Health / Console
        |
        +-----------------------+
        |           |           |
        v           v           v
    Snowflake    Email      External Messaging
        |
        v
 Account / Transaction Data
```

## MuleSoft layers

### 1. API contract

`src/main/resources/api/real-bank-api.raml` defines:

- Resources.
- HTTP methods.
- Query parameters.
- URI parameters.
- Request types.
- Response types.
- Status codes.
- Examples.

### 2. API routing

`src/main/mule/global/global_element.xml` defines the HTTP listener, APIKit configuration, APIKit router, API console, and common error handling.

### 3. Business flows

The main implementation flows are grouped under `src/main/mule/Main_implimentation/`.

### 4. Database flows

Reusable Snowflake operations are grouped under `src/main/mule/Database_implimentation/`.

### 5. Supporting flows

Separate directories contain account-number generation, email notifications, and other supporting integrations.

## Data flow: account creation

```text
POST /api/accounts
      |
      v
Validate request
      |
      v
Read Aadhaar + bankName query parameters
      |
      v
Check existing customer/account in Snowflake
      |
   +--+----------------+
   |                   |
Existing             New
   |                   |
   v                   v
Duplicate flow     Generate account number
   |                   |
   |                   v
   |              Persist account
   |                   |
   +---------+---------+
             |
             v
      Notification/response
```

## Data flow: deposit/withdrawal

```text
Client
  |
  v
Account transaction endpoint
  |
  v
Validate account + amount
  |
  v
Database/business processing
  |
  v
Transaction result
  |
  v
JSON response
```

## Data flow: transaction history

```text
GET /api/accounts/{accountNumber}/transactions
                |
                v
        Verify account
                |
                v
        Query Snowflake
                |
                v
       Transform transaction rows
                |
                v
          JSON response
```

## Deployment topology

The repository contains two Render services in `render.yaml`:

1. A static frontend service rooted at `frontend/`.
2. A Docker-based API service using `Dockerfile`.

The Mule Maven configuration also contains CloudHub 2 deployment settings and environment-driven credentials.

## Configuration boundary

Sensitive configuration is expected to be supplied through environment variables. The application configuration references database and email properties rather than embedding the secret values in source files.

## Design principle

The documentation is additive. Existing source directories, flows, frontend files, deployment files, and API contracts are not replaced by the documentation structure.


## Additional visual diagrams

The diagrams below are intentionally kept close to the repository structure so that developers can trace a request from frontend to MuleSoft, database, notifications, and deployment.

### Component diagram

~~~mermaid
flowchart TB
 FE[frontend/] --> HTTP[Mule HTTP Listener]
 HTTP --> APIKIT[APIKit Router]
 APIKIT --> RAML[RAML Contract]
 APIKIT --> MAIN[Main Implementation Flows]
 MAIN --> DB[Database Implementation]
 MAIN --> NUM[Account Number Generation]
 MAIN --> MAIL[Email Implementation]
 DB --> SF[(Snowflake)]
 MAIL --> SMTP[SMTP]
 MAIN --> MSG[External Messaging]
~~~

### Request lifecycle

~~~mermaid
sequenceDiagram
 participant C as Client
 participant M as Mule
 participant R as APIKit/RAML
 participant B as Business Flow
 participant D as Snowflake
 C->>M: HTTP request
 M->>R: Route request
 R->>B: Invoke flow
 B->>D: Query/update when required
 D-->>B: Result
 B-->>C: JSON response
~~~

### Account lifecycle

~~~mermaid
stateDiagram-v2
 [*] --> AccountCreation
 AccountCreation --> ACTIVE
 ACTIVE --> ACTIVE: Deposit / Withdrawal / Update
 ACTIVE --> INACTIVE: Deactivate
 INACTIVE --> [*]
~~~

### Error path

~~~mermaid
flowchart TD
 C[Request] --> A[APIKit / Mule Flow]
 A --> V{Valid request?}
 V -->|No| E400[400 Bad Request]
 V -->|Yes| F{Resource available?}
 F -->|No| E404[404 Not Found]
 F -->|Yes| P[Business processing]
 P --> R[Success response]
 A --> E405[405 Method Not Allowed]
 A --> E415[415 Unsupported Media Type]
 A --> E501[501 Not Implemented]
~~~
