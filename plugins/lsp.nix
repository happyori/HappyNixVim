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
        enable = true;
        installCargo = true;
        installRustc = true;
      };
      tsserver = { enable = true; };
      yamlls = { enable = true; };
      gopls = { enable = true; };

    };

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
    preConfig = /* lua */ ''
      local function setup_codelens_and_inlay(client, buffer)
        if client.supports_method("textDocument/inlayHint") then
          local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
          if type(ih) == "function" then
            ih(buf, true)
          elseif type(ih) == "table" and ih.enable then
            ih.enable(true, { bufnr = buf })
          end
        end

        if vim.lsp.codelens then
          if client.supports_method("textDocument/codeLens") then
            local codelens_enabled, _ = pcall(vim.lsp.codelens.refresh)
            if codelens_enabled then
              vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                buffer = buffer,
                callback = function() pcall(vim.lsp.codelens.refresh) end,
              })
            end
          end
        end
      end
    '';
    onAttach = /* lua */ ''
      -- setup_codelens_and_inlay(client, bufnr)
    '';
  };

  plugins = {
    typescript-tools = {
      enable = true;
    };
    which-key.registrations = {
      "<leader>cl" = "LSP";
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
  ];

  extraPlugins = [
    pkgs.vimPlugins.nvim-nu
  ];

  extraConfigLua = ''
    require("nu").setup({})
  '';

}
