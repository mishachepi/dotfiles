# ai-local — oMLX shortcuts. Sourced from zsh/zshrc.

alias omx='omlx'                      # shim: ~/.omlx/bin/omlx
alias omx-start='omlx start'
alias omx-stop='omlx stop'
alias omx-log='tail -f ~/.omlx/logs/server.log'

# List loaded models via the API
omx-models() {
  curl -s -H "Authorization: Bearer ${OMLX_API_KEY:?set OMLX_API_KEY in ~/.local_env.zsh}" \
    "${OMLX_BASE_URL}/models" | python3 -m json.tool
}

# One-shot chat: omx-chat <model-id> "<prompt>"
omx-chat() {
  curl -s -H "Authorization: Bearer ${OMLX_API_KEY:?set OMLX_API_KEY in ~/.local_env.zsh}" \
    -H 'Content-Type: application/json' \
    "${OMLX_BASE_URL}/chat/completions" \
    -d "{\"model\":\"$1\",\"messages\":[{\"role\":\"user\",\"content\":\"$2\"}]}" \
    | python3 -c 'import sys,json; print(json.load(sys.stdin)["choices"][0]["message"]["content"])'
}
