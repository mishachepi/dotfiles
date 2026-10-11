# ai-local — non-secret env. Sourced from zsh/zshrc.
# Secret OMLX_API_KEY lives in ~/.local_env.zsh (outside the repo), not here.

export OMLX_BASE_URL="http://127.0.0.1:9009/v1"     # oMLX server (settings.json → server.port)
# export OPENAI_BASE_URL="$OMLX_BASE_URL"           # opt-in: redirects every OpenAI-SDK tool to oMLX
# export OPENAI_API_KEY="$OMLX_API_KEY"             # uncomment if a tool reads OPENAI_API_KEY
