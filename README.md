# kinference releases

Release artifacts for kinference. Each release here carries the `kinfctl`
command-line tool as prebuilt binaries; the server image and the Helm charts
ship on GHCR under the same version:

- Image: `ghcr.io/buoyantio/kinference:<version>`
- Charts: `oci://ghcr.io/buoyantio/charts/kinference-crds:<version>`,
  `oci://ghcr.io/buoyantio/charts/kinference:<version>`

This repository holds no source code and does not track issues.

## Install kinfctl

Pick the binary for your platform from the release page: `darwin-arm64`
(Apple Silicon) or `linux-amd64`. A `.sha256` sits next to each.

```sh
version=<version>
curl -fsSL -o kinfctl https://github.com/BuoyantIO/kinference-releases/releases/download/v$version/kinfctl-$version-darwin-arm64
chmod +x kinfctl
sudo mv kinfctl /usr/local/bin/
```
