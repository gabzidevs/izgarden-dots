# The Lich Model - Tool Calling Fix

## Date: 2026-02-22

## Discovery

The Lich models (`qwen2.5-3b-lich` and `qwen3-8b-lich`) can now use **temperature 0.01** (ultra-precise) AND do tool calling. The fix was in the Modelfile TEMPLATE, not the parameters.

## Root Cause

The original template used incorrect field names:
- `.Tools` items accessed `.Name`, `.Description`, `.Parameters` 
- Actually they have `.Function` (which contains name, description, parameters)
- Needed proper `<tool_call>` XML tag format for tool call output

## Solution

Adapted template from `hhao/qwen2.5-coder-tools` (working pre-built model):

```TEMPLATE
"""{{- if .Messages }}
{{- if or .System .Tools }}<|im_start|>system
{{- if .System }}
{{ .System }}
{{- end }}
{{- if .Tools }}

# Tools

You may call one or more functions to assist with the user query.

You are provided with function signatures within <tools></tools> XML tags:
<tools>
{{- range .Tools }}
{"type": "function", "function": {{ .Function }}}
{{- end }}
</tools>

For each function call, return a json object with function name and arguments within <tool_call></tool_call> XML tags:
<tool_call>
{"name": <function-name>, "arguments": <args-json-object>}
</tool_call>
{{- end }}<|im_end|>
{{ end }}
{{- range $i, $_ := .Messages }}
...
```

## Parameters Preserved (Original)

- `temperature 0.01` - ultra-precise
- `top_k 5` - constrained sampling
- `top_p 0.15` - low diversity
- `num_ctx 32768` - large context

## Files Updated

- `ollama-templates/qwen2.5-3b-lich.Modelfile`
- `ollama-templates/qwen3-8b-lich.Modelfile`

## Verification

```bash
curl -s http://localhost:11434/v1/chat/completions -d '{
  "model": "qwen2.5-3b-lich",
  "messages": [{"role": "user", "content": "list files in /tmp"}],
  "tools": [{"type": "function", "function": {"name": "bash", ...}}]
}'
# Returns: {"name": "bash", "arguments": "{\"command\":\"ls /tmp\"}"}
```

## Reference

Source template: `hhao/qwen2.5-coder-tools` - Ollama library model that works with Cline
