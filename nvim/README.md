# nvim
Thank you [Mikluki](https://github.com/Mikluki/dotfiles) for big help with this config.

## Main
- navigation
- recordings
- treesitter
- lsp
- telescope

- **Terminal** `Ctrl + \`
- **Explorer neo-tree** `Ctrl + Shift + E`
- **Save** `Ctrl + S`

## neo-tree
  From within neo-tree window:
  - Press <C-x> - Change root directory (neo-tree will
  prompt for new path)
  - Press <BS> (Backspace) - Go up to parent directory
  and set it as new root
  - Press . (dot) - Set current directory as root

## Cheatsheet
grug-far - `<leader> si`
lazygit - `<leader> lg lgf lgc`
zenmode - `<leader> mw zm`

Чтобы не учить всё, помни структуру: **[Оператор] + [i / a] + [Объект]**
* **Операторы:** `c` (change), `d` (delete), `y` (yank/copy), `v` (visual select).
* **Модификатор:** `i` (inner — внутри), `a` (around — вместе с границами).
* **Объекты:** `w` (слово), `"` (кавычки), `(` / `b` (скобки), `{` / `B` (блок), `t` (тег), `f` (функция), `s` (предложение), `p` (абзац).


| Хоткей(и) | Действие | Контекст / Инструмент |
| --- | --- | --- |
| **Навигация** |  |  |
| `s` | Прыжок в любую точку по 2 буквам | Flash.nvim |
| `R` | Выделить логический блок (Treesitter) | Flash.nvim |
| `r` | Удаленное действие (например, `dr` + метка) | Flash.nvim (Remote) |
| `Ctrl + d` / `u` | Скролл вниз / вверх (с центровкой) | Vim Core |
| `<leader>j` / `k` + `m/i/l` | Прыжок к след/пред: Функции, If, Циклу | Treesitter (Nav) |
| `[q` / `]q` | Переход по списку ошибок (Quickfix) | Vim Core |
| `<Space>v` | Расширить выделение (слово -> блок -> функция) | Treesitter |
| `<Space>b` | Сжать выделение | Treesitter |
| **Редактирование** |  |  |
| **`ci"`** | изменить текст внутри кавычек | **c**hange **i**nside **"** |
| **`da(`** | удалить скобки вместе с содержимым | **d**elete **a**round **(** |
| **`yi{`** | скопировать всё внутри фигурных скобок | **y**ank **i**nside **{** |
| **`cit`** | изменить контент внутри html/xml тега | **c**hange **i**nside **t**ag |
| **`va"`** | выделить слово вместе с кавычками | **v**isual **a**round **"** |
| **`dt)`** | удалить всё от курсора до скобки | **d**elete **t**ill **)** |
| `F"x` ... `f"x` | Удалить кавычки вокруг (вручную) | Vim Core |
| `ea"<esc>bi"` | Обернуть слово в кавычки (вручную) | Vim Core |
| **LSP & Python** |  |  |
| `gd` | Перейти к определению (Go to Definition) | Маст-хэв |
| `gr` | Найти все упоминания (References) | Через Telescope |
| `gh` | Показать документацию и типы (Hover) | Вместо мышки |
| `<leader>sr` | Умное переименование (Smart Rename) | По всему проекту |
| `<leader>ca` | Быстрые исправления (Code Action) | Импорты, фиксы |
| `<leader>dy` | Скопировать текст ошибки (Diagnostic Yank) | Для Google/AI |
| `<leader>dt` | Вкл/Выкл отображение ошибок | Когда мешает шум |
| `<leader>n/pa` | Поменять аргументы местами (след/пред) | Treesitter (Swap) |
| **Интерфейс** |  |  |
| `<leader>ff` / `fg` | Поиск файлов / Поиск текста (grep) | Telescope |
| `<C-j>` / `<C-k>` | Навигация в меню автодополнения | nvim-cmp |
| `<CR>` (Enter) | Подтвердить выбор (LSP/Сниппет) | nvim-cmp |
| `<Tab>` / `<S-Tab>` | Прыжок вперед / назад по полям сниппета | LuaSnip |


| Хоткей | Прыжок Вперед | Прыжок Назад | Объект |
| --- | --- | --- | --- |
| **Метод/Функция** | `<leader>jm` | `<leader>km` | `am` (outer), `im` (inner) |
| **Условие (if)** | `<leader>ji` | `<leader>ki` | `ai` (outer), `ii` (inner) |
| **Цикл (loop)** | `<leader>jl` | `<leader>kl` | `al` (outer), `il` (inner) |
| **Аргумент** | `<leader>na` (swap next) | `<leader>pa` (swap prev) | `ia` (inner arg) |


## Install new LSP server
How to Add a New Language Later

For a New Language (e.g., TypeScript):

1. Install LSP Server via Mason
:Mason
Search for and install the server (e.g., tsserver, gopls, rust-analyzer)

2. Add Server to lspconfig.lua

In
/Users/mikhailchepkin/dotfiles/nvim/lua/mch/plugins/lsp/lspconfig.lua:152,
add it to the servers table:

local servers = {
  -- Your existing servers...
  pyright = { ... },
  ruff = { ... },

  -- Add new one:
  tsserver = {}, -- TypeScript
  -- or with custom settings:
  gopls = {
      settings = {
          gopls = {
              analyses = {
                  unusedparams = true,
              },
          },
      },
  },
}

3. (Optional) Add Formatter/Linter

If you want auto-formatting, add to
/Users/mikhailchepkin/dotfiles/nvim/lua/mch/plugins/lsp/formatter.lua:19:

formatters_by_ft = {
  -- existing...
  python = { "ruff_fix", "ruff_format" },

  -- add new:
  go = { "gofmt", "goimports" },
  typescript = { "prettier" },
  javascript = { "prettier" },
}

Then install the formatter via :Mason (e.g., prettier, gofmt)

4. Restart Neovim
:qa
Reopen and the LSP will auto-start for that file type!
