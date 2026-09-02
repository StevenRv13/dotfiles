<div align="center">

# 🏴‍☠️ Steven's Dotfiles

**Arch Linux + Hyprland**, basado en [ilyamiro/imperative-dots](https://github.com/ilyamiro/imperative-dots) con personalizaciones propias.

![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-1793D1?logo=archlinux&logoColor=white)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-58E1FF?logo=wayland&logoColor=white)
![Fish](https://img.shields.io/badge/Shell-Fish-34C88C?logo=gnubash&logoColor=white)
![Kitty](https://img.shields.io/badge/Terminal-Kitty-C7C2EA)

</div>

---

## 📑 Índice

- [Preview](#-preview)
- [Sistema](#️-sistema)
- [Estructura del repo](#-estructura-del-repo)
- [Instalación desde cero](#️-instalación-desde-cero)
- [Keybinds](#️-keybinds)
- [Personalización aplicada](#-personalización-aplicada)
- [Actualizar dotfiles](#-actualizar-dotfiles)

---

## 📸 Preview

> Hyprland + Kitty + Fastfetch con Luffy Gear 5 + tema morado/blanco

---

## 🖥️ Sistema

| Componente | Detalle |
|---|---|
| OS | Arch Linux |
| WM | Hyprland 0.56+ (Wayland), config en Lua (`hl.config`, `hl.bind`) |
| Terminal | Kitty |
| Shell | Fish |
| Bar / Launcher | Serpantinum (reemplazó a Quickshell) |
| Fetch | Fastfetch con imagen personalizada |
| Font | `JetBrainsMono Nerd Font Mono` (paquete `ttf-jetbrains-mono-nerd`) |

---

## 📁 Estructura del repo

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
├── kitty/                  # terminal (opacidad, colores matugen, shell fish forzado)
├── fastfetch/               # logo Luffy + paleta morada
├── fish/                    # shell config + fisher, z, fzf, sponge
└── *.png                    # wallpapers/imágenes usadas por fastfetch
```

---

## ⚙️ Instalación desde cero

### 1. Instalar Arch Linux base con archinstall

```bash
archinstall
```

Perfil recomendado: **minimal** o **Hyprland** directo.

### 2. Instalar el rice base (ilyamiro)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ilyamiro/imperative-dots/master/install.sh)"
```

Durante la instalación:
- Activar **Configure SDDM Theme**
- Activar **Download FULL Wallpaper Pack** (opcional)
- Configurar drivers **NVIDIA** si aplica
- Ingresar API key de OpenWeatherMap cuando se solicite

> 🔑 La API key gratuita se obtiene en https://openweathermap.org/api

> ℹ️ El instalador base trae Hyprland con config en **Lua** y la barra **Serpantinum** (ya no Quickshell). No instala Fish por defecto.

### 3. Instalar Fish y dependencias adicionales

```bash
sudo pacman -S fish micro brightnessctl fastfetch v4l2loopback-dkms lazygit ttf-jetbrains-mono-nerd
yay -S spotify iriunwebcam-bin brave-bin antigravity
chsh -s /usr/bin/fish
```

Cerrá sesión (o reiniciá) para que el shell nuevo tome efecto. Si abrís kitty antes de reiniciar sesión, forzalo explícitamente agregando `shell /usr/bin/fish` en `kitty.conf` (ya incluido en este repo) — evita depender de `$SHELL`, que queda cacheado por la sesión gráfica hasta el próximo login.

> ⚠️ El paquete `ttf-jetbrains-mono-nerd` registra la familia como **`JetBrainsMono Nerd Font Mono`** (sin espacio entre JetBrains y Mono), no `JetBrains Mono`. Si usás ese nombre con espacio en `kitty.conf` o en `hypr/config/settings.lua`, cae a una fuente de respaldo sin los íconos y varios símbolos salen como `?`. Este repo ya usa el nombre correcto.

Instalar Spicetify:
```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
fish -c "fish_add_path ~/.spicetify"
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify backup apply
```

### 4. Aplicar dotfiles personalizados

```bash
git clone https://github.com/StevenRv13/dotfiles.git
cp -r dotfiles/hypr ~/.config/
cp -r dotfiles/kitty ~/.config/
cp -r dotfiles/fastfetch ~/.config/
cp -r dotfiles/fish ~/.config/
cp dotfiles/luffy.png ~/Pictures/
cp dotfiles/Monkey-D-Luffy-Gear-5-PNG.png ~/Pictures/
```

<details>
<summary><b>5-8. Pasos opcionales</b> (zona horaria, firewall, dual boot, bases de datos)</summary>

### 5. Configurar zona horaria y sincronización

```bash
sudo timedatectl set-timezone America/Costa_Rica
sudo systemctl enable --now systemd-timesyncd
```

### 6. Configurar firewall (UFW)

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

### 7. Agregar Windows al GRUB (dual boot)

```bash
sudo pacman -S os-prober
sudo nano /etc/default/grub
# Descomentar: GRUB_DISABLE_OS_PROBER=false
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 8. Instalar bases de datos (desarrollo)

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

## ⌨️ Keybinds

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
| `Super + Space` | Play/pause |
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

## 🎨 Personalización aplicada

- Prompt de fish en tonos morados (`fish_color_user`, `_host`, `_cwd`, `_cwd_root`)
- Texto normal/argumentos en blanco (`fish_color_normal`, `_param`, `_quote`); comandos y rutas válidas en morado (`fish_color_command`, `_valid_path`); comandos inválidos en rojo real (`fish_color_error`)
- Carpetas, symlinks y ejecutables en tonos morados vía `LS_COLORS`
- Imagen de Luffy Gear 5 como logo en fastfetch (protocolo gráfico de kitty), con módulos extra (host, kernel, uptime, packages, shell, de, wm, terminal, cpu, gpu, memoria, disco, IP local) en tonos de morado
- Fondo de kitty `#1e1e1e` con opacidad `0.65`, shell forzado a `/usr/bin/fish`
- Tema Persona 5 Royal en GRUB

---

## 🔄 Actualizar dotfiles

Después de hacer cambios:

```bash
cd ~/dotfiles
cp -r ~/.config/hypr .
cp -r ~/.config/kitty .
cp -r ~/.config/fish .
cp -r ~/.config/fastfetch .
git add .
git commit -m "descripción del cambio"
git push
```
