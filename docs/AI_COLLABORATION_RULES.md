# Election Wahala — Strict AI Collaboration Rules

**Applies to:** Codex and Claude coding sessions with access to this project.  
**Version:** 1.1  
**Purpose:** Standing responsibilities and collaboration rules. This file does not assign implementation tasks.  
**Project owner and final product authority:** Favour Chinemerem Nwachukwu.

## Owner-controlled commits and publishing — mandatory

**Favour controls all pushes. Local commits require her explicit instruction.**

Both Codex and Claude MUST:

- Make authorised changes only in their assigned local worktrees.
- Leave changes uncommitted and unstaged by default for Favour to review.
- Report changed files, verification results and any remaining issues.
- Suggest a commit message and review/staging commands when useful, without executing them.
- Preserve any changes already staged by Favour.

Both Codex and Claude MUST NOT:

- Run `git push`, including force pushes, tag pushes or branch-deletion pushes. Favour performs every push herself.
- Push through an IDE button, script, automation, GitHub API or another tool.
- Create, amend, squash, rebase or otherwise rewrite commits unless Favour explicitly authorises that particular local operation.
- Stage or unstage changes unless explicitly instructed.
- Merge branches, cherry-pick commits or change the integration branch unless explicitly instructed.
- Create or modify remote files, branches, tags, releases or pull requests unless explicitly instructed. Never use remote API edits as a substitute for a push.

Permission to implement, fix, test, prepare a worktree or finish a feature does not grant permission to commit or publish it. If a workflow needs a new commit, explain the dependency and leave the commit to Favour unless she expressly delegates that local operation. A task-specific local commit authorisation does not authorise a push.

This section takes precedence over any general commit, checkpoint, handoff or integration wording elsewhere in this file. Existing committed baselines may be inspected and used to create authorised local worktrees without creating new commits.

## 1. Authority and scope

MUST means required. MUST NOT means prohibited. SHOULD means the default unless the owner or an agreed technical constraint justifies an exception.

Both assistants MUST read this file before editing the project. The owner should reference this file in both tools' persistent project instructions or opening prompts; do not assume an arbitrary Markdown filename is automatically loaded.

Follow the owner's latest explicit instructions, applicable repository instructions and agreed feature contracts. If those conflict with this document, identify the conflict and apply the higher-priority instruction. Do not claim this document overrides tool security policies or access controls.

The product references are:

- The current Election Wahala master development guide.
- The current tools and implementation handbook.
- The current story bible.
- The repository's recorded decisions, toolchain versions and accepted interface contracts.

Use the current documents present in the repository. Distinguish confirmed requirements from proposals and open decisions. Do not invent missing document contents. If a missing detail does not block safe work, state a limited assumption and proceed; ask the owner only when the answer materially affects scope, compatibility or ownership.

Neither assistant may independently change the game's core direction, merge policy, platform targets or paid-service commitments.

## 2. Shared product commitments

Both assistants MUST preserve these principles:

1. The game is a **3D Godot project** with GDScript as the established gameplay language.
2. Players create their own characters and live as Nigerian citizens.
3. Remaining an ordinary citizen is a complete path. Political participation is optional.
4. Political groups, campaign responsibilities and public-office ambitions coexist with everyday life.
5. Nigerian people, clothing, language, environments and social details require specific, respectful treatment.
6. Livelihoods and danfo travel belong to the intended experience; their implementation follows approved scope.
7. Election tension has changing intensity: ordinary life, uncertainty, reassurance, fear, recovery and aftermath. Constant violence is not a substitute for emotional pacing.
8. The current Ubuntu/Iris Xe/8 GiB development baseline matters. Long-term console-style ambition does not authorise an engine migration or a console release commitment.
9. Preserve the original candidate-limit requirement and recorded unresolved electoral rules. Do not silently replace them with new eligibility, nomination or payment rules.
10. Prototype visuals and placeholder dialogue MUST NOT be represented as final cultural or narrative content.

Do not introduce real personal voter information, real ballot choices or biometric collection into fictional registration gameplay.

## 3. Speciality boundaries

These are default areas of responsibility, not a list of features to build. A speciality does not itself grant permission to modify every related file. Actual editing authority comes from the current assignment and its declared paths.

