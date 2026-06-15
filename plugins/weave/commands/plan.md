---
description: create a weave plan with tasks for the given goal
argument-hint: [plan title / what we are working on]
---

Create a weave plan for: $ARGUMENTS

1. `weave add plan "<title>" --body "<one-line goal>"`.
2. Break it into 3-8 concrete tasks: for each, `weave add task "<step>" --parent <planId>`.
3. Add `weave link` edges for any depends_on / blocks relationships.
4. `weave focus <planId>`.
5. Show me the plan with `weave show <planId>` and confirm before implementing.
