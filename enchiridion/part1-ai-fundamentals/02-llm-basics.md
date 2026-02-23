# Chapter 2: LLM Basics - The Magic Behind the Words

*"Dude, I know you want to help, but you gotta understand: this is advanced magic."*  
*— Jake the Dog, probably talking about LLMs*

---

You've used functions, variables, and APIs. Now meet the building blocks of AI: **tokens**, **context windows**, and **temperature**. Think of these as the "magic system" rules in Adventure Time—once you understand them, you can cast better spells (prompts).

## Tokens: The Atoms of Language

### What is a Token?

A token is the smallest unit an LLM processes. It's not a letter, not quite a word—think of it as a syllable or word fragment.

**Examples:**
```
"Hello" → 1 token
"Programming" → 2-3 tokens ("Pro" + "gram" + "ming")
"nebulanix" → 3 tokens ("neb" + "ula" + "nix")
"😊" → 1 token (emojis count!)
```

**The Rule of Thumb:**
- 1 token ≈ 0.75 words (English)
- 100 tokens ≈ 75 words
- 1000 tokens ≈ 750 words

### Why Tokens Matter

**1. Context Window Limits**
Your model has a maximum token budget. Like Jake's stretchy powers—great, but finite.

```
qwen3:8b = 64K tokens ≈ 48,000 words
That's like... 96 pages of text!
```

**2. Cost (Cloud Models)**
APIs charge per token. Local models? You "pay" in RAM and time.

**3. Processing Speed**
More tokens = slower generation. A 4K context response is faster than 64K.

### Tokenization Visualized

```python
# How OpenAI/GPT sees your code:

def calculate_sum(a, b):
    return a + b

# Tokenized:
["def", " calculate", "_sum", "(", "a", ",", " b", "):",
 "\n", "    ", "return", " a", " +", " b"]
```

Notice:
- Whitespace matters (" b" not "b")
- Newlines are tokens
- Common words may be single tokens
- Rare words split into subword units

### Counting Tokens

**Local (with ollama):**
```bash
# Tokens in your prompt
ollama run qwen3:8b "Your prompt here" --verbose

# Or check context usage in logs
cat ~/.ollama/server.log | grep "tokens"
```

**Cloud (rough estimate):**
```bash
# Quick word count, multiply by 1.33
wc -w yourfile.txt
echo "Approx tokens: $(( $(wc -w < yourfile.txt) * 4 / 3 ))"
```

## Context Window: Working Memory

### The Backpack Analogy

Imagine you're on an adventure with Finn and Jake. Your **context window** is your backpack—it can only hold so much gear.

```
┌─────────────────────────────────┐
│     Context Window (64K)        │
├─────────────────────────────────┤
│ System Prompt      │ 500 tokens │
│ Conversation       │ 4000 tokens│
│ Current File       │ 8000 tokens│
│ Available Space    │ 47500 tok  │ ← Room for response!
└─────────────────────────────────┘
```

**Fill the backpack too full?** Things fall out (old context gets forgotten).

### Context Window Sizes

| Model | Context | Approx Pages |
|-------|---------|--------------|
| gemma3:4b | 32K | ~48 pages |
| qwen3:8b | 64K | ~96 pages |
| qwen3-coder:30b | 256K | ~384 pages |
| Claude 3.5 | 200K | ~300 pages |

### Managing Context

**Good: Include relevant code**
```markdown
Here's the function I'm working with:

```typescript
function authenticateUser(token: string): User {
  // ... implementation
}
```

Question: How do I add refresh token support?
```

**Bad: Dump entire codebase**
```markdown
Here's my whole project: [10000 lines of code]
Now fix the bug.
```
→ Model gets lost in noise, misses the point

### Context Compaction

When your backpack gets full, OpenCode can:
1. **Summarize** old conversation (keep gist, drop details)
2. **Prune** oldest messages
3. **Compress** using smart algorithms

Like Jake when he's carrying too much—he consolidates!

## Temperature: Creativity vs Consistency

### The Jake Analogy

**Low Temperature (0.0-0.3) = Serious Jake:**
- Predictable
- Consistent
- Safe choices
- "Dude, just use the map"

**High Temperature (0.7-1.0) = Silly Jake:**
- Creative
- Varied
- Unexpected
- "Let's ride the giant snail!"

### How It Works

Temperature controls randomness in token selection:

```
Low temp (0.1):
"The function returns" → 99% chance → "the result"

High temp (0.9):
"The function returns" → 60% chance → "the result"
                         → 20% chance → "a value"
                         → 15% chance → "bananas" (weird!)
                         → 5% chance → "your mom"
```

### When to Use What

**Temperature 0.0-0.3 (Deterministic):**
- Code generation (you want consistency)
- Factual Q&A
- Test cases
- Documentation

**Temperature 0.4-0.6 (Balanced):**
- Brainstorming
- Explaining concepts
- General coding help
- Most daily tasks

**Temperature 0.7-1.0 (Creative):**
- Generating variable names
- Writing comments
- Creative writing
- When you want variety

### Pro Tip: System vs Task

```json
{
  "temperature": 0.2,  // Keep system consistent
  "agent": {
    "brainstorm": {
      "temperature": 0.8  // But allow creativity here
    }
  }
}
```

## Other Important Parameters

### Top-p (Nucleus Sampling)

Instead of temperature, you can use **top-p**:
- Consider only tokens that cumulatively reach probability p
- p=0.9 = "Pick from the top 90% likely tokens"
- More natural than temperature alone

```json
{
  "temperature": 0.7,
  "top_p": 0.9  // Focus on quality candidates
}
```

**When to use:** When you want creative but not crazy outputs.

