<div align="center">

# Steven's Dotfiles

**Arch Linux + Hyprland**, basado en [ilyamiro/serpantinum](https://github.com/ilyamiro/serpantinum), con una instalación reproducible y personalizaciones propias.

![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-1793D1?logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-58E1FF?logo=wayland&logoColor=white)
![Fish](https://img.shields.io/badge/Shell-Fish-34C88C?logo=gnubash&logoColor=white)
![Kitty](https://img.shields.io/badge/Terminal-Kitty-C7C2EA)

</div>

---

## Índice

- [Preview](#preview)
- [Sistema](#sistema)
- [Estructura del repo](#estructura-del-repo)
- [Instalación desde cero](#instalación-desde-cero)
- [Keybinds](#keybinds)
- [Personalización aplicada](#personalización-aplicada)
- [Solución de problemas](docs/troubleshooting-hyprland.md)
- [Actualizar dotfiles](#actualizar-dotfiles)

---

## Preview

> Hyprland + Kitty + Fastfetch con Luffy Gear 5 + tema morado/blanco

---

## Sistema

| Componente | Detalle |
|---|---|
| OS | Arch Linux |
| WM | Hyprland 0.56+ (Wayland), config en Lua (`hl.config`, `hl.bind`) |
| Terminal | Kitty |
| Shell | Fish |
| Bar / Launcher | Serpantinum con preset Obsidian personalizado |
| Fetch | Fastfetch con imagen personalizada |
| Font | `JetBrainsMono Nerd Font Mono` (paquete `ttf-jetbrains-mono-nerd`) |

---

## Estructura del repo

```
dotfiles/
├── hypr/                  # Hyprland (Lua)
│   ├── hyprland.lua        # entrypoint, hace require() de config/
│   └── config/
│       ├── keybinds.lua    # todos los atajos
│       ├── settings.lua    # general, decoration, input, animaciones
│       ├── variables.lua   # mainMod, terminal
│       ├── env.lua
│       ├── autostart.lua
│       └── monitors.lua
├── kitty/                  # terminal (fuente, colores y apariencia)
├── fastfetch/              # resumen compacto del sistema
├── fish/                    # shell config + fisher, z, fzf, sponge
├── bash/                    # shell de respaldo
├── btop/                    # monitor de recursos
├── cava/                    # visualizador de audio y shaders
├── fuzzel/                  # launcher y paleta de colores
├── gtk-3.0/ y gtk-4.0/      # estilos visuales de aplicaciones
├── serpantinum/             # barra, dock, launcher y tema sanitizado
├── wallpapers/videos/       # fondos animados administrados con Git LFS
├── color-options/           # presets alternativos para Fish y Fastfetch
├── install.sh               # instalación con backup automático
├── packages.txt             # dependencias oficiales de Arch
└── *.png                    # wallpapers/imágenes usadas por fastfetch
```

---

## Instalación desde cero

### 1. Instalar Arch Linux base con archinstall

```bash
archinstall
```

Perfil recomendado: **minimal** o **Hyprland** directo.

### 2. Instalar Serpantinum (ilyamiro)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ilyamiro/serpantinum/master/install/install.sh)"
```

Durante la instalación:
- Activar **Configure SDDM Theme**
- Activar **Download FULL Wallpaper Pack** (opcional)
- Configurar drivers **NVIDIA** si aplica
- Ingresar API key de OpenWeatherMap cuando se solicite

> La API key gratuita se obtiene en https://openweathermap.org/api

> El instalador base trae Hyprland con config en **Lua** y la barra **Serpantinum** (ya no Quickshell). No instala Fish por defecto.

### 3. Clonar e instalar la configuración

```bash
git clone https://github.com/StevenRv13/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --packages
chsh -s /usr/bin/fish
```

El instalador enlaza las configuraciones desde el repo y respalda cualquier archivo anterior en `~/.dotfiles-backup-FECHA/`. Se puede ejecutar sin `--packages` si las dependencias ya están instaladas. No sobrescribe secretos ni guarda el estado generado de Fish. Los fondos animados ocupan aproximadamente 1,3 GB y se descargan mediante Git LFS.

Cerrá sesión (o reiniciá) después de `chsh`. Kitty usará el shell predeterminado de la sesión.

La configuración actual usa la familia **`JetBrains Mono`** tanto en Kitty como en Hyprland.

Instalar Spicetify:
```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
fish -c "fish_add_path ~/.spicetify"
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify backup apply
```

<details>
<summary><b>4-7. Pasos opcionales</b> (zona horaria, firewall, dual boot, bases de datos)</summary>

### 4. Configurar zona horaria y sincronización

```bash
sudo timedatectl set-timezone America/Costa_Rica
sudo systemctl enable --now systemd-timesyncd
```

### 5. Configurar firewall (UFW)

```bash
sudo pacman -S ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow in on tailscale0
sudo ufw enable
sudo systemctl enable ufw
```

Para abrir un puerto específico cuando se necesite:
```bash
sudo ufw allow 3000   # ejemplo: servidor Node.js
sudo ufw deny 3000    # para cerrarlo de nuevo
```

### 6. Agregar Windows al GRUB (dual boot)

```bash
sudo pacman -S os-prober
sudo nano /etc/default/grub
# Descomentar: GRUB_DISABLE_OS_PROBER=false
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 7. Instalar bases de datos (desarrollo)

```bash
# PostgreSQL
sudo pacman -S postgresql
sudo -u postgres initdb -D /var/lib/postgres/data
sudo systemctl enable --now postgresql

# MongoDB
yay -S mongodb-bin
sudo systemctl enable --now mongodb
```

</details>

---

## Keybinds

Definidas en [`hypr/config/keybinds.lua`](hypr/config/keybinds.lua). `Super` = tecla Meta/Windows.

#### Ventanas

| Atajo | Acción |
|---|---|
| `Super + Q` | Cerrar ventana activa |
| `Alt + F4` | Cerrar ventana activa (alterno) |
| `Super + G` | Alternar ventana flotante |
| `Super + Shift + F` | Alternar ventana flotante (alterno) |
| `Super + ←/→/↑/↓` | Mover foco entre ventanas |
| `Super + Ctrl + ←/→/↑/↓` | Mover ventana activa |
| `Super + Shift + ←/→/↑/↓` (mantenido) | Redimensionar ventana ±50px |
| `Super + click izq + arrastrar` | Mover ventana |
| `Super + click der + arrastrar` | Redimensionar ventana |
| Gesto 3 dedos horizontal (trackpad) | Cambiar workspace |

#### Apps

| Atajo | Acción |
|---|---|
| `Super + Enter` | Terminal (Kitty) |
| `Super + B` | Brave |
| `Super + E` | Gestor de archivos (Nautilus) |

#### Panel / Serpantinum

| Atajo | Acción |
|---|---|
| `Super + R` | Recargar Serpantinum |
| `Super + C` | Toggle clipboard |
| `Super + D` | Toggle lanzador de apps |
| `Super + U` | Toggle música |
| `Super + F` | Toggle panel de sistema |
| `Super + W` | Toggle selector de wallpaper |
| `Super + S` | Toggle calendario |
| `Super + N` | Toggle red / WiFi |
| `Super + V` | Toggle volumen |
| `Super + H` | Toggle guía de keybinds |

#### Workspaces

| Atajo | Acción |
|---|---|
| `Super + 1..9, 0` | Ir a workspace 1–10 |
| `Super + Shift + 1..9, 0` | Mover ventana activa a workspace 1–10 |

#### Sistema / multimedia

| Atajo | Acción |
|---|---|
| `Super + L` | Bloquear pantalla |
| `XF86PowerOff` | Bloquear pantalla |
| `XF86AudioPlay` / `XF86AudioPause` | Play/pause |
| `XF86AudioMicMute` | Mute micrófono |
| `XF86AudioMute` | Mute salida |
| `XF86AudioLowerVolume` / `XF86AudioRaiseVolume` | Volumen ± |
| `XF86MonBrightnessDown` / `XF86MonBrightnessUp` | Brillo ± |
| `Print` | Captura de pantalla (selección) |
| `Shift + Print` | Captura + editar |
| `Super + Print` | Captura pantalla completa |
| `Super + Shift + Print` | Captura pantalla completa + editar |

---

## Personalización aplicada

- Prompt de Fish en tonos blanco, violeta, magenta y rojo
- Comandos, rutas, carpetas, symlinks y ejecutables coloreados mediante las variables de Fish y `LS_COLORS`
- Fastfetch compacto con logo pequeño y módulos de OS, CPU, memoria y shell
- Kitty con `JetBrains Mono` a 16 pt, fondo semitransparente y paleta monocromática cargada desde `colors.conf`
- Serpantinum, Cava, Fuzzel y estilos GTK coordinados con la misma paleta
- 23 fondos animados MP4 enlazados automáticamente en `~/Pictures/Wallpapers`
- Tres combinaciones de color alternativas en `color-options/`
- Tema Persona 5 Royal en GRUB

---

## Actualizar dotfiles

Como las configuraciones quedan enlazadas al repo, los cambios hechos en `~/.config` aparecen directamente en Git:

```bash
cd ~/dotfiles
git status
git add .
git commit -m "descripción del cambio"
git push
```

No agregués tokens, claves API, archivos de sesión ni `fish_variables`.
