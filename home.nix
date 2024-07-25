{ pkgs, user, stylix, nix-colors, ... }:

{
  # Home Manager modules.
  imports = [
    stylix.homeManagerModules.stylix
    ./home
  ];

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    # User packages.
    packages = with pkgs; [
      # Terminal.
      foot
      tmux
      lf
      fzf
      eza
      fastfetch
      brightnessctl
      gnumake

      # Video/Audio.
      pulseaudio
      pavucontrol
      vlc

      # File management.
      unzip
      unrar
      xfce.thunar

      # Hyprland customization / Wayland utils.
      rofi-wayland
      waybar # Old bar.
      #ags # New bar.
      hyprpaper
      hyprpicker
      wlogout
      dunst
      libnotify			# Dependency for dunst.
      networkmanagerapplet
      wl-clipboard
      
      # Other apps.
      firefox
      
      # Programming.
      gcc
      zig_0_12
      jdk22
      python3
      ripgrep
      fd
    ];
  };

  programs = {
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        TERM = "kitty";
        BROWSER = "firefox";
      };
      shellAliases = {
        rebuild = "sudo nixos-rebuild switch --flake ~/.setup#laptop";
        vim = "nvim";
        ls = "eza";
        ll = "eza --group --header --group-directories-first --all --long";
        lt = "eza --tree --level 3";
        fz = "fzf --preview='cat {}'";
        fv = "nvim $(fzf --preview='cat {}')";
        cd = "z ";
        sudo = "sudo ";
      };
    };

    starship = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };
  };

  # Allow proprietary software.
  nixpkgs.config.allowUnfree = true;
  
  # Theming
  home.pointerCursor = {
    gtk.enable = true;
#    package = pkgs.bibata-cursors;
#    name = "Bibata-Original-Classic";
#    size = 16;
  };
  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.gruvbox-plus-icons;
      name = "Gruvbox-Plus-Dark";
    };
#    theme = {
#      package = pkgs.gruvbox-gtk-theme;
#      name = "Gruvbox-Dark";
#    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk2";
    style = {
      name = "gtk2";
    };
  };

  # Theme.
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpaper.png;
    polarity = "dark";
    base16Scheme = nix-colors.colorSchemes.gruvbox-material-dark-medium;
    cursor.package = pkgs.phinger-cursors;
    cursor.name = "phinger-cursors-light";
    cursor.size = 24;
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
      	name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
	      name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
	      name = "JetBrainsMono NF";
      };
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";
}

