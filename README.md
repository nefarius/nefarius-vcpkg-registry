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
```
