{pkgs, ...}: let
  p = pkgs.vimPlugins;

  # Treesitter with all grammars pre-built by Nix (parsers are NOT compiled at
  # runtime; LazyVim's treesitter spec is overridden below to not auto-install).
  treesitter = p.nvim-treesitter.withAllGrammars;

  # Base LazyVim plugin set + the default "core extras" (snacks picker/explorer
  # and blink.cmp completion). Each is linked under its lazy.nvim short-name,
  # which equals the nixpkgs `pname` for everything except catppuccin.
  mkLink = drv: {
    name = drv.pname;
    path = drv;
  };

  basePlugins = [
    p.LazyVim
    p.snacks-nvim
    p.tokyonight-nvim
    p.bufferline-nvim
    p.lualine-nvim
    p.noice-nvim
    p.nui-nvim
    p.mini-ai
    p.mini-icons
    p.mini-pairs
    p.which-key-nvim
    p.flash-nvim
    p.gitsigns-nvim
    p.trouble-nvim
    p.todo-comments-nvim
    p.grug-far-nvim
    p.persistence-nvim
    p.lazydev-nvim
    p.ts-comments-nvim
    p.nvim-ts-autotag
    p.plenary-nvim
    p.nvim-web-devicons
    p.nvim-lspconfig
    p.conform-nvim
    p.nvim-lint
    p.nvim-treesitter-textobjects
    # completion (default core extra: coding.blink)
    p.blink-cmp
    p.blink-compat
    p.friendly-snippets
  ];

  # Directory of plugins for lazy.nvim's `dev.path`. Entry names must match the
  # last path segment of each plugin's GitHub "owner/repo" spec.
  lazyPath = pkgs.linkFarm "lazyvim-plugins" (
    (map mkLink basePlugins)
    ++ [
      {
        name = "nvim-treesitter";
        path = treesitter;
      }
      {
        # catppuccin/nvim -> short name "nvim" (pname is "catppuccin-nvim")
        name = "nvim";
        path = p.catppuccin-nvim;
      }
    ]
  );
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Let lazy.nvim manage the runtimepath; don't also load plugins via
    # home-manager (that would conflict with lazy).
    initLua = ''
      -- Leader must be set before lazy.nvim loads.
      vim.g.mapleader = " "
      vim.g.maplocalleader = "\\"

      -- Bootstrap lazy.nvim from the Nix store.
      vim.opt.rtp:prepend("${p.lazy-nvim}")

      require("lazy").setup({
        -- Use ONLY Nix-provided plugins; never fetch from the internet.
        dev = {
          path = "${lazyPath}",
          patterns = { "" }, -- treat every plugin as a local "dev" plugin
          fallback = false,
        },
        install = { missing = false },
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },

          -- mason downloads binaries at runtime and cannot work on Nix.
          -- LSP servers/formatters come from programs.neovim.extraPackages.
          { "mason-org/mason.nvim", enabled = false },
          { "mason-org/mason-lspconfig.nvim", enabled = false },
          { "williamboman/mason.nvim", enabled = false },
          { "williamboman/mason-lspconfig.nvim", enabled = false },

          -- Grammars are provided by Nix (withAllGrammars); don't auto-install.
          {
            "nvim-treesitter/nvim-treesitter",
            opts = { ensure_installed = {}, auto_install = false },
          },
        },
        -- Quiet the update checker; updates happen via `nix flake update`.
        checker = { enabled = false },
        change_detection = { enabled = false },
      })
    '';

    extraPackages = with pkgs; [
      cargo
      delve
      docker-compose-language-service
      dockerfile-language-server
      gcc
      goimports-reviser
      gopls
      puppet
      deno
      gotools
      hadolint
      lua-language-server
      marksman
      typescript-language-server
      shfmt
      terraform-ls
      yaml-language-server
      yamllint
    ];
  };
}
