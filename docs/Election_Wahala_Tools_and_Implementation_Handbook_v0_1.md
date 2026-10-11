# Election Wahala: Tools, Resources and Implementation Handbook

**Version:** 0.1  
**Date:** 12 October 2026  
**Companion:** Election_Wahala_Development_Guide_v0_2.md  
**Owner:** Favour Chinemerem Nwachukwu  
**Purpose:** Translate the game vision into software choices, resource pipelines, assigned work packages, dependencies and completion gates.

> Build a playable Nigerian citizen story first. Use open-source tools where they fit, test the difficult technical assumptions early, and expand toward the full election and social experience without losing the tension, relationships or optional political paths.

## 1. What this handbook does—and does not claim

The master guide defines the game. This handbook defines how to build it. It is a separate living document, not a replacement for the storyline, requirement register or decisions in master guide v0.2.

This is a recommended implementation baseline. Godot, 3D, Ubuntu and VS Code/Codex are established project choices. Additional packages below are proposed selections or trials, not already installed or proven compatible. No software was installed on the user's laptop while preparing this document. Costs have not been quoted by vendors. A framework listed here does not automatically implement our game rules.

No honest tool list can predict every dependency for a future nationwide multiplayer console-quality game. This handbook covers the known systems, identifies the remaining decision gates and provides a process for admitting later dependencies. It deliberately avoids installing multiple overlapping engines, backends or dialogue frameworks.

**Status vocabulary:** Established = used in current work; Adopt next = recommended near-term choice; Trial = evaluate before committing; Later = needed only at a named milestone; Optional = useful if a real problem arises; Open = decision still required.

Source notes at the end link to official documentation and original project pages inspected for this handbook. Licensing summaries are procurement checks, not a substitute for reading the exact downloaded release and asset licence.

## 2. The stack in one view

| Layer | Recommended choice | When | Why / boundary |
|---|---|---|---|
| Engine | Godot 4 standard build, Compatibility renderer | Established | Keep current working 3D project |
| Gameplay language | GDScript | Established | Engine-native gameplay; no extra language runtime |
| Editing / coding assistance | Existing VS Code and Codex | Established | Inspect/edit/test focused tasks; human review remains necessary |
| Source control | Git; remote repository provider chosen by owner | Adopt next | Recoverable checkpoints and collaboration |
| Large source assets | Git LFS when binary assets arrive | Adopt next | Avoid growing ordinary Git history with large art/audio |
| Modelling / rigging / animation | Blender | Adopt next | One primary 3D production application |
| Texture and concept painting | Krita | Next art milestone | Edit original textures and clothing patterns |
| Vector signs / interface artwork | Inkscape | Optional | Use when editable vector work is needed |
| Audio recording / cleanup | Audacity | Audio milestone | Voice and ambience preparation |
| Video capture | Existing Ubuntu recorder; OBS if needed | Established / optional | Record reproducible playtests |
| Dialogue | Godot Dialogue Manager compatible release | Trial | Authored branching conversations |
| Quest state, queue, incidents, transport | Custom small GDScript systems | Build | These encode our original rules |
| Testing | GUT compatible release + Godot test scenes | Trial / adopt | Behaviour regressions and repeatable validation |
| Local saves | Versioned JSON using Godot file APIs | First slice | Simple and inspectable; not online authority |
| Accounts/social/persistence | Nakama OSS + PostgreSQL | Network trial | Game-oriented backend; integration still required |
| Backend game rules | Nakama TypeScript runtime | Network trial | Reuse owner's TypeScript familiarity |
| 3D authoritative simulation | Headless Godot server | Network trial | Reuse movement/collision scene logic |
| Local backend deployment | Docker Engine and Compose on Ubuntu | Network trial | Reproducible services; start only when needed |
| Android | Matching Godot export templates, OpenJDK and Android SDK | Early device milestone | Real-device performance proof |
| iOS | macOS/Xcode access + Godot export workflow | Later | Not available through Ubuntu alone |
| PlayStation | Separate feasibility/porting work | Long-term open | No default console exporter assumed |

**Do not add now:** React, Next.js, Phaser, Unity, Unreal, Flutter, Firebase, Supabase, a second database, Kubernetes, Redis, a live AI dialogue service or a custom web admin panel. Some may be useful later for a specific reason; none is necessary to get our first citizen mission working.

## 3. Hardware and installation order

### 3.1 Development machine

Known baseline: Ubuntu 24.04.4, Intel i5-1135G7, Iris Xe and 8 GiB RAM. The current project runs locally. That does not establish capacity for complex crowds, high-resolution textures or multiple servers and editors at once.

