# Real Bank API — Requirements Document

**Project:** real-bank-api  
**Repository:** Narsing-s/real-bank-api  
**Document purpose:** Describe the requirements represented by the existing repository without changing the existing application behavior.

---

## 1. Purpose

The Real Bank API provides a MuleSoft-based banking service for customer account lifecycle operations, balance-changing transactions, transaction history, and customer assistance.

The repository currently contains:

- A Mule 4.9 application.
- RAML 1.0 API contract.
- APIKit routing.
- Snowflake database integration.
- Email notification flows.
- A WhatsApp assistance flow.
- A responsive static frontend.
- Docker and Render deployment configuration.
- Automated workflow configuration.

This document is an **as-is requirements specification derived from the repository**.

---

## 2. Scope

### 2.1 In scope

1. Customer account creation.
2. Automatic account-number generation.
3. Account lookup.
4. Account filtering by ACTIVE/INACTIVE status.
5. Account profile updates.
6. Account deactivation/deletion.
7. Deposits.
8. Withdrawals.
9. Transaction-history retrieval.
10. Customer email notifications for relevant operations.
11. WhatsApp assistance.
12. Health monitoring.
13. Browser-based API console.
14. Responsive frontend interaction with the API.
15. Snowflake-backed customer and transaction data processing.
16. Cloud deployment support through Docker/Render and MuleSoft deployment configuration.

### 2.2 Out of scope for this document

This document does not introduce new banking features that are not represented by the repository. In particular, it does not assume that the application currently implements customer login, JWT/OAuth authentication, OTP authorization, card management, loans, beneficiaries, or payment-gateway processing.

---

## 3. Actors

| Actor | Responsibility |
|---|---|
| Customer | Creates and manages an account, performs deposits/withdrawals, and views transactions. |
| Bank staff/system user | May use account-management capabilities represented by the API. |
| Frontend user | Uses the responsive web UI to interact with supported banking operations. |
| MuleSoft application | Validates requests, routes API operations, applies business logic, transforms data, and coordinates integrations. |
| Snowflake | Stores and retrieves customer/account and transaction information. |
| Email service | Sends operational notifications. |
| WhatsApp/external messaging service | Supports the assistance flow. |
| Deployment platform | Runs the API/frontend according to the repository deployment configuration. |

---

## 4. Functional Requirements

### FR-01 — Health check

The system shall expose a health endpoint that returns an HTTP 200 response when the Mule application is available.

Expected endpoint:

`GET /health`

The current implementation returns a JSON status indicating that the service is UP.

### FR-02 — Create account

The system shall allow a customer account to be created using customer information and required bank-identification query parameters.

Required request information:

- Full name.
- Date of birth.
- Mobile number.
- Email.
- Address.
- Aadhaar number query parameter.
- Bank name query parameter.

The bank name is constrained by the RAML contract to the configured set:

- HDFC
- SBI
- APGIVB
- AXIS
- ICICI
- YES

The system shall validate required customer fields before continuing with database processing.

### FR-03 — Detect existing customer/account

Before creating a new account, the system shall check customer/account information against existing data.

When a matching account is found, the current implementation follows an existing-account response path and sends the associated notification flow rather than creating another account.

### FR-04 — Account-number generation

For a valid new account request, the system shall generate an account number through the existing account-number-generation flow.

### FR-05 — Account retrieval

The system shall allow an account to be retrieved using its account number.

Expected endpoint:

`GET /api/accounts/{accountNumber}`

The implementation shall query the account data source and return account information when the account exists.

### FR-06 — Account status filtering

The system shall support account retrieval filtered by status.

Expected endpoint:

`GET /api/accounts?status=ACTIVE`

Supported status values:

- ACTIVE
- INACTIVE

### FR-07 — Account update

The system shall allow supported customer account fields to be updated for an existing account.

The current RAML contract supports:

- FullName
- mobileNumber
- address

The implementation shall verify the account before updating it and shall avoid an unnecessary update when the submitted values are already equal to the stored values.

### FR-08 — Account deactivation

The system shall support account deactivation using the account number.

Expected endpoint:

`DELETE /api/accounts/{accountNumber}`

The current implementation describes this operation as deactivation and sends a notification to the user.

### FR-09 — Deposit

The system shall allow a positive amount to be deposited into an existing account.

Expected endpoint:

`POST /api/accounts/{accountNumber}/deposit`

Request:

```json
{
  "amount": 1000
}
```

The amount must be at least 1 according to the RAML contract.

The resulting transaction shall contain account number, transaction type, amount, resulting balance, and timestamp.

### FR-10 — Withdrawal

The system shall allow a positive amount to be withdrawn from an existing account.

Expected endpoint:

