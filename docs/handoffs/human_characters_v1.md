# First provisional human-character pass

## Checkout and review state

- Worktree: `/home/favour-nwachukwu/Projects/election-wahala-characters`
- Branch: `feature/human-characters`
- Baseline: `736127e3497f5ff2d7a1b3aaf855a4830d6cf9a0`, the latest merged remote
  `main`, verified read-only before creating this worktree.
- All implementation changes are local, unstaged and uncommitted. No merge,
  commit, push, remote edit or asset purchase was performed.
- The older local `main` pointer and existing worktrees were left unchanged.
  Uncommitted integration-checkout work was preserved and was not carried into
  this new baseline.

Read `docs/AI_COLLABORATION_RULES.md` and `docs/ART_DIRECTION.md` before the pass.
The assignment owns only the files listed below. It does not change dialogue
content, Claude's panel, Input Map, renderer settings or the shared interaction
interface.

## Result and scope

The player capsule's visible mesh is replaced by an animated civilian human.
The standalone interaction target and the separate human-character review
target use a second civilian palette. The player CharacterBody3D, collision
shape, camera nodes, spring-arm exclusion, movement script and physics remain
in place. Officer StaticBody3D and capsule collision remain in place.

These are two **provisional male-base civilian variants**, not final Nigerian
character designs or a complete representation of Lagos residents. The player
wears a muted teal short-sleeved shirt, navy trousers and dark shoes; the officer
wears an ivory shirt, brown trousers and dark shoes. Their skin palettes differ
and both have dark hair. No ethnicity, political preference or personality is
assigned from these appearances. The officer's clothing is not an asserted
official agency uniform. Later character work still needs varied adult ages,
genders, body types, hairstyles and everyday wardrobes described in the art
direction.

The player visual has feet at local `y = -1` because the physics body origin is
at capsule centre. The officer visual has feet at local `y = 0`. The source model
is approximately 1.858 metres tall and faces +Z; the Model wrapper rotates it to
the project's -Z visual convention. The officer visual root rotates back toward
the entrance. Only the player visual turns toward actual horizontal movement;
neither the player body nor camera rotates to drive this presentation.

The player plays `idle`, `walk` and `run` according to actual horizontal velocity,
and returns to idle when stopped or movement input is locked by dialogue.
The existing 5 m/s walk and 8 m/s run speeds are preserved; the animation switches
to run above 6.5 m/s. The officer remains idle. The clips are in place and do not
move the physics body.

When the canopy or another obstacle brings the camera within 0.70 m of the
player eye point, only the player's visible Model is hidden to avoid the close
camera being filled by the head/torso. It reappears beyond 0.95 m. This hysteresis
does not alter spring-arm collision, camera controls, player collision or the
officer's visibility. It is a provisional camera presentation choice requiring
human comfort review.

## Changed and added files

Modified:

- `polling_unit.tscn`: replaces only the player's visible capsule with the human
  visual instance; the Lagos environment and camera/body setup are preserved.
- `tests/interaction/interaction_playtest.tscn`: replaces only the officer's
  visible capsule with the officer human visual. Its separate dialogue
  substitute and existing test code are preserved.

Added:

- `assets/characters/quaternius/casual_civilian.glb` and its `.import` metadata:
  compact CC0 model derivative, containing only the three locomotion clips.
- `assets/characters/quaternius/LICENSE.txt`: exact source release licence.
- `assets/characters/quaternius/SOURCE.md`: source, licence, modification and
  reproduction notes.
- `assets/characters/quaternius/PROVENANCE.json`: original/derivative/licence
  hashes and actual model statistics.
- `assets/characters/quaternius/repack_civilian.py`: standard-library-only,
  source-hash-checked reproducible glTF-to-GLB repacking script.
- `scripts/characters/civilian_visual.gd` and its `.uid`: visual animation,
  palette, facing and close-camera visibility only.
- `scenes/characters/player_human_visual.tscn`: reusable player presentation.
- `scenes/characters/officer_human_visual.tscn`: reusable idle officer
  presentation.
- `tests/characters/human_character_playtest.tscn`: polling environment, officer
  body/target, interaction controller and unchanged real DialoguePanel hosted
  in a CanvasLayer.
- `tests/characters/run_character_checks.gd` and its `.uid`: focused automated
  character and existing-behaviour checks.
- `docs/handoffs/human_characters_v1.md`: this handoff.

Generated `.godot` caches are checkout-local and are not implementation files.

## Asset rights and size

Selected asset: **Quaternius, Ultimate Modular Men Pack / Ultimate Modular
Males, February 2022 release, `Casual_2.gltf`**.

