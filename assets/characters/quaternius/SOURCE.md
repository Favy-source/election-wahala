# Provisional civilian human asset

Author: **Quaternius**. Original asset: `Casual_2.gltf` from the February 2022
**Ultimate Modular Men Pack**. The accompanying original licence file calls the
pack “Ultimate Modular Males”. This is the older release, not a newer QAL pack.

- [Official release page](https://quaternius.com/packs/ultimatemodularcharacters.html)
- [Official release download folder](https://drive.google.com/drive/folders/1USAAquX2JJWuA2m6zol0KUkFe3UkZ8zX)
- [Exact original model download](https://drive.google.com/uc?export=download&id=1Jn7kULNmrtqP8BUUL19h8MhbdOnwPFhv)
- [Exact release licence download](https://drive.google.com/uc?export=download&id=1TTvylHa1CsiJuHFWWiv6PFGhLM-aAH5z)
- Licence: **CC0 1.0 Universal**, as stated by the release's accompanying
  `LICENSE.txt` and the official release page. [CC0 terms](https://creativecommons.org/publicdomain/zero/1.0/).
- Attribution is not required by CC0; the project records Quaternius's authorship
  voluntarily. No purchase or paid dependency is involved.

`casual_civilian.glb` is a local derivative containing the unchanged body, feet,
head, legs, material values, skin weights, skeleton and bind matrices. Only the
`Idle_Neutral`, `Walk` and `Run` animation clips are retained, renamed `idle`,
`walk` and `run`. Unreferenced buffer views/accessors are pruned and the embedded
glTF data is placed in a binary GLB container. No mesh, skeleton or animation
keyframe transform is edited. The model includes no weapon or prop geometry.

The original model is 3,058,092 bytes; the derivative is 800,552 bytes. It has
4 skinned meshes, 10 surfaces, 5,776 triangles and 62 joints. Clip lengths are
1.666667 seconds (idle), 1.333333 seconds (walk), and 0.8 seconds (run). There are
no image textures or external binary dependencies. `PROVENANCE.json` records
the exact source/licence/derivative SHA-256 values and additional statistics.

To reproduce the derivative, download the documented original model separately
and run the standard-library-only Python script:

```sh
python3 repack_civilian.py /path/to/Casual_2.gltf /path/to/casual_civilian.glb
```

The script requires the exact recorded source hash, copies all retained buffer
view bytes, and verifies that the node graph and material values are unchanged.
This model is a generic provisional civilian shape, not a final Nigerian
character design. Clothing/skin palette variants and in-game scale/facing are
project presentation choices outside the derivative mesh.
