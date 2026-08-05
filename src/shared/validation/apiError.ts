import { z } from 'zod'

export const ApiErrorSchema = z.object({
  code: z.string(),
  title: z.string(),
  detail: z.string(),
  context: z.record(z.unknown()),
  errors: z
    .array(
      z.object({
        code: z.string(),
        title: z.string(),
        detail: z.string(),
        context: z.record(z.unknown()),
      }),
    )
    .optional(),
})

export type ApiError = z.infer<typeof ApiErrorSchema>
