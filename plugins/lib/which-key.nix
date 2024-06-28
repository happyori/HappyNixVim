{ config, lib, helpers, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.happy = {
    whichKeyRegisterOnPattern = mkOption
      {
        type = types.listOf (types.submodule {
          options = {
            pattern = mkOption {
              type = types.either types.str (types.listOf types.str);
              default = [ ];
            };
            mappings = mkOption {
              type = types.listOf (types.submodule {
                options = {
                  name = mkOption { type = types.str; };
                  bind = mkOption { type = types.str; };
                };
              });
              default = [ ];
              example = [
                { name = "LSP"; bind = "<leader>cl"; }
              ];
            };
          };
        });
        default = [ ];
      };
  };

  config =
    let
      toAutoCmds = atts: {
        inherit (atts) pattern;
        event = "BufEnter";
        desc = "Register Which Key Aliases for [${atts.pattern}]";
        group = "happy_register_which_keys";
        callback = helpers.mkRaw /* lua  */ ''
          function(args)
            local wk = require("which-key")
            local __nixvim_wk_binds = ${helpers.toLuaObject atts.mappings}
            local buf = args["buf"]
            local binds = {}
            for _, mapping in ipairs(__nixvim_wk_binds) do
              binds[mapping.bind] = mapping.name
            end

            wk.register(binds, { buffer = buf })
          end
        '';
      };
    in
    {
      autoGroups.happy_register_which_keys.clear = true;
      autoCmd = map toAutoCmds config.happy.whichKeyRegisterOnPattern;
    };
}
