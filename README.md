# nefarius-vcpkg-registry

My vcpkg packages registry.

## Hosted packages

- [neflib](https://github.com/nefarius/neflib)

## How to update

Run the `.\update-neflib.ps1 -RefVersion X.X.X` PowerShell helper script and push.

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
      "baseline": "a51cec12849ac113d4b8436c80bcf0b989668f90",
      "packages": [ "neflib" ]
    }
  ],
  "default-registry": {
    "kind": "git",
    "repository": "https://github.com/microsoft/vcpkg",
    "baseline": "3508985146f1b1d248c67ead13f8f54be5b4f5da"
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

## Resources

- [Registries: Bring your own libraries to vcpkg](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/)
