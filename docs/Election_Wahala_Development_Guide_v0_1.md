# Election Wahala: The People’s Story

## Master game design and development guide

**Version:** 0.1 — first consolidated design baseline  
**Prepared:** 11 October 2026  
**Project owner:** Favour Chinemerem Nwachukwu  
**Implementation:** Godot 4, 3D, Ubuntu development, Codex in VS Code  
**Document status:** Working specification. Confirmed requirements are binding; proposed mechanics and numerical budgets remain reviewable. No 30-day delivery cap applies.

> Create your own character and live as a Nigerian citizen before, during, and after an election. Build a life, form relationships, navigate hope and fear, and choose whether politics becomes your career. Remaining an ordinary citizen must be a complete experience.

## Contents

1. Authority, evidence and decision labels
2. Product vision and design pillars
3. Requirement register and conversation reconciliation
4. Audience, platforms and scope boundaries
5. Character creation, identity and persistence
6. Daily life and citizen gameplay
7. World, regions and diaspora
8. Story architecture and chapter plan
9. Voter registration and PVC collection
10. Groups, teams, applications and political roles
11. Election seasons, candidacy and voting
12. Tension, violence and aftermath
13. Dialogue, NPCs and simulation
14. Progression and economy
15. Nigerian art, animation, audio and interface
16. Multiplayer architecture and fair play
17. Game systems and data design
18. Existing prototype audit
19. First complete playable slice
20. Development milestones and backlog
21. Testing and acceptance criteria
22. Performance and production workflow
23. Add-ons, monetisation and fundraising
24. Risks, unresolved decisions and change control
25. Immediate development brief
26. Sources and research register

## 1. Authority, evidence and decision labels

This guide consolidates the visible discussion, recovered summaries of the earlier game conversation, inspected project attachments, and sampled frames from the supplied recordings. It is not a verbatim transcript. Early retrieval recovered important requirements, but cannot establish that every sentence of the earliest discussion has been reproduced. Any additional recovered requirement should be appended with its provenance rather than guessed.

Four labels apply throughout:

| Label | Meaning | Treatment |
|---|---|---|
| CONFIRMED | Explicit user requirement or correction | Preserve unless the owner changes it |
| PROPOSED | Design or implementation recommendation | May be prototyped when authorised; do not describe as user-approved |
| OPEN | Decision not yet resolved | Keep configurable; resolve before dependent production work |
| SUPERSEDED | Earlier direction replaced by later instruction | Retain in the decision record, not in the active build brief |

All detailed rules, mission titles, sample characters, numerical targets, technology subdivisions and release sequencing below are **PROPOSED unless explicitly marked CONFIRMED**. This convention avoids presenting an extensive design draft as hundreds of already approved decisions.

Evidence classes: U = visible user discussion; R = recovered earlier discussion summary; A = inspected attachment; V = sampled recording frames; S = external source. Local Codex test counts are **reported**, not independently reproduced here. A recording can show movement and camera views; it cannot prove secret-ballot security, every collision, or measured rendering performance.

Scope discipline: preserve the complete vision in this guide while implementing small, testable increments. Deferring a feature is not deleting it. A local prototype is not an online multiplayer release.

## 2. Product vision and design pillars

### 2.1 The game’s promise

**CONFIRMED:** Citizens are the protagonists. Players create their own characters. They may stay ordinary citizens or join political groups, take team roles and pursue public office. The world must feel recognisably Nigerian in its people, clothing, environments and experiences. Fear, tension and consequential election events are integral, not optional decoration.

The core story concerns people trying to live their lives while an approaching election reshapes their routines and relationships. A player’s concern may be collecting wages, helping family, getting a voter’s card or finding a safe route home. Another player may be organising a campaign that affects that same street.

### 2.2 Design pillars

1. **A complete citizen life.** A nonpartisan player has objectives, relationships, progression and endings without joining a party or seeking office.
2. **Politics intersects with life.** Campaign duties fit around personal responsibilities; political office does not erase citizenship.
3. **Embodied 3D presence.** Walking, looking, hearing, approaching people and navigating crowds deliver the experience. Menus support physical play.
4. **A specific Nigerian world.** Regional research drives locations and people. Lagos is the first proposed production location, not a template for all Nigeria.
5. **Tension with emotional contrast.** Ordinary warmth, humour, food, work and friendship make danger meaningful. Constant gunfire would flatten the intended experience.
6. **Consequences with continuity.** Promises, choices, injuries, losses and community changes remain visible after election day.
7. **Social agency.** Individual accounts can form communities and teams with meaningful responsibilities.

### 2.3 Core loops

**Citizen loop:** pursue a personal goal → travel and meet people → encounter an opportunity or obstacle → decide → receive a consequence → update relationships and plans.

**Community loop:** identify a shared need → gather people → allocate tasks → act together → observe neighbourhood change.

**Political loop:** join or organise a group → apply for responsibility → build support → campaign → contest or support a candidate → respond to results and governance.

**Election-season loop:** preparation → registration and mobilisation → campaigns → election eve → voting → counting and disputes → aftermath and governance.

Success means players can describe a person they care about, a meaningful choice and a consequence—not merely a higher score.

## 3. Requirement register and conversation reconciliation

| ID | Requirement | Status / provenance | Implementation destination |
|---|---|---|---|
| R01 | Working title Election Wahala: The People’s Story | CONFIRMED, R | Branding and narrative bible |
| R02 | Citizens are the main protagonists | CONFIRMED, U/R | All chapters and progression |
| R03 | Create a custom character and live through the story | CONFIRMED, U | Character creator and saves |
| R04 | Political participation is optional | CONFIRMED, U | Citizen-only completion path |
| R05 | Individual signup followed by joining teams/communities | CONFIRMED, U | Accounts and membership |
| R06 | Apply for roles such as campaign manager | CONFIRMED, U | Applications and permissions |
| R07 | Apply to contest offices, including House of Representatives | CONFIRMED, U | Candidacy and constituencies |
| R08 | Up to ten player presidential candidates | CONFIRMED, R | Election configuration |
| R09 | First ten registrants choosing run for president claim slots | CONFIRMED original rule, R | Slot reservation; conflict noted in §11 |
| R10 | 3D game | CONFIRMED, U | Godot 3D pipeline |
| R11 | Nigerian people, outfits, environments and everyday life | CONFIRMED, U | Art and cultural review |
| R12 | All 36 states and FCT in long-term scope | CONFIRMED, R | Regional expansion plan |
| R13 | Diaspora Nigerians returning to registered polling units | CONFIRMED, R | Diaspora origin and travel story |
| R14 | Strong fear, tension and embodied movement/interactions | CONFIRMED, U/R | Incident and audio systems |
| R15 | Gunshots, reactive people, touts and violence | CONFIRMED, R | Authored incidents and crowd response |
| R16 | Bribery and manipulation, missing/substituted materials | CONFIRMED, R | Branching missions and evidence |
| R17 | Biased/manipulated counting, fires, deaths and aftermath | CONFIRMED, R | Counting and consequence chapters |
| R18 | Voter registration and in-person collection experience | CONFIRMED, U | PVC quest chain |
| R19 | Long queues, officers and an optional bribery/queue-jumping encounter | CONFIRMED, U | Queue simulation and branches |
| R20 | Ubuntu PC development with Codex in VS Code | CONFIRMED, U/A | Development workflow |
| R21 | Remove the 30-day cap | CONFIRMED, U | Milestone gates, no fixed deadline |
| R22 | Mobile distribution ambition: Android and iOS | Earlier context, reconfirm release priority | Export and device plan |
| R23 | Paid presidential tickets | OPEN: user explored monetisation | Commercial decision gate |
| R24 | Secret ballots, asynchronous seasons, Election Rooms | PROPOSED earlier architecture | Multiplayer specification |
| R25 | Fictional parties/candidates and historical inspiration | Established working direction, R | Content bible; naming review |
| R26 | Civilian action inspired by intensity of COD/Wild Rift | CONFIRMED reference for feel, R | Movement/audio, not assumed shooter genre |
| R27 | Thorough living guide covering features and add-ons | CONFIRMED, U | This document and change log |

