cask "light" do
  arch arm: "arm64", intel: "amd64"

  version "0.0.0"
  sha256 arm:   "0000000000000000000000000000000000000000000000000000000000000000",
         intel: "1111111111111111111111111111111111111111111111111111111111111111"

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
