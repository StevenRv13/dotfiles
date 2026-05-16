# 🏴‍☠️ Steven's Dotfiles — Arch Linux + Hyprland

Setup personal basado en [ilyamiro/imperative-dots](https://github.com/ilyamiro/imperative-dots) con personalizaciones propias.

---

## 📸 Preview

> Hyprland + Kitty + Fastfetch con Luffy + tema naranja/gris

---

## 🖥️ Sistema

| Componente | Detalle |
|---|---|
| OS | Arch Linux |
| WM | Hyprland 0.55+ (Wayland) |
| Terminal | Kitty |
| Shell | Fish |
| Bar | Quickshell (incluida en el rice) |
| Fetch | Fastfetch con imagen personalizada |
| Launcher | incluido en el rice |
| Font | JetBrains Mono Nerd |

---

## ⚙️ Instalación desde cero

### 1. Instalar Arch Linux base con archinstall

```bash
archinstall
```

Perfil recomendado: **minimal** o **Hyprland** directo.

---

### 2. Instalar el rice base (ilyamiro)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ilyamiro/imperative-dots/master/install.sh)"
```

Durante la instalación:
- Activar **Configure SDDM Theme**
- Activar **Zsh Shell Setup**
- Activar **Download FULL Wallpaper Pack** (opcional)
- Configurar drivers **NVIDIA** si aplica
- Ingresar API key de OpenWeatherMap cuando se solicite

> La API key gratuita se obtiene en https://openweathermap.org/api

---

### 3. Instalar dependencias adicionales

```bash
sudo pacman -S zsh micro brightnessctl fastfetch v4l2loopback-dkms lazygit
yay -S spotify iriunwebcam-bin brave-bin antigravity
```

Instalar Spicetify:
```bash
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
echo 'export PATH=$PATH:~/.spicetify' >> ~/.zshrc
source ~/.zshrc
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R
spicetify backup apply
```

---

### 4. Aplicar dotfiles personalizados

```bash
git clone https://github.com/StevenRv13/dotfiles.git
cp -r dotfiles/hypr ~/.config/
cp -r dotfiles/kitty ~/.config/
cp -r dotfiles/fastfetch ~/.config/
cp -r dotfiles/fish ~/.config/
cp dotfiles/luffy.png ~/Pictures/
```

---

### 5. Configurar zona horaria y sincronización

```bash
sudo timedatectl set-timezone America/Costa_Rica
sudo systemctl enable --now systemd-timesyncd
```

---

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

---

### 7. Agregar Windows al GRUB (dual boot)

```bash
sudo pacman -S os-prober
sudo nano /etc/default/grub
# Descomentar: GRUB_DISABLE_OS_PROBER=false
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

---


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

---

## ⌨️ Keybinds principales

| Atajo | Acción |
|---|---|
| `Super + Enter` | Terminal (Kitty) |
| `Super + D` | Lanzador de apps |
| `Super + Q` | Cerrar ventana |
| `Super + F` | Firefox |
| `Super + E` | Gestor de archivos |
| `Super + W` | Cambiar wallpaper |
| `Super + S` | Calendario / Clima |
| `Super + N` | Red / WiFi |
| `Super + V` | Volumen |
| `Super + U` | Música |
| `Super + L` | Bloquear pantalla |
| `Super + H` | Guía de keybinds |
| `Super + 1-9` | Cambiar workspace |
| `Super + Shift + 1-9` | Mover ventana a workspace |
| `Print` | Captura de pantalla |

---

## 🎨 Personalización aplicada

- Colores naranja (`#ff6600`) en prompt, fetch y bordes de ventana
- Imagen de Luffy como logo en fastfetch
- Tema blanco/gris en widgets de Quickshell (`qs_colors.json`)
- Fondo de kitty `#1e1e1e` con opacidad `0.65`
- Carpetas en naranja via `LS_COLORS`
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
