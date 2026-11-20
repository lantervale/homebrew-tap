#!/bin/sh
# Points Casks/light.rb at light's latest release: its version, and the
# SHA-256 of its two DMGs as light_<version>-checksums.txt lists them. The
# checksums are only taken once cosign verified their signature, made by
# light's release workflow at that tag. A release without a DMG for both
# Macs leaves the cask as it is.
#
#	.github/update-light.sh
#
# It needs gh (signed in, or GH_TOKEN) and cosign, and prints
# version=<version> to $GITHUB_OUTPUT when it changed the cask.
set -eu
repo=lantervale/light
cask=Casks/light.rb

tag=$(gh release view --repo "$repo" --json tagName --jq .tagName)
version=${tag#v}
have=$(sed -n 's/^  version "\(.*\)"$/\1/p' "$cask")
if [ "$version" = "$have" ]; then
	echo "light $version: the cask is current"
	exit 0
fi

dir=$(mktemp -d)
trap 'rm -rf "$dir"' EXIT
sums=light_$version-checksums.txt
gh release download "$tag" --repo "$repo" --dir "$dir" --pattern "$sums" --pattern "$sums.sigstore.json"
cosign verify-blob "$dir/$sums" --bundle "$dir/$sums.sigstore.json" \
	--certificate-identity "https://github.com/$repo/.github/workflows/release.yml@refs/tags/$tag" \
	--certificate-oidc-issuer https://token.actions.githubusercontent.com

sum() { awk -v f="light_${version}_darwin_$1.dmg" '$2 == f || $2 == "*" f { print $1 }' "$dir/$sums"; }
arm=$(sum arm64)
intel=$(sum amd64)
if [ -z "$arm" ] || [ -z "$intel" ]; then
	echo "light $version ships no DMG for both Macs: the cask stays at $have"
	exit 0
fi

sed -i.bak -E \
	-e "s/^(  version \")[^\"]*\"/\1$version\"/" \
	-e "s/(arm: +\")[0-9a-f]{64}\"/\1$arm\"/" \
	-e "s/(intel: +\")[0-9a-f]{64}\"/\1$intel\"/" \
	"$cask"
rm -f "$cask.bak"
grep -q "version \"$version\"" "$cask" && grep -q "\"$arm\"" "$cask" && grep -q "\"$intel\"" "$cask"
echo "light $have -> $version: arm64 $arm, amd64 $intel"
[ -z "${GITHUB_OUTPUT:-}" ] || echo "version=$version" >> "$GITHUB_OUTPUT"