Practical working pattern: Godot plus VS Code for coding; close Godot or unnecessary browser tabs during heavier Blender work; run backend containers only for network tests. Prefer a physical Android device to a resource-heavy emulator. Begin with small textures and compact scenes. Measure free disk and memory before downloading large asset packs or SDKs.

A RAM or hardware upgrade is a possible later expense, not a purchase prerequisite for the next task. Verify machine-specific upgrade options before buying anything.

### 3.2 Install in waves

1. **Project protection:** verify Git, create a repository checkpoint, choose a remote, back up source assets. Audit versions of already installed Godot and VS Code.
2. **First playable interaction:** no new large application needed. Implement interaction, dialogue, objectives and local saves. Trial one dialogue plugin only if it reduces work.
3. **First human character:** Blender; one small licensed character base; Krita when editing its texture/outfit.
4. **First sound pass:** Audacity and a few licensed or original recordings. Existing screen recorder is sufficient until its limitations are concrete.
5. **Network proof:** Docker Engine/Compose, Nakama, PostgreSQL, SDK and TypeScript build tooling. Keep services local while developing.
6. **Device export:** engine-matched export templates, JDK and Android SDK; install required SDK components rather than every platform image.
7. **Public service preparation:** hosting, domain/TLS, backups, monitoring and moderation. No public deployment before these work.

### 3.3 Read-only machine audit

Run these on the user's Ubuntu laptop—not in an unrelated cloud workspace—and record results. Missing commands are an inventory result, not an instruction to install everything immediately.

```bash
lsb_release -ds
free -h
df -h .
git --version
git lfs version
code --version
blender --version
docker version
docker compose version
java -version
```

The downloaded Godot executable may not be named `godot` on PATH. Check its actual location and `--version`, and record the exact filename. Do not upgrade the engine mid-task merely because a newer version exists.

## 4. Dependency policy and version control

Maintain `docs/toolchain.md` with exact tested versions of Godot, export templates, Blender, plugins, SDKs, Nakama, PostgreSQL and build tooling. Pin compatible releases after testing; never use unqualified `latest` container tags in a reproducible build. Stable documentation may move ahead of our pinned release, so consult version-specific docs during implementation.

Create an admission record for every plugin: purpose, official repository, release/commit, licence, supported Godot version, test scene, files changed and removal plan. Reject a plugin when built-in engine features already solve the task cleanly.

Commit gameplay code, scenes, Godot UID sidecar files where produced by the pinned version, project settings, original text resources, licences and import settings required for reproducibility. Ignore the generated `.godot/` cache, temporary exports, local credentials and private signing keys. Do not use a blanket ignore rule that accidentally excludes required UID files.

Use Git LFS for selected large binaries such as `.blend`, `.glb` and source audio when appropriate. LFS stores pointers in Git and separate binary objects [T04]; a repository clone without the objects is incomplete. Test a fresh checkout and asset fetch. Hosted LFS storage/bandwidth may cost money even though the tool is open source.

Keep one issue/task per meaningful change. A task should reference the master-guide requirement and this handbook's work package. Commit a working checkpoint before a substantial scene refactor. Do not rewrite shared history or mass-delete project files as a routine cleanup step.

## 5. Godot systems: built-in features and code we must write

| Game need | Engine facility / candidate | Custom work |
|---|---|---|
| Character movement | CharacterBody3D, Input Map | Input ownership, acceleration tuning, interactions, network validation |
| Camera | Camera3D, SpringArm3D | Framing, collision comfort, sensitivity and controller input |
| Humanoid animation | Skeleton3D, AnimationPlayer, AnimationTree | Rig import, blend rules, facing and foot-contact tuning |
| Interactions | Ray/shape queries, Area3D, signals | Target priority, range, visibility, prompts and actions |
| NPC routes | NavigationRegion3D / NavigationAgent3D | Schedules, destinations, queue slots and stuck recovery |
| Dialogue | Dialogue Manager trial | Nigerian dialogue, localisation keys and permitted state changes |
| Missions | Resources/JSON and signals | State machine, branches, prerequisites and consequence logic |
| Queue | Navigation plus explicit ordered slots | Service assignment, join/leave, fairness and interruption handling |
| Day phases | Timers / authored state | Election calendar, route availability and personal progress rules |
| Audio | AudioStreamPlayer3D and buses | Mix, regional ambience, incident cues and subtitles |
| UI | Control nodes and themes | Phone, journal, dialogue, team screens and readable touch layouts |
| Saves | FileAccess / JSON | Schema version, atomic writes, backups and migrations |
| Vehicles | Prototype custom controller or built-in vehicle facilities | Test handling before choosing; stops, seats, fares and recovery |
| Multiplayer | High-level networking / headless export | Authority, sessions, reconnect, interpolation and state ownership |
| Election ledger | Backend storage and custom rules | Capacity, eligibility, secret-ballot handling and counting |

