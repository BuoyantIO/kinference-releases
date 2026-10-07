# kinference releases

Release artifacts for kinference. Each release here carries the `kinfctl`
command-line tool as prebuilt binaries; the server image and the Helm charts
ship on GHCR under the same version:

- Image: `ghcr.io/buoyantio/kinference:<version>`
- Charts: `oci://ghcr.io/buoyantio/charts/kinference-crds:<version>`,
  `oci://ghcr.io/buoyantio/charts/kinference:<version>`

This repository holds no source code and does not track issues.

## Install kinfctl

Binaries are built for macOS on Apple Silicon (`darwin-arm64`) and Linux on
x86_64 (`linux-amd64`); a `.sha256` sits next to each. Set `version` to the
release you want and the snippet picks the right one:

```sh
version=<version>
os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')
curl -fsSL -o kinfctl https://github.com/BuoyantIO/kinference-releases/releases/download/v$version/kinfctl-$version-$os-$arch
chmod +x kinfctl
sudo mv kinfctl /usr/local/bin/
```
