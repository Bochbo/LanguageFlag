cask "languageflag" do
  version "1.0.0"
  sha256 "a16b997216596ea973c9ee81bb2a9e24a751a3c6d91a0a5966e76040db164c12"

  url "https://github.com/swiftyuser/LanguageFlag/releases/download/1.0.0/languageflag.zip"
  name "LanguageFlag"
  desc "Show keyboard layouts with flags"
  homepage "https://github.com/swiftyuser/LanguageFlag"

  # Move the `.app` to `/Applications`
  app "LanguageFlag.app"
end