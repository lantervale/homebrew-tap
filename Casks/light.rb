cask "light" do
  arch arm: "arm64", intel: "amd64"

  version "0.2.5"
  sha256 arm:   "125ff7c5fa729c3339159860d16d0725769c9babac8c0800355333ded78b37f2",
         intel: "dc909152ccf9d4447f051506ebd887c05bad48dbb9c0b32a61fba0bcbaf14c26"

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
