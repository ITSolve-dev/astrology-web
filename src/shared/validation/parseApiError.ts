import { type ApiError, ApiErrorSchema } from '@/shared/validation/apiError'

/**
 * Validates an unknown error payload against the backend's ApiError contract.
 * Returns null when the shape doesn't match, so callers can fall back to a
 * generic message instead of showing raw/unexpected data to the user.
 */
export function parseApiError(error: unknown): ApiError | null {
  const result = ApiErrorSchema.safeParse(error)
  if (!result.success) return null
  return result.data
}
