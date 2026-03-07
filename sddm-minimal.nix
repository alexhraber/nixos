{ config, pkgs, lib, ... }:

{
  services.displayManager.defaultSession = "hyprland";

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "breeze";

    settings = {
      General = {
        DisplayServer = "wayland";
        GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=1.5,QT_FONT_DPI=144";
        InputMethod = "";
      };

      Theme = {
        Current = "breeze";
        CursorTheme = "Bibata-Modern-Ice";
        CursorSize = 24;
        Font = "Source Code Pro,12,-1,5,50,0,0,0,0,0";
      };

      Users = {
        RememberLastUser = true;
        RememberLastSession = true;
        HideShells = "/run/current-system/sw/bin/nologin";
        MinimumUid = 1000;
        MaximumUid = 60000;
      };
    };
  };
}
