{ config, lib, helpers, ... }:
let
  inherit (lib) types mkOption;
in
{
  options.happy = {
    patternKeymapsOnEvents = mkOption
      {
        type = types.listOf (types.submodule {
          options = {
            event = mkOption {
              type = types.str;
            };
            pattern = mkOption {
              type = types.str;
            };
            mappings = mkOption {
              type = types.listOf helpers.keymaps.mapOptionSubmodule;
            };
          };
        });
        default = [ ];
        example = [
          {
            event = "BufRead";
            pattern = "*.ts";
            group = null;
            mappings = [
              {
                mode = "n";
                key = "<C-j>";
                action = "<C-w>j";
                options = { };
              }
            ];
          }
        ];
      };
  };
  config =
    let
      toAutoGroups = atts:
        { name = "nixvim_binds_patterned_${atts.event}"; value = { clear = true; }; };
      toAutoCmds = atts: {
        inherit (atts) event pattern;
        group = "nixvim_binds_patterned_${atts.event}";
        callback = helpers.mkRaw /* lua */ ''
          function()
            do
              local __nixvim_binds = ${helpers.toLuaObject atts.mappings}
              for i, map in ipairs(__nixvim_binds) do
                vim.keymaps.set(map.mode, map.key, map.action, map.options)
              end
            end
          end
        '';
        desc = "Load keymaps on ${atts.event} with pattern ${atts.pattern}";
      };
    in
    {
      autoGroups = lib.listToAttrs (map toAutoGroups config.happy.patternKeymapsOnEvents);
      autoCmd = map toAutoCmds config.happy.patternKeymapsOnEvents;
    };
}