### 3.1 Superseded and corrected directions

- The earlier 2D approach is superseded by the explicit 3D decision.
- The 30-day cap is removed; scope is sequenced by completion gates.
- A political career is not the default or mandatory player progression.
- The prototype polling compound is a test location associated with election day; it does not force the story to begin on election day.
- Earlier six-chapter and later seven-chapter suggestions were assistant proposals. Section 8 reconciles their themes into one proposed chapter structure.
- Party nomination before presidency was proposed later, but conflicts with the original first-ten rule. It has not replaced that rule.
- No evidence establishes that a full firearm combat system, seamless national map, real-world political accounts, or unlimited MMO population was approved.
- The phrase “Cloth Pro” appeared in the original tool question. The precise product remains ambiguous; no subscription or asset pipeline should depend on interpreting it as Claude or a clothing tool.
- Unrelated older political web projects surfaced during retrieval. They are not silently incorporated into this game.

## 4. Audience, platforms and scope boundaries

Primary audience: people interested in Nigerian everyday life, social play and election stories, including Nigerians at home and abroad. Political knowledge should not be required. Onboarding explains unfamiliar terms through context and optional journal entries.

The desired intensity and depictions of death may affect the eventual age rating. Target rating and graphicness remain OPEN. Prepare a content inventory before distribution; do not promise an age category before the actual content is assessed.

Development baseline: the user’s Ubuntu laptop, Intel i5-1135G7, Iris Xe, 8 GiB RAM. Current prototype uses Godot 4 with Compatibility rendering. Pin the exact installed engine version in the repository before adding more contributors or CI.

Proposed platform sequence: desktop prototype → Android device test during early production → desktop/Android private alpha → iOS once the build pipeline and hardware are available. Godot’s current iOS export documentation requires macOS/Xcode [S04]. Mobile support is a production constraint from the start, even if desktop testing is easier.

Not initial-slice scope: the whole country as walkable geography, all political offices, vehicle driving, full household simulation, unrestricted player violence, voice chat, real payments, and hundreds of simultaneous players. These remain separate scope decisions or later features.

## 5. Character creation, identity and persistence

### 5.1 Creation flow

Create account when online services exist → create fictional character → choose appearance and initial background → select story/world context → receive an opening personal goal → enter the neighbourhood. During local development, use a local profile without pretending account security exists.

Proposed initial choices: name, skin tone, hairstyle, body preset, face preset, clothing and one of a small number of backgrounds. Avoid a complex facial sculpting tool before basic human animation works. Later expand wardrobe, age presentation, accessories and body variety.

Backgrounds supply opening relationships and circumstances, not fixed moral traits or political alignment. Examples: local resident, new arrival, returning diaspora resident. A player’s state of residence, registered constituency and family origin are separate concepts. No ethnicity grants intelligence, violence, honesty or electoral bonuses.

### 5.2 Identity layers

| Identity | Purpose | Persistence |
|---|---|---|
| Account | Authentication, ownership and moderation | Across sessions |
| Character | Appearance, personal story and relationships | Across chosen story continuity |
| Season participation | Room membership, eligibility and activity | One season |
| Political membership | Group affiliation and role history | Policy to decide at season rollover |
| Voter record | Fictional registration and constituency | Within the game’s ruleset |

Do not request a real PVC number, biometrics, real party affiliation or real ballot choice to play. Registration minigames use fictional character data.

### 5.3 Starting circumstances and recovery

A character begins with an accessible home or safe arrival point, modest fictional funds and a personal obligation. A missed mission should normally create another route or consequence rather than permanently destroy a new player’s progress. Player death, injury recovery and permanent character loss are OPEN; prototype checkpoint recovery first.

## 6. Daily life and citizen gameplay

### 6.1 The initial everyday-life model

Start with a few meaningful systems: a home hub, one livelihood activity, transport choices, relationships, a phone/journal and a small inventory. Do not build hunger, rent, fatigue, careers and a full economy simultaneously.

Example jobs are short authored activities: collect a delivery, repair an item, help at a shop, complete a paid errand. Each can intersect with election events. A campaign procession might delay delivery; a contact might withhold payment; helping someone may cost time but strengthen a relationship.

Proposed resources: fictional cash, time-of-day, a compact inventory and relationship states. Energy or fatigue should be added only if playtests demonstrate meaningful choices. Avoid punitive chores that demand daily login.

### 6.2 Citizen content parity

A complete citizen route must include personal objectives, varied dialogue, community influence, registration choices, election-day decisions and a satisfying aftermath. No party badge is required to unlock most neighbourhood content. Political abstention or non-membership must not be treated as a failed game.

Citizens can help neighbours, compare claims, organise a nonpartisan community activity, document an incident, attend a meeting, decline a rally invitation or vote when eligible. The player chooses their level of engagement.

### 6.3 Example ordinary-day mission: Collect What You Are Owed

Start at home with a payment due from a completed job. Travel to a shop, discover the contact has gone to a nearby campaign event, and choose to wait, follow or ask a trusted neighbour to help. A family request arrives while time passes. Rewards include payment, knowledge of a local organiser and a relationship outcome. The political invitation is optional and the job remains completable without joining anyone.

Acceptance: two approaches reach a valid ending; the journal distinguishes optional political activity from the personal objective; no dialogue choice assigns the player a party without explicit action.

## 7. World, regions and diaspora

### 7.1 Geographic model

Long-term geography includes all 36 states and the FCT: Abia, Adamawa, Akwa Ibom, Anambra, Bauchi, Bayelsa, Benue, Borno, Cross River, Delta, Ebonyi, Edo, Ekiti, Enugu, Gombe, Imo, Jigawa, Kaduna, Kano, Katsina, Kebbi, Kogi, Kwara, Lagos, Nasarawa, Niger, Ogun, Ondo, Osun, Oyo, Plateau, Rivers, Sokoto, Taraba, Yobe, Zamfara, and the Federal Capital Territory.

Representation does not mean 37 equally detailed open worlds at first release. Use a national travel/map layer, then add authored neighbourhoods progressively. Track each region as planned, researched, represented in UI, playable, or production-complete. Never advertise map entries as fully playable environments.

### 7.2 First proposed location

A fictional Lagos neighbourhood centred on a public primary school polling unit. Build a connected home/street/shop/registration-centre/polling-compound route. The registration centre is a distinct location or scene; do not assume the school polling unit issues PVCs.

