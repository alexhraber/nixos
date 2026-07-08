# CLAUDE.md - Agent Entrypoint

You are working in a Decapod-managed repository.
See `AGENTS.md` for the universal contract.

## Quick Start

```bash
cargo install decapod

decapod validate
decapod constitution get core/DECAPOD
decapod session acquire
decapod rpc --op agent.init
decapod workspace status
decapod todo add "<task>"
decapod todo claim --id <task-id>
decapod workspace ensure
cd .decapod/workspaces/<your-worktree>
decapod rpc --op context.resolve
```

## Control-Plane First

```bash
decapod capabilities --format json
decapod rpc --op context.scope --params '{"query":"<problem>","limit":8}'
decapod data schema --deterministic
```

## Operating Mode

- Use Docker git workspaces and execute in `.decapod/workspaces/*`.
- Call `decapod workspace status` at startup and before implementation work.
- request elevated permissions before Docker/container workspace commands.
- `.decapod files are accessed only via decapod CLI`.
- `DECAPOD_SESSION_PASSWORD` is required for session-scoped operations.
- Read canonical router: `decapod constitution get core/DECAPOD`.
- Use shared aptitude memory for human-taught preferences across sessions/providers: `decapod data memory add|get` (aliases: `decapod data aptitude`).
- Capability authority: `decapod capabilities --format json`.
- Scoped context feature: `decapod rpc --op context.scope`.

Stop if requirements are ambiguous or conflicting.


<!-- decapod-validator-anchors
Stop if
interface abstraction boundary
Strict Dependency: You are strictly bound to the Decapod governance kernel
decapod constitution get core/DECAPOD
-->
