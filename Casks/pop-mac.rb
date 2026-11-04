# The Homebrew cask for Pop Mac. The release workflow fills in the version and
# the checksum, and copies the result to Casks/pop-mac.rb in krystxf/homebrew-tap.
cask "pop-mac" do
  version "0.9.0"
  sha256 "5e9bfee1978479194fbb3f883b1c56a46d4059e4f0eb352e12be95baa70da277"

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
