{ pkgs, ... }:

let
  inherit (pkgs) nixos-icons;
  vars = import ./variables.nix;
in

{
  #environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.FLAKE = "/home/${vars.user1}/.dotfiles/nixos/";
  environment = {
    variables = { };
    pathsToLink = [
      "/share/zsh"
    ];
  };

  environment.sessionVariables = rec {
     # XDG_STATE_HOME = "$HOME/.local/state";
     # XDG_CURRENT_DESKTOP = "GNOME";
      # Not officially in the specification
      # XDG_BIN_HOME    = "$HOME/.local/bin";
      # PATH = [ 
      # "${XDG_BIN_HOME}"
      # ];
      };

    nix = {
      optimise.automatic = true;

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      settings = {
        builders-use-substitutes = true;
        substituters = [
          "https://hyprland.cachix.org"
          "https://anyrun.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        ];
        experimental-features = "nix-command flakes";
        auto-optimise-store = true;
      };
    };

    nixpkgs.overlays = [
      (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (
            python-final: python-prev: {
              catppuccin = python-prev.catppuccin.overridePythonAttrs (oldAttrs: rec {
                version = "1.3.2";

                src = prev.fetchFromGitHub {
                  owner = "catppuccin";
                  repo = "python";
                  rev = "refs/tags/v${version}";
                  hash = "sha256-spPZdQ+x3isyeBXZ/J2QE6zNhyHRfyRQGiHreuXzzik=";
                };

                # can be removed next version
                disabledTestPaths = [
                  "tests/test_flavour.py" # would download a json to check correctness of flavours
                ];
              });
            }
          )
        ];
      })
    ];

    # Bootloader.
    boot = {
      initrd.systemd.enable = true;
      tmp.cleanOnBoot = true;
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [ "quiet" "nosgx" ];

      loader = {
        timeout = 0;
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      plymouth = {
        enable = true;
        theme = "bgrt";
        logo = "${nixos-icons}/share/icons/hicolor/48x48/apps/nix-snowflake-white.png";
      };
    };

    # Set your time zone.
    time.timeZone = "Europe/Berlin";

    # Locale Settings
    i18n = {
      extraLocaleSettings = {
        defaultLocale = "de_DE.UTF-8";
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };

    # Configure console(tty)
    console.keyMap = "de";
    #console.font = "ter-v32b";
    #console.packages = with pkgs; [ terminus_font ];

    hardware = {
      pulseaudio.enable = true;
    };

    # virtualisation
    virtualisation = {
      podman.enable = true;
      libvirtd.enable = true;
    };

    security.pam.services.swaylock = { };
    security.pam.services.gtklock = { };
    security.pam.services.hyprlock = { };
    security.polkit.enable = true;

    # Enable sound with pipewire.
    #sound.enable = true;
    security.rtkit.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
      defaultUserShell = pkgs.zsh;
      users.${vars.user1} = {
        isNormalUser = true;
        description = "daniel";
        extraGroups = [ "video" "input" "networkmanager" "wheel" "dialout" "libvirtd" ];
      };
    };

    xdg.portal.enable = true;

    system.activationScripts.script.text = ''
      cp /home/${vars.user1}/face.png /var/lib/AccountsService/icons/${vars.user1}
    '';

    # Installed Fonts
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "Ubuntu"
            "UbuntuMono"
            "Hermit"
          ];
        })
      ];
    };

    system.stateVersion = "23.05";
  }