Use scene transitions or short travel sequences initially. Add drivable vehicles only when they create worthwhile missions. Neighbouring buildings should provide context without implying every door has an interior.

### 7.3 Regional research sheet

For each future location record settlement type, architecture, surfaces, vegetation, climate, street layout, transport, work patterns, clothing variation, languages, soundscape and locally reviewed dialogue. Include modern, maintained and worn spaces. Do not make poverty, corruption or violence the sole visual identity.

### 7.4 Diaspora route — confirmed scope, proposed execution

The returning citizen has family contacts, travel expenses and a reason to participate. Playable beats: prepare the return → arrive and reconnect → verify in-game registration/location → travel to the relevant community → navigate unfamiliar changes and family expectations → participate in the local story → decide what happens after the election.

Do not silently replace this with remote voting from abroad. The original requirement is returning to a registered polling unit. Actual election eligibility and transfer procedures depend on the period represented and need research before production.

## 8. Story architecture and chapter plan

### 8.1 Structure

Use one personal story threaded through a shared election calendar. Chapter unlocks reflect the world phase, while personal tasks can be revisited where plausible. Political missions are optional branches, not separate prerequisites for the citizen storyline.

The first proposed campaign has eight chapters. The titles below reconcile earlier suggestions such as Before the Ballot, Price of Loyalty, Election Day Wahala and Who Counted My Vote? None is a final approved title.

| Chapter | Citizen focus | Optional political layer | Persistent consequence |
|---|---|---|---|
| 1. Before the Posters | Establish home, livelihood and relationships | Meet a recruiter or organiser | Personal contacts and first community commitment |
| 2. My Name on the Register | Registration and card collection | Help members understand registration | Eligibility, trust and unresolved paperwork |
| 3. The Price of Loyalty | Campaign promises and everyday pressures | Join a group, apply for a role, organise | Debts, promises and affiliations |
| 4. A Country on the Move | Community activity and diaspora return | Local outreach and candidate preparations | Who is present and whom you can rely on |
| 5. Election Eve | Information, preparation and rising anxiety | Final team coordination | Readiness, route knowledge and contacts |
| 6. Election Day Wahala | Reach the unit, queue, vote or respond to disruption | Candidate/supporter responsibilities | Ballot status, safety and witnessed events |
| 7. Who Counted My Vote? | Observe results and assess discrepancies | Agents, candidates and disputes | Evidence, announced outcomes and public trust |
| 8. After the Announcement | Relationships, loss, celebration and public services | Governance and accountability | Personal and community epilogues |

### 8.2 Chapter 1: Before the Posters

Purpose: give the player a reason to care about the neighbourhood. Introduce movement, phone/journal, conversation and one paid activity. Meet three contrasting people: a close contact, a neighbour and someone whose needs conflict with the player’s immediate goal.

Mandatory beats: arrive or wake at home; complete an everyday task; experience a small community disagreement; hear about the approaching election. Optional beat: decline or accept an invitation to a meeting. Exit condition: a personal objective resolved and one relationship established. Failure should teach controls or offer an alternate path, not demand political participation.

### 8.3 Chapter 2: My Name on the Register

Purpose: make citizenship preparation tangible. Check registration status, follow the appropriate branch, attend the centre and collect the card when ready. Separate registration from later collection. Queue encounters expose solidarity, frustration, administrative difficulty and a specific fictional corruption incident.

Exit condition: card collected, a documented pending issue, or a deliberate choice to defer. Consequence: later voting eligibility reflects the chosen ruleset, while the rest of the citizen story remains playable. Detailed design is in §9.

### 8.4 Chapter 3: The Price of Loyalty

Purpose: introduce competing promises, inducements and relationships. A player may encounter an offer of money or goods associated with campaign support. Show who benefits, who objects and what the player actually agreed to. Do not treat accepting an item as automatically changing a secret ballot.

Optional political path: membership application, introductory responsibility and a team task. Citizen path: attend or avoid an event, investigate a local promise, help a neighbour or continue work. Exit condition: resolve a commitment or choose independence; record promises separately from actual votes.

### 8.5 Chapter 4: A Country on the Move

Purpose: connect local life with wider Nigeria and diaspora experiences. A returning friend or the player’s own origin route introduces travel and changed relationships. Community tasks bring player teams and ordinary citizens into contact.

Political branch: candidate application or campaign assignment. Citizen branch: transport planning, family reunion or community preparation. Exit condition: determine election-period location and settle one practical obligation. Full national travel remains later scope.

### 8.6 Chapter 5: Election Eve

Purpose: build anticipation without requiring combat. Conflicting messages, distant activity and requests from friends create uncertainty. Players can verify a report, arrange a meeting point, prepare documents or help someone plan a route.

Do not randomise danger without readable cues. A false rumour and a verified report should be distinguishable through obtainable evidence. Exit condition: a preparation choice and a safety/contact plan; missing a preparation adds difficulty, not an automatic death.

### 8.7 Chapter 6: Election Day Wahala

Purpose: deliver the central polling-unit experience. Routes may include a calm unit, delayed materials, accreditation trouble, intimidation or a serious incident. The incident catalogue contains the original requested gunshots, touts, fires, deaths and missing/substituted materials; not every playthrough contains all of them.

Citizen choices: wait, seek clarification, help someone, document from a safe position, leave, return where allowed, or complete voting. Political-role choices depend on permissions and proximity. Exit states explicitly distinguish voted, unable to vote, left voluntarily, interrupted or awaiting continuation. A dramatic scene must not secretly duplicate or delete server ballots.

### 8.8 Chapter 7: Who Counted My Vote?

Purpose: explore counting, collation, conflicting reports and trust. Fictional story scenarios can contain manipulated figures or substituted materials, with evidence the player can observe. Journal entries label witnessed facts, hearsay and unresolved claims separately.

Players compare available records, speak with people and decide whether to pursue a report or protect another obligation. Any institutional dispute process is a game abstraction until researched. The player need not personally overturn a national result to achieve a meaningful ending.

### 8.9 Chapter 8: After the Announcement

Purpose: show that election outcomes have human costs and benefits. Return to familiar places changed by events. Include celebration, disappointment, damaged relationships, recovery, grief and follow-up on promises as appropriate to the playthrough.

Governance branch: elected players face limited budgets and competing priorities. Citizen branch: monitor a commitment, rebuild an activity, seek help or move forward. Epilogues reflect relationships, unresolved obligations, neighbourhood conditions and the player’s decisions. Winning office is not the sole successful ending.

### 8.10 Narrative production rules

Every mission needs an ID, chapter, prerequisites, location, objectives, optional branches, state changes, failure/recovery, save points, dialogue keys, assets, research notes and acceptance tests. Keep plot facts in structured data rather than dispersed script conditions. Personal branches cannot freely rewind a shared multiplayer world; use private dialogue state and clearly scoped instanced story events.

## 9. Voter registration and PVC collection

### 9.1 Authenticity boundary

The user explicitly requested online application, an in-person visit, long queues, issuing officers and a bribery/queue-jumping encounter. Preserve these as gameplay requirements. Research does not support treating online pre-registration and immediate card collection as one universal step. INEC’s dated 2025 CVR document describes online pre-registration followed by in-person completion [S01]. Its 2021 collection guidance describes personal collection and designated centres [S02]. These are dated procedural references, not a claim that procedures never change.

