import { Environment } from './http/environment';
import { SdkConfig } from './http/types';
import { RealBankApiAutoSdkService } from './services/real-bank-api-auto-sdk';

export * from './services/real-bank-api-auto-sdk';

export * from './http';
export { Environment } from './http/environment';

export class RealBankApiAutoSdk {
  public readonly realBankApiAutoSdk: RealBankApiAutoSdkService;

  constructor(public config: SdkConfig) {
    this.realBankApiAutoSdk = new RealBankApiAutoSdkService(this.config);
  }

  set baseUrl(baseUrl: string) {
    this.realBankApiAutoSdk.baseUrl = baseUrl;
  }

  set environment(environment: Environment) {
    this.realBankApiAutoSdk.baseUrl = environment;
  }

  set timeoutMs(timeoutMs: number) {
    this.realBankApiAutoSdk.timeoutMs = timeoutMs;
  }
}

// c029837e0e474b76bc487506e8799df5e3335891efe4fb02bda7a1441840310c
