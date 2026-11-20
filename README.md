# lantervale/tap

Homebrew casks of the [Lantervale studio](https://github.com/lantervale).

## light

[light](https://lantervale.github.io/light/) is a small web browser written from scratch in Go, a very early preview:
do not open sensitive pages with it, and do not type a secret anywhere in it.

```sh
brew install --cask lantervale/tap/light
```

It installs `light.app` from the DMG of light's latest [release](https://github.com/lantervale/light/releases), for
Apple silicon or Intel, on macOS 13 or later. The app is not notarized by Apple, only signed ad hoc, so Gatekeeper
would refuse to open it: the cask removes the quarantine attribute from the installed app, as the release notes tell
you to do by hand. `brew uninstall --cask light` removes it, `brew uninstall --zap --cask light` its settings and
history too (`~/Library/Application Support/light`).

## How the cask stays current

`.github/workflows/update-light.yml` runs every hour (and by hand from the Actions tab). It reads light's latest
release; when its version is not the cask's, it downloads `light_<version>-checksums.txt`, verifies its cosign
signature against light's release workflow at that tag, writes the version and the SHA-256 of both DMGs into
`Casks/light.rb` and commits. It needs no secret: it reads a public release and pushes with its own token. A release
without a DMG for both Macs leaves the cask as it is.

To check the cask locally:

```sh
brew tap lantervale/tap
brew trust --cask lantervale/tap/light
brew style lantervale/tap
brew audit --cask --tap lantervale/tap light
```
