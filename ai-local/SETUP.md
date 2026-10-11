# ai-local — локальные LLM на Apple Silicon

Локальный inference через **oMLX** (MLX → mlx-lm → oMLX), OpenAI-совместимый API на `127.0.0.1:9009`.

## Установка

**Только DMG**, не `brew`/`pip`:
- oMLX поддерживает Python 3.11–3.13.
- Без полного Xcode (`xcrun: metal not found`) кастомные Metal-кернелы не собираются — модель молча уходит на медленный путь и ест больше памяти. DMG везёт собранные кернелы и свой Python.

```sh
# DMG: https://github.com/jundot/omlx/releases → oMLX.app в /Applications → первый запуск
omlx start          # фоновый сервис (shim: ~/.omlx/bin/omlx)
```

Обновление: скачать DMG, `spctl -a -t open --context context:primary-signature -v <dmg>` → `omlx stop` + quit app → заменить `/Applications/oMLX.app` → `open -a oMLX && omlx start`. `~/.omlx/` (модели, settings, ключ) не трогается.

OptiQ-модели (`optiq/optiq_vision.safetensors`) требуют oMLX ≥ 0.6 — старые версии грузят их как text-only (`VLM loading failed … falling back` в `omx-log`).

## Подключение

- `env.zsh` — `OMLX_BASE_URL`; секрет `OMLX_API_KEY` — в `~/.local_env.zsh` (вне репо).
- `aliases.zsh` — `omx-start/stop/log`, `omx-models`, `omx-chat <model> "<prompt>"`.
- Оба подключаются из `zsh/zshrc`.

## Модели

Тянутся встроенным HF-downloader oMLX (UI или admin API) в `~/.omlx/models/mlx-community/`.

| Модель | Размер | Тип | Роль |
|---|---|---|---|
| `Qwen3.8-27B-4bit` | 16 ГБ | dense 27B, text+vision | reasoning/coding |
| `gemma-4-26b-a4b-it-4bit` | 15 ГБ | MoE 26B/4B active, text+vision | быстрая |
| `gemma-4-12B-it-qat-OptiQ-4bit` | 9 ГБ | dense 12B, text+vision | лёгкая general/vision |
| `whisper-large-v3-turbo` | 1.5 ГБ | ASR | `/v1/audio/transcriptions` |

Память: потолок oMLX задаёт `memory_guard_tier` (`balanced`); при 32 ГБ RAM в памяти одна LLM + whisper, oMLX сам выгружает/подгружает по запросу.

Qwen3.8 и Gemma 4 — **thinking-модели**: рассуждения в `message.reasoning_content`, ответ в `content`. `max_tokens` < 500 обрывает на рассуждении → `finish_reason: length`, `content` пустой.

```sh
# admin API: сначала сессия — POST /admin/api/login с api_key = auth.api_key из ~/.omlx/settings.json (curl -c ck …)
curl -b ck -X POST localhost:9009/admin/api/hf/download -H 'Content-Type: application/json' -d '{"repo_id":"mlx-community/<name>"}'
curl -b ck localhost:9009/admin/api/hf/tasks          # прогресс
rm -rf ~/.omlx/models/mlx-community/<name>            # удалить
```

## Pi (coding-агент) → локальная модель

[Pi](https://pi.dev) (CLI `pi`), конфиг вне git в `~/.pi/agent/`:

- `models.json` — провайдер `omlx`: `baseUrl=http://127.0.0.1:9009/v1`, `api=openai-completions`, `apiKey` = `auth.api_key` из `~/.omlx/settings.json`.
- Обязателен `compat: { supportsDeveloperRole: false, supportsReasoningEffort: false }` — иначе Pi шлёт роль `developer`/`reasoning_effort`, которые oMLX-gemma не понимает.
- `settings.json` — `defaultProvider: omlx` + `defaultModel: Qwen3.8-27B-4bit`. Переключить: `pi --model <id>` или `/model`.

Проверка: `pi -p "..."`.

## Тесты

Встроенный бенчмарк oMLX (`/admin/api/bench/*`: throughput + accuracy) и OptiQ-самоквантование (`/admin/api/oq/*`).
