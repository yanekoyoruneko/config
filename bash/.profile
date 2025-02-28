# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022


if [ -n "${WSL_DISTRO_NAME}" ]; then
   if ! [ -d "/mnt/wsl/${WSL_DISTRO_NAME}" ]; then
      mkdir "/mnt/wsl/${WSL_DISTRO_NAME}"
      wsl.exe -d ${WSL_DISTRO_NAME} -u root mount --bind / "/mnt/wsl/${WSL_DISTRO_NAME}/"
   fi
fi

[ -n "$BASH_VERSION" ] && . "$HOME/.bashrc"
#command emacs --daemon &>/dev/null &

[ -r /home/yan3k/.opam/opam-init/init.sh ] && . /home/yan3k/.opam/opam-init/init.sh &>/dev/null || true
[ -r /home/yan3k/.ghcup/env ] && . /home/yan3k/.ghcup/env

if [ -e /home/yan3k/.nix-profile/etc/profile.d/nix.sh ]; then . /home/yan3k/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[ -f "/home/yan3k/.ghcup/env" ] && . "/home/yan3k/.ghcup/env" # ghcup-env

PATH="$HOME/.local/bin:$PATH"
TERM=xterm-256color
EDITOR=emacs