Do not build a generic “framework for everything” before one mission works. Extract reusable components after two real uses reveal their common behaviour. A downloaded dialogue addon is not a quest engine, and an online groups feature is not our political-role permission system.

### 5.1 Initial plugin candidates

**Dialogue Manager:** original project at `github.com/nathanhoad/godot_dialogue_manager` [T05]. Trial its branching dialogue workflow with one NPC. Confirm release compatibility, input focus, export behaviour and access to our quest state. Keep gameplay mutations behind explicit functions rather than allowing arbitrary dialogue strings to alter any field. If the plugin is unsuitable, implement a small data-driven dialogue runner; do not install several competing addons.

**GUT:** Godot unit-testing framework at `github.com/bitwes/Gut` [T06]. Select a release compatible with the pinned Godot version. Test mission transitions, save migration, reward idempotency and eligibility functions. Use engine scenes for integration. Do not mistake a large count of trivial assertions for gameplay quality.

No terrain plugin, visual-shader framework, ECS library or behaviour-tree package is required for the current small compound. Add only after identifying a measurable need.

## 6. Open-source art pipeline and asset sources

### 6.1 Tools and formats

Blender is the primary modelling, rigging and animation tool. Export game-ready glTF/GLB assets; keep editable `.blend` sources separately. Godot documents glTF and Blender import routes [T02]. Explicit GLB exports are a practical reproducible choice because everyone importing the game need not rely on a local Blender executable configuration.

Krita handles texture painting and concept work [T07]. Inkscape is an optional vector editor for original signage and UI graphics; verify its current distribution/licence at installation. Use ordinary PNG textures and suitably optimised runtime files, while retaining editable originals. Shared materials and modest resolution matter more than downloading the largest available textures.

### 6.2 Resource shortlist

| Resource | Use | Licence/source check | Work still needed |
|---|---|---|---|
| Kenney assets | Props, generic UI and prototype environment pieces | Asset-page assets stated CC0 [A01] | Adapt scale/style; these do not establish Nigerian authenticity |
| Quaternius Universal Base Characters | Character-body starting point | Specific base pack states CC0 [A02] | Nigerian hairstyles/outfits, rig review, animations and customisation |
| Poly Haven | Materials, HDRIs and some models | Asset licence page states CC0 [A03] | Downsize, test rendering and choose locally appropriate materials |
| ambientCG | Candidate material library | Exact official asset/licence must be checked before approval | Candidate only; official licence retrieval incomplete in this research |
| MakeHuman | Optional alternative human-generation trial | Application and exported/community assets may have different terms [A04] | Evaluate topology, rig and exact asset licences; not default pipeline |
| Freesound | Selected sound effects/ambience | Individual sounds carry different licences [A05] | Filter carefully; clean, edit and document recordings |
| Original field reference | Nigerian streets, clothing and environmental observation | Record ownership/permission and intended use | Convert reference into original game assets |

Open-source software, open-licensed assets and free downloads are different categories. A site providing free downloads does not automatically allow commercial redistribution. A paid pack can have a permissive licence, while a free pack can restrict commercial use. Check the specific item and included dependencies.

### 6.3 First asset procurement task

Acquire only a small trial set: one human base, one idle/walk/run set if licensed and compatible, one ground material, one wall material and a handful of props. Put unapproved downloads outside the shipping asset directory. For each, complete the asset manifest before importing.

Review the human in Godot before designing twenty outfits. Verify height, orientation, collision alignment, skin appearance under daylight, animation deformation, feet contact and camera framing. Choose one everyday outfit first. A generic base model can save time; it will not supply the desired cultural character design by itself.

### 6.4 What we must make or commission

Nigerian clothing combinations, character faces/hair where the base is inadequate, local school signage, danfo livery and interior, conductor performance, neighbourhood-specific buildings, authored dialogue and emotional acting need original work or appropriately licensed sources. Build from references for the represented place rather than assembling unrelated “African” assets.

Do not import another game's models or reproduce its logo. Concept images may help art direction; they do not replace UV mapping, rigging, animation or a performant 3D model. No runtime AI service is required for our first release.

### 6.5 Asset manifest fields

`asset_id`, `display_name`, `source_url`, `creator`, `download_date`, `version_or_hash`, `licence_identifier`, `licence_file_path`, `required_credit`, `commercial_use_review`, `modifications`, `source_file`, `runtime_file`, `import_settings`, `triangle_count`, `texture_sizes`, `reviewer`, `approval_status`.

Store notices in `LICENSES/` and generate credits from the approved manifest. Record CC0 provenance too. For recorded voices, store a release/usage agreement and performer credit preference. Using GPL art software does not by itself make all artwork GPL; the artwork and embedded assets must be checked separately [T03]. Plugin/code redistribution may have different obligations.

