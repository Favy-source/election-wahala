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
| Geographic foundation | **OpenStreetMap** data (ODbL) | Proposed |
| Map data download | **Geofabrik Nigeria extract**, cropped to our starting area | Proposed; after the starting neighbourhood is chosen |
| Map inspection and preparation | **QGIS** | Proposed; install when preparing the first map |
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

## Geography and mapping (proposed)

We propose **OpenStreetMap (OSM)** as the geographic foundation for Lagos: real street names, road layouts, intersections, waterways and mapped building outlines. The current school courtyard is a prototype and does not yet represent an accurately mapped Lagos location.

**Map data gives us geography; we still build the experience.** Roads and building outlines guide construction, but they don't produce convincing shops, compounds, drains, markets, danfo buses, clothing or street activity.

Proposed pipeline: [Geofabrik Nigeria extract](https://download.geofabrik.de/africa/nigeria.html) → crop and prepare the starting area in **QGIS** → model buildings, street furniture and vehicles in **Blender** → assemble the playable neighbourhood, collision, navigation and in-game map in **Godot**.

- **No live map API for the first playable area.** Prepare the geography during development and package the resulting environment with the game. Walking down a street makes no map request and doesn't depend on a map server.
- **Use downloadable data, not map tiles.** Don't bulk-download tiles from the public OSM tile service; its [tile usage policy](https://operations.osmfoundation.org/policies/tiles/) prohibits offline downloading.
- **Licence.** OSM data is under the ODbL: attribution is required, and adapted databases can carry share-alike obligations ([OSM copyright](https://www.openstreetmap.org/copyright)). Record the source, extract date and licence in `LICENSES/` and the asset manifest alongside our geographic assets.

Rules for a mapped Lagos:

- **Real street names and connections.** Verify names in our selected area. Don't invent names for missing data and present them as authentic.
- **Neighbourhood-specific environments.** Commercial districts, residential streets, informal settlements and waterfront communities need their own researched architecture and daily activity.
- **Local verification.** Check mapped information against permitted reference material and local knowledge. Coverage of our starting neighbourhood has not been audited yet.
- **Recorded accuracy.** Track what follows real geography and what we adjust for gameplay.
- **Fictional content clearly identified.** Our invented school, characters and election incidents remain distinguishable from real locations and events.

**Scope:** start with a few connected, accurately mapped blocks: the polling school, a residential street, shops and a transport stop. Expand district by district while keeping a coherent Lagos layout, rather than building all of Lagos at once.

**Open decision: the starting neighbourhood.** The prototype and art direction are themed on Ilupeju, while the story bible proposes the fictional "Akinwale". This choice determines the first map extract and the references we need.

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