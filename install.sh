#!/bin/sh
#
# Installs kinfctl, the kinference command-line tool, from a release in
# BuoyantIO/kinference-releases:
#
#   curl -fsSL https://raw.githubusercontent.com/BuoyantIO/kinference-releases/main/install.sh | sh
#
# Environment:
#   KINFCTL_VERSION      release to install, e.g. 0.1.0-alpha.2; default: the newest release
#   KINFCTL_INSTALL_DIR  where the binary goes; default: ~/.kinference/bin
set -eu

repo=BuoyantIO/kinference-releases
dir=${KINFCTL_INSTALL_DIR:-$HOME/.kinference/bin}

version=${KINFCTL_VERSION:-}
if [ -z "$version" ]; then
  # The newest release, prereleases included (GitHub's /releases/latest
  # skips prereleases). The API lists releases newest first.
  version=$(curl -fsSL "https://api.github.com/repos/$repo/releases?per_page=1" \
    | sed -n 's/.*"tag_name": *"v\([^"]*\)".*/\1/p' | head -n 1)
  if [ -z "$version" ]; then
    echo "install.sh: no releases found in $repo" >&2
    exit 1
  fi
fi

os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')
asset=kinfctl-$version-$os-$arch
url=https://github.com/$repo/releases/download/v$version/$asset

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Downloading $url"
if ! curl -fsSL -o "$tmp/$asset" "$url"; then
  echo "install.sh: could not download $asset: is there a v$version release with a $os-$arch build?" >&2
  exit 1
fi
curl -fsSL -o "$tmp/$asset.sha256" "$url.sha256"
if ! (
  cd "$tmp"
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum -c "$asset.sha256" >/dev/null
  else
    shasum -a 256 -c "$asset.sha256" >/dev/null
  fi
); then
  echo "install.sh: checksum mismatch for $asset" >&2
  exit 1
fi

mkdir -p "$dir"
mv "$tmp/$asset" "$dir/kinfctl"
chmod +x "$dir/kinfctl"
echo "kinfctl $version installed to $dir/kinfctl"
case ":$PATH:" in
  *":$dir:"*) ;;
  *) echo "Add it to your PATH, e.g.:  export PATH=\"\$PATH:$dir\"" ;;
esac
