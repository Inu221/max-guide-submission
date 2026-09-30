# Зафиксированные версии компонентов

Снимок подготовлен **30 сентября 2026 года**.

Superproject `max-guide` фиксирует конкретные SHA трех Git submodule. Эти версии входят в резервный архив исходного кода.

| Компонент | Production-ветка | Commit | Назначение |
|---|---|---|---|
| Backend | `master` | `ddb8f9fb9519ffc1f81a0372704f4b68fe145c9f` | API, seed, MAX Bot API и production runtime |
| Frontend | `main` | `8fc47ab1b10dcea288160db83b44a5b9e6a3ea19` | пользовательское mini app |
| Admin | `main` | `ffdf036c3d339c1303fae783cf5bcaaeb52a687f` | административный интерфейс |

Основной superproject:

```text
max-guide
commit dc8262cde5a101b237146c973b18a7e7e1939d3e
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
