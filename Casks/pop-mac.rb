# The Homebrew cask for Pop Mac. The release workflow fills in the version and
# the checksum, and copies the result to Casks/pop-mac.rb in krystxf/homebrew-tap.
cask "pop-mac" do
  version "0.10.1"
  sha256 "073afe59a15c778036972ca24f0ab57625e6892ede758c5c21a3933410e3f9c2"

  url "https://github.com/krystxf/pop_mac/releases/download/v#{version}/PopMac.zip"
  name "Pop Mac"
  desc "Pop!_OS Shell tiling window manager"
  homepage "https://github.com/krystxf/pop_mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "PopMac.app"

  uninstall quit: "dev.krystof.popmac"

  zap trash: "~/.config/pop-mac"

  caveats <<~EOS
    Pop Mac needs Accessibility access. macOS asks for it on the first start:
      System Settings > Privacy & Security > Accessibility
  EOS
end
