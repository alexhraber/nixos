{ config, pkgs, lib, ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      min-free = 10737418240;
      max-free = 32212254720;
      keep-outputs = false;
      keep-derivations = false;
    };
  };

  services.journald.extraConfig = "SystemMaxUse=1G\nSystemKeepFree=8G\nRuntimeMaxUse=512M\nMaxRetentionSec=14day\nCompress=yes\n";

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };
}
