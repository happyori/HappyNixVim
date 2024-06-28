{ inputs, lib, pkgs, system, config, ... }:
let
  inherit (config.happy) mkKeymap;
  currentHostname =
    if builtins.pathExists /etc/hostname then
      (builtins.replaceStrings [ "\n" ] [ "" ] (builtins.readFile /etc/hostname))
    else "happypc";
in
{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd = {
        enable = true;
        package = inputs.nixd.packages.${system}.nixd;
        settings = {
          options = {
            nixvim.expr = ''(builtins.getFlake "github:happyori/HappyNixVim").packages.${system}.nvim.options'';
            nixos.expr = ''(builtins.getFlake "/home/happy/.config/nixos").nixosConfigurations.${currentHostname}.options'';
          };
        };
      };
      lua-ls = { enable = true; };
      dockerls = { enable = true; };
      jsonls = { enable = true; };
      nushell = { enable = true; };
      rust-analyzer = {
        enable = false;
        installCargo = true;
        installRustc = true;
      };
      yamlls = { enable = true; };
      eslint = {
        enable = true;
        settings = {
          workingDirectories = { mode = "auto"; };
        };
      };
      tailwindcss = { enable = true; settings = { filetypes_exclude = [ "markdown" ]; }; };
      gopls = { enable = true; };
    };
    inlayHints = true;
    capabilities = /* lua */ ''
      vim.tbl_deep_extend("force", capabilities, {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      })
    '';
    keymaps =
      let
        keymap' = mapList:
          let
            inherit (lib) elemAt length;
            key = elemAt mapList 0;
            action = elemAt mapList 1;
            options = { desc = elemAt mapList 2; };
            lua = if length mapList > 3 then elemAt mapList 3 else false;
          in
          { inherit key action options lua; mode = "n"; };
        telescope_builtin = func: "function() require('telescope.builtin').${func}({ reuse_win = true }) end";
      in
      {
        diagnostic = {
          "<leader>x[" = "goto_prev";
          "<leader>x]" = "goto_next";
        };
        lspBuf = {
          "K" = "hover";
        };
        extra = [
          (keymap' [ "<leader>clx" "<cmd>LspStop<cr>" "Stop LSP" ])
          (keymap' [ "<leader>cls" "<cmd>LspStart<cr>" "Start LSP" ])
          (keymap' [ "gd" (telescope_builtin "lsp_definitions") "Show definitions" true ])
          (keymap' [ "gr" "<cmd>Telescope lsp_references<cr>" "Show references" ])
          (keymap' [ "gD" "vim.lsp.buf.declaration" "Goto Declaration" true ])
          (keymap' [ "gI" (telescope_builtin "lsp_implementations") "Goto Implementations" true ])
          (keymap' [ "gy" (telescope_builtin "lsp_type_definitions") "Goto T[y]pe Definition" true ])
          (keymap' [ "gK" "vim.lsp.buf.signature_help" "Signature Help" true ])
          (keymap' [ "<leader>ca" "vim.lsp.buf.code_action" "Code Actions" true ])
          (keymap' [ "<leader>cc" "vim.lsp.codelens.run" "Run Codelens" true ])
          (keymap' [ "<leader>cC" "vim.lsp.codelens.refresh" "Refresh & Display Codelens" true ])
          (keymap' [ "<leader>cr" "vim.lsp.buf.rename" "Rename" true ])
          {
            key = "<leader>cA";
            action = /* lua */ ''
              function()
                vim.lsp.buf.code_action({
                  context = {
                    only = {
                      "source",
                    },
                    diagnostics = {},
                  },
                })
              end
            '';
            options = { desc = "Source Action"; };
            lua = true;
          }
        ];
      };
  };

  plugins = {
    typescript-tools = {
      enable = true;
      settings = {
        tsserverPath = pkgs.nodePackages.typescript-language-server.outPath + "/lib/node_modules/typescript/lib/tsserver.js";
      };
    };
    which-key.registrations = {
      "<leader>cl" = "LSP";
    };
    rustaceanvim = {
      enable = true;
      settings = {
        server = {
          settings = {
            inlayHints = {
              lifetimeElisionHints = {
                enable = "always";
              };
              implicitDrops.enable = true;
            };
            check = {
              command = "clippy";
            };
            imports.preferPrelude = true;
          };
        };
      };
    };
  };

  happy.patternKeymapsOnEvents = [
    {
      event = "BufEnter";
      pattern = "*.ts";
      mappings = lib.flatten [
        (mkKeymap [ "n" "<leader>cTo" "<cmd>TSToolsOrganizeImports<cr>" { desc = "TS: Organize and Remove Imports"; } ])
        (mkKeymap [ "n" "<leader>cTs" "<cmd>TSToolsSortImports<cr>" { desc = "TS: Sort Imports"; } ])
        (mkKeymap [ "n" "<leader>cTf" "<cmd>TSToolsFixAll<cr>" { desc = "TS: Fix all fixable errors"; } ])
        (mkKeymap [ "n" "<leader>cTr" "<cmd>TSToolsRenameFile<cr>" { desc = "TS: Rename file"; } ])
      ];
    }
    {
      event = "BufEnter";
      pattern = "*.rs";
      mappings = lib.flatten [
        (mkKeymap [ "n" "<leader>cRe" "<cmd>RustLsp expandMacro<cr>" { desc = "Rust: Expand Macro"; } ])
        (mkKeymap [ "n" "<leader>cRc" "<cmd>RustLsp openCargo<cr>" { desc = "Rust: Open Cargo.toml"; } ])
        (mkKeymap [ "n" "<leader>cRp" "<cmd>RustLsp parentModule<cr>" { desc = "Rust: Go to Parent Module"; } ])
        (mkKeymap [ [ "n" "v" ] "<leader>cRj" "<cmd>RustLsp joinLines<cr>" { desc = "Rust: Smart Join Lines"; } ])
      ];
    }
  ];

  happy.whichKeyRegisterOnPattern = [
    {
      pattern = "*.ts";
      mappings = [{ name = "Typescript"; bind = "<leader>cT"; }];
    }
    {
      pattern = "*.rs";
      mappings = [{ name = "Rust"; bind = "<leader>cR"; }];
    }
  ];

  extraPlugins = [
    pkgs.vimPlugins.nvim-nu
    pkgs.vimPlugins.otter-nvim
  ];

  extraPackages = [
    pkgs.nodePackages.typescript-language-server
    pkgs.clippy
  ];

  extraConfigLua = ''
    require("nu").setup({})
    require("otter").setup({
      lsp = {
        hover = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        },
        diagnostic_update_events = { "BufWritePost" },
      },
      buffers = {
        set_filetype = false,
        write_to_disk = false,
      },
      strip_wrapping_quote_characters = { "'", '"', "`" },
      handle_leading_whitespace = false
    })
  '';
}
