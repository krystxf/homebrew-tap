class PopMac < Formula
  desc "Pop!_OS Shell tiling window manager for macOS"
  homepage "https://github.com/krystxf/pop_mac"
  url "https://github.com/krystxf/pop_mac/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5c6756856612d80946478c8c2303c2b21ae300000279b47d7c8572959252a808"
  license "GPL-3.0-only"
  head "https://github.com/krystxf/pop_mac.git", branch: "main"

  depends_on xcode: ["16.0", :build]
  depends_on macos: :ventura

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "PopMac"
    bin_path = Utils.safe_popen_read("swift", "build", "--configuration", "release", "--show-bin-path").chomp

    app = prefix/"PopMac.app"
    (app/"Contents/MacOS").install "#{bin_path}/PopMac"
    (app/"Contents").install "Resources/Info.plist"
    # Releases after 0.1.0 have an app icon.
    (app/"Contents/Resources").install "Resources/AppIcon.icns" if File.exist?("Resources/AppIcon.icns")
    system "codesign", "--force", "--sign", "-", app
  end

  def caveats
    <<~EOS
      Start Pop Mac:
        open #{opt_prefix}/PopMac.app

      Start it at login with `brew services start pop-mac`, or with
      "Launch at Login" in its menu bar menu.

      Pop Mac needs Accessibility access. macOS asks for it on the first start:
        System Settings > Privacy & Security > Accessibility

      The app is signed ad hoc, so macOS asks again after each upgrade.
      Remove the old "PopMac" entry from the Accessibility list, then allow the new one.
    EOS
  end

  service do
    run [opt_prefix/"PopMac.app/Contents/MacOS/PopMac"]
    # Restart after a crash, but not after "Quit Pop Mac".
    keep_alive successful_exit: false
    process_type :interactive
  end

  test do
    assert_match "Pop Mac", shell_output("#{prefix}/PopMac.app/Contents/MacOS/PopMac --version")
    system "codesign", "--verify", "--strict", prefix/"PopMac.app"
  end
end
