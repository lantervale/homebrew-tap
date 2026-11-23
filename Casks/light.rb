cask "light" do
  arch arm: "arm64", intel: "amd64"

  version "0.2.4"
  sha256 arm:   "b7458bbbc6b5828ebeb83b21dbd769ae52ae5e8b415402bf37ec574ed0ede265",
         intel: "5a01103a408ea2582de0a0fedeb5ec3355199adda48828b0774b9a96c307fa7e"

  url "https://github.com/lantervale/light/releases/download/v#{version}/light_#{version}_darwin_#{arch}.dmg"
  name "light"
  desc "Small web browser written from scratch in Go"
  homepage "https://lantervale.github.io/light/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "light.app"

  # light is signed ad hoc, without an Apple Developer identity, so Gatekeeper refuses it while it is in quarantine.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/light.app"]
  end

  zap trash: "~/Library/Application Support/light"

  caveats <<~EOS
    light is not notarized by Apple: it is only signed ad hoc. This cask removed the
    quarantine attribute from #{appdir}/light.app so that macOS opens it.
  EOS
end
