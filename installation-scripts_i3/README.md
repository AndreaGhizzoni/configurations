# Installation scripts order:
- `0_inti.install.bash`
- `1_base.install.bash`
- `2_git.install.bash`
- `3_i3-post.install.bash`
- `4_fonts.install.bash`
- `5_zsh.install.bash`
- log in into i3, genrate new i3config in .config/i3/config
  copy `i3/common/*` in `~/.config/i3/`
  copy `i3/[desktop|laptop]/*` in `~/.config/i3/`
  copy `i3/[desktop|laptop]/i3blocks` in `/usr/share`
  run: `sudo apt-get install xserver-xorg-input-synaptics`
  set: `lxappearance`
- `6_utilities.install.bash`
- `7_vim.install.bash`
