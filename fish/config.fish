if status is-interactive
# Commands to run in interactive sessions can go here
end
set fish_color_user ffffff
set fish_color_host ff2200
set fish_color_cwd ff0000 --bold
set fish_color_cwd_root 00ffff
set fish_color_normal ffffff
set fish_color_param ffffff
set fish_color_quote ff3300
set fish_color_command ff0000
set fish_color_valid_path ff1100 --underline
set fish_color_error 00ffff
set -x LS_COLORS "di=1;38;2;255;0;0:fi=0:ln=38;2;255;51;0:ex=38;2;220;0;0"
fastfetch

fish_add_path "$HOME/.spicetify"


# Added by Antigravity CLI installer
fish_add_path "$HOME/.local/bin"
