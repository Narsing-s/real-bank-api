# Real Bank API — API Reference

This page summarizes the endpoint contract in `src/main/resources/api/real-bank-api.raml`.

## Base path

The Mule listener routes API traffic through:

`/api/*`

For a local application using the default listener port, the API is typically reached through:

`http://localhost:8081/api`

## Endpoints

### Health

#### GET /health

Returns service health.

Example:

```json
{
  "status": "UP",
  "service": "real-bank-api"
}
```

### Create account

#### POST /api/accounts

Query parameters:

- `adharNumber` — required, 12 characters.
- `bankName` — required; supported values are HDFC, SBI, APGIVB, AXIS, ICICI, YES.

Body:

```json
{
  "FullName": "Narsing Rao",
  "dateOfBirth": "1998-05-12",
  "mobileNumber": "9876543210",
  "email": "narsing@example.com",
  "address": "Andhra Pradesh, India"
}
```

### List/filter accounts

#### GET /api/accounts

Optional query parameter:

- `status=ACTIVE`
- `status=INACTIVE`

### Get account

#### GET /api/accounts/{accountNumber}

Example:

`GET /api/accounts/ACC1001`

### Update account

#### PATCH /api/accounts/{accountNumber}

Supported request fields in the RAML contract:

```json
{
  "FullName": "Updated Name",
  "mobileNumber": "9876543210",
  "address": "Updated Address"
}
```

### Deactivate account

#### DELETE /api/accounts/{accountNumber}

Deactivates the account according to the current implementation.

### Deposit

#### POST /api/accounts/{accountNumber}/deposit

Body:

```json
{
  "amount": 1000
}
```

### Withdraw

#### POST /api/accounts/{accountNumber}/withdraw

Body:

```json
{
  "amount": 500
}
```

The RAML contract defines a business error response for insufficient balance.

### Transaction history

#### GET /api/accounts/{accountNumber}/transactions

Returns transaction records containing:

- accountNumber
- type
- amount
- balance
- timestamp

### WhatsApp assistance

#### POST /api/assistance/whatsapp

Body:

```json
{
  "mobileNumber": "9876543210",
  "message": "Hello, I need help with my account"
}
```

## Common API errors

The shared APIKit error handler maps common protocol/API errors to:

| Status | Meaning |
|---:|---|
| 400 | Bad request |
| 404 | Resource not found |
| 405 | Method not allowed |
| 406 | Not acceptable |
| 415 | Unsupported media type |
| 501 | Not implemented |

For the authoritative contract, use the RAML file rather than this summary.
