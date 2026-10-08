# Solución de problemas de Hyprland

## Kitty ocupa toda la pantalla al abrirse

### Síntoma

Al abrir Kitty mientras otra aplicación está visible, la terminal ocupa toda el área del workspace. El comportamiento esperado es el mosaico normal de Hyprland: la aplicación existente y Kitty deben repartirse la pantalla, aproximadamente a la mitad.

No debe corregirse haciendo que Kitty sea flotante. Tampoco es necesariamente el modo fullscreen de Kitty: primero hay que revisar el estado que Hyprland registra para la ventana.

### Diagnóstico

Comprobar la ventana activa:

```bash
hyprctl activewindow -j | jq '{class,title,fullscreen,fullscreenClient,floating,workspace,size,at}'
```

Comprobar todas las ventanas y sus workspaces:

```bash
hyprctl clients -j | jq '.[] | {class,title,fullscreen,fullscreenClient,floating,workspace,size,at}'
```

Para Kitty, el estado correcto es:

- `class`: `kitty`
- `floating`: `false`
- `fullscreen`: `0`
- En el mismo workspace que la otra aplicación

### Causa y corrección permanente

Kitty puede emitir solicitudes de maximización o fullscreen. La regla guardada en `hypr/config/settings.lua` obliga a mantenerla en el mosaico normal e ignora esas solicitudes:

```lua
hl.window_rule({
  name = "kitty-tiled-terminal",
  match = { class = "^kitty$" },

  tile = true,
  suppress_event = "maximize fullscreen",
})
```

Aplicar la configuración y revisar errores:

```bash
hyprctl reload
hyprctl configerrors
```

Después, cerrar las ventanas de Kitty que ya estaban abiertas y abrir una nueva. Las reglas estáticas se aplican al crear la ventana.

### Verificación

Con otra aplicación abierta en el mismo workspace, abrir Kitty con `Super + Enter` y ejecutar:

```bash
hyprctl activewindow -j | jq '{class,floating,fullscreen,size,workspace}'
```

En una pantalla de 1920 píxeles de ancho, Kitty debería medir cerca de 950 píxeles, dependiendo de los gaps configurados. Si aparece en otro workspace, comprobar primero que ambos programas se abrieron en el mismo workspace; eso es un problema distinto de maximización.
