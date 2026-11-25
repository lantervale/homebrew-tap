cask "light" do
  arch arm: "arm64", intel: "amd64"

  version "0.2.6"
  sha256 arm:   "f90294b8266f386e3bab9a80c563379cf0bca217e7cd85e6ea4c27068300e026",
         intel: "a54f3fb7911c80a5b6539b62ed4d371089c25f1f7eed8446c7ba625fde582a8a"

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
