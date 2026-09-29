# Зафиксированные версии компонентов

| Компонент | Ветка | Текущий commit | Назначение |
|---|---|---|---|
| Backend | `develop` | `5b8da6d331463459186f940957a31bad07fa8507` | API, seed и production runtime; feature PR влит |
| Frontend | `develop` | `43f3180c460a06f36f663dcc787b80f269639e3b` | пользовательское мини-приложение; feature PR влит |
| Admin | `main` | `0f5545faf13495aa0a15fb33d95fba54521244ef` | административный интерфейс; опубликованная release-ветка |

Backend и frontend пока зафиксированы на `develop`: после общей проверки и
переноса в production-ветки их SHA нужно заменить на итоговые `master` и
`main`. Затем необходимо повторно проверить Compose и публичный стенд.
