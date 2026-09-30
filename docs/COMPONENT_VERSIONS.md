# Зафиксированные версии компонентов

Снимок подготовлен **30 сентября 2026 года**.

Superproject `max-guide` фиксирует конкретные SHA трех Git submodule. Эти версии входят в резервный архив исходного кода.

| Компонент | Production-ветка | Commit | Назначение |
|---|---|---|---|
| Backend | `master` | `7696553f3f6a6a58f87addd452e25753a67bfaf2` | API, seed, MAX Bot API и production runtime |
| Frontend | `main` | `1cc2ff9dfa31b25f3995f3c662634f6169c62fd8` | пользовательское mini app |
| Admin | `main` | `1811ea9e7025474b90c30a8f61cc8cf96a4c9988` | административный интерфейс |

Основной superproject:

```text
max-guide
commit fb686f513fd7f4579e63c5a8434471de12b930a8
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
