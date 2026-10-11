Our main stack is **Godot 4 + GDScript**, with **Blender for 3D assets**. For multiplayer, we’re proposing **Nakama + PostgreSQL**, subject to a small compatibility test.

You’ll open **one project repository in VS Code** containing the game, backend code, assets and documentation.

| Area | Technology | Status |
|---|---|---|
| Game engine | **Godot 4**, Compatibility renderer | Already using |
| Gameplay programming | **GDScript** | Already using |
| Code editor | **VS Code** | Already using |
| Coding assistance | **Codex extension** | Already using |
| Version control | **Git** | Set up now |
| Large asset versioning | **Git LFS** | Add when importing larger assets |
| Remote repository | **GitHub** | Proposed |
| 3D modelling, rigging and animation | **Blender** | Next |
| Texture painting and concept art | **Krita** | During asset production |
| Vector signs and interface artwork | **Inkscape** | Optional |
| Audio recording and editing | **Audacity** | During audio production |
| Gameplay recording | Ubuntu recorder / **OBS Studio** | Recorder available; OBS optional |
| Branching dialogue | **Godot Dialogue Manager** | Trial compatible release |
| Automated gameplay tests | **GUT — Godot Unit Test** | Trial compatible release |
| Local save files | **JSON**, using Godot’s file APIs | Build soon |
| Backend and social features | **Nakama OSS** | Proposed trial |
| Backend programming | **TypeScript** in Nakama’s runtime | Proposed trial |
| Backend build tooling | **Node.js + npm + TypeScript compiler** | For compiling backend code |
| Database | **PostgreSQL** | With backend trial |
| Godot/backend connection | **Official Nakama Godot SDK** | With backend trial |
| Shared 3D simulation | **Headless Godot server** | Multiplayer trial |
| Backend containers | **Docker Engine + Docker Compose** | Multiplayer trial |
| Android builds | Godot export templates, **OpenJDK + Android SDK** | Device-testing stage |
| iOS builds | **macOS + Xcode** and Godot export workflow | Later |

**Node.js is build tooling here; Nakama runs the backend logic in its own runtime.** We aren’t currently planning an Express server.

For open-licensed assets, our shortlist is **Kenney, Quaternius, Poly Haven and selected Freesound recordings**. Each downloaded asset still needs its licence recorded. These are resource sources, not application dependencies.

For the repository, use this structure:

```text
election-wahala/
├── project.godot
├── player.gd
├── polling_unit.tscn
├── scenes/
├── scripts/
├── assets/
│   ├── models/
│   ├── textures/
│   ├── audio/
│   └── ui/
├── data/
│   ├── dialogue/
│   ├── missions/
│   └── rules/
├── addons/
├── tests/
├── backend/
│   ├── src/
│   └── tests/
├── server/
├── infrastructure/
├── art-source/
├── docs/
├── LICENSES/
├── README.md
├── .gitignore
└── .gitattributes
```

Keep your existing `project.godot`, `player.gd` and `polling_unit.tscn` in place initially. Add `.gdignore` files inside `backend`, `server`, `infrastructure` and `art-source` so Godot doesn’t import those directories.

Put the **development guide, implementation handbook and story bible** inside `docs`.

**For now, set up Git and the repository around your existing Godot project.** Add backend packages when we begin the networking trial. React, Next.js, Flutter, Unity and Unreal are not part of this stack.