# Git Flow

Краткое руководство по работе с Git на проекте. Полная версия — в Notion (Engineering Docs → Git Flow).

## Принципы

- Линейная история — rebase вместо merge, всегда
- Изолированная разработка — каждая задача в отдельном worktree
- Обязательный code review — прямой push в `main` запрещён
- Conventional Commits — единый формат коммитов

## Настройка Git

```bash
git config --global user.name "Имя Фамилия"
git config --global user.email "your@email.com"

# Автоматический rebase при git pull
git config --global pull.rebase true

# Автоочистка локальных ссылок на удалённые ветки
git config --global fetch.prune true
```

## Worktrees

Предпочтительный способ работы на проекте. Worktree позволяет параллельно работать над несколькими задачами без `git stash` или переключения веток — каждая задача в своей директории.

```bash
# Создать worktree с новой веткой от main
git worktree add .worktrees/<name> -b <branch> origin/main

# Удалить после мержа
git worktree remove .worktrees/<name>
```

Symlinks для `.env` — слинковать из основного проекта:

```bash
ln -s ../../.env .worktrees/<name>/.env
```

## Шаблоны

| Что | Шаблон |
|-----|--------|
| Ветка | `<name>/<type>/<number>-<slug>` |
| Коммит | `<type>[scope]: <description> (#<number>)` |
| PR заголовок | `[#<number>] Описание` |

**Пример ветки:** `uladzislauliahun/feature/1-client-configure-base-setup`

## Типы коммитов

`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

## Правила коммитов

- Язык — только английский
- `type` обязателен, `scope` опционален
- `description` — с маленькой буквы, без точки
- `#issue_number` — обязателен в конце description
- `BREAKING CHANGE` — через `!` или footer

## Pull Request

- PR только на `main` (исключение — под-ветки сложных задач)
- Squash and merge — обязателен
- Минимум 1 human approve
- CI зелёный
- Ветка удаляется после мержа
- Идеальный размер PR — 100–200 строк, максимум — 400–500

## Полный цикл задачи

1. Получить задачу → `gh issue view <n>`
2. Обновить main → `git fetch origin && git rebase origin/main main`
3. Создать worktree → `make worktree-create ISSUE=<n>`
4. Валидация — config, актуальность, symlinks, зависимости
5. Работа + коммиты по Conventional Commits
6. Push → `git push -u origin <branch>`
7. PR → `make pr-create`
8. Review → approve → CI зелёный → squash merge
9. Очистка → `make worktree-cleanup`
