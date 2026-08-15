# Intent

<!-- decapod:declared-capabilities:start -->

## Declared Capability Surfaces

- `authentication`
- `background-processing`
- `event-driven`
- `external-integrations`
- `infrastructure-management`
- `persistent-state`
- `public-api`
- `secrets-handling`

<!-- decapod:declared-capabilities:end -->

## Product Outcome
- NixOS system configuration for `cube`.

## What This Project Is
nixos is a service_or_library project built using shell.
NixOS system configuration for `cube`.

Key operating facts:
- **Primary languages**: shell
- **Detected surfaces**: shell

## Product View
```mermaid
flowchart LR
  U[Primary User] --> P[nixos]
  P --> O[User-visible Outcome]
  P --> G[Proof Gates]
  G --> E[Evidence Artifacts]
```

## Inferred Baseline
- Repository: nixos
- Product type: service_or_library
- Primary languages: shell
- Detected surfaces: shell

## Scope
| Area | In Scope | Proof Surface |
|---|---|---|
| Core workflow | Define a concrete user-visible workflow | Acceptance criteria + tests |
| Data contracts | Document canonical inputs/outputs | [INTERFACES.md](./INTERFACES.md) and schema checks |
| Delivery quality | Block promotion on broken proof surfaces | [VALIDATION.md](./VALIDATION.md) blocking gates |

## Non-Goals (Falsifiable)
| Non-goal | How to falsify |
|---|---|
| Feature creep beyond the primary outcome | Any PR adds capability not tied to outcome criteria |
| Shipping without evidence | Missing validation artifacts for promoted changes |
| Ambiguous ownership boundaries | Missing owner/system-of-record in interfaces |

## Constraints
- Technical: runtime, dependency, and topology boundaries are explicit.
- Operational: deployment, rollback, and incident ownership are defined.
- Security/compliance: sensitive data handling and authz are mandatory.

## Acceptance Criteria (must be objectively testable)
- [ ] Decapod validate passes, required tests pass, and promotion-relevant artifacts are present.
- [ ] Non-functional targets are met (latency, reliability, cost, etc.).
- [ ] Validation gates pass and artifacts are attached.
- [ ] Repository test/lint/typecheck commands are defined and wired into CI.

## Epistemic Custody Fields

### Active Assumptions
- [ ] List any assumptions made to proceed.
- [ ] Flag assumptions that require future verification.

### Confidence & Risk Level
- **Confidence**: Low/Medium/High (Rationale: )
- **Risk**: Low/Medium/High (Impact of wrong assumptions: )

### Measured vs Inferred Facts
| Fact | Source (Provenance) | Type (Measured/Inferred) |
|---|---|---|
| | | |

### Unresolved Contradictions
- [ ] List any evidence that conflicts with current assumptions or intent.

### Deferred Questions
- [ ] Questions to be answered later.

### Stop Conditions
- [ ] Explicit conditions under which the agent should stop and ask for help.

### Proof Required Before Completion
- [ ] Specific evidence needed to prove the outcome is met.

## Tradeoffs Register
| Decision | Benefit | Cost | Review Trigger |
|---|---|---|---|
| Simplicity vs extensibility | Faster iteration | Potential rework | Feature set expands |
| Strict gates vs dev speed | Higher confidence | More upfront discipline | Lead time regressions |

## First Implementation Slice
- [ ] Define the smallest user-visible workflow to ship first.
- [ ] Define required data/contracts for that workflow.
- [ ] Define what is intentionally postponed until v2.

## User and Actor Contract
- Primary user/agent:
- Authorized actors and their allowed mutations:
- Preconditions required before the primary workflow:
- Observable success result:
- Observable failure result and recovery action:
- Human decision points that automation must not infer:

## Outcome Decomposition
| Outcome | Trigger | State Written | Evidence | Owner |
|---|---|---|---|---|
| Primary outcome | | | | |
| Safety/quality outcome | | | | |
| Operational outcome | | | | |

## Change Impact Rules
- A change to user intent updates this document and acceptance criteria.
- A change to a runtime boundary updates [ARCHITECTURE.md](./ARCHITECTURE.md).
- A change to a callable or persisted contract updates [INTERFACES.md](./INTERFACES.md).
- A change to proof or promotion behavior updates [VALIDATION.md](./VALIDATION.md).
- A breaking change requires an explicit migration trigger, compatibility note,
  rollback condition, and an agent-facing instruction.

## Open Questions (with decision deadlines)
| Question | Owner | Deadline | Decision |
|---|---|---|---|
| Which interfaces are versioned at launch? | TBD | YYYY-MM-DD | |
| Which non-functional target is hardest to hit? | TBD | YYYY-MM-DD | |

<!-- decapod:codebase-attestation:start -->

## Codebase Attestation

- Repository signal fingerprint: `6cf51a5f91cb1302bae833bbcf59573c7a0de7188e1ffda0def84ceef9032985`
- Significant implementation surfaces: `.github/` (2 files), `README.md/` (1 files)
- Refreshed from the current codebase by `decapod specs.refresh`
<!-- decapod:codebase-attestation:end -->
