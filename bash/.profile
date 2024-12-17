if [ -n "${WSL_DISTRO_NAME}" ]; then
   if ! [ -d "/mnt/wsl/${WSL_DISTRO_NAME}" ]; then
      mkdir "/mnt/wsl/${WSL_DISTRO_NAME}"
      wsl.exe -d ${WSL_DISTRO_NAME} -u root mount --bind / "/mnt/wsl/${WSL_DISTRO_NAME}/"
   fi
fi
#command emacs --daemon &>/dev/null &
PATH="$HOME/.local/bin:$PATH"
TERM=xterm-256color

[ -r ~/.bashrc ] && . ~/.bashrc

[ -r /home/yan3k/.opam/opam-init/init.sh ] && . /home/yan3k/.opam/opam-init/init.sh &>/dev/null || true
[ -r /home/yan3k/.ghcup/env ] && . /home/yan3k/.ghcup/env

if [ -e /home/yan3k/.nix-profile/etc/profile.d/nix.sh ]; then . /home/yan3k/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

[ -f "/home/yan3k/.ghcup/env" ] && . "/home/yan3k/.ghcup/env" # ghcup-env
