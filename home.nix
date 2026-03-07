{ config, pkgs, lib, ... }:

let
  waybar-cpu = pkgs.writeShellScriptBin "waybar-cpu" (builtins.readFile ./waybar/scripts/cpu.sh);
  waybar-mem = pkgs.writeShellScriptBin "waybar-mem" (builtins.readFile ./waybar/scripts/mem.sh);
  waybar-net = pkgs.writeShellScriptBin "waybar-net" (builtins.readFile ./waybar/scripts/net.sh);
in
{
  home.stateVersion = "25.11";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.packages = with pkgs; [
    ghostty
    chromium
    nautilus
    waybar
    wofi
    swaybg
    hyprlock
    hypridle
    wl-clipboard
    grim
    slurp
    playerctl
    pavucontrol
    networkmanagerapplet
    brightnessctl
    nwg-look
    yazi
    fastfetch
    lm_sensors
    jq
    waybar-cpu
    waybar-mem
    waybar-net
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "ghostty";
    BROWSER = "chromium";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    font = {
      name = "Source Code Pro";
      size = 12;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  fonts.fontconfig.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    settings = import ./hypr.nix { inherit config pkgs lib; };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;
    settings = [
      (builtins.fromJSON (builtins.readFile ./waybar/config.json))
    ];
    style = builtins.readFile ./waybar/style.css;
  };

  programs.wofi = {
    enable = true;
    style = builtins.readFile ./wofi/style.css;
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi.override { plugins = [ pkgs.rofi-calc ]; };
    terminal = "ghostty";
    theme = "~/.config/rofi/theme.rasi";
    extraConfig = {
      modi = "combi,drun,calc";
      combi-modi = "drun,calc";
      show-icons = true;
      icon-theme = "Adwaita";
      drun-display-format = "{name}";
      calc-command = "echo -n '{result}' | wl-copy";
      no-history = true;
      display-combi = "";
      display-drun = " Apps";
      display-calc = " Calc";
    };
  };

  xdg.configFile."rofi/theme.rasi".text = ''
    * {
      bg:      rgba(17,21,29,0.96);
      bg-alt:  rgba(30,38,54,0.98);
      border:  rgba(42,52,71,1);
      accent:  rgba(124,92,255,1);
      accent2: rgba(66,199,255,1);
      fg:      rgba(230,237,247,1);
      fg-dim:  rgba(148,163,184,1);
      urgent:  rgba(255,107,129,1);
      background-color: transparent;
      text-color: @fg;
      font: "Source Code Pro 14";
    }

    window {
      background-color: @bg;
      border: 2px;
      border-color: @border;
      border-radius: 16px;
      width: 640px;
      padding: 12px;
    }

    mainbox {
      spacing: 8px;
    }

    inputbar {
      background-color: @bg-alt;
      border: 1px;
      border-color: @border;
      border-radius: 10px;
      padding: 10px 14px;
      spacing: 8px;
      children: [prompt, entry];
    }

    prompt {
      text-color: @accent;
    }

    entry {
      placeholder: "search apps or calculate...";
      placeholder-color: @fg-dim;
    }

    listview {
      lines: 8;
      spacing: 4px;
      scrollbar: false;
    }

    element {
      border-radius: 8px;
      padding: 8px 12px;
      spacing: 10px;
      children: [element-icon, element-text];
    }

    element normal.normal {
      background-color: transparent;
    }

    element selected.normal {
      background-color: rgba(124,92,255,0.18);
    }

    element-icon {
      size: 22px;
    }

    element-text {
      vertical-align: 0.5;
    }

    element-text selected {
      text-color: @fg;
    }

    message {
      background-color: @bg-alt;
      border: 1px;
      border-color: @border;
      border-radius: 8px;
      padding: 8px 12px;
    }
  '';

  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      font-family = "Source Code Pro";
      font-size = 16;

      background = "0d1017";
      foreground = "e6edf7";

      cursor-color = "7c5cff";
      selection-background = "24324a";
      selection-foreground = "f5f7ff";

      palette = [
        "0=#11151d"
        "1=#ff6b81"
        "2=#5ee6a8"
        "3=#ffd166"
        "4=#42c7ff"
        "5=#7c5cff"
        "6=#4ce0d2"
        "7=#c9d7e7"
        "8=#3a4658"
        "9=#ff8fa3"
        "10=#7ef0ba"
        "11=#ffe08a"
        "12=#74d7ff"
        "13=#9a7bff"
        "14=#7ceee3"
        "15=#ffffff"
      ];

      background-opacity = 0.94;
      window-padding-x = 12;
      window-padding-y = 12;

      cursor-style = "bar";
      gtk-titlebar = false;
      confirm-close-surface = false;
      copy-on-select = "clipboard";
    };
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = true;

      format = ''
        [╭─](bold #3a4658)$username$hostname$directory$git_branch$git_status$rust$golang$nodejs$python$nix_shell$cmd_duration
        [╰─](bold #3a4658)$character
      '';

      right_format = "$time";

      character = {
        success_symbol = "[󱞩](bold #7c5cff) ";
        error_symbol = "[󱞩](bold #ff6b81) ";
        vimcmd_symbol = "[󱞩](bold #5ee6a8) ";
      };

      username = {
        show_always = true;
        style_user = "bold #cba6f7";
        format = "[ $user](#cba6f7)";
      };

      hostname = {
        ssh_only = false;
        style = "bold #94e2d5";
        format = "[@$hostname](#94e2d5) ";
      };

      directory = {
        style = "bold #42c7ff";
        truncation_length = 3;
        truncate_to_repo = true;
        read_only = " 󰌾";
        format = "[in](dimmed #94a3b8) [$path]($style)[$read_only](#ff6b81) ";
      };

      git_branch = {
        symbol = " ";
        style = "bold #7c5cff";
        format = "[on](dimmed #94a3b8) [$symbol$branch]($style) ";
      };

      git_status = {
        style = "bold #ffd166";
        format = "([$all_status$ahead_behind]($style) )";
        conflicted = "󰞇 ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "󰄬 ";
        untracked = "?\${count}";
        stashed = "*\${count}";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»\${count}";
        deleted = "✘\${count}";
      };

      rust = {
        symbol = " ";
        style = "bold #f38ba8";
        format = "[via](dimmed #94a3b8) [$symbol$version]($style) ";
      };

      golang = {
        symbol = " ";
        style = "bold #8bd5ff";
        format = "[via](dimmed #94a3b8) [$symbol$version]($style) ";
      };

      nodejs = {
        symbol = " ";
        style = "bold #5ee6a8";
        format = "[via](dimmed #94a3b8) [$symbol$version]($style) ";
      };

      python = {
        symbol = " ";
        style = "bold #ffd166";
        format = "[via](dimmed #94a3b8) [$symbol$version]($style) ";
      };

      nix_shell = {
        symbol = " ";
        style = "bold #7dcfff";
        format = "[in](dimmed #94a3b8) [$symbol$state( $name)]($style) ";
        impure_msg = "[impure](bold #ff6b81)";
        pure_msg = "[pure](bold #5ee6a8)";
        unknown_msg = "[shell](bold #7dcfff)";
      };

      cmd_duration = {
        min_time = 500;
        style = "dimmed #94a3b8";
        format = "[took $duration]($style) ";
      };

      time = {
        disabled = false;
        time_format = "%H:%M";
        style = "dimmed #6b7280";
        format = "[$time]($style)";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    options = [ "--cmd" "z" ];
  };

  programs.nushell = {
    enable = true;
    extraConfig = ''
      $env.PKG_CONFIG_PATH = "${pkgs.sqlite.dev}/lib/pkgconfig"
      $env.LIBRARY_PATH = "${pkgs.sqlite.out}/lib"
      $env.PATH = ($env.PATH | append $"($env.HOME)/.cargo/bin")
      $env.config.show_banner = false
      source /etc/nixos/nushell/custom.nu
      source /etc/nixos/nushell/overlay.nu
    '';
  };

  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "source": "nixos_small",
        "padding": {
          "top": 1,
          "left": 2,
          "right": 3
        }
      },
      "display": {
        "separator": "  "
      },
      "modules": [
        "break",
        {
          "type": "title",
          "key": "",
          "format": "{##cba6f7}{user-name}{##94e2d5}@{##42c7ff}{host-name}{#}"
        },
        {
          "type": "custom",
          "format": "{##3a4658}────────────────────────────────────────{#}"
        },
        {
          "type": "os",
          "key": ""
        },
        {
          "type": "host",
          "key": "󰌢"
        },
        {
          "type": "kernel",
          "key": ""
        },
        {
          "type": "uptime",
          "key": "󰅐"
        },
        {
          "type": "packages",
          "key": "󰏖"
        },
        {
          "type": "shell",
          "key": ""
        },
        {
          "type": "terminal",
          "key": ""
        },
        {
          "type": "wm",
          "key": "󱂬"
        },
        {
          "type": "theme",
          "key": "󰉼"
        },
        {
          "type": "icons",
          "key": "󰀻"
        },
        {
          "type": "cursor",
          "key": "󰇀"
        },
        {
          "type": "cpu",
          "key": "󰍛"
        },
        {
          "type": "gpu",
          "key": "󰢮"
        },
        {
          "type": "memory",
          "key": "󰑭"
        },
        {
          "type": "disk",
          "key": "󰋊"
        },
        {
          "type": "localip",
          "key": "󰩟"
        },
        {
          "type": "break"
        },
        {
          "type": "colors",
          "paddingLeft": 2,
          "symbol": "circle"
        },
        {
          "type": "custom",
          "format": "  {##6b7280}NixOS • Hyprland • Ghostty • Nushell{#}"
        }
      ]
    }
  '';

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "Default";
      theme_background = false;
      truecolor = true;
      force_tty = false;
      graph_symbol = "braille";
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_gradient = true;
      proc_per_core = true;
      cpu_graph_upper = "total";
      cpu_graph_lower = "user";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      mem_graphs = true;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      net_download = 100;
      net_upload = 100;
      net_auto = true;
      net_sync = false;
      # Preset 0: CPU Monster — big cpu + cores + proc by cpu, hide mem/net/disk
      preset_0 = "cpu_single:false cpu_bottom:false show_cpu:true show_corebox:true show_mem:false show_net:false show_disks:false show_io_stat:false show_gpu:false show_proc:true proc_sorting:cpu lazy proc_per_core:true";
      # Preset 1: Memory Monster — mem + disks + proc by mem, hide cpu/net
      preset_1 = "cpu_single:false cpu_bottom:false show_cpu:false show_corebox:false show_mem:true show_net:false show_disks:true show_io_stat:true show_gpu:false show_proc:true proc_sorting:mem proc_mem_bytes:true";
    };
  };

  services.swaync.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.0117;
          contrast = 1.05;
          brightness = 0.95;
          vibrancy = 0.18;
          vibrancy_darkness = 0.2;
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "rgba(230,237,247,1.0)";
          font_size = 72;
          font_family = "Source Code Pro";
          position = "0, 140";
          halign = "center";
          valign = "center";
        }
        {
          text = "cmd[update:1000] echo \"$(date +'%A, %B %d')\"";
          color = "rgba(148,163,184,1.0)";
          font_size = 20;
          font_family = "Source Code Pro";
          position = "0, 78";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = { width = 580; height = 80; };
          position = "0, -60";
          halign = "center";
          valign = "center";

          outline_thickness = 3;
          inner_color = "rgba(13,16,23,0.9)";
          outer_color = "rgba(124,92,255,0.9)";
          check_color = "rgba(66,199,255,0.9)";
          fail_color = "rgba(255,107,129,0.9)";

          font_family = "Source Code Pro";
          font_color = "rgba(230,237,247,1.0)";
          font_size = 18;

          placeholder_text = "password";
          fail_text = "<i>$FAIL</i>  [$ATTEMPTS]";

          rounding = 12;
          shadow_passes = 2;
          shadow_size = 6;
          fade_on_empty = false;
          dots_spacing = 0.25;
          dots_center = true;
        }
      ];
    };
  };
}