Before shipping, choose a fictional election period and verify that period’s registration, biometric and collection procedures. Do not hard-code real current dates, fees or opening hours into the game based on old documents.

### 9.2 Proposed state model

Unregistered → application started → appointment/visit pending → registration completed → card pending → card ready → card collected.

Additional states: correction required, collection lookup failed, visit deferred and replacement requested. Existing registered characters can start at card pending or card collected. All data is fictional; a simulated biometric interaction needs no camera or fingerprint access.

### 9.3 Mission sequence

1. A conversation or phone task reveals the need to check status.
2. The character accesses a fictional portal or receives assistance.
3. The game explains which visit is needed: registration completion or collection.
4. Travel creates a practical choice between money, time and another obligation.
5. At the centre, read signs or ask an officer; join the appropriate queue.
6. Encounter people and an optional complication while the queue advances.
7. Complete the official interaction or receive a specific reason for follow-up.
8. Update the card/status journal and return to ordinary life.

### 9.4 Queue gameplay

Represent the queue with ordered slots and service stations. Characters should not endlessly push each other through physics. Use navigation to approach a slot, then a controlled waiting position. Show queue position or an understandable progress cue.

Compress real waiting into a few purposeful encounters. Proposed first test: roughly three to six minutes with conversation, then tune from playtests. Permit a clear leave-and-return consequence. Accessibility priority, ordinary assistance and corrupt queue jumping are different situations; never imply that priority accommodation is bribery.

### 9.5 Corruption encounter

A named fictional intermediary or officer offers unofficial faster service. Branches: refuse and wait, pay fictional cash, question the demand, seek another officer, or record/report through the fictional story system. Payment may fail to deliver the promised result. Refusal retains a viable path. Honest staff and helpful citizens must also appear.

This is a narrative dilemma, not a real-money speed boost. Do not sell premium queue priority or make a bribe the only way to obtain the card. Avoid a universal moral score; affected relationships and recorded events supply consequences.

### 9.6 Acceptance conditions

Correct state transitions; no duplicate card issuance; insufficient fictional cash handled; leaving or disconnecting does not corrupt the queue; multiple players cannot occupy one service slot; save/load resumes at a sensible stage; dialogue explains the next step; the honest path completes; real identity information is never required.

## 10. Groups, teams, applications and political roles

### 10.1 Definitions

**Community:** social or geographic association, possibly nonpartisan. **Party/political group:** a political organisation. **Campaign team:** a group working for a particular candidate or contest. **Role:** responsibility within a group. **Public office:** a position gained through the game’s election process.

Joining a community does not automatically enrol someone in a party. Leaving a campaign should not delete friendships or civilian progress. Whether players can create parties at launch, hold multiple party memberships, or change affiliation mid-season remains OPEN.

### 10.2 Role catalogue

| Role | Entry | Playable responsibility | Boundary |
|---|---|---|---|
| Independent citizen | Default | Daily life, community tasks, eligible voting | No party obligation |
| Party member | Join/apply | Meetings, volunteering, proposals | No automatic leadership power |
| Community organiser | Appointment/application | Coordinate local tasks and concerns | Cannot cast votes for members |
| Campaign manager | Application accepted by authorised leader | Assign tasks, organise events, allocate approved resources | Cannot read ballots or access personal wallets |
| Spokesperson | Appointment | Prepare messages and participate in debates | Publication/moderation permissions scoped |
| Campaign treasurer | Later proposed role | Track approved fictional campaign funds | Audited transfers; no real-money custody |
| House of Representatives candidate | Candidacy process | Constituency engagement and election | Seat-specific eligibility |
| Presidential candidate | Original ten-slot rule | National campaign and team leadership | Slot and season bound |
| Other elected officials | Later expansion | Jurisdiction-specific responsibilities | Do not build all offices at once |
| Observer/journalist | Optional proposed path | Gather and communicate evidence | Evidence access, not election-admin access |
| Polling staff | NPC initially; player role later OPEN | Process queue/accreditation in scenario | No unrestricted ballot editing |

### 10.3 Application lifecycle

Draft → submitted → reviewed → accepted or declined → active assignment → resigned, removed or expired. Candidate-office applications and campaign-job applications are separate entities. A leader sees only information necessary to assess the role.

Acceptance records role, scope, term and permissions. On removal, revoke permissions immediately, reassign unfinished work and preserve civilian progress. Every privileged action should record actor, target, time and reason. Provide a straightforward explanation of rejection without requiring public humiliation or harassment.

### 10.4 Team gameplay

Initial cooperative task: organise a neighbourhood meeting. The manager creates a task, a member accepts, another delivers supplies, and the organiser starts the event once prerequisites are met. Contribution and completion must be server-confirmed. Partial participation can still earn appropriate recognition; one absent leader should not permanently lock everyone out.

Leadership absence policy, succession, party creation limits and membership switching are OPEN. Prototype one party, one team and three roles before building a national political hierarchy.

## 11. Election seasons, candidacy and voting

### 11.1 Containers and time

Proposed hierarchy: account → character → election room → season → contest. A room is a bounded community; a season is an election cycle; a contest is a specific office. Candidate limit and population limit are different numbers. Ten presidential candidates does not mean ten total players.

The original discussion proposed asynchronous seasons, but this remains a design proposal. Live scenes can coexist with longer campaign windows. Exact season duration, voting windows, time zones and missed-session policy remain OPEN. Do not impose the removed 30-day cap as a season length.

### 11.2 Presidential slots: preserve the original rule

CONFIRMED original request: the first ten registrants who choose to run for president take the available slots. Later suggestions about party primaries are not an approved replacement.

Implement a configurable reservation model only after resolving whether “registrants” means account signup or season/contest registration. Proposed safe default for a test is **contest registration**, with the interpretation visibly marked provisional. The server must atomically reserve one slot; two simultaneous requests cannot both take slot ten.

Open policy questions: reservation expiry, withdrawal, waitlist, alternate accounts, accessibility across time zones, whether multiple slots can belong to one party, and whether party nomination happens before or after a slot reservation. Never quietly introduce performance-based qualification or paid priority.

### 11.3 House of Representatives and other contests

Proposed game model: a character belongs to a registered constituency for the contest, applies to run, receives whatever nomination the chosen ruleset requires and appears on that constituency’s ballot. Research real office terminology and jurisdiction before claiming realism. Initial tests may use a clearly named fictional constituency and simplified eligibility.

### 11.4 Voting workflow

Check fictional eligibility → reach/enter the valid voting context → accreditation interaction → private ballot UI → select → review → submit → receive a generic success acknowledgement.

Keep party membership distinct from vote choice. A campaign manager cannot verify how a member voted. Proposed ballot secrecy includes avoiding receipts that reveal the selected candidate to other players. Account-level eligibility checks and ballot storage should minimise identity linkage; do not promise cryptographic anonymity without a design and audit.

### 11.5 Results versus fictional manipulation

Two different systems are needed: an authoritative competitive election ledger and an authored story representation of election irregularities. A fictional NPC may announce a suspicious result in a narrative scenario. That is not permission for a compromised client, administrator or paying player to rewrite competitive ballots.

