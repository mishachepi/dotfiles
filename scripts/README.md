# Scripts Collection

Useful automation scripts for macOS and Git workflows.

## 📦 Available Scripts

### 🧹 clean_macos.sh
**Comprehensive macOS cleanup utility**

Cleans and frees disk space by removing:
- Docker (images, containers, volumes, build cache)
- Homebrew cache
- npm cache
- uv cache (Python package manager)
- System caches (~/Library/Caches, /Library/Caches)
- System logs
- Temporary files

**Features:**
- Interactive prompts for each cleanup operation
- Shows disk space before cleanup
- Beautiful summary table at the end
- Color-coded output

**Usage:**
```bash
./clean_macos.sh
# Or if in PATH:
clean_macos.sh
```

**Example output:**
```
╔═══════════════════════════════════════════════════════════╗
║                    CLEANUP SUMMARY                        ║
╠═══════════════════════════════════════════════════════════╣
║ Docker (images, containers, volumes, build cache)     22.94 GB ║
║ Homebrew cache                                          1.3 GB ║
║ npm cache                                               1.5 GB ║
║ uv cache (Python)                                       5.9 GB ║
╠═══════════════════════════════════════════════════════════╣
║ TOTAL FREED                                           31.64 GB ║
╚═══════════════════════════════════════════════════════════╝
```

---

### 🔄 git-pull-all.sh
**Batch update all Git repositories**

Finds all Git repositories in the current directory (recursively) and runs `git pull` on the main/master branch.

**Features:**
- Auto-detects main/master branch
- Color-coded output (green for success, red for errors)
- Shows which repositories were updated

**Usage:**
```bash
cd ~/projects
./git-pull-all.sh
```

**Example output:**
```
→ Updating repository in: ./project1
✔ Updated: ./project1 (main)

→ Updating repository in: ./project2
✔ Updated: ./project2 (master)
```

---

### 🌿 git-switch-branches.sh
**Interactive branch switcher**

Finds all Git repositories and lets you interactively switch to main or master branch.

**Features:**
- Shows available branches
- Interactive prompts for each repository
- Skip option for repositories you don't want to change

**Usage:**
```bash
cd ~/projects
./git-switch-branches.sh
```

**Example:**
```
→ Repository: ./my-project
Available branches:
 - main
 - master
Switch to 'main' or 'master'? (type name or skip): main
✔ Switched to main
```

---

### 🔑 i_know.sh
**SSH known_hosts cleaner**

Removes entries from `~/.ssh/known_hosts` when you get "Host key has changed" errors.
Smart pattern search — just pass an IP or hostname and it finds all matching entries.

**Features:**
- Search by IP or hostname (partial match, finds all entries)
- Parse SSH error output directly via pipe
- Interactive: (a)ll / (c)hoose / (n)o for multiple matches
- Dry-run mode (`-n`) to preview without deleting
- Auto-backup before every removal (`known_hosts.bak`)
- Works on both macOS and Linux

**Usage:**
```bash
# Search and remove by IP (finds all ports)
i_know 192.168.1.1

# Remove by hostname
i_know github.com

# Pipe SSH error directly
ssh user@host 2>&1 | i_know

# Dry run — see what would be removed
i_know -n 10.0.0.5
```

**Example — multiple entries:**
```
$ i_know 192.168.1.1

Searching 192.168.1.1 in known_hosts...

  1) line 2     [192.168.1.1]:22
  2) line 3     192.168.1.1
  3) line 4     [192.168.1.1]:2222

Remove: (a)ll / (c)hoose / (n)o? a
done: removed 3 entries (backup: known_hosts.bak)
```

**Example — selective removal:**
```
Remove: (a)ll / (c)hoose / (n)o? c
  [192.168.1.1]:22 (line 2)? [y/n]: y
  192.168.1.1 (line 3)? [y/n]: n
  [192.168.1.1]:2222 (line 4)? [y/n]: y
done: removed 2 entries (backup: known_hosts.bak)
```

---

### 🔐 load_env.sh
**Environment variable loader**

Loads environment variables from `.env` file in current directory.

**Features:**
- Filters out comments (lines starting with #)
- Skips empty lines
- Handles whitespace properly
- Error checking for missing .env file

**Usage:**
```bash
# In directory with .env file:
source ./load_env.sh

# Or:
. ./load_env.sh
```

**Example .env:**
```bash
# Database config
DB_HOST=localhost
DB_PORT=5432

# API keys
API_KEY=your-key-here
```

---

### 📹 record_session.sh
**Secure terminal session recorder**

Records terminal session and encrypts it with GPG.

**Features:**
- Records all terminal output
- Automatically encrypts with GPG
- Deletes unencrypted recording
- Timestamped filenames

**Usage:**
```bash
./record_session.sh

# Type 'exit' when done recording
# Enter GPG passphrase when prompted
```

**Output:**
```
🔴 Session recording started.
Type 'exit' to finish.
... your terminal session ...
exit
🔴 Session recording finished.
Encrypting session recording.
Recording encrypted and saved to session-2026-02-15_13-45-22.log.gpg
Original recording was deleted
```

**Decrypt later:**
```bash
gpg -d session-2026-02-15_13-45-22.log.gpg
```

---

## 🚀 Installation

Scripts are located in `~/dotfiles/scripts/`. To use them globally:

### Option 1: Add to PATH (recommended)
```bash
# Already configured in dotfiles/zsh/zshrc:
# path=("$HOME/dotfiles/scripts" $path)
```

### Option 2: Create aliases
```bash
# Add to ~/.zshrc or aliases.sh:
alias clean="~/dotfiles/scripts/clean_macos.sh"
alias gitpull="~/dotfiles/scripts/git-pull-all.sh"
```

### Option 3: Make executable and run directly
```bash
chmod +x ~/dotfiles/scripts/*.sh
~/dotfiles/scripts/clean_macos.sh
```

---

## 📝 Notes

- Most scripts require bash
- Some operations require `sudo` (cleanup scripts)
- Docker cleanup requires Docker daemon to be running
- `record_session.sh` requires GPG installed

---

## 🔧 Dependencies

**Required:**
- bash
- coreutils (du, rm, etc.)

**Optional (for specific scripts):**
- docker (for clean_macos.sh Docker cleanup)
- brew (for clean_macos.sh Homebrew cleanup)
- npm (for clean_macos.sh npm cleanup)
- uv (for clean_macos.sh Python cache cleanup)
- gpg (for record_session.sh)
- git (for git-*.sh scripts)

---

## 🤝 Contributing

Feel free to improve these scripts or add new ones!
