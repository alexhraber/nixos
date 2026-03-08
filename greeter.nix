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
            --theme 'text=white;time=darkgray;container=black;border=darkgray;title=white;greet=lightgray;prompt=blue;input=white;action=darkgray;button=blue' \
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
