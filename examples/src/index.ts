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
