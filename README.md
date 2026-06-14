# weave — setup guide

`weave` is Oskar's cooperation-graph tool for working with Claude Code. This repo holds
the single-file `weave` CLI plus this install + first-run guide.

## What it is

`weave` is a shared graph (`.weave/graph.json`) of plans, tasks, decisions, files, and
questions for a project. Both you and Claude Code read and write it, so you have a
persistent shared memory across sessions instead of starting from zero every time.

## Prerequisites

- **Python 3** (any recent version). Check: `python3 --version`.
- **Claude Code** — the `claude` CLI and/or VS Code extension. <https://claude.com/code>
- The `weave` script — it's the file named `weave` in this repo. Single Python file,
  stdlib only, zero dependencies.

## 1. Install the CLI (once per machine)

First get the file — clone this repo (or download the `weave` file from it):

```bash
git clone https://github.com/OskarAndreasBerg-Procano/weave.git
```

### Linux / macOS

```bash
mkdir -p ~/bin
cp weave/weave ~/bin/weave
chmod +x ~/bin/weave
# ensure ~/bin is on PATH (add to ~/.bashrc or ~/.zshrc if needed):
#   export PATH="$HOME/bin:$PATH"
python3 ~/bin/weave --help    # sanity check
```

### Windows

Copy the `weave` file somewhere convenient, e.g. `C:\bin\weave` (no extension), then:

```powershell
python C:\bin\weave --help    # sanity check
```

(You can wrap that in a `weave.bat` if you want `weave …` to work directly, but it isn't
required.)

## 2. Set up weave in a project (once per project)

`cd` into the project directory and run:

```bash
# Linux/macOS:
python3 ~/bin/weave init

# Windows:
python C:\bin\weave init
```

This scaffolds, in that project:

- `.weave/` — the weave directory, including an empty `graph.json`.
- `CLAUDE.md` — a weave block describing the workflow (merged in if `CLAUDE.md` already exists).
- `.mcp.json` — registers the weave MCP server so Claude Code gets native `weave_status`, `weave_add` etc. tools.
- `.claude/settings.local.json` — installs the SessionStart / PostToolUse / PreToolUse hooks.
- `.claude/commands/weave-*.md` — slash commands like `/weave-status`, `/weave-plan`.
- `.gitignore` — gitignores `.mcp.json` + `settings.local.json` (they bake per-machine paths).

`.weave/graph.json` is **committed to git** — it's the shared memory. Only the wiring is
per-machine; each contributor runs `weave init` once after cloning.

## 3. Restart Claude Code — important

Claude Code reads `.mcp.json` and hooks **at session start only**. If a chat is already
open in this project, **close it and start a new one**. You should then see at the top of
the new session:

> `[weave] shared project graph: .weave/graph.json …`

and Claude should have the `weave_status`, `weave_add`, `weave_context`, … tools available.

## 4. Try it

```bash
python3 ~/bin/weave demo    # seeds a small demo graph
python3 ~/bin/weave serve   # opens the live workspace in a browser
```

In Claude Code:

- `/weave-status` — Claude summarizes the graph.
- *"Add a plan for X and break it into 4 tasks"* — Claude adds the nodes via `weave_add`.
- *"What should I read for the focus task?"* — Claude uses `weave_context`.

## Daily workflow (TL;DR)

- **Plans / tasks:** `weave add plan "<goal>"`, then `weave add task "<step>" --parent <planId>`.
- **Progress:** `weave set <taskId> --status doing|done|blocked`.
- **Decisions:** `weave add decision "<choice>" --body "<why>" --parent <planId>`.
- **Files you edit** in Claude are auto-registered into the graph (PostToolUse hook).
- Mostly: just ask Claude to do these — it uses the `weave_*` MCP tools directly.

## Troubleshooting

- **No `weave_*` MCP tools after init.** Did you restart the Claude Code chat? `.mcp.json` is only read at session start.
- **`python3` not found** (Windows): install Python from <https://python.org> and tick *"Add Python to PATH"* during install. Some Windows setups also need `python` rather than `python3`.
- **Full command reference:** `weave --help`. The weave block in your project's `CLAUDE.md` is the workflow reference Claude reads at session start.

Ping Oskar with anything else. 🤝
