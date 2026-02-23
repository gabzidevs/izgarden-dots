{ lib }:

let
  parseModel =
    model:
    let
      parts = lib.splitString "/" model;
    in
    lib.last parts;

  ollamaProvider =
    { model, ollamaHost }:
    let
      modelName = parseModel model;
    in
    {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama";
        options = {
          baseURL = "${ollamaHost}/v1";
        };
        models = {
          "${modelName}" = {
            inherit modelName;
            tools = true;
          };
        };
      };
    };

  ollamaCloudProvider = {
    ollama-cloud = {
      name = "Ollama Cloud";
    };
  };

  anthropicProvider = {
    anthropic = {
      name = "Anthropic";
    };
  };

  googleProvider = {
    google = {
      models = {
        "antigravity-claude-opus-4-6-thinking" = {
          name = "Claude Opus 4.6 Thinking (Antigravity)";
          limit = {
            context = 200000;
            output = 64000;
          };
          modalities = {
            input = [
              "text"
              "image"
              "pdf"
            ];
            output = [ "text" ];
          };
          variants = {
            low = {
              thinkingConfig = {
                thinkingBudget = 8192;
              };
            };
            max = {
              thinkingConfig = {
                thinkingBudget = 32768;
              };
            };
          };
        };
        "antigravity-gemini-3-pro" = {
          name = "Gemini 3 Pro (Antigravity)";
          limit = {
            context = 1048576;
            output = 65535;
          };
          modalities = {
            input = [
              "text"
              "image"
              "pdf"
            ];
            output = [ "text" ];
          };
          variants = {
            low = {
              thinkingLevel = "low";
            };
            high = {
              thinkingLevel = "high";
            };
          };
        };
        "antigravity-gemini-3-flash" = {
          name = "Gemini 3 Flash (Antigravity)";
          limit = {
            context = 1048576;
            output = 65536;
          };
          modalities = {
            input = [
              "text"
              "image"
              "pdf"
            ];
            output = [ "text" ];
          };
          variants = {
            minimal = {
              thinkingLevel = "minimal";
            };
            low = {
              thinkingLevel = "low";
            };
            medium = {
              thinkingLevel = "medium";
            };
            high = {
              thinkingLevel = "high";
            };
          };
        };
      };
    };
  };
in

{
  inherit
    ollamaProvider
    ollamaCloudProvider
    anthropicProvider
    googleProvider
    parseModel
    ;
}