For the first competitive prototype, count validated submissions deterministically. Irregularity stories occur in labelled story instances. If a later season deliberately includes a manipulation mechanic, its rules, counterplay and result semantics must be decided and disclosed before implementation. This distinction preserves both the requested story and player trust.

### 11.6 Governance and rollover

Proposed governance: elected players choose among limited community projects with fictional budgets, delays and competing requests. Citizens observe and respond. Do not simulate an entire national economy initially.

Define which state survives rollover: character appearance and social relationships may persist; candidacy, ballots and office terms normally expire. Archive results and permitted public history. No rollover may duplicate funds or retain expired privileges.

## 12. Tension, violence and aftermath

### 12.1 Intended feeling

The user requested tension comparable in immediacy to action games, with moving, talking people and gunshots. This does not establish a player shooter mechanic. The first implementation centres on civilian navigation, escape, assistance and decisions under uncertainty.

Use an incident progression: normal activity → subtle warning → uncertainty → escalation → response → recovery. Incidents are authored and state-driven; avoid uncontrolled random punishment.

### 12.2 Incident catalogue

| Incident | Early cue | Citizen actions | Lasting state |
|---|---|---|---|
| Missing materials | Staff checking a delayed delivery | Wait, ask, leave/return, help communicate | Delay and trust |
| Suspicious replacement materials | Conflicting labels or accounts | Observe, ask, preserve information | Evidence record |
| Intimidating group/touts | Route obstruction and crowd change | Reroute, seek help, leave | Route availability and relationships |
| Gunshots nearby | Directional sound and reactions | Take cover, move away, help a companion | Injury/fear/mission consequences |
| Fire | Smoke, alarm and spreading obstruction | Exit, warn people, seek help | Damaged location and recovery tasks |
| Injury or death | Witnessed event or verified news | Assist within game actions, contact others, grieve | Persistent absence or recovery |
| Conflicting count | Different reported figures | Compare records, speak to witnesses | Dispute and confidence |

Include calm polling experiences too. No ethnicity, religion or region is assigned inherent hostility. Touts and corrupt actors are individual characters or fictional groups with specific motivations.

### 12.3 Control and fairness

Danger requires navigable exits, readable cues and tested camera behaviour. Avoid unavoidable spawn attacks. Proposed public multiplayer default: no unrestricted player-versus-player violence. Shared incidents use bounded effects, protection against repeated targeting and reconnect recovery. Graphic intensity and whether players can directly cause violence remain OPEN.

Reduced camera shake, adjustable sound mix, subtitles for important cues and pause in local story mode support accessibility. Online time cannot be paused globally; provide safe locations and clear session consequences.

### 12.4 Death and aftermath

Confirmed story scope includes death. Permanent deletion of player characters is not confirmed. Prototype meaningful NPC outcomes and checkpoint recovery while the character-death policy is decided. Avoid using loss only as spectacle: subsequent dialogue, damaged places, missing people and family responses should reflect what occurred.

## 13. Dialogue, NPCs and simulation

NPCs need goals, relationship context and a small state machine before elaborate AI. Start with idle, walk-to-target, queue, converse, serve, react and recover. Give named characters a home context, occupation, immediate need, speech style and memory of a few relevant choices.

Use authored branching dialogue initially. Free-form generative dialogue is not required and adds cost, consistency and moderation complexity. English and Pidgin are initial proposals; other languages need native-speaker review. Do not write every Nigerian character in identical slang.

Crowds can combine a few detailed nearby NPCs with simpler background characters. Navigation should respect doors, tables and queue slots. Incident reactions should propagate with believable delay, not make every person turn simultaneously.

NPC/player separation: an NPC officer can run a registration sequence; a real player campaign manager uses role permissions. Offline fallback must not impersonate a real player’s vote or statement.

## 14. Progression and economy

Track relationships individually, public reputation in context, completed commitments, livelihood progress and fictional cash. Avoid a single score deciding every person’s opinion. A choice may strengthen one relationship and disappoint another.

Separate personal funds, campaign funds and any future purchased cosmetic entitlement. Campaign managers can use only approved campaign resources. All online transfers require atomic server transactions and an audit trail. No client can set its own balance.

Early money sources: completed work and authored rewards. Sinks: transport and optional ordinary purchases. Calibrate so a new player can finish essential citizen missions without buying currency. A bribery event uses fictional cash; it must not invite a real-money purchase at the moment of pressure.

Progression should unlock options rather than make rich players better at voting. Skill bonuses, if added, must not change ballot weight. No premium double votes, election-result purchases or purchasable immunity is proposed.

## 15. Nigerian art, animation, audio and interface

### 15.1 Art direction

CONFIRMED identity: Nigerian characters, outfits and environments. Proposed rendering style: grounded stylised 3D with believable proportions and lightweight geometry. This is a production proposal, not a user-approved commitment to cartoon visuals or photorealism.

Current bright flat geometry is a blockout. Improve colour, silhouettes, material variation and human motion before expensive effects. Use photo references from the specific location type, with permission/licence records where required.

### 15.2 Character production

First deliverable: one reusable rigged human, idle/walk/run animations and one everyday outfit. Then validate scale, feet contact, camera framing and performance. Only afterwards add wardrobe variants and more body/face presets.

Include a range of skin tones, builds, hairstyles, braids, head coverings, ages and everyday clothing. Casual shirts, jeans, dresses, office wear, sandals, Ankara and other locally appropriate styles can coexist. Avoid dressing every character as a ceremonial cultural symbol. Uniforms and role-specific clothing need reference checks for the chosen period.

Pipeline: reference brief → model source and licence → mesh/UV/material cleanup → rig → animation → export/import → collision and controller integration → in-engine review. A generated image is a concept or texture, not automatically a rigged 3D character. Codex can integrate assets and write tooling but does not eliminate modelling and animation work.

### 15.3 Environment production

Initial kit: school walls/roof/veranda, gate and perimeter, plastic chairs, canopy, tables, ballot props, street surfaces, drainage crossing, signs, a shop frontage and a home interior. Reuse modules with regional variation rather than duplicating whole scenes.

Blend maintained and worn details. Muted soil and concrete should replace the overly uniform yellow ground where appropriate. Add everyday objects where people would use them. Keep collision simpler than visual geometry, especially furniture legs and decorative trim.

### 15.4 Sound and music

Sound layers: footsteps by surface, nearby conversations, distant activity, domestic sounds, traffic where appropriate, event audio and incident cues. Do not fill every scene with every stereotypical sound. Important dialogue remains intelligible. Record or license voices/music; track permissions and performer agreements.

Spatial audio supports navigation and fear. Gunshot and alarm cues need safe adjustable volume and subtitle alternatives. Music should respond to context without announcing every threat too early.

### 15.5 Interface

Initial screens: profile/character, pause/settings, phone/journal, dialogue, interaction prompt, registration status and objective tracker. Later: community directory, membership application, role dashboard, task board, candidate list, ballot and results.

Use clear everyday language and optional definitions for PVC, ward, constituency and collation. A displayed mission is not a real-world voting instruction. Keyboard remapping, sensitivity, readable fonts, subtitles and touch-friendly layouts belong in the plan. Mobile controls must be tested on a device, not inferred from a desktop screenshot.

