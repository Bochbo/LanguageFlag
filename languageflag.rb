class Languageflag < Formula
  desc "LanguageFlag - Show keyboard layouts with flags"
  homepage "https://github.com/swiftyuser/LanguageFlag"
  url "https://github.com/swiftyuser/LanguageFlag/releases/download/1.0.0/languageflag.zip"
  sha256 "a16b997216596ea973c9ee81bb2a9e24a751a3c6d91a0a5966e76040db164c12"
  license "MIT"

  # Dependencies (if applicable)
  # depends_on "some_dependency"

  def install
    # Install binary to Homebrew's bin directory
    bin.install "languageflag"
  end

#  test do
#    # Test your app's functionality (optional, but recommended)
#    assert_match "LanguageFlag v1.0.0", shell_output("#{bin}/languageflag --version")
#  end
end