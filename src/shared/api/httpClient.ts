const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? ''

export type HttpMethod = 'GET' | 'POST' | 'PUT' | 'PATCH' | 'DELETE'

export interface HttpRequestOptions extends Omit<RequestInit, 'method' | 'body'> {
  method?: HttpMethod
  body?: unknown
}

/**
 * Thin fetch wrapper shared by every feature's `api/` layer.
 *
 * On a non-2xx response it throws the parsed response body as-is (expected to
 * match the backend's ApiError contract) so callers can run it through
 * `parseApiError` instead of guessing the shape here.
 *
 * The generated Hey API client will eventually replace hand-written calls in
 * `api/` modules, but this wrapper stays as the single place that owns base
 * URL, default headers and error propagation.
 */
export async function httpClient<TResponse>(
  path: string,
  { method = 'GET', body, headers, ...rest }: HttpRequestOptions = {},
): Promise<TResponse> {
  const mergedHeaders = new Headers(headers)
  if (body !== undefined && !mergedHeaders.has('Content-Type')) {
    mergedHeaders.set('Content-Type', 'application/json')
  }

  const response = await fetch(`${API_BASE_URL}${path}`, {
    ...rest,
    method,
    headers: mergedHeaders,
    body: body === undefined ? undefined : JSON.stringify(body),
  })

  const data = await response.json().catch(() => null)

  if (!response.ok) {
    throw data
  }

  return data as TResponse
}
