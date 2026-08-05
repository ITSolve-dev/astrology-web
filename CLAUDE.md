# Astrology Web — AI Agent Guide

Главный файл инструкций для AI-агентов. Читай перед любым действием.

## Проект

Telegram Mini App на React + TypeScript. Feature-based архитектура (FSD-подмножество).
Фронтенд не взаимодействует с Telegram API напрямую — вся логика на бэкенде.

## Карта документации

| Что | Где |
|-----|-----|
| Архитектура, слои, правила зависимостей | [`docs/architecture/`](docs/architecture/) |
| Стиль кода, именование | [`docs/styleguide.md`](docs/styleguide.md) |
| Решения (ADR) | [`docs/decisions/`](docs/decisions/) |
| Git flow, коммиты, PR | [`docs/git-flow.md`](docs/git-flow.md) |
| Тестирование | [`docs/testing.md`](docs/testing.md) |
| Telegram-специфика | [`docs/telegram.md`](docs/telegram.md) |

## Критичные правила

- Слои: `app` → `pages` → `features` → `shared`. Зависимости только сверху вниз
- Фичи не импортируют друг друга — общее выносится в `entities/` или `shared/`
- Публичное API фичи — только через `index.ts`. Прямой импорт из `model/`, `api/`, `ui/` запрещён
- UI не делает прямых вызовов API — только через `model/` сервис
- Запрещённые имена файлов: `utils.ts`, `hooks.ts`, `helpers.ts`, `store.ts`, `atoms.ts`
- `index.ts` — только barrel-файл, никогда не содержит логику

## Стек

- React v19 + TypeScript v5.8, Vite v6, Bun
- Reatom v3 (стейт), React Router v6 (роутинг)
- Tailwind v4 (стили), Shadcn/ui на движке Base UI (UI-компоненты; копируются в `shared/ui`, не устанавливаются как чёрный ящик)
- Zod v3 (валидация), Hey API (кодогенерация API-клиента)
- Sonner v2 (уведомления)
- Biome v2 (lint/format), Vitest v3 + MSW v2 + Playwright (тесты)
- Steiger + @feature-sliced/steiger-plugin (проверка архитектуры)

## Команды

| Команда | Описание |
|---------|----------|
| `make dev` | Dev сервер |
| `make build` | Production сборка |
| `make lint` | Biome linter с auto-fix |
| `make format` | Biome formatter |
| `make typecheck` | TypeScript проверка типов |
| `make check` | Все проверки (lint + format + typecheck + arch) |
| `make arch` | Steiger проверка архитектуры |
| `make test` | Запуск тестов |
| `make pr-create` | Создать PR с автогенерацией описания |
| `make worktree-create ISSUE=N` | Создать worktree из issue |
| `make worktree-create BRANCH=...` | Создать worktree с явным именем ветки |
| `make worktree-cleanup` | Удалить текущий worktree и ветку |

## Рабочий процесс

Design Doc → Implementation Plan → Реализация → Самопроверка → Human Review → PR → AI Code Review → Approval
