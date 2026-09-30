# Непарадный Ставрополь — комплект конкурсной сдачи

«Непарадный Ставрополь» — чат-бот и мини-приложение в MAX, которые помогают туристу или жителю найти локальные места и события, собрать маршрут и перейти от идеи «куда сходить» к готовому плану в одном пользовательском сценарии.

Этот репозиторий содержит **материалы конкурсной сдачи**: презентацию, документацию, OpenAPI-контракт, DATA-API и резервный архив зафиксированной версии исходного кода.

Исходный продукт находится в отдельном superproject `max-guide`, который фиксирует версии трех Git submodule:

- `max-guide-backend` — NestJS API, PostgreSQL, MAX Bot API и Swagger;
- `max-guide-frontend` — пользовательское React mini app;
- `max-guide-admin` — административный интерфейс.

Зафиксированные версии перечислены в [`docs/COMPONENT_VERSIONS.md`](docs/COMPONENT_VERSIONS.md).  
Состав финального пакета и порядок проверки описаны в [`docs/FINAL_SUBMISSION.md`](docs/FINAL_SUBMISSION.md).

## Материалы презентации

- [презентация PowerPoint](presentation/max-guide-hackathon/max-guide-hackathon.pptx);
- [презентация PDF](presentation/max-guide-hackathon/export/max-guide-hackathon.pdf);
- [текст выступления](presentation/max-guide-hackathon/speech.md).

## Финальный архив исходного кода

В `artifacts/` находятся:

```text
artifacts/
├── max-guide-final-2026-09-30.tar.gz
└── SHA256SUMS.txt
```

Архив содержит снимок **всего superproject `max-guide`**, включая содержимое трех submodule на SHA, зафиксированных superproject.

Проверка контрольной суммы:

```bash
cd artifacts
sha256sum -c SHA256SUMS.txt
```

Ожидаемый результат:

```text
max-guide-final-2026-09-30.tar.gz: OK
```

Скрипт, которым собирается архив:

```bash
./scripts/build-final-artifact.sh
```

После финальной фиксации исходников архив и `SHA256SUMS.txt` не пересобираются без необходимости. Если изменяется код или SHA submodule, необходимо обновить фиксацию версий, повторить smoke-test и собрать новый архив.

## Воспроизводимый локальный запуск

Рекомендуемый путь проверки исходного кода — использовать зафиксированный архив:

```bash
mkdir -p /tmp/max-guide-review
tar -xzf artifacts/max-guide-final-2026-09-30.tar.gz -C /tmp/max-guide-review
cd /tmp/max-guide-review/max-guide
node tools/local.cjs up
```

`tools/local.cjs` поднимает прод-сборку в изолированном compose-проекте
`max-guide-local` на <http://localhost:3100> и при первом запуске создаёт
`.env.local` со случайными локальными паролями (файл не попадает в Git).

Основные локальные адреса:

- mini app: <http://localhost:3100>;
- admin: <http://localhost:3100/admin/>;
- API: <http://localhost:3100/api>;
- Swagger UI: <http://localhost:3100/api/docs>;
- OpenAPI JSON: <http://localhost:3100/api/docs-json>;
- health check: <http://localhost:3100/api/health>.

Для карты требуется `REACT_APP_YANDEX_MAPS_KEY` в `.env.local`. Без валидного ключа карта может быть недоступна, при этом остальные экраны и API остаются проверяемыми.

Остановка:

```bash
node tools/local.cjs down
```

Полный сброс локальных данных:

```bash
node tools/local.cjs down
docker volume rm $(docker volume ls -q --filter name=max-guide-local)
```

## Основной сценарий проверки

1. Открыть чат-бота MAX.
2. Перейти из бота в mini app.
3. Открыть ленту или карту мест.
4. Выбрать объект и открыть карточку.
5. Добавить место в маршрут или сохранить результат.
6. Открыть собранный маршрут и просмотреть точки на карте.

Production bot / Mini App:

<https://max.ru/t632_hakaton_max_bot>

Публичный API:

<https://max-guide.legacy-team.tech/api>

Swagger:

<https://max-guide.legacy-team.tech/api/docs>

## Проверка API

Для собственного API приложены:

- `openapi.json`;
- `DATA-API.yaml`;
- [`docs/API_VERIFICATION.md`](docs/API_VERIFICATION.md);
- `scripts/verify-api.sh`.

Проверка production API:

```bash
API_BASE_URL=https://max-guide.legacy-team.tech/api ./scripts/verify-api.sh
```

Проверка локально запущенного API (см. раздел выше):

```bash
API_BASE_URL=http://localhost:3100/api ./scripts/verify-api.sh
```

## Архитектура

```text
MAX bot ───────┐
               ├── NestJS API ── PostgreSQL
React miniapp ─┤       │
               │       └── локальное/S3-хранилище медиа
Admin React ───┘
```

Backend отвечает за авторизацию, контент, маршруты, события, медиа, MAX-интеграцию и admin API. Frontend и admin работают с тем же API.

## Данные и интеграции

- PostgreSQL хранит пользователей, места, события, маршруты и состояния.
- Демонстрационные места — заранее подготовленные тестовые данные.
- Фотографии seed-набора хранятся локально; источники указываются в данных.
- Яндекс Карты требуют отдельного API-ключа.
- MAX Bot API и MAX WebApp используют настройки, выданные для проекта.
- S3 поддерживается backend, но не является обязательным для локальной проверки.

Тестовые данные не выдаются за прямую интеграцию с городской информационной системой.

## Секреты

В Git не публикуются рабочие токены, пароли и приватные ключи. `.env.example` содержит только шаблонные значения.

Тестовый пользователь может быть зарегистрирован через mini app либо через:

```text
POST /api/auth/register/email
```

Административный логин не относится к основному пользовательскому сценарию и передается отдельно только при необходимости проверки admin-панели.

## Известные ограничения

- локальная email-авторизация предназначена для воспроизводимой технической проверки;
- подготовленные места и расписания не обновляются автоматически;
- Яндекс Карта требует валидный API-ключ;
- часть внешних интеграций зависит от production-окружения и настроек MAX.

Продуктовое позиционирование, сценарий, метрики пилота и масштабирование зафиксированы в [`docs/PRODUCT_STORY.md`](docs/PRODUCT_STORY.md).