## 7. Audio, fear and presentation tools

Use Audacity for recording/editing [T08], Godot audio buses for implementation, and original or individually licensed effects. Keep voice masters in a lossless format, then export an appropriate runtime format after listening tests. Separate speech, music, ambience and effects buses so users can adjust them.

Create an audio cue sheet for each story beat: source, position, trigger, duration, priority, subtitle equivalent and recovery behaviour. A distant gunshot should not sound identical to a nearby one, and a loud sound alone should not carry all the emotional work.

First sound test: ordinary school/street ambience → crowd unease → reassuring dialogue → distant incident cue → quiet recovery. Pair it with visible NPC behaviour and an available exit. Test reduced volume and subtitles. Record what players actually noticed.

The existing Ubuntu recorder is sufficient for initial evidence. OBS is an open-source option for structured capture [T09]; do not run heavy recording settings during a performance benchmark without noting recording overhead. FFmpeg may be used for conversion when installed, but is not a game-runtime dependency.

Later cinematic tools can remain within Godot: authored cameras, AnimationPlayer and scripted events. Maintain player control during most scenes. Full motion capture, expensive facial animation and licensed middleware are optional later investments, not prerequisites for emotional storytelling.

## 8. Online architecture: a trial with clear ownership

### 8.1 Recommended first trial

Trial **Nakama OSS + PostgreSQL + official Godot SDK**, with custom backend rules in TypeScript [N01–N04]. Nakama is a useful candidate because the project needs identity, social groups and persistent game data. Evaluate it with a two-client proof before treating it as a permanent commitment.

Important distinction: Nakama's technical “parties” are session-oriented grouping features. Our fictional political parties need persistent organisation records, memberships, applications and permission rules. Do not map one to the other solely because the names match.

Node.js/npm may be used to compile TypeScript tooling, but Nakama's server runtime is not a general Node.js application [N03]. Do not assume browser APIs, Node packages, arbitrary filesystem access or Express work inside it. Restrict dependencies to supported runtime behaviour.

### 8.2 Proposed authority split

| Component | Owns | Must not own |
|---|---|---|
| Godot client | Rendering, camera, input, UI, local predicted presentation | Final balances, roles, ballots or server eligibility |
| Headless Godot server | Shared 3D simulation, proximity, collision and active incidents | Permanent identity or election data without backend transaction |
| Nakama/custom server logic | Authentication, group/role rules, mission rewards, candidate and ballot operations | Trust in client-reported outcomes |
| PostgreSQL behind services | Durable records and transaction state | Direct connections from player clients |

Nakama authoritative matches do not automatically run Godot physics. Use the headless Godot experiment for shared physical scenes; define a narrow authenticated server-to-server interface for persistent rewards. The backend remains the owner of permanent transactions. Avoid two competing authorities for the same field.

Start simple: one simulation process, one backend and one database for a private test. Do not build automatic fleet scaling first. Decide whether headless processes are necessary for every activity after measuring real requirements.

### 8.3 Proof-of-concept acceptance

Two clients connect with distinct test identities; one creates/joins a group; another applies for a campaign role; an authorised leader accepts; a shared task completes once; a client disconnects/rejoins; role revocation takes effect; a manipulated client request is rejected.

Then test authoritative movement and one proximity-gated interaction. Measure memory, server CPU, round-trip time and bandwidth. Network tick rate and player capacity remain tuning decisions. Do not promise MMO scale based on two local clients.

### 8.4 Election-specific engineering

Implement candidate-slot reservation with atomic capacity enforcement, and idempotent ballot submission with eligibility and phase checks. Resolve the master guide's first-ten/nomination conflict before building final UX. Keep identity eligibility records and ballot choice access carefully separated. Generic storage is not a complete secret-ballot design.

Use a deterministic counting function and test it against fixed fixtures. Never let a client or campaign leader set results. Narrative manipulation incidents remain distinct from competitive vote integrity.

### 8.5 Deployment and operations

Use Docker Engine/Compose when the online trial begins [N04]. The earlier Docker Desktop connection error on the laptop should be diagnosed before assuming any backend runs; inspect the active Docker context and daemon. Do not erase unrelated containers or volumes to fix a project setup problem.

For public testing, choose one hosting environment after measuring the stack. Configure encrypted transport for supported public endpoints, server authentication, firewall boundaries, secrets, private database access, backups and restore procedures. Local quickstart credentials/configuration are not production defaults.

Begin with structured logs and basic host metrics. Add monitoring/alert tooling after defining the failure signals: crashes, authentication failures, transaction errors, unusual candidate requests, backup failure and server saturation. A new monitoring stack is not necessary for the offline slice.

## 9. Platform and build tooling

