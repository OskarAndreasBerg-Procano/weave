# weave plugin

A shared cooperation graph for you and Claude Code. Plans, tasks, decisions,
files and questions live in one JSON-backed graph that both sides read and
write. Comes with a live browser workspace, slash commands, hooks, and an
MCP server.

## What you get

- **MCP server** (`weave_status`, `weave_add`, `weave_set`, `weave_link`,
  `weave_focus`, `weave_show`, `weave_ls`, `weave_attach`, `weave_context`,
  `weave_inbox`, `weave_ask`) — Claude can read and write the graph natively.
- **Slash commands** — `/weave:status`, `/weave:plan`, `/weave:sync`,
  `/weave:done`, `/weave:attach`, `/weave:ask`, `/weave:search`,
  `/weave:undo`, `/weave:init`, `/weave:serve`.
- **Hooks** — SessionStart prints current focus + reading list,
  PreToolUse surfaces mid-task human edits, PostToolUse auto-tracks files
  you write or edit.
- **Workspace** — `weave serve` opens a force-directed graph in your
  browser. Click any file node to read it inline. Drag, link, undo,
  history, cross-project nav.

## Install

```
/plugin marketplace add OskarAndreasBerg-Procano/weave
/plugin install weave@weave
```

Then in any project:

```
/weave:init
```

This creates `.weave/graph.json` and adds a `weave` section to `CLAUDE.md`.
It does NOT write per-project hook/MCP files because the plugin already
provides them globally.

Open the workspace:

```
/weave:serve
```

## Requirements

- Python 3.8+ on `PATH` as `python` (Windows) or `python3` (Unix)
- No third-party Python packages. Stdlib only.

## License

MIT
