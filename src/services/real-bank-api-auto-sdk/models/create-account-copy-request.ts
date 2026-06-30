import { z } from 'zod';

/**
 * Zod schema for the CreateAccountCopyRequest model.
 * Defines the structure and validation rules for this data type.
 * This is the shape used in application code - what developers interact with.
 */
export const createAccountCopyRequest = z.lazy(() => {
  return z.object({
    fullName: z.string().optional().nullable(),
    dateOfBirth: z.string().optional().nullable(),
    mobileNumber: z.string().optional().nullable(),
    email: z.string().optional().nullable(),
    address: z.string().optional().nullable(),
  });
});

/**
 *
 * @typedef  {CreateAccountCopyRequest} createAccountCopyRequest
 * @property {string}
 * @property {string}
 * @property {string}
 * @property {string}
 * @property {string}
 */
export type CreateAccountCopyRequest = z.infer<typeof createAccountCopyRequest>;

/**
 * Zod schema for mapping API responses to the CreateAccountCopyRequest application shape.
 * Handles any property name transformations from the API schema.
 * If property names match the API schema exactly, this is identical to the application shape.
 */
export const createAccountCopyRequestResponse = z.lazy(() => {
  return z
    .object({
      FullName: z.string().optional().nullable(),
      dateOfBirth: z.string().optional().nullable(),
      mobileNumber: z.string().optional().nullable(),
      email: z.string().optional().nullable(),
      address: z.string().optional().nullable(),
    })
    .transform((data) => ({
      fullName: data['FullName'],
      dateOfBirth: data['dateOfBirth'],
      mobileNumber: data['mobileNumber'],
      email: data['email'],
      address: data['address'],
    }));
});

/**
 * Zod schema for mapping the CreateAccountCopyRequest application shape to API requests.
 * Handles any property name transformations required by the API schema.
 * If property names match the API schema exactly, this is identical to the application shape.
 */
export const createAccountCopyRequestRequest = z.lazy(() => {
  return z
    .object({
      fullName: z.string().optional().nullable(),
      dateOfBirth: z.string().optional().nullable(),
      mobileNumber: z.string().optional().nullable(),
      email: z.string().optional().nullable(),
      address: z.string().optional().nullable(),
    })
    .transform((data) => ({
      FullName: data['fullName'],
      dateOfBirth: data['dateOfBirth'],
      mobileNumber: data['mobileNumber'],
      email: data['email'],
      address: data['address'],
    }));
});