`POST /api/accounts/{accountNumber}/withdraw`

The implementation shall validate account existence and apply the withdrawal business logic. Insufficient balance is represented as a business error in the API contract.

### FR-11 — Transaction history

The system shall allow transaction history to be retrieved for an account.

Expected endpoint:

`GET /api/accounts/{accountNumber}/transactions`

A transaction record shall contain:

- Account number.
- Transaction type.
- Amount.
- Balance after the transaction.
- Timestamp.

### FR-12 — WhatsApp assistance

The system shall expose an assistance endpoint that accepts:

- Mobile number.
- Message.

Expected endpoint:

`POST /api/assistance/whatsapp`

The existing implementation is designed to forward the assistance request to an external messaging service.

### FR-13 — Notifications

The system shall support email notifications for applicable account and transaction operations. The Mule application contains a shared SMTP configuration and dedicated notification flows for several success, duplicate, missing-account, and update/deletion scenarios.

### FR-14 — API console

The Mule application shall expose the APIKit console under the configured console route so developers can inspect and exercise the API contract.

### FR-15 — Frontend

The repository shall retain the existing responsive frontend. The frontend currently supports:

- Dashboard/account summary.
- Account search.
- ACTIVE/INACTIVE filtering.
- Account details.
- Account creation.
- Deposit.
- Withdrawal.
- Transaction/mini-statement view.
- Banking assistant.
- Mobile-responsive interaction.

The frontend shall communicate with the deployed API using its configured API base URL.

---

## 5. API Requirements

The public API shall use:

- RAML 1.0.
- Version `v1`.
- HTTP/HTTPS.
- JSON request/response bodies where specified by the RAML contract.
- APIKit routing inside MuleSoft.

The main API base path is:

`/api`

The current public resources are:

| Method | Resource | Purpose |
|---|---|---|
| GET | /health | Service health |
| POST | /api/accounts | Create account |
| GET | /api/accounts | List/filter accounts |
| GET | /api/accounts/{accountNumber} | Get account |
| PATCH | /api/accounts/{accountNumber} | Update account |
| DELETE | /api/accounts/{accountNumber} | Deactivate account |
| POST | /api/accounts/{accountNumber}/deposit | Deposit |
| POST | /api/accounts/{accountNumber}/withdraw | Withdraw |
| GET | /api/accounts/{accountNumber}/transactions | Transaction history |
| POST | /api/assistance/whatsapp | WhatsApp assistance |

---

## 6. Data Requirements

### 6.1 Account

The API contract defines an account with:

- accountNumber
- FullName
- dateOfBirth
- mobileNumber
- email
- address
- status
- balance

### 6.2 Transaction

The API contract defines a transaction with:

- accountNumber
- type
- amount
- balance
- timestamp

### 6.3 Account creation input

The account creation request contains:

- FullName
- dateOfBirth
- mobileNumber
- email
- address

Aadhaar number and bank name are supplied as required query parameters.

---

## 7. Validation Requirements

The system shall:

1. Reject account creation when required customer fields are missing.
2. Validate Aadhaar query-parameter length according to the RAML contract.
3. Validate bank name against the supported bank enumeration.
4. Validate transaction amounts as positive values.
5. Validate account-number based operations against account existence.
6. Return appropriate HTTP status codes for invalid, missing, or unsupported requests.
7. Preserve the existing APIKit error handling behavior.

The current shared error handling includes mappings for bad request, not found, method not allowed, not acceptable, unsupported media type, and not implemented conditions.

---

## 8. Business Rules

1. Account numbers are generated by the application flow rather than supplied by the customer.
2. An existing matching customer/account should not result in an unintended duplicate account.
3. Only supported account profile fields may be updated through the PATCH contract.
4. Deposit and withdrawal operations must be represented as transactions.
5. Transaction history must be associated with an account number.
6. Account status is represented as ACTIVE or INACTIVE.
7. Account deactivation shall preserve the application behavior currently implemented by the DELETE flow.
8. The API contract and implementation should remain synchronized when future changes are introduced.

---

## 9. Integration Requirements

### 9.1 Snowflake

The application shall connect to Snowflake using the configured MuleSoft Snowflake connector.

The deployment configuration expects environment-provided values for:

- DB_SF_NAME
- DB_SF_WAREHOUSE
- DB_SF_DATABASE
- DB_SF_SCHEMA
- DB_SF_USER
- DB_SF_PASSWORD
- DB_SF_ROLE

The implementation uses Snowflake for customer/account and transaction queries and updates.

### 9.2 Email

The application shall support SMTP email notifications.

The deployment configuration expects:

- EMAIL_USERNAME
- EMAIL_PASSWORD