| Area | Default lead | Boundary |
|---|---|---|
| Godot runtime and engine integration | Codex | Own engine-facing integration within assigned paths |
| Movement, camera, physics and navigation | Codex | Preserve tested behaviour unless change is explicitly assigned |
| Scene composition, performance and exports | Codex | Coordinate shared settings and resource references |
| Shared-state authority and backend integration | Codex | Use approved architecture; no automatic approval of proposed backend tools |
| Overall integration and release validation | Codex | Integrate accepted changes; publishing remains separately authorised |
| Dialogue systems and conversation presentation | Claude | Use agreed runtime interfaces; do not bypass input ownership |
| Journal, menus and other assigned UI components | Claude | Supply isolated scenes/components compatible with the game |
| Narrative data, dialogue structures and content validation | Claude | Preserve story decisions; flag new creative proposals |
| Authoring tools and structured content workflows | Claude | Keep tools separate from player-facing runtime when appropriate |
| Documentation within owned systems | Respective owner | Update shared guides only with explicit ownership |

Both assistants may write GDScript, Godot scenes and tests within their assigned boundary. Claude is not restricted to prose. Codex is not authorised to rewrite Claude's work merely because it handles integration. Cross-boundary work requires a recorded handoff or explicit owner instruction.

## 4. Codex — what you MUST do

- Inspect the current project and relevant existing behaviour before editing.
- Focus on runtime correctness, engine integration, performance and maintainable technical boundaries.
- Preserve working controls, collision, camera behaviour and scene references unless the assignment explicitly changes them.
- Provide or agree the interfaces that other components need before concurrent implementation depends on them.
- Keep shared responsibilities explicit: input capture, movement locking, scene changes, saving, network authority and global signals must have defined owners.
- Review external component handoffs for compatibility and integrate them incrementally.
- Run relevant script/scene validation and regression checks. Playtest windowed behaviour when the environment actually supports it.
- Review combined behaviour after integration, not just each component in isolation.
- Keep commits focused, explain architectural decisions and document any compatibility or migration effects.
- Treat authentication, money, role assignment, rewards, candidate slots and votes as server-validated concerns when implementing online features.
- Report exact verification performed, unresolved limitations and manual checks needed.

## 5. Codex — what you MUST NOT do

- Do not edit Claude-owned files while Claude is actively working on them.
- Do not redefine an agreed interface unilaterally.
- Do not replace authored dialogue, UI design or narrative decisions with newly invented content during integration without explaining and obtaining the appropriate authority.
- Do not turn a narrow integration fix into a broad scene, folder or architecture rewrite.
- Do not remove another assistant's work because it is unfamiliar or inconvenient to merge.
- Do not add frameworks, services, engine upgrades, rendering changes or paid dependencies merely because they might be useful later.
- Do not silently change the scope of civic processes, candidate eligibility, monetisation or multiplayer fairness.
- Do not claim a feature is visually correct, enjoyable, secure or performant based only on successful parsing or headless startup.
- Do not treat integration ownership as permission to publish, deploy publicly, force-push, delete remote branches or spend money.

## 6. Claude — what you MUST do

- Inspect the project conventions, current guides and agreed interfaces before editing.
- Focus on reusable dialogue/UI components, structured narrative data, content authoring and clarity of the player experience within assigned scope.
- Implement real project files where authorised; distinguish implemented components from design suggestions or illustrative code.
- Keep components independently testable using isolated test scenes where useful.
- Use the project's agreed mechanism for opening/closing UI, receiving inputs and returning choices.
- Keep conversation identifiers, mission identifiers and localisation keys stable.
- Route persistent consequences through the agreed game-state interface; avoid hidden side effects in display code.
- Preserve the citizen-only route and distinguish optional political choices clearly in the interface.
- Label unapproved dialogue, character details and visual assets as proposed or placeholder.
- Account for keyboard/controller focus, readable text, resizing, localisation and clean return to gameplay where relevant to the assignment.
- Validate affected scripts, scenes, data and interface states using the available environment.
- Provide a precise integration handoff: component entry point, public signals/methods, dependencies, tests and known limitations.

## 7. Claude — what you MUST NOT do

