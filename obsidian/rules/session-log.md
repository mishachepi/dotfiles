# Session Log — the `[a]` day-log

The day-note `## Logs` section is the **semantic layer** of the system: *what actually moved or was decided in the life-system today*, in human terms. It is **not** a mechanical trace of what an agent did — scion already records every tool-call (L0 transcript) and every event (L1 `scion logs`) for free. Never re-type that firehose by hand.

## Write one `[a]` only when something **important is finished or decided**

Not for steps, attempts, reads, or work-in-progress. Only a real **outcome** or **decision** earns a line.

```bash
logi a "<outcome / decision>" --task "Task"    # or --epic / --area (exactly ONE)
```

`logi` validates the context-link and format before writing (day must exist — `fm day-create DATE` first). Always prefer it over `echo >>`.

## Rules

1. **Only the important and the done.** If it isn't a real outcome or decision, don't log it. When in doubt, leave it out.
2. **One outcome = one line.** A multi-step task = one entry when it lands, not a play-by-play. Keep it ≤ ~140 chars; deeper detail belongs in the task's `## Result`.
3. **Log what YOU did or decided — never what you received.** Inbound messages, acks, "X confirmed" are already logged by whoever originated them. Re-logging the other side of a handshake is the #1 source of noise.
4. **Exactly one context link**, most specific: `[task::[[…]]]` > `[epic::[[…]]]` > `[area::[[…]]]`. Never two. If genuinely unclear what you're working on — ask.
5. **Use `[[wikilinks]]`**, never paraphrase strategic docs.
6. **`[f]` finance — only via `fini`** (`logi f` delegates to it). Never write `[f]` by hand.

## Don't log

- Tool mechanics, reads, searches, failed attempts, retries → that's L0/L1 in scion.
- The other side of a handshake — received messages, acks, "core confirmed X".
- Work-in-progress — wait until it actually lands.
- Two links on one line, or a second entry for the same outcome from another angle.

## After midnight

Work past midnight goes into the **actual calendar day it happens** — the next day's note, at the real clock time (e.g. `02:30`). No 24+ offset, no keeping it in the previous day.

---

> Markers (all via the `logi` skill): `- [a] HH:MM …` outcome/decision · `- [t] HH:MM-HH:MM …` time-block · `- [f]` finance (fini only). Full tracking mechanics: [[tracking-rule]].
