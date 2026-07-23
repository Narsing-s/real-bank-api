import { z } from 'zod';
import { BaseService } from '../base-service';
import { ContentType, HttpResponse, SdkConfig } from '../../http/types';
import { RequestBuilder } from '../../http/transport/request-builder';
import { SerializationStyle } from '../../http/serialization/base-serializer';
import { ThrowableError } from '../../http/errors/throwable-error';
import { Environment } from '../../http/environment';
import {
  CreateAccountCopyRequest,
  createAccountCopyRequestRequest,
} from './models/create-account-copy-request';
import { CreateAccountCopyParams } from './request-params';

/**
 * Service class for RealBankApiAutoSdkService operations.
 * Provides methods to interact with RealBankApiAutoSdkService-related API endpoints.
 * All methods return promises and handle request/response serialization automatically.
 */
export class RealBankApiAutoSdkService extends BaseService {
  protected createAccountCopyConfig: Partial<SdkConfig> = {
    environment: Environment.REAL_BANK_API_JIK9_PB,
  };

  /**
   * Sets method-level configuration for createAccountCopy.
   * @param config - Partial configuration to override service-level defaults
   * @returns This service instance for method chaining
   */
  setCreateAccountCopyConfig(config: Partial<SdkConfig>): this {
    this.createAccountCopyConfig = config;
    return this;
  }

  /**
   *
   * @param {string} [params.adharNumber] -
   * @param {string} [params.bankName] -
   * @param {Partial<SdkConfig>} [requestConfig] - The request configuration for retry and validation.
   * @returns {Promise<HttpResponse<any>>} - OK
   */
  async createAccountCopy(
    body: CreateAccountCopyRequest,
    params?: CreateAccountCopyParams,
    requestConfig?: Partial<SdkConfig>,
  ): Promise<any> {
    const resolvedConfig = this.getResolvedConfig(this.createAccountCopyConfig, requestConfig);
    z.object({
      adharNumber: z.string().optional().nullable(),
      bankName: z.string().optional().nullable(),
    }).parse(params ?? {});
    const request = new RequestBuilder()
      .setConfig(resolvedConfig)
      .setBaseUrl(resolvedConfig)
      .setMethod('POST')
      .setPath('/api/accounts')
      .setRequestSchema(createAccountCopyRequestRequest)
      .setRequestContentType(ContentType.Json)
      .addResponse({
        schema: z.any(),
        contentType: ContentType.Json,
        status: 200,
      })
      .addQueryParam({
        key: 'adharNumber',
        value: params?.adharNumber,
      })
      .addQueryParam({
        key: 'bankName',
        value: params?.bankName,
      })
      .addHeaderParam({ key: 'Content-Type', value: 'application/json' })
      .addBody(body)
      .build();
    return this.client.callDirect<any>(request);
  }
}
