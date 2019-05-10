# vagrant-ansible-housekeeping

#### Pre-Installation Setup

To run the vagrant installer you will need Virtualbox and vagrant running on your machine. If you're on a Mac the easiest way to install everything you'll need is with homebrew.  The following steps will install homebrew and vagrant

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask install virtualbox
    brew cask install vagrant

#### Usage

- Clone this branch
- `cd` to project directory
- run `vagrant up`
- run `vagrant ssh` and evaluate the server's configuration
