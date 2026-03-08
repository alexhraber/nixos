{ pkgs, ... }:

let
  regreetCss = ''
    * {
      font-family: "Orbitron";
      font-size: 14px;
      color: #e8f6ff;
    }

    window {
      background-color: #040814;
      background-image:
        radial-gradient(circle at top left, rgba(107, 227, 255, 0.18), transparent 28%),
        radial-gradient(circle at top right, rgba(123, 92, 255, 0.18), transparent 26%),
        linear-gradient(160deg, #030712 0%, #081120 45%, #02040a 100%);
    }

    box {
      background-color: transparent;
    }

    entry,
    button,
    combobox,
    row {
      min-height: 46px;
      border-radius: 22px;
      border: 1px solid rgba(122, 213, 255, 0.30);
      background-color: rgba(6, 16, 30, 0.82);
      background-image: linear-gradient(180deg, rgba(28, 59, 95, 0.40), rgba(4, 11, 22, 0.88));
      box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.06),
        0 0 24px rgba(71, 181, 255, 0.08);
    }

    entry,
    button {
      padding-left: 18px;
      padding-right: 18px;
    }

    entry:focus,
    button:focus,
    combobox:focus,
    row:selected {
      border-color: rgba(127, 230, 255, 0.72);
      box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.10),
        0 0 0 1px rgba(127, 230, 255, 0.30),
        0 0 28px rgba(71, 181, 255, 0.22);
    }

    button {
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 0.14em;
      text-transform: uppercase;
    }

    button:hover {
      background-image: linear-gradient(180deg, rgba(46, 94, 145, 0.56), rgba(6, 18, 35, 0.92));
      border-color: rgba(127, 230, 255, 0.52);
    }

    label {
      color: #cfe7ff;
      letter-spacing: 0.12em;
    }

    headerbar,
    .titlebar,
    separator {
      opacity: 0;
      min-height: 0;
      min-width: 0;
      margin: 0;
      padding: 0;
      border: 0;
      background: transparent;
    }
  '';
in
{
  programs.regreet = {
    enable = true;
    cageArgs = [ "-s" "-m" "last" ];
    font = {
      package = pkgs.orbitron;
      name = "Orbitron";
      size = 13;
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
    };
    extraCss = regreetCss;
  };

  services.greetd = {
    enable = true;
    settings.default_session.user = "greeter";
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

  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