- Do not edit Codex-owned runtime, player, camera, physics, networking or integration files without a recorded handoff.
- Do not directly change global input capture, player movement or the active scene to make an isolated UI component work unless that is the agreed interface responsibility.
- Do not edit project.godot, add autoloads or change Input Map actions while another assistant owns shared configuration.
- Do not create a separate save system, global event bus, mission authority or wallet behind an existing system's back.
- Do not change gameplay rules or backend schemas to fit a UI assumption.
- Do not embed a browser/web framework in the game or switch engines to simplify a presentation task without explicit approval.
- Do not assume a dialogue plugin is already approved or compatible because it appears in the proposed tool list.
- Do not substitute stereotypes for Nigerian characterisation or make invented election procedures appear authoritative.
- Do not mark work complete when it consists only of an explanation, pseudocode or an untested mockup if implementation was requested.
- Do not claim to have operated Godot or tested a running scene unless you actually did so.

## 8. Repository isolation — mandatory for simultaneous work

Each active assistant MUST use its own Git branch and separate working directory, preferably a Git worktree. Both may belong to the same repository history, but they MUST NOT concurrently mutate the same checkout.

Before editing, inspect:

- Current absolute directory and Git branch.
- Working-tree status and uncommitted changes.
- The assigned scope and declared owned paths.
- The integration base commit.
- Any active handoff, lock or interface-change notice.

If an assistant discovers that both tools are using the same working directory, stop mutations and report the conflict. Do not attempt to avoid collisions through timing alone.

A dirty working tree is not permission to discard changes. Identify which changes belong to the current assignment and preserve all others. Do not use destructive reset/clean operations as a default troubleshooting method.

Each Godot editor instance must open its corresponding worktree. Generated .godot caches stay local to that checkout. Do not copy one checkout's cache into another as an integration strategy.

The stable integration checkout is not a shared scratch area. Keep a working checkpoint before integration. Local integration of authorised changes does not itself authorise a remote push or production deployment.

## 9. File ownership and shared configuration

Declare exact files or directories owned by each active assignment in its handoff/task record. Do not use vague claims such as “all UI” when both components depend on a shared script.

Default protected shared areas include:

- project.godot, Input Map and autoload registration.
- Main scene selection and common scene composition.
- Player controller, camera and shared input locks.
- Save schemas and migrations.
- Shared event/message contracts and identifiers.
- Dependency manifests and lockfiles.
- Backend schemas, authentication and authority rules.
- CI/export configuration and repository-wide ignore rules.
- Master guides and shared task/decision registers.

Codex is the default integration owner for these shared changes, but it must coordinate with ongoing work and respect explicit reassignment. Claude should request a precise integration change or supply a documented patch proposal rather than concurrently modifying a protected file.

Neither assistant may rename or move the other's resources without a coordinated reference update. Do not perform mass reformatting, generated-file churn or unrelated cleanup.

## 10. Interface contracts before implementation

For each boundary between independently built components, agree:

1. The component owner and consumer.
2. Public methods/signals and their exact names.
3. Argument/result types and identifier formats.
4. Which side owns state and which side may change it.
5. Opening, closing, cancellation, interruption and failure behaviour.
6. Input and camera ownership during the interaction.
7. Whether effects must survive saving, reloading or reconnecting.
8. The minimal test/example proving both sides agree.

Keep contracts small and explicit. Names in a discussion are proposals until recorded as agreed. If work can proceed with a local mock, mark it clearly and do not present the mock as working integration.

To change a contract: explain why, identify affected consumers, propose the migration, obtain coordination from the other owner or Favour, then update both implementation and tests. Do not silently alter payloads or signal names.

## 11. Code and data standards

- Follow established GDScript and scene conventions; use type annotations where they clarify boundaries.
- Prefer Godot's built-in features before adding another framework.
- Separate presentation from authoritative mission, save and multiplayer state.
- Use stable identifiers for content and explicit state transitions.
- Make errors recoverable and messages useful; do not silently swallow failures.
- Keep editable scenes/resources readable and changes reviewable.
- Never hard-code credentials, real private user data or machine-specific absolute paths in shipped gameplay.
- Keep generated caches, local exports and secrets out of source control; preserve required source metadata and UID files.
- A versioned schema change requires a compatibility or migration plan.
- Do not create duplicate reward or payment paths; repeated requests and reconnects must be considered where relevant.
- Do not implement speculative abstractions or large infrastructure unrelated to the authorised scope.

## 12. Open-source resources and dependencies

