class Languageflag < Formula
  desc "LanguageFlag - Show keyboard layouts with flags"
  homepage "https://github.com/swiftyuser/LanguageFlag"
  url "https://github.com/swiftyuser/LanguageFlag/releases/download/1.0.0/languageflag.zip"
  sha256 "a16b997216596ea973c9ee81bb2a9e24a751a3c6d91a0a5966e76040db164c12"
  license "MIT"

  def install
    # Install the .app bundle into the prefix directory
    prefix.install "LanguageFlag.app"

    # Create a wrapper script to launch the app from the command line
    (bin/"languageflag").write <<~EOS
      #!/bin/bash
      echo "Test123"
      open "#{prefix}/LanguageFlag.app"
    EOS
  end

  # def install
  #   prefix.install "LanguageFlag.app"
  #   (bin/"LanguageFlag").write <<~EOS
  #     #!/bin/bash
  #     open "#{prefix}/LanguageFlag.app"
  #   EOS
  # end

  def caveats
    <<~EOS
      LanguageFlag.app has been installed to:
        #{prefix}/LanguageFlag.app

      You can run it using the command:
        languageflag
    EOS
  end
end

# cask "languageflag" do
#   version "1.0.0"
#   sha256 "a16b997216596ea973c9ee81bb2a9e24a751a3c6d91a0a5966e76040db164c12"

#   url "https://github.com/swiftyuser/LanguageFlag/releases/download/1.0.0/languageflag.zip"
#   name "LanguageFlag"
#   desc "Show keyboard layouts with flags"
#   homepage "https://github.com/swiftyuser/LanguageFlag"

#   # Move the `.app` to `/Applications`
#   app "LanguageFlag.app"
# end