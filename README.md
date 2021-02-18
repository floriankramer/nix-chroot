# nix-chroot
This repo caontains a set of scripts to install the [nix package manager](https://nixos.org/) into a chroot.
It uses alpine linux as the base system.

## How To Use
Run `setup.sh` to setup the system (it will be installed into a folder called root). The script needs
to be run as root. Then use `enter.sh` to enter the chroot. `cleanup.sh` deletes the system.