The Mule configuration currently uses Gmail SMTP settings with STARTTLS.

### 9.3 External messaging

The project contains HTTP-request configuration for an external messaging endpoint and a WhatsApp assistance flow. Credentials and endpoint configuration must remain environment-controlled rather than being committed as secrets.

---

## 10. Non-Functional Requirements

### NFR-01 — Availability

The deployed API should expose a working health endpoint suitable for platform health checks.

### NFR-02 — Maintainability

API definitions shall remain in RAML, routing shall remain APIKit-based, and business/integration flows shall remain separated into the existing Mule flow structure.

### NFR-03 — Observability

Important flows should continue to provide useful application logs for request processing, database interaction, and flow completion without exposing secrets.

### NFR-04 — Security

Secrets such as database passwords, email passwords, and external-service credentials shall not be hard-coded into source control.

Personal data such as Aadhaar numbers, email addresses, mobile numbers, and dates of birth should be handled as sensitive information and should not be written to logs unnecessarily.

### NFR-05 — Deployment

The application shall remain deployable using the repository's existing Docker/Render configuration and Mule Maven/CloudHub 2 deployment configuration.

### NFR-06 — Compatibility

The current application targets Mule Runtime 4.9.0 and Java 17 as declared by the project metadata.

### NFR-07 — API consistency

Changes to endpoint behavior should update the RAML contract and corresponding implementation together.

---

## 11. Error Requirements

The API shall provide meaningful JSON error responses for common failures.

The current shared APIKit handling maps:

- 400 — Bad request.
- 404 — Resource not found.
- 405 — Method not allowed.
- 406 — Not acceptable.
- 415 — Unsupported media type.
- 501 — Not implemented.

Business flows also contain operation-specific failure responses, including account-not-found, duplicate-account, and insufficient-balance scenarios.

---

## 12. Deployment Requirements

### Mule application

The repository is packaged as a Mule application and contains:

- `pom.xml`
- `mule-artifact.json`
- `Dockerfile`
- `render.yaml`

### Frontend

The frontend is located under `frontend/` and is configured as a static site in the Render configuration.

### Environment configuration

Deployment must provide all required database, email, and platform configuration values through environment variables/secrets.

---

## 13. Testing Requirements

The project shall retain its existing test structure under `src/test`.

At minimum, future changes should be verified for:

1. Health endpoint.
2. Account creation success.
3. Required-field validation.
4. Duplicate account/customer handling.
5. Account lookup success and not-found behavior.
6. ACTIVE/INACTIVE filtering.
7. Account update.
8. Account deactivation.
9. Deposit.
10. Withdrawal and insufficient-balance behavior.
11. Transaction-history retrieval.
12. WhatsApp assistance.
13. APIKit error handling.
14. Snowflake integration behavior.
15. Notification flow behavior.

---

## 14. Traceability

| Requirement area | Repository source |
|---|---|
| API contract | `src/main/resources/api/real-bank-api.raml` |
| API routing/configuration | `src/main/mule/global/global_element.xml` |
| Account creation | `src/main/mule/Main_implimentation/post_account_creation.xml` |
| Account lookup | `src/main/mule/Main_implimentation/get_account_detailes_by_accountNumber.xml` |
| Status filtering | `src/main/mule/Main_implimentation/get_account_detailes_by_active_inactive.xml` |
| Account update | `src/main/mule/Main_implimentation/patch_account_detailes_by_accountNumber.xml` |
| Account deletion/deactivation | `src/main/mule/Main_implimentation/delete_account_detailes_by_accountNumber.xml` |
| Deposit | `src/main/mule/Main_implimentation/post_deposite_flow.xml` |
| Withdrawal | `src/main/mule/Main_implimentation/post_withdraw_flow.xml` |
| Transactions | `src/main/mule/Main_implimentation/get_transactions_by_accountNumber.xml` |
| Account number generation | `src/main/mule/auto_accuntnum_creation/auto_accountNumber_creation.xml` |
| Snowflake operations | `src/main/mule/Database_implimentation/` |
| Email integration | `src/main/mule/email_implimentation/` and global SMTP configuration |
| Frontend | `frontend/` |
| Deployment | `Dockerfile`, `render.yaml`, `pom.xml` |
| Runtime metadata | `mule-artifact.json` |

---

## 15. Current-State Notes

This document intentionally describes what can be established from the repository. It does not claim that the API has production-grade banking controls such as full identity verification, customer authentication, authorization, fraud detection, regulatory compliance, double-entry accounting, encryption-at-rest design, or disaster recovery unless those capabilities are explicitly implemented elsewhere in the repository.

Those capabilities may be appropriate future requirements for a production banking platform, but adding them is outside the requested documentation-only change.
