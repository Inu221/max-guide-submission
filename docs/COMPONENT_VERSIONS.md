# Зафиксированные версии компонентов

Снимок подготовлен **30 сентября 2026 года**.

Superproject `max-guide` фиксирует конкретные SHA трех Git submodule. Эти версии входят в резервный архив исходного кода.

| Компонент | Production-ветка | Commit | Назначение |
|---|---|---|---|
| Backend | `master` | `ddb8f9fb9519ffc1f81a0372704f4b68fe145c9f` | API, seed, MAX Bot API и production runtime |
| Frontend | `main` | `c92b80636fc384dc0815e6936df85c6b4a15bbe5` | пользовательское mini app |
| Admin | `main` | `ffdf036c3d339c1303fae783cf5bcaaeb52a687f` | административный интерфейс |

Основной superproject:

```text
max-guide
commit 11e7bbb1f64ec5e383fc26fa4d45093a6c1488a7
```

## Что входит в архив

`artifacts/max-guide-final-2026-09-30.tar.gz` содержит:

```text
max-guide/
├── docs/
├── max-guide-admin/      # содержимое зафиксированного submodule
├── max-guide-backend/    # содержимое зафиксированного submodule
├── max-guide-frontend/   # содержимое зафиксированного submodule
├── nginx/
├── tools/
├── .env.example
├── .gitmodules
├── docker-compose.dev.yml
├── docker-compose.local.yml
├── docker-compose.prod.yml
├── Dockerfile.web
└── ...
```

Git-служебные каталоги `.git/` в архив не включаются.

## Правило обновления

Если после фиксации изменяется любой компонент:

1. обновить SHA соответствующего submodule в `max-guide`;
2. зафиксировать новый commit superproject;
3. обновить эту таблицу;
4. повторить smoke-test;
5. пересобрать `artifacts/max-guide-final-2026-09-30.tar.gz`;
6. пересчитать `SHA256SUMS.txt`;
7. обновить SHA-256 в материалах сдачи, если он уже был указан.

Репозиторий `max-guide-submission` содержит материалы сдачи и не является частью архива исходного продукта.
