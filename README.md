# RealBankApiAutoSdk TypeScript SDK 2.0.0

Welcome to the RealBankApiAutoSdk SDK documentation. This guide will help you get started with integrating and using the RealBankApiAutoSdk SDK in your project.

## Versions

- SDK version: `2.0.0`

## Table of Contents

- [Setup & Configuration](#setup--configuration)
  - [Supported Language Versions](#supported-language-versions)
  - [Installation](#installation)
- [Setting a Custom Timeout](#setting-a-custom-timeout)
- [Sample Usage](#sample-usage)
- [Services](#services)
- [Models](#models)

# Setup & Configuration

## Supported Language Versions

This SDK is compatible with the following versions: `TypeScript >= 4.8.4`

## Installation

To get started with the SDK, we recommend installing using `npm` or `yarn`:

```bash
npm install real-bank-api-auto-sdk
```

or

```bash
yarn add real-bank-api-auto-sdk
```

## Setting a Custom Timeout

You can set a custom timeout for the SDK's HTTP requests as follows:

```ts
const realBankApiAutoSdk = new RealBankApiAutoSdk({ timeout: 10000 });
```

# Sample Usage

Below is a comprehensive example demonstrating how to authenticate and call a simple endpoint:

```ts
import { CreateAccountCopyRequest, RealBankApiAutoSdk } from 'real-bank-api-auto-sdk';

(async () => {
  const realBankApiAutoSdk = new RealBankApiAutoSdk({});

  const createAccountCopyRequest: CreateAccountCopyRequest = {
    fullName: '{{FullName}}',
    dateOfBirth: '{{dateOfBirth}}',
    mobileNumber: '{{mobileNumber}}',
    email: '{{email}}',
    address: '{{address}}',
  };

  const data = await realBankApiAutoSdk.realBankApiAutoSdk.createAccountCopy(
    createAccountCopyRequest,
    {
      adharNumber: '{{adharNumber}}',
      bankName: '{{bankName}}',
    },
  );

  console.log(data);
})();
```

## Services

The SDK provides various services to interact with the API.

<details>
<summary>Below is a list of all available services with links to their detailed documentation:</summary>

| Name                                                                             |
| :------------------------------------------------------------------------------- |
| [RealBankApiAutoSdkService](documentation/services/RealBankApiAutoSdkService.md) |

</details>

## Models

The SDK includes several models that represent the data structures used in API requests and responses. These models help in organizing and managing the data efficiently.

<details>
<summary>Below is a list of all available models with links to their detailed documentation:</summary>

| Name                                                                         | Description |
| :--------------------------------------------------------------------------- | :---------- |
| [CreateAccountCopyRequest](documentation/models/CreateAccountCopyRequest.md) |             |

</details>
