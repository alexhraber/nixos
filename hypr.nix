{ config, pkgs, lib, ... }:

let
  terminal = "ghostty";
  launcher = "anyrun";
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
    "dbus-update-activation-environment --systemd --all"
    "systemctl --user import-environment HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0"
    "swaync"
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
      "easeOutQuint, 0.23, 1, 0.32, 1"
      "smoothIn, 0.12, 0, 0.39, 0"
      "almostLinear, 0.5, 0.5, 0.75, 1.0"
      "quick, 0.15, 0, 0.1, 1"
    ];
    animation = [
      "windows, 1, 5, easeOutQuint, popin 85%"
      "windowsIn, 1, 4, easeOutQuint, popin 87%"
      "windowsOut, 1, 2, smoothIn, popin 87%"
      "border, 1, 6, easeOut"
      "fade, 1, 3, quick"
      "fadeIn, 1, 2, almostLinear"
      "fadeOut, 1, 2, almostLinear"
      "layers, 1, 4, easeOutQuint"
      "layersIn, 1, 4, easeOutQuint, fade"
      "layersOut, 1, 2, smoothIn, fade"
      "workspaces, 1, 5, easeOutQuint, slidevert"
    ];
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
    force_split = 2;
  };

  group = {
    "col.border_active" = "rgba(7c5cffee) rgba(42c7ffee) 45deg";
    "col.border_inactive" = "rgba(2a3447cc)";
    groupbar = {
      font_family = "Source Code Pro";
      font_size = 11;
      height = 22;
      gaps_in = 4;
      gradients = true;
      "col.active" = "rgba(124,92,255,0.45)";
      "col.inactive" = "rgba(42,52,71,0.25)";
      text_color = "rgba(230,237,247,1.0)";
      text_color_inactive = "rgba(148,163,184,0.7)";
    };
  };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    vfr = true;
    mouse_move_enables_dpms = true;
    key_press_enables_dpms = true;
    focus_on_activate = true;
    new_window_takes_over_fullscreen = 1;
    anr_missed_pings = 3;
  };

  input = {
    kb_layout = "us";
    kb_options = "compose:caps";
    repeat_rate = 40;
    repeat_delay = 600;
    numlock_by_default = true;
    follow_mouse = 1;
    touchpad = {
      natural_scroll = false;
      scroll_factor = 0.4;
    };
    sensitivity = 0;
  };

  cursor = {
    no_hardware_cursors = false;
    hide_on_key_press = true;
  };

  bind = [
    # Apps
    "$mod, RETURN, exec, $terminal"
    "$mod, SPACE, exec, $menu"
    "$mod, B, exec, ${browser}"
    "$mod, E, exec, ${fileManager}"
    "$mod, L, exec, hyprlock"
    "$mod SHIFT, T, exec, ${terminal} -e btop"

    # Window management
    "$mod, Q, killactive"
    "$mod, F, fullscreen, 0"
    "$mod ALT, F, fullscreen, 1"
    "$mod, V, togglefloating"
    "$mod, P, pseudo"
    "$mod, J, togglesplit"

    # Focus
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"

    # Move windows
    "$mod SHIFT, left, movewindow, l"
    "$mod SHIFT, right, movewindow, r"
    "$mod SHIFT, up, movewindow, u"
    "$mod SHIFT, down, movewindow, d"

    # Resize windows
    "$mod, minus, resizeactive, -80 0"
    "$mod, equal, resizeactive, 80 0"
    "$mod SHIFT, minus, resizeactive, 0 -80"
    "$mod SHIFT, equal, resizeactive, 0 80"

    # Workspaces
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

    # Workspace cycling
    "$mod, TAB, workspace, e+1"
    "$mod SHIFT, TAB, workspace, e-1"
    "$mod CTRL, TAB, workspace, previous"
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"

    # Window cycling (ALT+TAB within workspace)
    "ALT, TAB, cyclenext"
    "ALT, TAB, bringactivetotop"
    "ALT SHIFT, TAB, cyclenext, prev"
    "ALT SHIFT, TAB, bringactivetotop"

    # Scratchpad
    "$mod, S, togglespecialworkspace, scratchpad"
    "$mod ALT, S, movetoworkspacesilent, special:scratchpad"

    # Window groups
    "$mod, G, togglegroup"
    "$mod ALT, G, moveoutofgroup"
    "$mod ALT, left, moveintogroup, l"
    "$mod ALT, right, moveintogroup, r"
    "$mod ALT, up, moveintogroup, u"
    "$mod ALT, down, moveintogroup, d"
    "$mod ALT, TAB, changegroupactive, f"
    "$mod ALT SHIFT, TAB, changegroupactive, b"

    # Screenshots
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
    "suppressevent maximize, class:.*"
    "nofocus, class:^$, title:^$, xwayland:1, floating:1, fullscreen:0, pinned:0"
    "scrolltouchpad 0.2, class:^com.mitchellh.ghostty$"
  ];
}
