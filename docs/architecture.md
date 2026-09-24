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
