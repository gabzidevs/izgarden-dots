_:

let

  mkAgents =
    agentFilesPath:
    let
      agentspath = toString agentFilesPath;
    in
    {
      build = {
        mode = "primary";
        description = "The Wish Master - orchestrator of the Time Room";
        tools = {
          write = true;
          edit = true;
          read = true;
          grep = true;
          glob = true;
          bash = true;
          task = true;
          webfetch = true;
          websearch = true;
        };
        system_prompt_file = "${agentspath}/prismo.md";
      };

      plan = {
        mode = "primary";
        description = "The Wish Master - orchestrator of the Time Room";
        permission = {
          write = "deny";
          edit = "deny";
          bash = "deny";
        };
        system_prompt_file = "${agentspath}/prismo.md";
      };

      prismo = {
        mode = "subagent";
        description = "The Wish Master as subagent - cosmic orchestrator";
        system_prompt_file = "${agentspath}/prismo.md";
      };

      finn = {
        mode = "subagent";
        description = "Git operations expert - Mathematical!";
        system_prompt_file = "${agentspath}/finn.md";
        model = "ollama/qwen3:8b";
      };

      # Special compound agent for Finn delegating to Shelby
      finn-shelby = {
        mode = "subagent";
        description = "Finn delegating verification to Shelby - Action + Check";
        system_prompt_file = "${agentspath}/finn-shelby.md";
      };

      simon = {
        mode = "subagent";
        description = "Nix/NixOS expert - In my time...";
        system_prompt_file = "${agentspath}/simon.md";
      };

      fern = {
        mode = "subagent";
        description = "Dotfiles/Undergarden expert - I'm a copy...";
        system_prompt_file = "${agentspath}/fern.md";
      };

      jake = {
        mode = "subagent";
        description = "Tools/CLI expert - I can stretch!";
        system_prompt_file = "${agentspath}/jake.md";
      };

      prisco = {
        mode = "subagent";
        description = "Jake-as-Prismo - confused cosmic entity";
        system_prompt_file = "${agentspath}/jake-prismo.md";
      };

      marceline = {
        mode = "subagent";
        description = "Fundamentals/stability expert - Everything stays";
        system_prompt_file = "${agentspath}/marceline.md";
      };

      gleeman = {
        mode = "subagent";
        description = "Practical code specialist - Got a build to run";
        system_prompt_file = "${agentspath}/gleeman.md";
      };

      bmo = {
        mode = "subagent";
        description = "Interactive/exercises expert - Let's play!";
        system_prompt_file = "${agentspath}/bmo.md";
        model = "ollama/llama3.2:3b";
      };

      huntress = {
        mode = "subagent";
        description = "Prompt engineering expert - Words are magic";
        system_prompt_file = "${agentspath}/huntress.md";
      };

      bubblegum = {
        mode = "subagent";
        description = "Workflow organization expert - Gum holds it together!";
        system_prompt_file = "${agentspath}/bubblegum.md";
      };

      lich = {
        mode = "subagent";
        description = "The Lich - Ultra-precise editor (temp 0.01)";
        system_prompt_file = "${agentspath}/lich.md";
        model = "ollama/qwen2.5-3b-lich";
      };

      lemongrab = {
        mode = "subagent";
        description = "Lemongrab - Anxious validator - UNACCEPTABLE!";
        system_prompt_file = "${agentspath}/lemongrab.md";
        model = "ollama/qwen2.5-3b-lemongrab";
      };

      magicman = {
        mode = "subagent";
        description = "Magic Man - Casual chaos coder - Let's get TECHNICAL!";
        system_prompt_file = "${agentspath}/magicman.md";
        model = "ollama/qwen2.5-3b-magicman";
      };

      normalman = {
        mode = "subagent";
        description = "Normal Man - Grounded refactor specialist (the redeemed Magic Man)";
        system_prompt_file = "${agentspath}/normalman.md";
        model = "ollama/qwen2.5-coder-magicman";
      };

      golb = {
        mode = "subagent";
        description = "GOLB - Chaotic creativity - CREATION THROUGH DESTRUCTION!";
        system_prompt_file = "${agentspath}/golb.md";
        model = "ollama/qwen2.5-3b-golb";
      };

      shelby = {
        mode = "subagent";
        description = "Verification expert - Check please! (Delegatable only via Finn)";
        system_prompt_file = "${agentspath}/finn-shelby.md";
      };
    };
in
{
  inherit mkAgents;
}