## 16. Multiplayer architecture and fair play

### 16.1 Proposed service boundaries

The Godot client renders the world and sends player intentions. An authoritative simulation server validates shared movement and interactions. A persistent backend stores accounts, memberships, progression and elections. These can begin as a small modular deployment; do not start with many microservices.

Godot supports high-level multiplayer with several networking backends [S03]. The specific transport, hosting provider and backend stack remain OPEN. Conduct a small connection/reconnect experiment before committing to a production service.

### 16.2 Authority rules

| Data/action | Authority |
|---|---|
| Camera and local UI | Client |
| Shared position and interactions | Server validation |
| Money, inventory rewards, role changes | Persistent server transaction |
| Candidate slots and eligibility | Election service transaction |
| Ballot acceptance and counting | Authoritative election service |
| Cosmetic preview | Client; ownership verified when online |
| Dialogue branch with persistent effects | Validated story service/state handler |

A client requests an action; it does not submit the final wallet balance, rank or election result. Check authentication, role scope, distance/proximity where relevant and current phase.

### 16.3 Connectivity

Expect dropped connections and variable bandwidth. Rejoin should restore the committed state, not repeat rewards. Give each money, role and vote operation an idempotency key. A vote submission with a lost acknowledgement must return its prior status when retried.

Private story progress can save locally; competitive state cannot be imported from an edited local file. Decide later whether offline story content can award any online progression.

### 16.4 Social protections tied to actual features

Team chat and naming create a need for report, mute, block, name review and moderation. Voice chat is later scope. Prevent leaders from discovering ballots, appropriating personal funds or trapping someone in a group. Rate-limit invitations, applications and messages. Record administrative actions and define appeal/recovery procedures before a public launch.

## 17. Game systems and data design

### 17.1 Proposed Godot organisation

| Folder/system | Responsibility |
|---|---|
| scenes/player | Player rig, collider and camera |
| scenes/world | Neighbourhoods, interiors and transitions |
| scenes/props | Reusable environment assets |
| scenes/npcs | Characters and interaction points |
| scenes/ui | HUD, dialogue, phone and menus |
| scripts/interaction | Target detection and action execution |
| scripts/story | Mission state and consequences |
| scripts/simulation | Queues, NPC states and incidents |
| scripts/network | Session and shared-state adapters |
| data | Missions, dialogue, roles and rulesets |
| assets | Models, textures, audio and licence records |
| tests | Behaviour checks and test scenes |
| docs | This guide, art direction, decisions and playtest notes |

Refactor the monolithic polling scene incrementally. Do not break a working prototype merely to achieve a perfect folder structure.

### 17.2 Core records

Account; Character; AppearancePreset; Region; Location; Residence; Constituency; Season; ElectionRoom; Contest; CandidateReservation; Candidacy; PoliticalGroup; Membership; RoleAssignment; RoleApplication; CampaignTask; VoterStatus; BallotSubmission; AggregateResult; MissionProgress; Relationship; InventoryEntry; WalletLedger; Incident; EvidenceEntry; SaveVersion; ModerationReport.

Important constraints: one active assignment per unique role/scope policy; no duplicate membership rows; no duplicate accepted ballot per eligible participant/contest; candidate capacity never exceeded; money transfers balance; mission reward granted once. Exact database syntax is deferred until the backend is selected.

### 17.3 Events and interfaces

Use explicit events such as interaction_requested, dialogue_completed, queue_joined, registration_completed, card_collected, application_submitted, role_assigned, task_completed, ballot_accepted and incident_resolved. Event payloads include identifiers and version information, not arbitrary executable script.

Example service commands: ApplyForRole(group, role, statement), ReserveCandidateSlot(contest), JoinQueue(station), CompleteRegistration(visit), SubmitBallot(contest, choice, idempotency_key). Each returns success, a recoverable error or a denied reason. Do not implement these as unauthenticated public endpoints.

### 17.4 Save and migration

Version save schemas from the start. Persist stable IDs rather than fragile scene-node paths. Local saves should be written atomically with a fallback copy. Test loading an older version after adding new mission fields. Online persistence needs backups and a tested restore path before paid operation.

## 18. Existing prototype audit

### 18.1 Observed or inspected

The project resides on the user’s Ubuntu machine at the shared path /home/favour-nwachukwu/Projects/election-wahala. Inspected uploads include project.godot, player.gd and two polling scene versions. The local project remains authoritative; uploaded files are snapshots.

Inspected player code includes WASD/arrow actions, Shift running, gravity, camera-relative movement, mouse capture/release, pitch limits and a SpringArm3D excluding the player collider. The scene contains a capsule player, ground, school, perimeter, canopy, furniture, ballot box, trees, sky and ambient light.

Sampled recordings show changes in viewpoint, movement through and outside the compound and views beneath the canopy. They do not establish frame rate or all collision cases. Codex reported 57 control checks and later 110 integration checks; those suites were not independently rerun here.

### 18.2 Specific follow-up items

- The inspected player script respawns at (0, 1, 0), while the newer scene starts at (0, 1, 12). It may still recover safely, but use a spawn marker or recorded starting transform so scene-specific spawn intent survives future layouts.
- The current scene uses real INEC text on a prop. Decide institution naming for the fictional setting before treating that asset as final branding.
- Primitive furniture uses many individual bodies and shapes. Consolidate collision where measurement or snagging shows a problem.
- Main-scene UID and script UID references depend on imports. Verify a clean checkout launches; do not rely on copied cache files.
- No evidence yet of human models, dialogue, missions, persistence, accounts, teams or working online elections.
- Editor cache files are generated working data, not the source of gameplay design. Keep source scenes/assets and regenerate caches through import.

### 18.3 Workflow already learned

Stop the game and save before external changes. After Codex edits, accept Godot’s Reload from disk prompt. Use the Play button because the laptop’s F6 controls brightness. In the embedded game, choose Input and click the game surface; Escape releases the captured pointer. These usability notes belong in the developer onboarding instructions.

## 19. First complete playable slice

### 19.1 Purpose

Prove the citizen story, interaction and consequences before adding more decorative scenery or national scope. Proposed slice title: **A Day to Get Your Card**. Target session length is an initial 15–25 minute design hypothesis, not a schedule commitment.

### 19.2 Included

One neighbourhood route; one playable human with a few appearance presets; a home start; one paid errand; three to five named NPCs; a registration/collection centre; a visible queue; an honest path and a fictional shortcut/bribery branch; one optional political invitation; a journal; save/load; one consequence scene.

The existing polling compound remains a separate test scene. After the PVC slice works, build a second short sequence that reaches the compound, interacts with an officer and completes simplified voting. Combining everything into the first slice would obscure which systems are actually enjoyable.

### 19.3 Completion criteria

A new player can finish without developer instructions, understand why they are visiting the centre, make at least one meaningful decision, obtain a resolved/pending status, resume after quitting and finish without joining a party. No silent softlock after refusing money, leaving a queue or declining a political offer. Character movement and camera remain usable around the full route.

### 19.4 Separate multiplayer proof

