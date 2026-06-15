---
description: roll the graph back to its previous snapshot - use after a bad edit or sync
argument-hint: [optional --to <rev>]
---

Roll back the most recent graph change with `weave undo` (or `weave undo --to <rev>` to jump to a specific snapshot from `weave history`). Then run `weave status` and tell me what's different. Use this when an edit or sync went wrong.
