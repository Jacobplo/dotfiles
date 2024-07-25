{ pkgs, inputs, user, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;

  # Enable NTFS support and shared partition.
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems. "/media/Shared" = {
    device = "/dev/nvme0n1p5";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=1000" ];
  };

  # Display manager.
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
  };
  
  # Networking.
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone and internationalization.
  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Required for input devices.
  services = {
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
    libinput = {
      enable = true;
      touchpad.tapping = false;
      touchpad.naturalScrolling = true;
    };
  };
  
  # Sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # OpenGL
  hardware.graphics.enable = true;

  services.flatpak.enable = true;
 
  # Required for flatpak.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.power-profiles-daemon.enable = true;

  # Fonts.
  fonts.packages = with pkgs; [
    noto-fonts
    font-awesome
    (nerdfonts.override { 
      fonts = [ 
        "JetBrainsMono" 
       ]; 
    })
  ];
  fonts.fontconfig = {
    defaultFonts =  {
    	serif = [ "Noto Serif" ];
    	sansSerif = [ "Noto Sans" ];
    	monospace = [ "JetBrainsMono NF" ];
    };
  };

  # System user.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  # User does not need to give password when using sudo.
  security = {
    sudo.wheelNeedsPassword = false;
  };

  # Allow proprietary software.
  nixpkgs.config.allowUnfree = true;

  # Nix Package Manager settings.
  nix = {
    # Optimize Syslinks
    settings = {
      auto-optimise-store = true;
    };

#    # Automatic garbage collection.
#    gc = {
#      automatic = true;
#      dates = "weekly";
#      options = "--delete-older-than 7d";
#    };

    # Enable nixFlakes on system.
    package = pkgs.nixFlakes;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  environment = {
    variables = {
      TERMINAL = "wezterm";
      EDITOR = "nvim";
      VISUAL = "nvim";
      LLDB_USE_NATIVE_PDB_READER = "yes";
    };

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    # Default packages install system-wide.
    systemPackages = with pkgs; [
      git
      killall
      usbutils
      pciutils
      alsa-utils
      wget
      kitty
      vim
      nix-prefetch
      nix-prefetch-git
      nix-prefetch-github

      # Sddm theme dependency.
      libsForQt5.qt5.qtgraphicaleffects
      
      # Overlay packages.
      ags
    ];
  };

  # Default programs install system-wide.
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    zsh = {
      enable = true;
#      syntaxHighlighting.enable = true;
#      autosuggestions.enable = true;
    };

#    starship = {
#      enable = true;
#      presets = [ "nerd-font-symbols" ];
#    };
  };
  
  # Overlays.
  nixpkgs.overlays = [
    (final: prev:
    {
      ags = prev.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
    })
  ];

  system.stateVersion = "24.05";
}
