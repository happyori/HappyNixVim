{ helpers, ... }:
{
  autoGroups = {
    otter_nix_setup = { clear = true; };
  };

  autoCmd = [
    {
      event = [
        "BufEnter"
      ];
      pattern = [
        "*.nix"
      ];
      group = "otter_nix_setup";
      desc = "Setup NIX otter raft for lua";
      callback = helpers.mkRaw /* lua */ ''
        function()
            local lang = { 'lua' }
            local completion = true
            local diagnostics = true
            local tsquery = nil
            require('otter').activate(lang, completion, diagnostics, tsquery)
        end
      '';
    }
  ];
}
