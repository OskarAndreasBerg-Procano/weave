---
description: bootstrap a weave graph in the current project (skips local hook wiring)
argument-hint: [optional project name]
---

Bootstrap a weave graph in the current project: `weave init --plugin $ARGUMENTS`.

The `--plugin` flag tells weave that hooks, MCP wiring and slash commands are already provided by the installed Claude Code plugin, so it only creates `.weave/graph.json`, the inbox/outbox/plans/versions folders, registers the project in the global index, and adds a weave section to CLAUDE.md. Run `weave demo` after init if you want sample nodes to play with, or jump straight into adding your first plan with `/weave:plan`.