- [Official release page](https://quaternius.com/packs/ultimatemodularcharacters.html)
- [Official release folder](https://drive.google.com/drive/folders/1USAAquX2JJWuA2m6zol0KUkFe3UkZ8zX)
- [Exact original model](https://drive.google.com/uc?export=download&id=1Jn7kULNmrtqP8BUUL19h8MhbdOnwPFhv)
- [Exact accompanying licence](https://drive.google.com/uc?export=download&id=1TTvylHa1CsiJuHFWWiv6PFGhLM-aAH5z)
- Licence: [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/),
  explicitly stated in this release's accompanying `LICENSE.txt` and release
  page. Attribution is optional; the project records Quaternius voluntarily.

The current general Quaternius website licence is QAL, with restrictions on
standalone asset redistribution. This pass uses the specific older release
whose accompanying licence explicitly says CC0. It does **not** assume that
every current Quaternius pack has the same terms. Exact licence and source hashes
are retained for this selected release.

The GLB derivative is 800,552 bytes, with 5,776 triangles, four skinned meshes,
ten surfaces and 62 joints. There are no image textures or external model data
dependencies. The same mesh is used for both characters. Local palettes and
animation libraries allow each character to animate independently. No weapon
or prop geometry is present.

Only `Idle_Neutral`, `Walk` and `Run` are retained and renamed `idle`, `walk` and
`run`. Unused buffer data is pruned. Mesh geometry, skin weights, skeleton,
bind matrices and retained animation keyframes are unchanged. See `SOURCE.md`
and `PROVENANCE.json` for byte counts, hashes and the reproduction command.

No dependency, system package, engine version or renderer change was introduced.

## Validation evidence

Runs use the existing Godot `4.7.2.stable.official.ed1daf0bf` executable and
Compatibility renderer. Automated and screenshot observations are distinct
from human input playtesting.

| Check | Result |
| --- | --- |
| Final Godot editor import | Passed; no errors or warnings |
| Main scene headless startup | Passed; 30 frames |
| Existing interaction regression suite | 53 passed |
| Existing dialogue regression suite | 50 passed; 13 expected invalid-content/active-open warnings |
| Character checks, headless | 52 passed |
| Character checks, X11 on Intel Iris Xe | 56 passed; no unexpected errors or warnings |

The final headless repeat also passed after test startup input isolation was
adjusted. All final logs contain no errors; only the dialogue suite's deliberate
negative cases emit warnings. The source licence and derivative hashes were
verified, and tracked diffs affect only the two visual-scene substitutions.
`player.gd`, `project.godot`, the controller, dialogue code/UI/data, chair mesh
and art-direction document match the fresh baseline exactly. The original
release licence is copied verbatim, including its original whitespace.

Logs: `/tmp/election-wahala-character-import.log`,
`/tmp/election-wahala-character-main-load.log`,
`/tmp/election-wahala-character-interaction.log`,
`/tmp/election-wahala-character-dialogue.log`,
`/tmp/election-wahala-character-checks-headless.log`, and
`/tmp/election-wahala-character-checks-windowed.log`.

The character checks exercise scene references, available animation clips,
palette independence, facing, walk/run/idle transitions, preserved capsule
dimensions and camera defaults, real-dialogue movement lock/restore and
close-camera hide/restore. The existing interaction suite exercises gravity,
wall collision, respawn and gameplay-state restoration. Windowed character
checks additionally save the four rendered review frames. The real panel is
used in the new review scene without editing its code or the contract. Mouse
capture comfort and exact restoration with human input remain manual checks.

Sampled foot positions at 24 points across idle, walk and run ranged from
-0.0145 m to +0.0736 m relative to ground. The canopy-post scenario shortened the spring arm to
approximately 0.6321 m and hid only the player visual; normal six-metre camera
distance restored it. These samples are measurements of the tested scenarios,
not proof of perfect gait planting or every camera angle.

Four automated windowed images were inspected at
`/tmp/election-wahala-character-review/`:

- `characters_front.png`: front shapes, skin/clothing palette and ground shadows.
- `characters_third_person.png`: normal player presentation.
- `characters_dialogue.png`: character scene with the unchanged real panel.
- `characters_canopy_close.png`: tight canopy camera with player model hidden.

These were scripted windowed observations. No human-driven play session,
exported build test or sustained frame-rate measurement was performed.

Reproduce focused checks from the character worktree with your installed Godot
4 executable:

```sh
godot --headless --path . --editor --quit
godot --headless --path . --script tests/interaction/interaction_checks.gd
godot --headless --path . --script tests/dialogue/run_dialogue_tests.gd
godot --headless --path . --script tests/characters/run_character_checks.gd
godot --path . --script tests/characters/run_character_checks.gd -- --snapshot-dir=/tmp/election-wahala-character-review
```

If `godot` is not on PATH, substitute
`/home/favour-nwachukwu/Applications/Godot/godot`. The last command needs a
working graphical session.

## Manual visual review

Open **`tests/characters/human_character_playtest.tscn`** in the character
worktree and press **F6**. F5 continues to run the existing polling environment,
now with the player's human visual.

1. Walk with WASD/arrows, run with Shift, and orbit with the mouse. Check scale,
   planted feet, facing on direction changes, blend timing, gait at the preserved
   movement speeds and readability beneath the canopy.
2. Approach the labelled officer near the canopy and press E. Check that opening
   does not select a response, the player idles while controls are locked, and
   the officer remains idle. Complete dialogue and cancel with Escape; check
   gameplay and mouse restoration.
3. Walk beside canopy posts and walls while rotating the camera. Check close
   camera body hiding and reappearance for distracting pops, head/torso clipping
   and view comfort. Officer collision must still block passage appropriately.
4. Judge the provisional faces, hair, skin tones and ordinary clothing in this
   Lagos setting. These assets establish a first playable human pass, not final
   cultural specificity or full character diversity.
5. Observe frame rate during ordinary movement and dialogue on the target
   laptop. Asset statistics alone do not establish Intel Iris Xe performance.

## Contract and remaining work

No interaction–dialogue public method, signal, conversation ID, node ID or
response ID changed. The unchanged controller still owns movement/look locking
and restoration; the unchanged DialoguePanel still owns content, focus and
navigation. Necessary player physics continue while dialogue is open.

Manual gait/foot contact, face/art judgement, camera hiding comfort, resizing
and sustained performance remain owner review items. No final character
customisation, crowd, voting mechanics, agency uniform or dialogue UI redesign
is included.

Suggested owner commit message, text only:

`Add provisional animated civilian player and polling officer visuals`
