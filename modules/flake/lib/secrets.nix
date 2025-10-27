{ inputs }:
let
  inherit (inputs) self;

  /**
    Create secrets for use with `agenix`.

    # Arguments

    - [file] the age file to use for the secret
    - [owner] the owner of the secret, this defaults to "root"
    - [group] the group of the secret, this defaults to "root"
    - [mode] the permissions of the secret, this defaults to "400"

    # Type

    ```
    mkSystemSecret :: (String -> String -> String -> String) -> AttrSet
    ```

    # Example

    ```nix
    mkSystemSecret { file = "./my-secret.age"; }
    => {
      file = "./my-secret.age";
      owner = "root";
      group = "root";
      mode = "400";
    }
    ```
  */
  mkSystemSecret =
    {
      file,
      owner ? "root",
      group ? "root",
      mode ? "0400",
      ...
    }@args:
    let
      args' = builtins.removeAttrs args [
        "file"
        "owner"
        "group"
        "mode"
      ];
      # record = ;
    in
    # {
    #   # sopsFile = "${self}/secrets/services/${file}.yaml";
    #   inherit owner group mode;
    # }
    mkAltSecret {
      inherit
        file
        owner
        group
        mode
        ;
    }
    // args';

  /**
    INFO: Internal SOPS mapping exposed
  */
  mkAltSecret =
    args:
    {
      sopsFile = "${self}/secrets/services/${args.file}.yaml";
    }
    // builtins.removeAttrs args [ "file" ];
in
{
  inherit mkSystemSecret mkAltSecret;
}
