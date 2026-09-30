# Финальный пакет сдачи

## Что фиксируется

Исходный продукт зафиксирован через:

1. commit superproject `max-guide`;
2. SHA submodule, записанные в этом commit;
3. резервный архив всего superproject с развернутым содержимым submodule;
4. SHA-256 контрольную сумму архива.

Зафиксированный superproject:

```text
1c1c02ee8695c6e35ea3d42c7269c7c48386b8fd
```

Зафиксированные submodule:

| Компонент | Ветка | Commit |
|---|---|---|
| Backend | `master` | `ddb8f9fb9519ffc1f81a0372704f4b68fe145c9f` |
| Frontend | `main` | `c45d0a6fb7d15c08a681ce59e99b5178f2380e03` |
| Admin | `main` | `ffdf036c3d339c1303fae783cf5bcaaeb52a687f` |

Подробности: [`COMPONENT_VERSIONS.md`](COMPONENT_VERSIONS.md).

## Архив

Файл:

```text
artifacts/max-guide-final-2026-09-30.tar.gz
```

содержит снимок **всего репозитория `max-guide`**, а не только три отдельных component repo.

В архив входят файлы superproject и содержимое:

```text
max-guide/max-guide-backend/
max-guide/max-guide-frontend/
max-guide/max-guide-admin/
```

на версиях, зафиксированных superproject.

Презентация и документы `max-guide-submission` **не входят** в этот архив. Они хранятся отдельно в submission-репозитории.

Контрольная сумма:

```text
artifacts/SHA256SUMS.txt
```

Проверка:

```bash
cd artifacts
sha256sum -c SHA256SUMS.txt
```

## Сборка архива

Скрипт:

```bash
./scripts/build-final-artifact.sh
```

Он:

- берет `max-guide` из соседнего каталога;
- архивирует файлы superproject;
- добавляет содержимое submodule на SHA, зафиксированных в superproject;
- не включает Git-служебные каталоги;
- создает `max-guide-final-2026-09-30.tar.gz`;
- пересчитывает `SHA256SUMS.txt`.

Ожидаемая структура рабочего каталога:

```text
hackatons/
├── max-guide-submission/
│   ├── artifacts/
│   ├── docs/
│   ├── presentation/
│   └── scripts/
└── max-guide/
    ├── max-guide-backend/
    ├── max-guide-frontend/
    ├── max-guide-admin/
    ├── nginx/
    ├── tools/
    ├── .gitmodules
    └── ...
```

После финальной фиксации архив не следует пересобирать без изменения исходников. Любая пересборка меняет SHA-256 и требует повторной фиксации значения в материалах сдачи.

## Проверка жюри

### Production

- Bot / Mini App: <https://max.ru/t632_hakaton_max_bot>
- API: <https://max-guide.legacy-team.tech/api>
- Swagger: <https://max-guide.legacy-team.tech/api/docs>

Основной сценарий:

```text
MAX → Mini App → выбор места/интересов → маршрут → сохранение результата
```

### Локальная воспроизводимая проверка

Распаковать архив:

```bash
mkdir -p /tmp/max-guide-review
tar -xzf artifacts/max-guide-final-2026-09-30.tar.gz -C /tmp/max-guide-review
cd /tmp/max-guide-review/max-guide
```

Запустить прод-сборку в изолированном локальном compose (`tools/local.cjs`
создаёт `.env.local` со случайными локальными паролями и поднимает проект
`max-guide-local`):

```bash
node tools/local.cjs up
```

Основные адреса:

- Mini App: <http://localhost:3100>
- Admin: <http://localhost:3100/admin/>
- API: <http://localhost:3100/api>
- Swagger: <http://localhost:3100/api/docs>

Для собственного API приложены `openapi.json` и `DATA-API.yaml`.

Проверка API:

```bash
API_BASE_URL=https://max-guide.legacy-team.tech/api ./scripts/verify-api.sh
```

По состоянию на **30 сентября 2026 года** smoke-test production API успешно проходил проверки health, seed places, feed, search, classic route, registration и login.

## Тестовые учетные записи и секреты

Тестовый пользователь может быть зарегистрирован самостоятельно через Mini App либо `POST /api/auth/register/email`.

Рабочие токены, пароли, API-ключи и MAX-секреты не публикуются в Git.

Административный доступ не входит в основной пользовательский сценарий и передается отдельно только при необходимости проверки admin-панели.