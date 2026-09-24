# Real Bank API — Diagram Quick Reference

For the complete architecture, request lifecycle, account, transaction, error, data-model, integration, configuration, and deployment diagrams, see [Architecture](./architecture.md).

## Overall architecture

~~~mermaid
flowchart LR
 U[User / API Client] --> F[Frontend]
 F --> API[MuleSoft API]
 API --> R[APIKit + RAML]
 R --> B[Business Flows]
 B --> DB[(Snowflake)]
 B --> E[Email]
 B --> W[WhatsApp / Messaging]
~~~

## Account creation

~~~mermaid
flowchart TD
 A[Create Account] --> B[Validate Request]
 B --> C[Check Existing Account]
 C -->|Existing| D[Existing-account Flow]
 C -->|New| E[Generate Account Number]
 E --> F[Save to Snowflake]
 F --> G[Notification]
 D --> H[Response]
 G --> H
~~~

## Deployment

~~~mermaid
flowchart TB
 G[GitHub] --> R[Render]
 G --> C[CloudHub 2 configuration]
 R --> F[Frontend]
 R --> A[Docker API]
 F --> A
 A --> DB[(Snowflake)]
 A --> E[Email]
 A --> W[Messaging]
~~~