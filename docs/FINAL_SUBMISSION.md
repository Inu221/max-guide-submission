# Финальный пакет сдачи

## Что фиксируется

Исходный продукт зафиксирован через:

1. commit superproject `max-guide`;
2. SHA submodule, записанные в этом commit;
3. резервный архив всего superproject с развернутым содержимым submodule;
4. SHA-256 контрольную сумму архива.

Зафиксированный superproject:

```text
a2c989fbdc6d993129cc56bc080bd0f0a5370aeb
```

Зафиксированные submodule:

| Компонент | Ветка | Commit |
|---|---|---|
| Backend | `master` | `7696553f3f6a6a58f87addd452e25753a67bfaf2` |
| Frontend | `main` | `1cc2ff9dfa31b25f3995f3c662634f6169c62fd8` |
| Admin | `main` | `1811ea9e7025474b90c30a8f61cc8cf96a4c9988` |

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

Подготовить окружение и запустить локальный compose:

```bash
cp .env.example .env
docker compose -f docker-compose.local.yml up --build
```

Основные адреса:

- Mini App: <http://localhost:3001>
- API: <http://localhost:3000/api>
- Swagger: <http://localhost:3000/api/docs>
- Admin: <http://localhost:3002>

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