**Desktop:** use matching Godot export templates, test a clean exported build outside the editor and record controls. A developer machine running the scene is not a distribution test.

**Android:** follow the pinned Godot version's instructions for OpenJDK and Android SDK. Current inspected stable docs specify OpenJDK 17 [P01]; confirm SDK/build-tool requirements during setup. Test on a physical phone. Track touch input, heat, memory, pause/resume, disconnection and readability. Store signing credentials securely outside source control.

**iOS:** plan macOS/Xcode access and actual-device testing when that milestone begins [P02]. No promise of an Ubuntu-only iOS shipping workflow.

**Controller:** add Input Map actions and UI focus/navigation. Test movement, camera, interaction, pause, dialogue and ballot review without a keyboard. The target is accessibility and future portability, not a claim of console certification.

**PlayStation:** Godot's official console guidance describes third-party routes for approved developers rather than an included public console export pipeline [P03]. Treat platform approval, porting, SDK access, hardware and certification as a separate future workstream. No price or delivery date is established.

## 10. The task system

Each task needs: ID, linked requirement, purpose, inputs, dependency, proposed owner role, tool, output, acceptance check, evidence and current status. All tasks below start **Not started/unverified** unless explicitly described as existing. “Owner” is a work role, not a person already hired.

Estimate only after inspecting the project and asset needs: S = one focused component; M = several related components; L = high uncertainty/multiple disciplines. These are relative sizing labels, not promises of hours. Split L tasks before implementation.

### Work package A — preserve and prepare

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| A01 | Audit installed versions and working scene / S | Developer; terminal, Godot | Current project | Versions and launch steps recorded |
| A02 | Establish Git checkpoint and backup / S | Developer; Git | A01 | Clean checkout launches; recovery demonstrated |
| A03 | Add master guide, handbook and task board / S | Product/developer; Markdown | A02 | Codex brief references current documents |
| A04 | Asset licence register and source folders / S | Art/developer | A02 | Trial asset can be traced to source/licence |
| A05 | Baseline performance recording / S | QA; Godot profiler | A01 | Resolution, scene and frame timings recorded |
| A06 | Spawn-marker recovery / S | Developer; GDScript | A02 | Falling returns to scene-defined start |

Existing evidence: a working capsule controller and polling compound were inspected; local Codex reported control/environment tests. Those results do not mark A01–A05 complete automatically.

### Work package B — interactions and story state

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| B01 | Interaction target and prompt / M | Gameplay; Godot | A02 | Range, obstruction and one-target priority work |
| B02 | Dialogue plugin trial / S | Gameplay/writer; Dialogue Manager | B01 | Branch and close work without input lock |
| B03 | Mission data and state transitions / M | Gameplay; GDScript/resources | B01 | Accept, decline and resolve objective |
| B04 | Phone/journal and objective display / M | UI; Control nodes | B03 | Player understands next step without explanation |
| B05 | Versioned save/load / M | Gameplay; JSON/FileAccess | B03 | Resume after quit, migration and no duplicate reward |
| B06 | Regression harness / S | QA; GUT | B03/B05 | Key state transitions run repeatably |
| B07 | Optional recruitment conversation / S | Writer/gameplay | B02/B03 | Declining never joins a party or blocks citizen story |

### Work package C — human and Nigerian environment

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| C01 | Location and character reference brief / M | Art/product | A03 | Specific place, everyday outfit and style examples selected |
| C02 | Import one licensed human / M | Character artist; Blender/Godot | A04/C01 | Scale, materials, rig and orientation correct |
| C03 | Idle/walk/run and facing / M | Animator/gameplay | C02 | No obvious sliding; movement and camera remain usable |
| C04 | Small character-creation UI / M | UI/gameplay | C02 | A few appearance choices save and reload |
| C05 | One home, street and centre route / L | Environment artist | C01/B01 | Traversable route with simple collision |
| C06 | Original signs, clothing and props / M | Art; Blender/Krita | C01/C02 | Cultural review and licence register complete |
| C07 | Material/lighting consistency pass / M | Art/QA | C05 | Readable shadows and measured baseline performance |

Character creator depth, NPC count and art finish are consciously small here. Do not commission a national wardrobe before one animated person works.

### Work package D — citizen/PVC slice

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| D01 | Script opening errand and relationships / M | Writer/product | Master story | One goal, named contacts, alternate approach |
| D02 | Implement one livelihood / M | Gameplay | B03/B05/D01 | Fictional payment issued once |
| D03 | Registration/collection state machine / M | Gameplay/research | B03 | Distinct stages and existing-card branch |
| D04 | Queue slots and officer service / M | Gameplay; navigation | C05/D03 | Join, leave, advance and recover without blocking |
| D05 | Honest and bribery encounter branches / M | Writer/gameplay | B02/D04 | Refusal remains viable; consequences persist |
| D06 | Completion and consequence scene / M | Writer/gameplay | D02–D05 | Citizen-only route finishes and reloads |
| D07 | First external playtest / M | QA/product | D06 | Observed confusion/bugs logged and critical issues fixed |

