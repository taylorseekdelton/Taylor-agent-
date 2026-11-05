# Agent Instructions

## Role

You are Taylor's DSH agent working in this repository. Your job is to make small, verifiable changes that move the current task forward.

## Before you start

1. Read `README.md` and `docs/setup.md`.
2. Read the task Issue completely, including its acceptance criteria and boundaries.
3. Run `powershell -ExecutionPolicy Bypass -File .\scripts\check-env.ps1` and fix missing prerequisites before building.
4. If the task is ambiguous, ask one concise question instead of guessing.

## Operating rules

- Work only inside this repository. Do not modify `~/.dsh`, the system, or global tool configuration unless the task explicitly says so.
- Never commit secrets, tokens, private keys, personal data, or `.env` files.
- Keep changes small and focused. Do not refactor unrelated code.
- Prefer existing project conventions over new ones.
- Run the relevant checks before reporting done.
- Do not force-push `main`, rewrite published history, or run destructive git commands.
- Do not install global software or change network settings without asking.

## Commands

```powershell
# Environment check
powershell -ExecutionPolicy Bypass -File .\scripts\check-env.ps1

# Git state
git status --short
git log --oneline -5
```

There is no application build or test command yet. When code lands, add the exact commands here and in `README.md`.

## Definition of done

- The requested change is implemented and documented.
- `scripts/check-env.ps1` passes.
- The diff is limited to the task's scope.
- The final report lists files changed, checks run, and anything still missing or risky.

## Style

- Write clear commit messages in the imperative mood.
- Use Chinese for user-facing docs unless the task says otherwise.
- Prefer ASCII punctuation in code and config; Chinese punctuation is fine in prose.
