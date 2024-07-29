require('lint').linters_by_ft = {
  markdown = {'vale'},
  ansible = {'ansible-lint'},
  terraform = {'tflint'},
  python = {'pylama', 'pylint', 'flake8'},
  yaml = {'yamllint'},
  json = {'jsonlint'},
  docker = { 'hadolint' },
  lua = {'stylua'},
}
