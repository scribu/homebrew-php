require 'formula'

class WpCli < Formula
  homepage 'https://wp-cli.org'
  url 'https://github.com/wp-cli/wp-cli/releases/download/v0.13.0/wp-cli.phar'
  sha1 'e5a6cfaf739bc5f382d89ddfc650c4bc756374fb'
  version '0.13.0'

  option 'without-bash-completion', "Don't install bash completion"

  resource 'bash-completion' do
    url 'https://raw.github.com/wp-cli/wp-cli/v0.13.0/utils/wp-completion.bash'
    sha1 'e019b047ddf964be12b92680acb96028c212b98d'
  end

  def install
    mv "wp-cli.phar", "wp-cli-#{version}.phar"
    libexec.install "wp-cli-#{version}.phar"
    sh = libexec + "wp"
    sh.write("#!/usr/bin/env bash\n\n${WP_CLI_PHP:-php} $WP_CLI_PHP_ARGS #{libexec}/wp-cli-#{version}.phar $*")
    chmod 0755, sh
    bin.install_symlink sh

    unless build.without? 'bash-completion'
      resource('bash-completion').stage {
        (prefix + 'etc/bash_completion.d').install "wp-completion.bash"
      }
    end
  end

  def test
    system "#{bin}/wp --info"
  end
end
