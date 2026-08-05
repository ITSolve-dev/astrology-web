# Стиль кода

Правила для людей и AI-агентов. Проверяется на код-ревью и автоматически через Biome.

## Именование файлов (LIFT)

- **L**ocatable — файл легко найти по имени
- **I**dentifiable — содержимое понятно без открытия
- **F**lat — без избыточной вложенности
- **T**DRY — не повторять то, что очевидно из контекста

### Запрещённые имена

| ❌ Запрещено | ✅ Правильно |
|-------------|-------------|
| `utils.ts` | `formatDate.ts`, `parseApiError.ts` |
| `hooks.ts` | `useProfileData.ts`, `useAuthRedirect.ts` |
| `helpers.ts` | `buildQueryString.ts` |
| `store.ts`, `atoms.ts` | `profile.atoms.ts`, `auth.atoms.ts` |

`index.ts` — только barrel-файл. Никогда не содержит логику.

### Схемы именования

**Файлы внутри фичи** — `<feature-name>.<type>.ts`:

| Тип | Пример |
|-----|--------|
| Атомы | `profile.atoms.ts` |
| Сервис | `profile.service.ts` |
| API | `profile.api.ts` |
| Типы | `profile.types.ts` |

**React-компоненты** — PascalCase без суффикса `.component`:
```tsx
ProfileCard.tsx
AuthForm.tsx
FeatureErrorBoundary.tsx
```

**Хуки** — префикс `use` + описание:
```ts
useProfileData.ts
useAuthRedirect.ts
useMediaQuery.ts
```

**Файлы в `shared/`** — описательное имя без префикса фичи:
```ts
formatDate.ts
parseApiError.ts
httpClient.ts
```

### Запрещённые папки

`lib/`, `utils/`, `helpers/` — запрещены. Вместо них:
- внутри фичи — конкретные имена в `model/` или рядом с файлом
- в `shared/` — папки по назначению: `formatting/`, `validation/`, `api/`

## TypeScript

- Строгая типизация везде — все функции и переменные с аннотациями
- `any` — избегать. Допустим только при работе с внешними API без типов, с комментарием
- Предпочитать `type` над `interface` для объектов данных
- Импорты типов через `import type`

## React

- Компоненты — функциональные, без классов
- Пропсы — через `type`, не `interface`
- UI-компоненты не содержат бизнес-логику и не вызывают API напрямую
- Каждая фича оборачивается в `FeatureErrorBoundary`

## Форматирование

Управляется **Biome** — не настраивается вручную. Запуск: `make format`.
