{ lib, pkgs, nixvim, ... }:

{
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    # Disable base16 from stylix.
    colorschemes.base16.enable = lib.mkForce false;

    plugins = {
      # Nixvim plugins.
      telescope.enable = true;
      treesitter.enable = true;
      lualine.enable = true;
      oil.enable = true;
      indent-blankline.enable = true;

      # Lsp servers.
      lsp = {
        enable = true;
	      servers = {
          nixd.enable = true;
	        zls.enable = true;
	        lua-ls.enable = true;
          java-language-server.enable = true;
	      };
      };

      # Completions.
      cmp = {
        enable = true;
	      settings = {
          autoEnableSources = true;
          sources = [
            { name = "nvim_lsp"; }
            { name = "buffer"; }
            { name = "path"; }
          ];
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp-cmdline.enable = true;
    };

    # Nixpkgs plugins.
    extraPlugins = with pkgs.vimPlugins; [
      gruvbox-nvim
      {
        plugin = gruvbox-material-nvim;
	      config = ''colorscheme gruvbox-material'';
      }
    ];

    # Options.
    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      autoindent = true;
      smartindent = true;
      number = true;
      scrolloff = 999;
      cursorline = true;
      cursorlineopt = "number";
    };
    
    # Auto commands.
    autoCmd = [
#      {
#       event = [ "BufEnter" "BufWinEnter" ];
#       pattern = [ "*.nix" ];
#	      command = "colorscheme gruvbox";
#      }
    ];
  };
}
