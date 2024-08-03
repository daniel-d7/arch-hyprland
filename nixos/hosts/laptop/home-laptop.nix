{ inputs, pkgs, ... }:

let
  vars = import ../../variables.nix;
in

{
  imports = [
    ../../configs/home-configs/styling.nix
    ../../configs/home-configs/zsh.nix
    ../../configs/home-configs/kitty.nix
    ../../configs/home-configs/waybar.nix
    ./link-dotfiles-laptop.nix
    ./home-programs-laptop.nix
  ];

  home.username = vars.user1;
  home.homeDirectory = vars.homeDirectoryUser1;

  #broken?????    #services.gpg-agent = {
  #  enable = true;
  #  defaultCacheTtl = 1800;
  #  enableSshSupport = true;
  #};

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  xdg.desktopEntries."org.gnome.Settings" = {
    name = "Settings";
    comment = "Gnome Control Center";
    icon = "org.gnome.Settings";
    exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center --verbose";
    categories = [ "X-Preferences" ];
    terminal = true;
  };

  xdg.desktopEntries."com.RoccoRakete.ThemeSwitcher" = {
    name = "ThemeSwitcher";
    comment = "Dotfile ThemeSwitcher";
    icon = "org.gnome.Settings";
    exec = "/home/daniel/.local/bin/theme_switcher";
    categories = [ "X-Preferences" ];
    terminal = false;
  };

  xdg.desktopEntries."Betaflight Configurator 10.9.0" = {
    name = "Betaflight Configurator 10.9.0";
    comment = "Configurator FPV Flight Controllers";
    icon = "/home/daniel/.local/bin/BetaflightConfigurator10_9_0/icon/bf_icon_128.png";
    exec = "/home/daniel/.local/bin/betaflight-configurator";
    categories = [ "X-FPV" ];
    terminal = false;
  };

  xdg.desktopEntries."BlHeliSuite32" = {
    name = "BlHeliSuite32";
    comment = "Configurator for BlHeli32 ESC's";
    icon = "org.gnome.Settings";
    exec = "/home/daniel/.local/bin/blhelisuite32";
    categories = [ "X-FPV" ];
    terminal = false;
  };

  xdg.desktopEntries."ExpressLRS Configurator" = {
    name = "ExpressLRS Configurator";
    comment = "Configurator for ExpressLRS";
    icon = "expresslrs-configurator";
    exec = "/home/daniel/.local/bin/expresslrs-configurator";
    categories = [ "X-FPV" ];
    terminal = false;
  };

  #xdg.desktopEntries."SuperSlicer" = {
  #  name = "SuperSlicer";
  #  comment = "3D Print Slicer";
  #  icon = "SuperSlicer";
  #  exec = "/home/daniel/.local/bin/superslicer";
  #  categories = [ "X-FPV" ];
  #  terminal = false;
  #};

  home.file = { };
  home.sessionVariables = { };

  home.stateVersion = "23.11";
}
