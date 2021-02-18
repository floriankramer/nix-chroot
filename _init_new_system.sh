#!/bin/bash
# This script should not be run directly, it is meant to initialize the new
# system

set -eEuo pipefail

apk add --no-cache bash-completion openssl sudo xz curl #man-pages man-db 

# setup nsswitch
echo 'hosts: dns files' > /etc/nsswitch.conf

# setup a user
adduser -h /home/user -s /bin/bash -D -u 1000 user
echo "root ALL=(ALL) ALL" > /etc/sudoers
echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "@includedir /etc/sudoers.d" >> /etc/sudoers 
cp /tmp/bashrc /home/user/.bashrc
chown user:user /home/user/.bashrc
chmod 644 /home/user/.bashrc

# Install nix
addgroup -g 30000 -S nixbld
mkdir -m 0755 /etc/nix
# init the build user swarm
for i in {1..30} ; do
  adduser -S -D -h /var/empty -g "Nix build user $i" -u $((30000 + i)) -G nixbld nixbld$i
done 

# Run the nix installer as user
pushd /home/user > /dev/null
sudo -u user bash -c 'curl -L https://nixos.org/nix/install | sh'
sudo -u user bash -c 'echo ". /home/user/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile'
sudo -u user bash -c 'echo ". /home/user/.bashrc" >> ~/.profile'
popd

# Ensure the apk cache is empty
rm -rf /var/cache/apk/* 