### Max Tokens

Hard limit on response length:
```json
{
  "max_tokens": 2048  // Stop after this many
}
```

**Use case:** Prevent runaway generation, control API costs.

### Frequency/Presence Penalty

Discourage repetition:
- **Frequency**: Penalize tokens by how often they appeared
- **Presence**: Penalize tokens that appeared at all

```json
{
  "frequency_penalty": 0.5,  // "Don't repeat yourself"
  "presence_penalty": 0.3     // "Try new words"
}
```

**Use case:** Long-form writing, avoiding "the the the" loops.

## The Nebulanix Context Advantage

Your 48GB machine changes the game:

### Cloud Constraints
```
Claude API: $3 per 1M input tokens
Long context = expensive!
```

### Local Freedom
```
Your machine: $0 per token
Context size = patience, not money
```

**Implication:** You can be more generous with context locally. Include more files, bigger examples, fuller documentation.

## Practical Examples

### Example 1: Debugging with Context

**Poor (low context):**
```
Fix this error: "TypeError: undefined is not a function"
```
→ Model guesses blindly

**Good (high context):**
```
I'm getting this error in my TypeScript project:

Error: TypeError: undefined is not a function
  at authenticateUser (auth.ts:23:15)

Here's the auth.ts file:
[include relevant 50 lines]

And here's how I'm calling it:
[include call site]
```
→ Model has enough context to diagnose

### Example 2: Temperature in Practice

**Code generation (low temp):**
```json
{
  "model": "qwen3-coder:30b",
  "temperature": 0.2,
  "prompt": "Write a function to validate email addresses"
}
```
→ Consistent, reliable regex patterns

**Variable naming (high temp):**
```json
{
  "model": "qwen3:8b",
  "temperature": 0.7,
  "prompt": "Suggest 5 creative names for a user authentication module"
}
```
→ Varied, interesting suggestions

## Common Mistakes

### ❌ Mistake 1: Ignoring Context Limits
```markdown
[Pastes entire 5000-line file]
"Fix the bug on line 483"
```
→ Model processes middle, forgets line 483

**✅ Fix:** Include only relevant sections with line numbers.

### ❌ Mistake 2: Wrong Temperature
```markdown
Temperature: 1.0
"Write a secure password hashing function"
```
→ Gets creative with security (dangerous!)

**✅ Fix:** Use 0.0-0.3 for security-critical code.

### ❌ Mistake 3: Token Miscounting
```markdown
"Summarize War and Peace in 1000 tokens"
```
→ Book is 500K+ tokens, summary impossible

**✅ Fix:** Check input size, adjust expectations.

## Exercise: Token Detective

### Exercise 1: Count the Tokens

How many tokens are in this prompt? (Estimate, then check)

```typescript
// Calculate fibonacci sequence
function fibonacci(n: number): number {
  if (n <= 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

// TODO: Optimize this for large n
```

**Your guess:** _____ tokens

**Actual** (using ollama verbose mode): Check with `ollama run qwen3:8b` and look for token counts in output.

### Exercise 2: Context Packing

You have a 32K context window (gemma3:4b). You need to:
- Include a 500-line file (~3000 tokens)
- Ask a question (~50 tokens)
- Leave room for the answer (~500 tokens)

**Question:** How many lines of another file can you include?

**Solution:**
```
Total: 32,000 tokens
Used: 3000 + 50 + 500 = 3550 tokens
Available: 28,450 tokens
Lines: ~28,450 / 6 (tokens per line) ≈ 4740 lines
```

But wait! System prompt and conversation history also count. Realistically: ~2000-3000 additional lines.

### Exercise 3: Temperature Tuning

Try generating the same function with different temperatures:

```bash
# Low temperature (consistent)
ollama run qwen3:8b "Write a function to reverse a string" --verbose

# Note the response, then exit

# Now edit config for high temperature
# In ~/.config/opencode/opencode.json, set temperature to 0.9

# Run again and compare
```

**Questions:**
1. How different are the implementations?
2. Which would you trust in production?
3. When might high temperature be useful?

### Exercise 4: The Context Window Game

You're debugging and have these files:
- `app.ts` (200 lines, ~1200 tokens)
- `auth.ts` (150 lines, ~900 tokens)
- `database.ts` (300 lines, ~1800 tokens)
- Error message (50 tokens)
- Your question (30 tokens)

**Challenge:** You need to fit this in 8K context (leaving room for response). What's your strategy?

**Strategy:**
1. Include full error message (50)
2. Ask specific question (30)
3. Include relevant portions of auth.ts (~400 tokens, the auth function)
4. Include database.ts connection code (~300 tokens)
5. Total: ~780 tokens, leaving 7200 for answer

**Key:** Be selective! Don't dump everything.

## Key Takeaways

1. **Tokens** ≈ word fragments. Count them to manage context.

2. **Context Window** = working memory. Don't overflow it.

3. **Temperature** = creativity dial. Low for code, high for brainstorming.

4. **Local advantage** = bigger contexts, no per-token costs.

5. **Be selective** with what you include. Quality > quantity.

## Adventure Time Connection

Remember when Finn had to choose what to put in his backpack for the dungeon? That's context management! And Jake's ability to stretch but still have limits? That's your context window!

The magic system in Adventure Time has rules—so do LLMs. Learn the rules, cast better spells.

---

*Next: [Chapter 3: The Nebulanix Stack](../03-nebulanix-stack.md)*

**Quick Reference Card:**
```
1 token ≈ 0.75 words
Context Window = backpack size
Temperature 0.0-0.3 = Serious Jake (code)
Temperature 0.7-1.0 = Silly Jake (creative)
Include relevant code, not everything
```
