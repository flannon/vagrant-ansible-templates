# vagrant-ansible-cantaloupe

#### Pre-Installation Setup

To run the vagrant installer you will need Virtualbox and vagrant running on your machine. If you're on a Mac the easiest way to install everything you'll need is with homebrew.  The following steps will install homebrew and vagrant

    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew cask install virtualbox
    brew cask install vagrant

#### Usage

- Clone this branch
- `cd` to project directory
- Clone this Cantaloupe forked repo branch directly into this directory: https://github.com/nyudlts/cantaloupe/tree/feature/disableHttpAuth
- run `vagrant up`
- Navigate here, it should show a customized landing page with NYU logo: http://192.168.50.99:8080/cantaloupe/

#### Iterating Builds

Automatic way: run `vagrant provision`

Manual way:

    vagrant rsync
    vagrant ssh
    cd /vagrant/cantaloupe; mvn clean package -DskipTests
    sudo cp /vagrant/cantaloupe/target/cantaloupe-4.1.1-SNAPSHOT.war /opt/tomcat/webapps/cantaloupe.war
    sudo systemctl restart tomcat8
