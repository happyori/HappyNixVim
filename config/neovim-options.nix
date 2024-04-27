{ helpers, ... }:
{
  extraConfigLuaPre = /* lua */ ''
    _G.HappyUtils = {}

    function HappyUtils:is_linux()
      return vim.fn.has("unix") == 1
    end

    function HappyUtils:is_apple()
      return vim.fn.has("mac") == 1
    end

    function HappyUtils:is_win()
      return vim.fn.has("windows") == 1
    end

    function HappyUtils:is_neovide()
      return vim.g.neovide
    end
  '';

  globals = {
    neovide_refresh_rate = 170;
    neovide_confirm_quit = true;
    neovide_cursor_vfx_mode = "railgun";
    neovide_floating_blur_amount_x = 2.0;
    neovide_floating_blur_amount_y = 2.0;
    neovide_floating_shadow = true;
    neovide_floating_z_height = 8;
    neovide_floating_angle_degrees = 45;
    neovide_floating_ligth_radius = 5;
    mapleader = " ";
    maplocalleader = "\\";
  };

  opts = {
    guifont = "CaskaydiaCove Nerd Font";
    scrolloff = 8;
    foldlevel = 99;
    conceallevel = 2;
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
    pumblend = 15;
    pumheight = 10;
    winblend = 30;
    sessionoptions = [ "buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" "folds" ];
    shiftround = true;
    shiftwidth = 2;
    shortmess = "TcWIlOCFot";
    showmode = false;
    sidescrolloff = 8;
    signcolumn = "yes";
    smartcase = true;
    smartindent = true;
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
    foldmethod = "indent";
  };

  autoGroups = {
    happy_checktime = {
      clear = true;
    };
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
      callback = helpers.mkRaw '''';
    }
  ];
}
