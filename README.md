# nefarius-vcpkg-registry

My vcpkg packages registry.

## Hosted packages

- [neflib](https://github.com/nefarius/neflib)

## How to update

```batch
git commit -a -m "Updated neflib" 
git rev-parse HEAD:ports/neflib
rem update .\versions\n-\neflib.json with returned checksum in "git-tree"
git add versions
git commit --amend --no-edit
git push
git rev-parse HEAD
```

## Test it locally

```batch
vcpkg install neflib:x64-windows-static --overlay-ports=ports/neflib
```

## How to consume

### `vcpkg-configuration.json`

```json
{
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/nefarius/nefarius-vcpkg-registry.git",
      "baseline": "latest",
      "packages": [ "neflib" ]
    }
  ],
  "default-registry": {
    "kind": "builtin",
    "baseline": "2024.07.12"
  }
}
```

### `vcpkg.json`

```json
{
  "dependencies": [
    "neflib"
  ]
}
```