Scope: one home, one work activity, one centre, a handful of NPCs and one meaningful dilemma. Keep simulated identity data fictional.

### Work package E — daily-life transport

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| E01 | Original danfo asset and stops / M | Art; Blender | A04/C01 | Boarding anchors and camera space usable |
| E02 | Passenger trip state / M | Gameplay | B05/E01 | Board, pay once, arrive and exit safely |
| E03 | Ride conversations and humour / M | Writer/audio | B02/E02 | Optional engagement; repeat trips can be condensed |
| E04 | Local driver handling experiment / M | Gameplay; Godot | E01 | Three stops, recover-from-stuck and readable controls |
| E05 | Driver shift and earnings / M | Gameplay | D02/E04 | Correct passengers, drop-offs and no duplicate payouts |
| E06 | Election-phase route availability / M | Gameplay/research | D03/E02 | Scenario restrictions have clear alternatives |

Passenger travel can extend the PVC slice. The driver's livelihood is a follow-on prototype. Real-player passengers wait until seat ownership, exit consent and disconnection behaviours are tested.

### Work package F — tension and election-day story

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| F01 | Emotional beat sheet / M | Narrative/audio/product | Known characters | Baseline, unease, relief, escalation and aftermath mapped |
| F02 | Audio buses and directional cue test / M | Audio/gameplay | F01 | Important cues remain understandable with subtitles |
| F03 | NPC incident reactions / M | Gameplay/animation | C03/F01 | Crowd response has timing and traversable escape routes |
| F04 | One authored incident / M | Gameplay | F02/F03/B05 | Player can act, recover and see consequences |
| F05 | Accreditation and local story ballot / M | Gameplay/research | D03/B04 | Eligibility status and submission outcome clear |
| F06 | Aftermath dialogue and world changes / M | Narrative/gameplay | F04/F05 | Earlier events affect familiar people/places |
| F07 | Emotional/readability playtest / M | QA/product | F06 | Players explain warnings, choices and mood shifts |

Do not use repeated surprise sounds as the sole measure of success. Fear should arise from attachment, uncertainty and readable danger. Player firearm combat and permanent death remain unresolved scope.

### Work package G — teams and multiplayer proof

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| G01 | Nakama/SDK/PostgreSQL compatibility trial / M | Backend; Compose | A01/A02 | Two test identities connect with pinned versions |
| G02 | Persistent organisation and membership / M | Backend/gameplay | G01 | Join/leave persists; organisation scope enforced |
| G03 | Application and role assignment / M | Backend/UI | G02 | Only authorised leader accepts; revocation immediate |
| G04 | Shared campaign task / M | Backend/gameplay | G03/B03 | Contributions recorded; reward once |
| G05 | Headless Godot simulation experiment / M | Network/gameplay | G01 | Two players and proximity interaction validated |
| G06 | Session trust and service boundary / M | Backend/network | G05 | Client cannot impersonate simulation server |
| G07 | Reconnect and fault tests / M | QA/backend | G04–G06 | Committed outcomes survive lost acknowledgements |
| G08 | Mute/report/block prototype / M | UI/backend | G02 | Enabled communication has usable protections |

### Work package H — competitive elections and governance

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| H01 | Resolve election-rule decisions / M | Product/design | Guide decision register | Signup scope, slots, nomination and season rules explicit |
| H02 | Candidate slot reservation / M | Backend | G01/H01 | Concurrent request test never exceeds ten |
| H03 | Constituency/contest eligibility / M | Backend/research | H01 | Correct contest available to correct participant |
| H04 | Secret-ballot access model / L | Backend/security | H03 | Threat model, storage boundary and tests reviewed |
| H05 | Ballot submission and counting / M | Backend/QA | H04 | Retry safe, duplicate rejected, deterministic totals |
| H06 | Results and disputes story presentation / M | Narrative/UI | H05/F06 | Fictional claims distinguishable from actual ledger |
| H07 | Limited governance choices / M | Gameplay/backend | H05 | Budgeted commitments produce citizen-visible outcomes |
| H08 | Season archive/rollover / M | Backend/QA | H07 | Expired powers removed; persistence policy obeyed |

### Work package I — release and expansion

