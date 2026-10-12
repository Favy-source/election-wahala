#!/usr/bin/env python3
"""Repack the pinned Quaternius 2022 Casual_2 glTF as a compact civilian GLB.

Python standard library only. Download the documented CC0 source separately,
then run: python3 repack_civilian.py /path/to/Casual_2.gltf /path/to/output.glb
Geometry, skin weights, bind matrices, nodes, and retained animation data are
copied byte for byte. Unused accessors/views and unwanted clips are omitted.
"""

from __future__ import annotations

import argparse
import base64
import copy
import hashlib
import json
from pathlib import Path
import struct


SOURCE_SHA256 = "55c654d09a2a5ff6e3bd6158d4a1b462f181cd6f1e12a0f5e9d959f9c3abc438"
CLIPS = {"Idle_Neutral": "idle", "Walk": "walk", "Run": "run"}


def remap_accessors(document: dict, mapping: dict[int, int]) -> None:
    for mesh in document.get("meshes", []):
        for primitive in mesh["primitives"]:
            primitive["attributes"] = {
                name: mapping[index] for name, index in primitive["attributes"].items()
            }
            if "indices" in primitive:
                primitive["indices"] = mapping[primitive["indices"]]
            for target in primitive.get("targets", []):
                for name, index in target.items():
                    target[name] = mapping[index]
    for skin in document.get("skins", []):
        if "inverseBindMatrices" in skin:
            skin["inverseBindMatrices"] = mapping[skin["inverseBindMatrices"]]
    for animation in document.get("animations", []):
        for sampler in animation["samplers"]:
            sampler["input"] = mapping[sampler["input"]]
            sampler["output"] = mapping[sampler["output"]]


def referenced_accessors(document: dict) -> set[int]:
    referenced: set[int] = set()
    for mesh in document.get("meshes", []):
        for primitive in mesh["primitives"]:
            referenced.update(primitive["attributes"].values())
            if "indices" in primitive:
                referenced.add(primitive["indices"])
            for target in primitive.get("targets", []):
                referenced.update(target.values())
    for skin in document.get("skins", []):
        if "inverseBindMatrices" in skin:
            referenced.add(skin["inverseBindMatrices"])
    for animation in document.get("animations", []):
        for sampler in animation["samplers"]:
            referenced.update((sampler["input"], sampler["output"]))
    return referenced


def accessor_views(accessor: dict) -> list[int]:
    views: list[int] = []
    if "bufferView" in accessor:
        views.append(accessor["bufferView"])
    if "sparse" in accessor:
        views.extend(
            accessor["sparse"][part]["bufferView"] for part in ("indices", "values")
        )
    return views


