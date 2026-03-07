{ config, pkgs, lib, ... }:

let
  terminal = "ghostty";
  launcher = "wofi --show drun";
  browser = "chromium";
  fileManager = "nautilus";
  mod = "SUPER";
in
{
  "$mod" = mod;
  "$terminal" = terminal;
  "$menu" = launcher;

  env = [
    "XCURSOR_SIZE,24"
    "HYPRCURSOR_SIZE,24"
    "QT_QPA_PLATFORM,wayland;xcb"
    "GDK_BACKEND,wayland,x11,*"
    "SDL_VIDEODRIVER,wayland"
    "CLUTTER_BACKEND,wayland"
    "XDG_CURRENT_DESKTOP,Hyprland"
    "XDG_SESSION_TYPE,wayland"
    "XDG_SESSION_DESKTOP,Hyprland"
  ];

  monitor = [
    ",preferred,auto,2.5"
  ];

  exec-once = [
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "mako"
    "nm-applet --indicator"
    "bash -lc 'WALL=\"$HOME/.config/wallpapers/main.png\"; if [ -f \"$WALL\" ]; then exec swaybg -i \"$WALL\" -m fill; else exec swaybg -c 0d1017; fi'"
  ];

  general = {
    gaps_in = 6;
    gaps_out = 14;
    border_size = 2;
    resize_on_border = true;
    allow_tearing = false;
    layout = "dwindle";
    "col.active_border" = "rgba(7c5cffee) rgba(42c7ffee) 45deg";
    "col.inactive_border" = "rgba(2a3447cc)";
  };

  decoration = {
    rounding = 16;
    active_opacity = 1.0;
    inactive_opacity = 0.95;
    fullscreen_opacity = 1.0;

    blur = {
      enabled = true;
      size = 8;
      passes = 3;
      new_optimizations = true;
      xray = false;
      noise = 0.02;
      contrast = 1.05;
      brightness = 1.0;
    };

    shadow = {
      enabled = true;
      range = 18;
      render_power = 3;
      color = "rgba(00000055)";
    };
  };

  animations = {
    enabled = true;
    bezier = [
      "easeOut, 0.22, 1, 0.36, 1"
      "smoothIn, 0.12, 0, 0.39, 0"
      "soft, 0.25, 0.9, 0.3, 1.0"
    ];
    animation = [
      "windows, 1, 6, easeOut, slide"
      "windowsIn, 1, 6, easeOut, slide"
      "windowsOut, 1, 5, smoothIn, slide"
      "border, 1, 8, soft"
      "fade, 1, 6, easeOut"
      "workspaces, 1, 6, easeOut, slidevert"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    vfr = true;
    mouse_move_enables_dpms = true;
    key_press_enables_dpms = true;
  };

  input = {
    kb_layout = "us";
    follow_mouse = 1;
    touchpad = {
      natural_scroll = false;
    };
    sensitivity = 0;
  };

  cursor = {
    no_hardware_cursors = false;
  };

  bind = [
    "$mod, RETURN, exec, $terminal"
    "$mod, SPACE, exec, $menu"
    "$mod, B, exec, ${browser}"
    "$mod, E, exec, ${fileManager}"
    "$mod SHIFT, L, exec, hyprlock"
    "$mod, Q, killactive"
    "$mod, F, fullscreen, 1"
    "$mod, V, togglefloating"
    "$mod, P, pseudo"
    "$mod, J, togglesplit"
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"
    "$mod SHIFT, left, movewindow, l"
    "$mod SHIFT, right, movewindow, r"
    "$mod SHIFT, up, movewindow, u"
    "$mod SHIFT, down, movewindow, d"
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod SHIFT, 1, movetoworkspace, 1"
    "$mod SHIFT, 2, movetoworkspace, 2"
    "$mod SHIFT, 3, movetoworkspace, 3"
    "$mod SHIFT, 4, movetoworkspace, 4"
    "$mod SHIFT, 5, movetoworkspace, 5"
    "$mod SHIFT, 6, movetoworkspace, 6"
    "$mod SHIFT, 7, movetoworkspace, 7"
    "$mod SHIFT, 8, movetoworkspace, 8"
    "$mod SHIFT, 9, movetoworkspace, 9"
    ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
    "$mod, Print, exec, mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"
  ];

  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  bindel = [
    ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
    ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
  ];

  windowrulev2 = [
    "float,class:^(pavucontrol)$"
    "float,class:^(nm-connection-editor)$"
    "size 980 700,class:^(pavucontrol)$"
  ];
}
