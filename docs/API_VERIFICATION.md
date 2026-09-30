# Проверка собственного API

## Автоматическая smoke-проверка

После локального запуска продукта (см. корневой `README.md`, изолированный проект `max-guide-local`) выполните:

```bash
API_BASE_URL=http://localhost:3100/api ./scripts/verify-api.sh
```

Для проверки публичного production API укажите HTTPS-адрес:

```bash
API_BASE_URL=https://max-guide.legacy-team.tech/api ./scripts/verify-api.sh
```

Скрипт проверяет обязательную цепочку:

1. состояние API и PostgreSQL;
2. наличие подготовленных мест и фотографий;
3. выдачу контентной ленты;
4. поиск места по запросу;
5. построение классического маршрута по координатам Ставрополя;
6. регистрацию временного тестового пользователя;
7. повторный вход этого пользователя.

Для регистрации каждый запуск создает уникальный адрес в домене `example.test`. Эти данные предназначены только для технической проверки.

## Ожидаемые результаты

| Проверка | Метод и путь | Код | Обязательный результат |
|---|---|---:|---|
| Health | `GET /api/health` | 200 | база данных имеет статус `up` |
| Места | `GET /api/places` | 200 | не менее 50 записей, присутствуют `photoUrls` |
| Лента | `GET /api/feed?limit=5` | 200 | непустой массив `items` |
| Поиск | `GET /api/search?q=парк&limit=5` | 200 | непустой массив `items` |
| Маршрут | `POST /api/routes/classic` | 201 | непустой массив `waypoints` |
| Регистрация | `POST /api/auth/register/email` | 201 | возвращен `token` |
| Вход | `POST /api/auth/login/email` | 200 | возвращен `token` |

Полный контракт находится в корневом файле `openapi.json`.

## Production endpoints

- API: <https://max-guide.legacy-team.tech/api>
- Swagger: <https://max-guide.legacy-team.tech/api/docs>

По состоянию на **30 сентября 2026 года** smoke-test был успешно пройден против production API по цепочке: health, seed places, feed, search, classic route, registration и login.

## Примечание о тестовом пользователе

Для основного сценария отдельная опубликованная учетная запись не обязательна: reviewer может зарегистрировать временного пользователя через mini app либо через `POST /api/auth/register/email`.

Рабочие пароли, токены и MAX-секреты в Git не публикуются.
