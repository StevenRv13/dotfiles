#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
backup_root="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
install_packages=false

usage() {
  cat <<'EOF'
Uso: ./install.sh [--packages]

  --packages  instala primero los paquetes principales con pacman

Las configuraciones existentes se mueven a ~/.dotfiles-backup-FECHA/.
EOF
}

for argument in "$@"; do
  case "$argument" in
    --packages) install_packages=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Opción desconocida: $argument" >&2; usage >&2; exit 2 ;;
  esac
done

if [[ "$install_packages" == true ]]; then
  if ! command -v pacman >/dev/null 2>&1; then
    echo "--packages solo es compatible con Arch Linux." >&2
    exit 1
  fi

  sudo pacman -S --needed \
    git fish kitty fastfetch fzf fd bat btop cava fuzzel \
    noto-fonts ttf-jetbrains-mono-nerd
fi

backup_path() {
  local target="$1"
  local relative="${target#"$HOME"/}"

  mkdir -p "$backup_root/$(dirname -- "$relative")"
  mv -- "$target" "$backup_root/$relative"
  echo "Respaldo: $target -> $backup_root/$relative"
}

link_path() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" ]] && [[ "$(readlink -f -- "$target")" == "$(readlink -f -- "$source")" ]]; then
    echo "Ya enlazado: $target"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    backup_path "$target"
  fi

  mkdir -p "$(dirname -- "$target")"
  ln -s -- "$source" "$target"
  echo "Instalado: $target"
}

for directory in fish kitty fastfetch hypr btop cava fuzzel; do
  link_path "$repo_dir/$directory" "$config_home/$directory"
done

for version in gtk-3.0 gtk-4.0; do
  mkdir -p "$config_home/$version"
  for filename in gtk.css thunar.css; do
    link_path "$repo_dir/$version/$filename" "$config_home/$version/$filename"
  done
done

link_path "$repo_dir/bash/.bashrc" "$HOME/.bashrc"
link_path "$repo_dir/bash/.bash_profile" "$HOME/.bash_profile"

mkdir -p "$config_home/serpantinum"
serpantinum_target="$config_home/serpantinum/settings.json"
serpantinum_tmp="$(mktemp)"
trap 'rm -f -- "$serpantinum_tmp"' EXIT
sed "s|__HOME__|$HOME|g" "$repo_dir/serpantinum/settings.json" > "$serpantinum_tmp"
if [[ -f "$serpantinum_target" ]] && cmp -s "$serpantinum_tmp" "$serpantinum_target"; then
  echo "Ya actualizado: $serpantinum_target"
else
  if [[ -e "$serpantinum_target" || -L "$serpantinum_target" ]]; then
    backup_path "$serpantinum_target"
  fi
  install -m 600 "$serpantinum_tmp" "$serpantinum_target"
  echo "Instalado: $serpantinum_target"
fi

mkdir -p "$HOME/Pictures"
for image in luffy.png Monkey-D-Luffy-Gear-5-PNG.png; do
  image_target="$HOME/Pictures/$image"
  if [[ -f "$image_target" ]] && cmp -s "$repo_dir/$image" "$image_target"; then
    echo "Ya actualizado: $image_target"
    continue
  fi
  if [[ -e "$image_target" || -L "$image_target" ]]; then
    backup_path "$image_target"
  fi
  install -m 644 "$repo_dir/$image" "$image_target"
done

echo
echo "Dotfiles instalados. Para usar Fish como shell predeterminado:"
echo "  chsh -s /usr/bin/fish"
if [[ -d "$backup_root" ]]; then
  echo "Respaldo creado en: $backup_root"
fi