def repack(source: Path, destination: Path) -> dict:
    source_bytes = source.read_bytes()
    if hashlib.sha256(source_bytes).hexdigest() != SOURCE_SHA256:
        raise ValueError("Input is not the documented CC0 2022 Casual_2.gltf source")
    original = json.loads(source_bytes)
    if original.get("extensionsUsed") or original.get("extensionsRequired"):
        raise ValueError("Extension references require an explicit review before repacking")
    document = copy.deepcopy(original)
    buffers: list[bytes] = []
    for buffer in original["buffers"]:
        uri = buffer.get("uri", "")
        if not uri.startswith("data:") or ";base64," not in uri:
            raise ValueError("Only the pinned source's embedded base64 buffers are supported")
        data = base64.b64decode(uri.split(",", 1)[1], validate=True)
        if len(data) != buffer["byteLength"]:
            raise ValueError("Source buffer length does not match its declaration")
        buffers.append(data)

    document["animations"] = []
    for source_name, result_name in CLIPS.items():
        matches = [a for a in original["animations"] if a.get("name") == source_name]
        if len(matches) != 1:
            raise ValueError(f"Expected exactly one source clip named {source_name}")
        animation = copy.deepcopy(matches[0])
        animation["name"] = result_name
        animation.setdefault("extras", {})["source_animation"] = source_name
        document["animations"].append(animation)

    keep_accessors = sorted(referenced_accessors(document))
    accessor_mapping = {old: new for new, old in enumerate(keep_accessors)}
    document["accessors"] = [copy.deepcopy(original["accessors"][i]) for i in keep_accessors]
    remap_accessors(document, accessor_mapping)
    keep_views = set()
    for accessor in document["accessors"]:
        keep_views.update(accessor_views(accessor))
    for image in document.get("images", []):
        if "bufferView" in image:
            keep_views.add(image["bufferView"])
    keep_views = sorted(keep_views)
    view_mapping = {old: new for new, old in enumerate(keep_views)}

    binary = bytearray()
    document["bufferViews"] = []
    for source_index in keep_views:
        view = copy.deepcopy(original["bufferViews"][source_index])
        source_data = buffers[view["buffer"]]
        source_offset = view.get("byteOffset", 0)
        source_end = source_offset + view["byteLength"]
        if source_end > len(source_data):
            raise ValueError("Source view extends beyond its buffer")
        binary.extend(b"\0" * (-len(binary) % 4))
        view["buffer"] = 0
        view["byteOffset"] = len(binary)
        binary.extend(source_data[source_offset:source_end])
        document["bufferViews"].append(view)

    for accessor in document["accessors"]:
        if "bufferView" in accessor:
            accessor["bufferView"] = view_mapping[accessor["bufferView"]]
        if "sparse" in accessor:
            for part in ("indices", "values"):
                sparse_data = accessor["sparse"][part]
                sparse_data["bufferView"] = view_mapping[sparse_data["bufferView"]]
    for image in document.get("images", []):
        if "bufferView" in image:
            image["bufferView"] = view_mapping[image["bufferView"]]

    document["buffers"] = [{"byteLength": len(binary)}]
    document["asset"].setdefault("extras", {})["provenance"] = {
        "author": "Quaternius",
        "source_release": "Ultimate Modular Males (2022), Casual_2.gltf",
        "source_sha256": SOURCE_SHA256,
        "license": "CC0 1.0 Universal",
        "changes": "Retain idle/walk/run clips; remove unreferenced buffers; GLB container",
    }

    # Prove repacking preserved the actual byte ranges and the whole node graph.
    assert document["nodes"] == original["nodes"]
    assert document["materials"] == original["materials"]
    for old, new in view_mapping.items():
        before = original["bufferViews"][old]
        after = document["bufferViews"][new]
        start = before.get("byteOffset", 0)
        before_bytes = buffers[before["buffer"]][start:start + before["byteLength"]]
        start = after["byteOffset"]
        after_bytes = bytes(binary[start:start + after["byteLength"]])
        assert before_bytes == after_bytes

    json_chunk = json.dumps(document, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    json_chunk += b" " * (-len(json_chunk) % 4)
    binary_chunk = bytes(binary) + b"\0" * (-len(binary) % 4)
    length = 12 + 8 + len(json_chunk) + 8 + len(binary_chunk)
    result = (
        struct.pack("<4sII", b"glTF", 2, length)
        + struct.pack("<I4s", len(json_chunk), b"JSON") + json_chunk
        + struct.pack("<I4s", len(binary_chunk), b"BIN\0") + binary_chunk
    )
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_bytes(result)

    triangles = 0
    vertices = 0
    primitives = 0
    for mesh in document["meshes"]:
        for primitive in mesh["primitives"]:
            if primitive.get("mode", 4) != 4:
                raise ValueError("Statistics require triangle-list primitives")
            count = document["accessors"][primitive.get("indices", primitive["attributes"]["POSITION"])]["count"]
            triangles += count // 3
            vertices += document["accessors"][primitive["attributes"]["POSITION"]]["count"]
            primitives += 1
    durations = {}
    for animation in document["animations"]:
        durations[animation["name"]] = max(
            document["accessors"][sampler["input"]]["max"][0]
            for sampler in animation["samplers"]
        )
    return {
        "source_sha256": SOURCE_SHA256,
        "derivative_sha256": hashlib.sha256(result).hexdigest(),
        "source_bytes": len(source_bytes),
        "derivative_bytes": len(result),
        "meshes": len(document["meshes"]),
        "mesh_names": [mesh.get("name") for mesh in document["meshes"]],
        "mesh_node_names": [node.get("name") for node in document["nodes"] if "mesh" in node],
        "primitives": primitives,
        "triangles": triangles,
        "vertices_in_primitives": vertices,
        "materials": [material.get("name") for material in document["materials"]],
        "joints": [len(skin["joints"]) for skin in document["skins"]],
        "clip_duration_seconds": durations,
        "accessors": len(document["accessors"]),
        "buffer_views": len(document["bufferViews"]),
    }


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("destination", type=Path)
    args = parser.parse_args()
    print(json.dumps(repack(args.source, args.destination), indent=2))


if __name__ == "__main__":
    main()
