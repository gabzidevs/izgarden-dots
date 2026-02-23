#!/usr/bin/env bash
# Test Qwen tooled models for function calling

set -e

models=("qwen2.5-coder-tooled" "qwen3-tooled" "qwen3-moe-tooled")

echo "Testing Qwen tooled models for function calling..."
echo ""

for model in "${models[@]}"; do
  echo "═══════════════════════════════════════"
  echo "Testing: $model"
  echo "═══════════════════════════════════════"

  # Test simple function call
  response=$(curl -s http://localhost:11434/api/chat -d "{
    \"model\": \"$model\",
    \"messages\": [{
      \"role\": \"user\",
      \"content\": \"What's the weather in San Francisco? Use the get_weather function.\"
    }],
    \"tools\": [{
      \"type\": \"function\",
      \"function\": {
        \"name\": \"get_weather\",
        \"description\": \"Get current weather for a location\",
        \"parameters\": {
          \"type\": \"object\",
          \"properties\": {
            \"location\": {
              \"type\": \"string\",
              \"description\": \"City name\"
            }
          },
          \"required\": [\"location\"]
        }
      }
    }],
    \"stream\": false
  }")

  echo "Response:"
  echo "$response" | jq -r '.message.content' 2>/dev/null || echo "$response"
  echo ""

  # Check if tool call was attempted
  if echo "$response" | grep -q "get_weather\|function\|tool"; then
    echo "✓ Model appears to recognize tool calling"
  else
    echo "⚠ No tool call detected in response"
  fi

  echo ""
done

echo "═══════════════════════════════════════"
echo "Test complete!"
echo ""
echo "Next steps:"
echo "1. Review responses above"
echo "2. Test in OpenCode: oll connect qwen3-tooled && opz"
echo "3. Try actual coding task with tools"
