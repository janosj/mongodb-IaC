# From here:
# https://learn.hashicorp.com/tutorials/terraform/install-cli

# ############################################################
# Installation may produce errors and identify prerequisites.
# ############################################################

# Xcode was too old.
# Search for Xcode in spotlight and run it.
# Version previously installed may not be compatible with current MacOS.
# To use Xcode.app, you need to update to the latest version.
# Upgrade via App Store. This can take a long time to download and install.

# Command Line Tools was too old.
# sudo rm -rf /Library/Developer/CommandLineTools
# sudo xcode-select --install

# Terraform cannot be built with any available compilers.
# brew install gcc

# That requires this:
# xcode-select --install
# If it looks like nothing is happening, it's because
# a modal popped up somewhere to download and install it.

# Rerun terraform install to vet dependencies are satisfied.

# ############################################################

echo "See script for prerequisites."
echo

echo "Updating Homebrew ..."
brew update

echo
echo "Installing HashiCorp tap (a repository of all their Homebrew packages) ..."
brew tap hashicorp/tap

echo
echo "Installing Terraform ..."
brew install hashicorp/tap/terraform

# Verify the installation
echo
echo "Verifying installation ..."
terraform -help
echo

