{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        user = "greeter";
        command = ''
          ${pkgs.tuigreet}/bin/tuigreet \
            --time \
            --asterisks \
            --remember \
            --remember-user-session \
            --greeting "Password unlock" \
            --cmd Hyprland
        '';
      };
    };
  };

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
