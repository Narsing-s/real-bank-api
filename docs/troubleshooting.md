# Troubleshooting Guide

## API Does Not Start

Check Mule/Java compatibility, Maven output, required environment variables, database configuration, SMTP configuration, listener/port settings and deployment logs.

Relevant files include `pom.xml`, `mule-artifact.json`, `src/main/mule/global/global_element.xml` and `src/main/resources/config_properties/`.

## API Starts but Requests Fail

Identify the HTTP method, path, request body/query parameters, status code, Mule error and correlation/request identifier when available. Compare the request with `src/main/resources/api/real-bank-api.raml`.

## Account Not Found

Confirm the account number, database record, account state and corresponding lookup flow. Review the returned status and error payload.

## Deposit or Withdrawal Failure

Check account number, amount format/validity, current balance for withdrawal, database connectivity, transaction persistence and notification processing.

## Transaction History Is Empty

Confirm the account number, database records, transaction flow configuration and database connectivity. Verify that the transaction operation persisted the transaction.

## Email Notification Failure

Check `EMAIL_USERNAME`, `EMAIL_PASSWORD`, SMTP connectivity, recipient address, deployment configuration and Mule/email flow logs. Never put credentials in screenshots or issue reports.

## Frontend Cannot Reach API

Check the frontend API base URL, browser/network errors, CORS response headers if reported by the browser, API availability and `GET /health`.

## Common HTTP Errors

| Status | General meaning |
|---|---|
| 400 | Invalid request/data according to current behavior |
| 404 | Resource/account not found |
| 405 | HTTP method not supported |
| 406 | Representation not accepted |
| 415 | Unsupported media type |

Always confirm the exact current RAML/flow behavior before diagnosing.

## Server/Integration Errors

Review Mule logs, identify the failing flow and downstream dependency, then check database/SMTP/external-service connectivity and whether the failure is repeatable.

## Safe Troubleshooting Rule

This documentation process does not modify application code. Reproduce the issue, identify the failing boundary, collect evidence and make any implementation change separately and deliberately.