In parallel only as scheduling allows—not as a second product—make a tiny technical test with two clients: connect, see one another, join a group, apply for a role, have an authorised leader accept, complete a shared task and reconnect. This is a risk-reduction experiment, not a promise that the story slice is multiplayer-ready.

## 20. Development milestones and backlog

Milestones have exit gates rather than dates. Effort estimates come after the first slice and networking experiment reveal asset and engineering costs.

| Milestone | Deliverable | Dependencies | Exit gate |
|---|---|---|---|
| M0 Design baseline | Guide, requirement IDs, open-decision register | Conversation reconciliation | Owner can identify confirmed vs proposed scope |
| M1 Interaction foundation | Interaction, dialogue, objective, save/load | Existing controller | Walk to NPC, converse, update and reload objective |
| M2 Human visual foundation | One rigged character and core animations | Asset pipeline | Feet, scale, movement and camera pass playtest |
| M3 Citizen/PVC slice | Everyday task, centre, queue, branches | M1/M2 | Complete independent citizen route |
| M4 Network/team proof | Two clients, membership, application, shared task | Small backend decision | Authoritative roles and reconnect work |
| M5 Election-day slice | Accreditation, voting, one incident, aftermath | M3 and voting rules | Correct state and a readable consequence |
| M6 Private social alpha | Combined neighbourhood and team loop | M4/M5 | Small invited group completes a cycle |
| M7 Competitive season | Candidate slots, campaigns, ballot, results | Conflict decisions and security review | Capacity, secrecy and count invariants pass |
| M8 Governance/content expansion | More chapters and role responsibilities | Stable season | Citizen and officeholder paths both complete |
| M9 Platform/release readiness | Device performance, moderation, recovery | Stable product | Release checklist satisfied |
| M10 Regional growth | Diaspora and additional researched locations | Reusable systems | Each region passes authenticity and performance review |

### 20.1 First implementation backlog

| ID | Task | Priority | Done when |
|---|---|---|---|
| B01 | Record guide and engine version in repository | Now | Source-of-truth docs visible to Codex |
| B02 | Replace hard-coded respawn with spawn marker | Now | Fall recovery returns to intended scene start |
| B03 | Reusable interaction component and prompt | Now | Only reachable target responds |
| B04 | Dialogue panel and movement/input ownership | Now | Talk/close/resume without stuck mouse |
| B05 | Objective and mission-state component | Now | Branches update correct objective |
| B06 | Versioned local save/load | Now | Resume objective without duplicate reward |
| B07 | Human rig integration experiment | Next | Idle/walk/run and correct floor contact |
| B08 | Centre layout and queue service | Next | Ordered service and valid exits |
| B09 | PVC mission with honest and corruption branches | Next | Both routes resolve with recorded consequences |
| B10 | Optional recruitment dialogue | Next | Declining preserves full citizen route |
| B11 | Two-client authority experiment | Next | Invalid role changes rejected |
| B12 | Simplified election-day story | Later | Ballot state distinct from incident state |

## 21. Testing and acceptance criteria

### 21.1 System checks

| System | Required behaviours |
|---|---|
| Movement/camera | Wall blocking, camera retraction, slopes/thresholds, spawn recovery, mouse release |
| Interaction | Range and visibility checks, one target, no activation through walls |
| Dialogue | Repeated opening, branch conditions, input handoff, localisation fallback |
| Missions | Alternative paths, refusals, interruption, no duplicate rewards, clear next step |
| Queue | Join/leave, officer availability, stuck NPC recovery, disconnect handling |
| Registration | Correct phase, existing card, pending card, correction route, duplicate prevention |
| Teams | Authorised acceptance, role revocation, leader absence, scope isolation |
| Elections | Ten-slot race, duplicate submission, retry, wrong contest, closed window, deterministic count |
| Saves | Interrupted write, missing field, old version, story/online separation |
| Incidents | Safe exits, camera readability, no repeated spawn targeting, aftermath consistency |

### 21.2 Playtest questions

Can the player explain the objective without help? Did the queue feel like a social situation or wasted time? Did refusing a corrupt offer still feel viable? Did the place and dialogue feel recognisably specific to Nigeria? Did ordinary life create attachment before danger? Was remaining independent as engaging as taking a team role? What did the player think a choice would do, and what actually happened?

Include Nigerian reviewers from the represented context and diaspora players for the return-home route. Record feedback as observations with reproduction steps, not only opinions or pass counts.

### 21.3 Release gates

No known data-loss or vote-duplication defect; playable citizen-only path; recovery from disconnection; acceptable measured performance on a defined low-end device; moderation tools working for enabled social features; asset licences accounted for; readable tutorials; backup restoration tested; platform-specific requirements checked at release time.

## 22. Performance and production workflow

### 22.1 Initial budgets — proposed and measurable

Target a stable 30 FPS baseline on the owner’s laptop at a documented resolution, with 60 FPS as an improvement goal where achievable. A 30 FPS frame budget is about 33.3 ms. Record CPU/GPU time, memory, scene population and resolution for each benchmark. No target has yet been demonstrated by the supplied recordings.

Begin with a small active NPC population and profile before raising it. Use shared materials, reused meshes, simple collision, restrained shadows and distance-based detail. Avoid adding real-time expensive effects before measuring their benefit. Establish mobile-specific budgets on actual hardware; Iris Xe results do not predict phone thermals.

### 22.2 Development loop

Choose one backlog item → inspect existing files → implement focused changes → run relevant automated validation → windowed playtest → record evidence and limitations → checkpoint in version control → update requirement status.

Use Git for source history and an asset licence manifest. Do not treat temporary test scripts or generated caches as the only record of validation. Keep reusable regression checks in the project; use one-off checks only where they answer a specific question.

### 22.3 Codex task contract

Each prompt includes the project path, guide/version, requirement IDs, exact outcome, protected existing behaviour, acceptance conditions and explicit exclusions. Ask for changed files, tests run, limitations and manual steps. Avoid asking Codex to “build the entire game” in one pass.

### 22.4 Roles needed as production grows

The owner supplies product direction and QA. Engineering covers gameplay/networking; environment and character art need modelling/animation; narrative needs authored content and local review; audio requires recording/licensing. Some duties can be combined, but planning should recognise the work instead of assuming AI coding produces all final assets.

## 23. Add-ons, monetisation and fundraising

### 23.1 Feature classification

| Content | Core vision or later addition | Commercial position |
|---|---|---|
| Custom character and citizen storyline | Core | Business model still OPEN |
| Optional teams and political roles | Core multiplayer vision | Avoid making basic participation dependent on spending |
| Registration, voting and consequences | Core | Not merely a paid side activity |
| All-state/FCT representation | Long-term confirmed scope | Delivery depth and release model OPEN |
| Diaspora return storyline | Confirmed long-term scope | Do not quietly demote to paid-only content |
| Extra wardrobe variants | Later expansion | Cosmetic sales proposal |
| Additional authored stories/locations | Later content | Paid packs possible, decision pending |
| Private rooms | Proposed social addition | Hosting fee/subscription possible |
| Vehicles, housing decoration, deeper careers | Proposed additions | Validate usefulness before pricing |
| Local/state office depth | Later political expansion | Part of roadmap, packaging undecided |

### 23.2 Revenue options

