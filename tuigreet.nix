{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --time-format '%H:%M  ·  %a %b %d' \
            --greeting "◈  cube" \
            --asterisks \
            --remember \
            --remember-session \
            --theme 'border=magenta;text=bright-white;prompt=cyan;time=magenta;action=bright-cyan;button=magenta;container=black;input=bright-white' \
            --width 72 \
            --container-padding 3 \
            --prompt-padding 1 \
            --cmd Hyprland
        '';
        user = "greeter";
      };
    };
  };

  # Suppress the login noise on tty1 (greetd owns it)
  systemd.services.greetd.serviceConfig = {
    StandardInput = "tty";
    StandardOutput = "tty";
    TTYPath = "/dev/tty1";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # tuigreet color env — matches the purple/dark theme
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
