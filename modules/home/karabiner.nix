{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  config =
    let
      codingProfile = config.garden.profiles.coding or { };
      tapHoldEnabled = codingProfile.keyboard.tapHold.enable or false;
      tapHoldConfig = codingProfile.keyboard.tapHold or { };

      keyToKarabiner =
        key:
        {
          escape = "escape";
          control = "left_control";
          hyper = [
            "left_control"
            "left_alt"
            "left_command"
            "left_shift"
          ];
          none = null;
        }
        .${key};

      buildSimpleModifications = tapKey: holdKey: [
        {
          description = "Caps Lock: tap = ${tapKey}, hold = ${holdKey}";
          manipulators = [
            {
              type = "basic";
              from = {
                key_code = "caps_lock";
                modifiers = {
                  optional = [ "any" ];
                };
              };
              to_if_held = map (k: { key_code = k; }) (keyToKarabiner holdKey);
              to_if_tapped = map (k: { key_code = k; }) (keyToKarabiner tapKey);
            }
          ];
        }
      ];

      buildAppModifications =
        appName: appConfig:
        let
          tapKey = appConfig.tapKey or "escape";
          holdKey = appConfig.holdKey or "hyper";
        in
        [
          {
            description = "${appName}: tap = ${tapKey}, hold = ${holdKey}";
            manipulators = [
              {
                type = "basic";
                from = {
                  key_code = "caps_lock";
                  modifiers = {
                    optional = [ "any" ];
                  };
                };
                conditions = [
                  {
                    type = "frontmost_application_if";
                    bundle_identifiers = [ appName ];
                  }
                ];
                to_if_held = map (k: { key_code = k; }) (keyToKarabiner holdKey);
                to_if_tapped = map (k: { key_code = k; }) (keyToKarabiner tapKey);
              }
            ];
          }
        ];

      globalRules =
        let
          tapKey = tapHoldConfig.tapKey or "escape";
          holdKey = tapHoldConfig.holdKey or "hyper";
        in
        buildSimpleModifications tapKey holdKey;

      appRules =
        let
          apps = tapHoldConfig.apps or { };
        in
        map buildAppModifications (lib.filterAttrs (_n: v: v != { }) apps);

      allRules = globalRules ++ appRules;

      karabinerJson = builtins.toJSON {
        global = {
          "check_for_updates_on_startup" = true;
          "show_in_menu_bar" = true;
          "show_profile_name_in_menu_bar" = false;
        };
        profiles = [
          {
            name = "Izgarden Tap/Hold";
            complex_modifications = {
              rules = allRules;
            };
          }
        ];
      };
    in
    mkIf tapHoldEnabled {
      xdg.configFile = {
        "karabiner/assets/complex_modifications/izgarden.json".text = karabinerJson;
      };
    };
}