The user asked whether presidential candidates could buy tickets with real money. Preserve this as an OPEN commercial idea. It creates conflicts with first-ten access, fairness, refunds for disconnects or cancellations and the interpretation of competition. No paid candidacy should be implemented until these rules are concrete and current platform/legal requirements have been reviewed.

Proposed alternatives: optional clothing/accessories, supporter edition, paid private-room hosting and substantial extra story packs. Sponsorship could support development, but real political sponsorship would need a separate editorial and conflict-of-interest decision. Do not assume it belongs in the game.

No commercial forecasts are established. Cosmetic revenue can be modelled as active users × payer conversion × average payer spend, then reduced by fees, refunds, taxes and operating costs. Private-room revenue has its own hosting cost. All inputs require actual tests, not invented market figures.

### 23.3 Fundraising preparation

Build evidence in this order: clear concept and audience → playable citizen slice → authentic art sample → social/team proof → playtest learning → costed milestone plan. A pitch should show what works, what remains uncertain and what funding unlocks.

Possible routes to investigate: self-funded milestone development, grants, publisher support, angels and crowdfunding. None is guaranteed. Prepare a concise deck, gameplay footage, team needs, budget, milestones, ownership/licence records and a risk register.

Earlier discussion mentioned Lagos Life fundraising as a comparison. Those amounts and circumstances were not reverified for this guide and are not included as established evidence. Research the exact company, source, date and funding type before citing it to investors. Investment raised and revenue earned are different metrics.

### 23.4 Cost categories

Track character/environment art, animation, audio, writing/localisation, engineering, devices, hosting, moderation, platform accounts, legal/accounting and contingency. Estimate the next demonstrable milestone rather than claiming a credible full-national-world budget before production data exists.

## 24. Risks, unresolved decisions and change control

### 24.1 Priority decisions

| Decision | Current state | Resolve before |
|---|---|---|
| Custom character; citizen-first; politics optional | CONFIRMED | Already binding |
| First playable location | Lagos proposed | Final environment art |
| Rendered visual style | Grounded stylised 3D proposed | Commissioning asset library |
| Election era | Fictional setting; period OPEN | Procedure-specific missions |
| First-ten presidency definition | Original confirmed, signup scope OPEN | Candidate service |
| Party nomination versus first-ten slots | Conflict OPEN | Competitive rules |
| Who creates parties and appoints initial leaders | OPEN | Group onboarding |
| Live/asynchronous season structure | OPEN | Multiplayer calendar |
| Population per room and empty-room handling | OPEN | Hosting capacity |
| NPC votes versus player-only elections | OPEN; never mix silently | Result service |
| Player combat, injury/death persistence | OPEN | Incident mechanics |
| Real institution naming and uniforms | OPEN | Final content assets |
| Languages and voiced-dialogue scope | OPEN | Recording and localisation |
| Paid candidacy and release pricing | OPEN | Payment integration |
| Account backend/hosting provider | OPEN | Network proof deployment |

### 24.2 Risk register

Scope expansion: many states, careers and offices can overwhelm production; mitigate through reusable modules and milestone gates. Asset quality: primitive scenes cannot validate final human realism; make an early rigged-character test. Network fairness: role and ballot state must remain server-authoritative. Cultural generalisation: use location-specific research and review. Tension fatigue: preserve calm and meaningful routines. Low-end performance: measure real devices early. Content volume: keep dialogue structured and localisable. Real-time scheduling: allow reconnect and avoid mandatory constant presence. Economic abuse: separate wallets and record transactions. Prototype overconfidence: distinguish automated parsing from actual playability.

### 24.3 Requirement change procedure

Assign an ID, record the user request or design rationale, label status, describe affected systems, state acceptance criteria and identify the milestone. When a decision changes, mark the old one superseded with a reason. Do not erase it or rewrite an assistant suggestion as an original user instruction.

### 24.4 Version log

0.1, 11 October 2026: consolidated citizen-first vision; recovered first-ten rule and original incident scope; recorded custom characters, optional teams/roles, voter-card experience, regional and diaspora goals; documented prototype evidence; proposed chapters, architecture, slices, milestones and decision gates.

## 25. Immediate development brief

The next coding task should establish a usable conversation/objective interaction, not attempt the whole registration system or add another large scenery pass.

Suggested local Codex brief:

```text
Read docs/Election_Wahala_Development_Guide_v0_1.md and inspect the
existing Godot project before editing.

Implement B02–B05 as a small local interaction prototype:
1. Use a spawn marker for respawn.
2. Add one clearly labelled temporary NPC at an accessible location.
3. Add an interaction action and an in-range prompt.
4. Open a short dialogue about checking voter registration.
5. Let the player accept information or decline; neither choice
   joins a party or changes voting eligibility.
6. Show a clear objective after accepting.
7. Disable movement/camera input while the dialogue needs UI input,
   then restore controls cleanly when it closes.

Preserve the current environment, movement and camera. Treat the
NPC visual as a placeholder. Do not add online accounts, payments,
national elections or full registration yet.

Validate scene/script loading and interaction state. Report changed
files, tests run and manual playtest steps. Keep confirmed requirements
separate from proposed features in any documentation updates.
```

After this task: add save/load, choose the first human asset pipeline and implement the PVC state machine in a dedicated test scene. Resolve visual style before spending heavily on character assets; resolve candidate-rule conflicts before building the competitive election service.

## 26. Sources and research register

### 26.1 Conversation and implementation evidence

U: current conversation, especially corrections on 3D, no 30-day cap, custom characters, optional citizen/political paths, Nigerian authenticity, role applications and PVC queue/bribery experience. R: retrieved earlier summaries of the Election Wahala conversation on 11 October 2026; these recover first-ten candidacy, national/diaspora scope and severe incident themes. A/V: uploaded project files and sampled screen recordings reviewed in this conversation. Their limitations are recorded in §§1 and 18.

### 26.2 External reference notes

- **S01 — INEC, Continuous Voter Registration 2025–2026**, dated July 2025. Supports a dated reference model of online pre-registration and physical completion. https://inecnigeria.org/wp-content/uploads/CONTINUOUS-VOTER-REGISTRATION-CVR-2025-2026.pdf
- **S02 — INEC, 2021 CVR Guidelines**, collection section. Supports historical personal-collection/designated-centre details. Not a promise of current opening hours or unchanged procedure. https://inecnigeria.org/wp-content/uploads/2022/11/2021-CVR-Guidelines-Final.pdf
- **S03 — Godot stable documentation, High-level multiplayer**, consulted 11 October 2026. Supports availability of networking APIs; it does not supply this game’s account, election or persistence service. https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
- **S04 — Godot stable documentation, Exporting for iOS**, consulted 11 October 2026. Check again when implementing the mobile pipeline. https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html

### 26.3 Research still required

Period-specific election procedures; roles and terminology for the chosen offices; accreditation/counting details; location-specific architecture and clothing; NYSC/polling-staff portrayal; diaspora travel experience; real institutional naming; platform purchase rules and age ratings; verified market/fundraising comparisons. Record source, date, claim, uncertainty and implementation impact for each finding.

This guide is ready to serve as the project’s first design baseline. The confirmed vision is retained, the prototype is acknowledged accurately, and unresolved choices are explicit rather than hidden inside code.
