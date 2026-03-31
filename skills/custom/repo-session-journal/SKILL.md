---
name: repo-session-journal
description: "Use this skill for most work in this DeerFlow repository, especially coding, debugging, reviews, architecture changes, maintenance, and cross-cutting investigations. It is the default repo workflow skill for this checkout: review recent repo context first, keep a concise local session journal in logs/agent-sessions, and leave a handoff-quality summary for future agents."
---

# Repo Session Journal

Use this skill as the default workflow for work in this repository unless the user clearly wants a different process or explicitly asks you not to keep a session journal.

The goal is simple: future agents should be able to understand what changed, why it mattered, and what is still unresolved without reconstructing the entire conversation.

## When To Use It

Use this skill for:

- Bug fixes and debugging
- Refactors and architecture work
- Repo maintenance and configuration changes
- PR review follow-up
- Multi-step investigations
- Work that touches multiple subsystems or will likely need a later handoff

## Core Workflow

### 1. Review context before changing anything

Before substantial work, review the most relevant repo context:

- `AGENTS.md`
- The files directly involved in the request
- Recent relevant entries under `logs/agent-sessions/`, if they exist

Do not read the entire archive by default. Read the newest relevant logs first and stop once you have enough context.

### 2. Keep one session file per work session

Create or update exactly one Markdown log for the current session:

`logs/agent-sessions/YYYY-MM-DD/HHMMSS-task-slug.md`

Use a short task slug based on the user request, for example:

- `logs/agent-sessions/2026-03-31/142210-skill-journal.md`
- `logs/agent-sessions/2026-03-31/154500-fix-mcp-wrapper.md`

This archive is local operating history, not commit history.

- Keep logs concise.
- Prefer summaries over transcripts.
- Do not paste large command outputs unless they are essential.
- Do not commit routine session logs unless the user explicitly asks.

### 3. Update the file at meaningful checkpoints

At minimum, the file should be created early and finalized before closing the task. Update it when a major decision, discovery, or blocker appears.

## Required Log Template

Use this structure:

```md
# Session: <short title>

## Request
<What the user wanted>

## Scope
<What is in scope and what is intentionally not being changed>

## Areas Touched
- <path or subsystem>

## Findings
- <important fact, current behavior, or constraint>

## Decisions
- <decision and reason>

## Open Questions / Risks
- <only if any remain>

## Next Steps
- <useful follow-up for the next agent or session>
```

If the session becomes purely exploratory and no files are changed, still leave a short summary so the next agent understands what was ruled out.

## Handoff Rules

Before ending the task:

- Make sure the session file reflects the final outcome.
- Record any unfinished work, assumptions, or risks.
- Point the next agent to the most relevant files or subsystems instead of describing everything at a high level.

## Chaoscribe Integration Hook

This repository may later integrate with the `chaoscribe` repo and the public site at `https://chaoscribe.com`.

Treat cross-repo work as a special case:

- If the task only mentions DeerFlow, stay within this repo and note any `chaoscribe` dependency as a future consideration.
- If the task involves DeerFlow-to-Chaoscribe integration, add a clear note in the session log describing the boundary, assumptions, and what information is missing.
- Reserve deep Chaoscribe-specific investigation for a future specialist skill named `chaoscribe-bridge`.

Until `chaoscribe-bridge` exists, do not invent detailed Chaoscribe behavior. Record the need for follow-up instead.
