# Правила зависимостей

Направление зависимостей строго нисходящее.

| Слой | Может зависеть от | Не может зависеть от |
|------|-------------------|----------------------|
| `app` | `pages`, `features`, `shared`, `entities`, `widgets` | — |
| `pages` | `features`, `widgets`, `entities`, `shared` | `app` |
| `widgets` | `features`, `shared`, `entities` | `app`, `pages` |
| `features` | `shared`, `entities` | `app`, `pages`, другие `features`, `widgets` |
| `entities` | `shared` | `app`, `pages`, `features`, `widgets` |
| `shared` | — | всего остального |

Фичи не импортируют друг друга. Общие данные → `entities/`. Общая логика → `shared/`.

## Публичное API фичи

Каждая фича экспортирует только через `index.ts`.

```ts
// ✅ Правильно
import { ProfileCard, profileService } from '@/features/profile'

// ❌ Запрещено
import { profileAtom } from '@/features/profile/model/profile.atoms'
```

Через `index.ts` наружу выходят только: сервис и UI-компоненты. Атомы и API-функции — внутренние детали реализации.

## Проверка архитектуры

Автоматически через **Steiger** + `@feature-sliced/steiger-plugin`:

```bash
make arch
```

Конфигурация — `steiger.config.ts` в корне. Неиспользуемые слои (`entities`, `widgets`) — отключить соответствующие правила.