| ID | Task / size | Owner / tools | Dependency | Done when |
|---|---|---|---|---|
| I01 | Desktop export and clean-install test / S | Build/QA | Citizen slice | Export runs outside editor |
| I02 | Android control/performance proof / M | Build/QA | C03/B04 | Physical phone handles input, resume and readable UI |
| I03 | Controller and accessibility pass / M | UI/QA | B04 | Core flow possible without keyboard |
| I04 | Private hosting, backups and restore / M | Operations/backend | G07 | Simulated loss recoverable; credentials protected |
| I05 | Credits, licences and content inventory / M | Producer | Asset manifest | Every shipped asset approved and credited appropriately |
| I06 | Moderation and support workflow / M | Product/operations | G08 | Reports, sanctions and recovery responsibilities defined |
| I07 | Pricing/platform policy review / M | Product | Actual business model | No payment integration before concrete rules |
| I08 | Regional/diaspora content planning / L | Research/narrative/art | Reusable content pipeline | Region-specific reference and story packs scoped |
| I09 | iOS feasibility/build | Later | Device budget and stable build | Export and device proof |
| I10 | Console feasibility | Later/open | Stable product and funding | Platform/porting route evaluated with current requirements |

## 11. Dependency sequence and what to do next

Start **A01 → A02 → A03 → A06 → B01 → B02/B03 → B04 → B05**. Those steps protect progress and produce a usable conversation with a saved objective. Then pursue C01–C03 and D01–D06 to create the citizen slice. A small G01 networking trial should happen before months of multiplayer assumptions accumulate, but it must not block local story development.

First session deliverable: a repository checkpoint, version inventory and a documented current build. Second deliverable: approach one temporary NPC, interact, accept or decline information, update the journal and resume after saving. Third: replace the capsule with one tested human. These are deliverables, not fixed calendar dates.

Transport, tension and political teams can be developed as bounded follow-on slices. Build more scenery only when a mission needs it. Do not start all work packages simultaneously on one person's machine.

## 12. Testing workflow and evidence

Four layers: pure rule tests, Godot scene integration, exported-build playtests and multiplayer fault tests. Test the risky behaviours: state transitions, permissions, idempotency, persistence, collision and recovery. Avoid tests that merely assert the same constant copied from implementation.

For each playtest record build commit, engine version, device, resolution/settings, scenario, steps, expected/actual outcome, relevant logs and recording. A performance result includes whether recording was active. A visual walkthrough does not establish network correctness.

Initial test scenes: movement obstacles; interaction through/around walls; dialogue focus; queue service; save migration; passenger boarding; driver stops; incident escape; two-client role assignment; ballot concurrency. Separate development-only test scenes from the player-facing main flow.

Meaningful exit gate for the first citizen slice: an unfamiliar player finishes without joining politics, understands the card status, experiences a choice, resumes after quitting and encounters no unrecoverable blockage. Exit gate for tension: players can describe both changing emotion and an available action. Exit gate for online elections: the server enforces rules under simultaneous and repeated requests.

## 13. Costs, people and open-source limits

### 13.1 What can start without new licence purchases

Godot, Blender, Krita, Audacity, Git, the shortlisted open-source plugins and locally hosted open-source backend components allow a low-cash-cost prototype. Exact downloaded licences still apply. Existing VS Code/Codex can remain in use; paid AI services and proprietary distributions are not reclassified as open source because they help build an open-source stack.

Do not buy multiple asset subscriptions before the first asset trial. No paid backend is needed for local missions. Do not buy console hardware or commit to a port now.

### 13.2 Costs that remain real

Art/animation labour, Nigerian writing and cultural review, original voice recording, sound/music rights, test devices, electricity/internet, backups, remote Git/LFS usage, server/database operation, moderation, support, platform accounts and potential future porting all require time or money. “Open source” does not mean free hosting or a maintenance-free product.

Cost worksheet: item, milestone, one-off/recurring, quantity, current quoted unit cost, currency/date, owner, cheaper alternative and approval. Use measured server needs to obtain quotes. Do not publish a monthly hosting estimate until capacity and traffic assumptions exist.

### 13.3 Human responsibilities

Favour is product owner and can lead QA using existing experience. Developer work can be supported by Codex. A character/environment artist, animator, narrative collaborator, sound performer/editor and backend/operations specialist may be part-time contributors or contracted tasks later. Budget for the skills rather than pretending one AI prompt replaces all of them.

When money is limited, commission one excellent reusable character/rig and a small location kit before a large quantity of disconnected assets. Test contractors with a paid, narrowly scoped asset whose import and licence requirements are clear.

## 14. Task template and Codex working agreement

```text
Task ID:
Master-guide requirement IDs:
Outcome for the player:
Current files/scenes:
Dependencies complete:
Scope of this change:
Tools/plugins approved for this task:
Implementation notes:
Acceptance checks:
Manual playtest:
Evidence/logs:
Licence/asset additions:
Known limitations:
Status and next dependency:
```

