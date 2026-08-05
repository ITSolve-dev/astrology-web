# Поток данных

## Однонаправленный цикл

**Запрос:**
```text
Действие пользователя → UI → Feature Model (сервис) → API Layer → Backend
```

**Ответ:**
```text
Backend → API Layer → Feature Model (атомы) → UI
```

UI не делает прямых вызовов API. UI не содержит бизнес-логику. UI только вызывает экшены сервиса и читает атомы.

## Управление состоянием (Reatom v3)

Атомы принадлежат фиче. Атомы не шарятся между фичами.

```ts
import { parseApiError } from '@/shared/validation/parseApiError'

// features/profile/model/profile.atoms.ts
export const profileAtom = atom<Profile | null>(null, 'profile')

// features/profile/model/profile.service.ts
export const fetchProfile = reatomAsync(
  async (ctx) => profileApi.getProfile(ctx),
  'profile.fetchProfile'
).pipe(
  withDataAtom(null),
  withErrorAtom((ctx, error) => {
    const parsed = parseApiError(error)
    toast.error(parsed ? parsed.title : 'Что-то пошло не так')
    return parsed?.title ?? 'Что-то пошло не так'
  }),
  withCache({ staleTime: 5 * 60 * 1000 }),
)
```

## Обработка ошибок

| Класс | Стратегия |
|-------|-----------|
| Ошибки рендера | `ErrorBoundary` → фолбэк UI |
| Ошибки API | `toast.error()` через Sonner или ошибки формы |

Все ошибки API парсятся через `parseApiError` из `shared/validation/`.

**Правила использования полей:**

| Поле | Где |
|------|-----|
| `code` | Программная логика (редирект, retry) |
| `title` | `toast.error()` — единственное поле в UI |
| `detail` | Только в логах |
| `context` | Только в логах |
| `errors[]` | Атом формы, не toast |

## Контракт API ошибок

Бэкенд всегда возвращает ошибки в едином формате. Формат `code`: `<module>.<error>` (макс. 3 сегмента, нижний регистр через точку).

**Одиночная ошибка:**
```json
{
  "code": "users.not_found",
  "title": "Пользователь не найден",
  "detail": "Пользователь user_01H... не найден",
  "context": { "user_id": "user_01H..." }
}
```

**Коллекция ошибок (валидация форм):**
```json
{
  "code": "common.validation_failed",
  "title": "Ошибка валидации",
  "detail": "Запрос не прошёл валидацию",
  "context": {},
  "errors": [
    {
      "code": "users.invalid_email",
      "title": "Некорректный email",
      "detail": "Поле email должно содержать '@'",
      "context": { "field": "email" }
    }
  ]
}
```

При наличии `errors[]` — передавать в атом формы, не в toast. При одиночной ошибке — `toast.error(parsed.title)`.
