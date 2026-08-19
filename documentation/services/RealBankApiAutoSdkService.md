# RealBankApiAutoSdkService

A list of all methods in the `RealBankApiAutoSdkService` service. Click on the method name to view detailed information about that method.

| Methods                                 | Description |
| :-------------------------------------- | :---------- |
| [createAccountCopy](#createaccountcopy) |             |

## createAccountCopy

- HTTP Method: `POST`
- Endpoint: `/api/accounts`

**Parameters**

| Name        | Type                                                              | Required | Description       |
| :---------- | :---------------------------------------------------------------- | :------- | :---------------- |
| body        | [CreateAccountCopyRequest](../models/CreateAccountCopyRequest.md) | ✅       | The request body. |
| adharNumber | string                                                            | ❌       |                   |
| bankName    | string                                                            | ❌       |                   |

**Return Type**

`any`

**Example Usage Code Snippet**

```typescript
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
