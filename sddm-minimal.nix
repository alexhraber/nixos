{ config, pkgs, lib, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --time \
            --time-format '%I:%M %p  %a %b %d' \
            --greeting '' \
            --asterisks \
            --remember \
            --remember-session \
            --theme 'border=magenta;text=white;prompt=magenta;time=cyan;action=cyan;button=cyan;container=black;input=white' \
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
