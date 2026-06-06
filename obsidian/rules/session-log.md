# Session Log

After every meaningful action (file edits, task changes, commands, direction changes), append a log entry to today's day note.

```bash
echo "$(date +%H:%M) описание действия" >> $VAULT_HOME/days/$(date +%Y)/$(date +%Y-%m-%d).md
```

Don't read the file. Just append via echo >>.

**What to log:** Time + what was done. Plain text, one line. Include `[[wikilinks]]` where relevant.
**What NOT to log:** Trivial reads, searches, failed attempts. Don't duplicate same action.
**Works from any repo** — always writes to the vault day note.
