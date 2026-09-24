# Testing Guide

This document describes how the current `real-bank-api` repository can be tested without changing application code.

## 1. Test Layers

| Layer | What to verify | Source of truth |
|---|---|---|
| API contract | Paths, methods, parameters, request/response shapes | `src/main/resources/api/real-bank-api.raml` |
| Mule routing | APIKit routing and listener configuration | `src/main/mule/global/global_element.xml` |
| Functional flows | Account, deposit, withdrawal, transactions, assistance | `src/main/mule/` |
| Integration | Snowflake, SMTP/email, external messaging | Mule configuration and flow implementations |
| Frontend | Search, account operations, filters and transaction views | `frontend/` |
| Deployment | Container/build/runtime configuration | `Dockerfile`, `render.yaml`, `pom.xml`, `mule-artifact.json` |

## 2. API Test Matrix

| Area | Scenario | Expected result |
|---|---|---|
| Health | GET /health | Successful health response |
| Create account | Valid required data | Account is created and account number is returned |
| Create account | Duplicate condition | Documented duplicate/error response |
| Account lookup | Existing account number | Account details returned |
| Account lookup | Unknown account number | 404-style documented error |
| Account list | No status filter | Account list returned |
| Account list | ACTIVE/INACTIVE filter | Matching accounts returned |
| Update | Existing account + valid fields | Updated account returned/saved |
| Delete/deactivate | Existing account | Current implementation's status behavior occurs |
| Deposit | Valid amount | Balance/transaction updated |
| Withdrawal | Valid amount with sufficient balance | Balance/transaction updated |
| Transactions | Existing account | Transaction history returned |
| WhatsApp assistance | Valid request | Current assistance response returned |
| Unsupported method | Unsupported HTTP method | 405-style error |
| Unsupported media type | Unsupported content type | 415-style error |

## 3. Frontend Checklist

- Application loads without JavaScript errors.
- Dashboard/account summary renders.
- Search and ACTIVE/INACTIVE filtering work.
- Account details load.
- Account creation validates required inputs.
- Deposit and withdrawal send expected requests.
- Transaction/mini-statement view displays returned data.
- Banking assistant handles success and error responses.
- UI remains usable on mobile-sized screens.

## 4. Negative Testing

Verify missing required fields, invalid/unknown account numbers, invalid status filters, invalid amounts, unsupported methods/media types, database failures, email failures and external messaging failures.

## 5. Regression Principle

Documentation-only changes must not alter application behavior. Validate that RAML, Mule XML flows, frontend source and deployment files remain unchanged.

## 6. Test Evidence

Record test date/time, environment, API base URL, test case/result, status code, correlation/request identifier when available, downstream dependency and failure evidence.

This guide documents a test strategy; it does not claim that every scenario is currently automated.