Codex should inspect files before editing, preserve working movement and camera unless the task changes them, make one coherent change, run relevant checks and state what could not be tested. Do not accept invented test counts, headless claims about mouse feel or automatic asset licensing assumptions.

The guide controls product intent; this handbook proposes technology. When a dependency fails, document the failure and evaluate a focused alternative rather than silently changing engines or adding several backends.

## 15. Near-term unresolved decisions

Choose final initial art style before commissioning assets. Confirm exact Lagos Life reference before competitor comparison. Decide dialogue-plugin adoption after the first trial. Choose whether the first working citizen build includes passenger travel immediately or as its first extension. Confirm backend after G01/G05. Resolve candidate registration and nomination before H02. Determine age/content scope before final violent imagery. Leave console release, full national-map depth and real payments open until prerequisites exist.

This handbook supplies a realistic route to implementation; it is not a promise that the entire long-term game is now fully specified. Detailed mission scripts, regional art briefs and online protocol contracts are deliverables inside the tasks above.

## 16. Official links and verification notes

Consulted 12 October 2026. Links point to primary projects/documentation; prefer release-specific instructions matching our pinned versions.

### Engine, tools and plugins

- **T01 Godot licence:** https://godotengine.org/license/ — engine licensing and credit guidance.
- **T02 Godot 3D import:** https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/available_formats.html — format/import reference.
- **T03 Blender licence:** https://www.blender.org/about/license/ — tool versus output/licensing context. Download via https://www.blender.org/ .
- **T04 Git LFS:** https://git-lfs.com/ — large-file workflow; remote storage is separate. Git: https://git-scm.com/ .
- **T05 Dialogue Manager:** https://github.com/nathanhoad/godot_dialogue_manager — original addon; pin a tested release and retain its licence.
- **T06 GUT:** https://github.com/bitwes/Gut and https://gut.readthedocs.io/ — correct upstream; select compatible documentation.
- **T07 Krita:** https://krita.org/en/ and https://krita.org/en/about/license/ — open-source painting and licensing.
- **T08 Audacity:** https://www.audacityteam.org/ — audio editing/recording; extra plugins/services may have separate terms.
- **T09 OBS:** https://obsproject.com/ and https://obsproject.com/kb/linux-installation — official capture tool and Linux instructions.
- **T10 Inkscape candidate:** https://inkscape.org/ — optional vector tool; licence-page retrieval failed in this research, so verify exact package before approval.

### Asset sources

- **A01 Kenney:** https://kenney.nl/assets and https://kenney.nl/support — asset-page resources stated CC0; retain individual licence files.
- **A02 Quaternius base characters:** https://quaternius.com/packs/universalbasecharacters.html — specific pack states CC0; do not generalise to every unrelated pack.
- **A03 Poly Haven:** https://polyhaven.com/license — asset licence reference, distinct from site/API terms.
- **A04 MakeHuman:** https://github.com/makehumancommunity/makehuman — optional trial; inspect application, export and downloaded-community-asset terms separately.
- **A05 Freesound:** https://freesound.org/help/faq/ — per-sound licensing/attribution. Exclude noncommercial-only sounds from a commercial build unless separately licensed.
- **A06 ambientCG candidate:** https://ambientcg.com/ and https://docs.ambientcg.com/license/ — verify directly before adoption; licence content was not successfully retrieved here.

### Backend and platforms

- **N01 Nakama upstream:** https://github.com/heroiclabs/nakama — inspect chosen release and licence.
- **N02 Official Godot SDK:** https://github.com/heroiclabs/nakama-godot — match supported versions.
- **N03 TypeScript runtime:** https://heroiclabs.com/docs/nakama/server-framework/typescript-runtime/ — runtime restrictions; not ordinary Node.js hosting.
- **N04 Compose quickstart:** https://heroiclabs.com/docs/install-docker-quickstart/ — starting reference, not production security configuration.
- **N05 Authoritative multiplayer:** https://heroiclabs.com/docs/nakama/concepts/multiplayer/authoritative/ — authoritative match concept; our physics and election systems still need implementation.
- **P01 Android export:** https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html — JDK/SDK and export requirements.
- **P02 iOS export:** https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html — macOS/Xcode workflow.
- **P03 Godot consoles:** https://godotengine.org/consoles/ — separate approved-developer/third-party routes; no out-of-box public PlayStation export promise.

## 17. Final readiness checklist

Before the next coding task: current project opens; source is backed up; guide and handbook are in the project; one task ID is selected; required assets/plugins have provenance; acceptance criteria are written; no unrelated tool stack is being installed.

Before claiming a milestone complete: actual player flow tested; save/recovery checked; evidence recorded; limitations explicit; documentation updated; clean checkout/export tested when relevant. Preserve the central promise throughout: ordinary Nigerian life that players care about, with optional politics and an election whose changing tension they can feel.