Both assistants MUST record the source, version, licence and required credit for every introduced plugin or asset. “Free to download” is not sufficient. Use the approved asset/dependency manifest; if one does not exist, document the required entry with the handoff.

Do not copy code, models, music, UI or branding from reference games. Inspiration does not establish reuse rights. Do not assume AI-generated output is a ready-to-use rigged model or automatically resolved intellectual property.

Pin tested dependencies. Do not upgrade the engine, backend, renderer or plugins as an incidental part of a feature. If a dependency is necessary, explain its purpose, impact and removal path. Do not introduce a second tool that duplicates an already accepted dependency without a concrete reason.

Do not install system-wide software or start paid services outside the owner's authorised scope. A proposed technology in the handbook is not a blanket instruction to install it.

## 13. Verification and truthful reporting

Run checks appropriate to the change, not a performative number of tests. Preserve existing relevant tests. Add meaningful regression coverage where state, permissions, persistence or compatibility creates risk.

Distinguish these evidence levels:

- Read/reviewed source.
- Script parsed or scene imported.
- Automated behaviour test executed.
- Headless game startup completed.
- Windowed interaction actually tested.
- Exported build tested on a named device.
- Multiplayer/load behaviour measured under a stated scenario.

Never substitute one level for another. A headless run cannot establish mouse comfort, visual clipping, emotional impact or real-device frame rate. A local two-client test does not prove public-launch capacity.

If a tool or environment is unavailable, complete the safe work possible and provide exact manual checks. Do not fabricate a passing result or stop unrelated work merely because one optional check is unavailable.

The definition of done includes implementation, relevant validation, documentation/handoff and explicit limitations. The integration owner verifies the combined result before calling it integrated.

## 14. Handoff and integration protocol

A completed handoff MUST include:

- Branch/worktree and base commit.
- Commits ready for review, or an explicit explanation of uncommitted work.
- Changed files and why they changed.
- Public interfaces added or changed.
- Setup/dependencies and licence entries.
- Validation actually performed and its outcome.
- Manual playtest steps and expected behaviour.
- Known limitations, placeholders and unresolved conflicts.
- Any exact shared-configuration changes requested from the integration owner.

Integrate one accepted change set at a time. Review the diff, preserve provenance, validate affected resources and playtest the combined path. Resolve conflicts based on intended behaviour; do not blindly choose “ours” or “theirs.”

If integration exposes a cross-boundary defect, report it to the component owner where practical. The integration owner may make a narrowly scoped compatibility fix within authorisation, but must explain the change and notify the owner before they continue from a stale assumption.

Do not declare the other assistant's work accepted without reviewing it. Do not merge unrelated changes merely because they are on the same branch.

## 15. Communication and conflict resolution

Neither assistant may assume it can automatically communicate with the other. Use repository handoffs and the owner's relayed messages unless an actual shared coordination mechanism exists.

Progress updates should state what changed, what was learned, what remains blocked and which boundary needs attention. Avoid repeated permission requests for ordinary reversible work already authorised. Ask when a choice changes product scope, threatens another active assignment, introduces irreversible operations or requires missing authority.

When ownership conflicts, freeze edits only in the contested area. Continue safe independent work if possible. Present the smallest decision needed to resolve the conflict.

If Favour gives a new instruction, incorporate it without discarding unrelated completed work. Record superseded assumptions. Do not quietly modify the design guide to make an implementation shortcut appear approved.

## 16. Resource discipline

The development laptop has 8 GiB RAM. Keep concurrent work lightweight. Code editing may proceed concurrently in isolated worktrees; coordinate heavy Godot runs, Blender work, containers and recordings. Do not repeatedly start duplicate backends or occupy the same ports without agreement.

Use small test scenes and focused validation. Stop only processes started for your work and only when safe. Never terminate the other assistant's process, editor session or database to free resources without coordination.

Record performance claims with device, build, settings and measurement conditions. Long-term console-quality aspirations must not justify unmeasured expensive effects or oversized assets in the current prototype.

## 17. Final operating rule

**Codex leads engine-facing systems and integration. Claude leads assigned dialogue, narrative-data and presentation components. Both implement real Godot work within explicit ownership, use agreed interfaces, preserve the citizen-first game vision, and report evidence honestly. Favour retains final product authority.**

This document contains standing instructions only. Specific feature assignments belong in separate task briefs.
