{ helpers, ... }:
{
  extraConfigLuaPre = builtins.readFile ../lua/happy_utils.lua;

  diagnostics = {
    severity_sort = true;
    virtual_text = true;
  };

  globals = {
    neovide_refresh_rate = 170;
    neovide_confirm_quit = true;
    neovide_cursor_vfx_mode = "railgun";
    neovide_floating_blur_amount_x = 10.0;
    neovide_floating_blur_amount_y = 10.0;
    neovide_floating_shadow = true;
    neovide_floating_z_height = 8;
    neovide_floating_angle_degrees = 45;
    neovide_transparency = 0.7;
    neovide_floating_ligth_radius = 5;
    mapleader = " ";
    maplocalleader = "\\";
  };

  opts = {
    guifont = "CaskaydiaCove Nerd Font";
    scrolloff = 12;
    foldlevel = 99;
    conceallevel = 2;
    cursorline = true;
    autowrite = true;
    completeopt = "menu,menuone,noinsert";
    confirm = true;
    expandtab = true;
    formatoptions = "jcroqlnt";
    grepformat = "%f:%l:%c:%m";
    grepprg = "rg --vimgrep";
    ignorecase = true;
    inccommand = "nosplit";
    laststatus = 3;
    list = true;
    mouse = "a";
    number = true;
    relativenumber = true;
    pumblend = 60;
    pumheight = 10;
    winblend = 100;
    sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";
    shiftround = true;
    shiftwidth = 2;
    shortmess = "TcWIlOCFot";
    showmode = false;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    smartindent = false;
    spelllang = [ "en" ];
    splitbelow = true;
    splitkeep = "screen";
    splitright = true;
    tabstop = 2;
    termguicolors = true;
    timeoutlen = 300;
    undofile = true;
    undolevels = 10000;
    updatetime = 200;
    virtualedit = "block";
    wildmode = "longest:full,full";
    winminwidth = 5;
    wrap = false;
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = "…";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
    smoothscroll = true;
  };

  autoGroups = {
    happy_checktime = { clear = true; };
    happy_highlight_yank = { clear = true; };
    happy_auto_create_dir = { clear = true; };
    happy_close_with_q = { clear = true; };
    happy_resize_splits = { clear = true; };
  };

  autoCmd = [
    {
      event = [ "FocusGained" "TermClose" "TermLeave" ];
      group = "happy_checktime";
      callback = helpers.mkRaw /* lua */ ''
        function()
          if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
          end
        end
      '';
    }
    {
      event = [ "TextYankPost" ];
      group = "happy_highlight_yank";
      callback = helpers.mkRaw /* lua */ ''
        function() vim.highlight.on_yank() end
      '';
    }
    {
      event = [ "VimResized" ];
      group = "happy_resize_splits";
      callback = helpers.mkRaw /* lua */ ''
        function()
          local current_tab = vim.fn.tabpagenr()
          vim.cmd("tabdo wincmd =")
          vim.cmd("tabnext " .. current_tab)
        end
      '';
    }
    {
      event = [ "FileType" ];
      group = "happy_close_with_q";
      pattern = helpers.toLuaObject [
        "PlenaryTestPopup"
        "help"
        "lspinfo"
        "notify"
        "qf"
        "query"
        "spectre_panel"
        "startuptime"
        "tsplayground"
        "neotest-output"
        "checkhealth"
        "neotest-summary"
        "neotest-output-panel"
      ];
      callback = helpers.mkRaw /* lua */ ''
        function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
        end
      '';
    }
    {
      event = [ "BufWritePre" ];
      group = "happy_auto_create_dir";
      callback = helpers.mkRaw /* lua */ ''
        function(event)
          if event.match:match("^%w%w+:[\\/][\\/]") then
            return
          end
          local file = vim.uv.fs_realpath(event.match) or event.match
          vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
        end
      '';
    }
  ];
}
