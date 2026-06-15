# weave — setup guide

`weave` is Oskar's cooperation-graph tool for working with Claude Code. This repo holds
the single-file `weave` CLI plus this install + first-run guide.

## What it is

`weave` is a shared graph (`.weave/graph.json`) of plans, tasks, decisions, files, and
questions for a project. Both you and Claude Code read and write it, so you have a
persistent shared memory across sessions instead of starting from zero every time.

## The live workspace

Run `weave serve` to open an interactive view of the whole graph in your browser at
**<http://127.0.0.1:4747/>** (local only — it binds to `127.0.0.1`, so it is never exposed
to your network). The browser opens automatically, and the view updates live as you and
Claude change the graph.

It is a dark, Apple-Finance-style workspace showing:

- **Plans and their tasks** with status at a glance (todo / doing / done / blocked), and
  the current **focus** plan highlighted.
- **Decisions, files, questions, notes, and milestones**, plus the edges that connect them
  (implements, depends_on, blocks, …).
- **Search and filtering** across nodes, and a git-commit inspector (look up work by
  `HEAD`, a SHA, or a branch name).
- **Adding nodes from the UI** — a short title plus a "detail for Claude" body.

Change the port with `weave serve --port <n>`.

> 📸 To show a preview here, run `weave serve`, take a screenshot, save it as
> `docs/workspace.png`, and add `![weave workspace](docs/workspace.png)` to this section.

### Viewing it over SSH (remote server)

If you run `weave serve` on a remote machine over SSH, it still binds to *that* machine's
`127.0.0.1:4747`, which your laptop cannot reach directly. Forward the port through an SSH
tunnel by connecting with `-L`:

```bash
# from your local machine — connect with the port forwarded:
ssh -L 4747:127.0.0.1:4747 user@server
```

Then, on the server, start it without trying to launch a browser:

```bash
weave serve --no-open
```

…and open **<http://127.0.0.1:4747/>** in your *local* browser. The tunnel maps your local
4747 to the server's 4747.

> Already connected? Add the forward without reconnecting: press `Enter`, then type `~C`
> to get the `ssh>` prompt, and enter `-L 4747:127.0.0.1:4747`.

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
