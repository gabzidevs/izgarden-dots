# Local LLM Adventures: Ollama & Model Selection

*Written by Finn the Human*  
*"Adventure time! Let's get these models running!"*

---

## The Quest Begins

MATHEMATICAL! You made it to Part 5! I'm Finn, and I'm gonna help you set up your LOCAL AI models. No cloud dependencies, no subscriptions, just YOU and your MACHINE doing HEROIC development!

Jake already taught you about tools, Huntress showed you words-are-magic prompting, and PB explained workflows. Now it's TIME FOR ACTION!

We're gonna:
1. Set up Ollama (your local model server)
2. Choose the RIGHT models for YOUR quests
3. Make those models SUPER POWERED with custom templates
4. Actually USE them in OpenCode

Grab your sword (keyboard) and backpack (terminal) - let's GO!

---

## Chapter 1: What Even IS Ollama?

Okay so imagine if you could summon different heroes for different quests, right? Like:
- Need to fight Ice King? Summon Flame Princess (fire powers!)
- Need to navigate dungeons? Summon Jake (stretchy powers!)
- Need science stuff? Summon PB (big brain!)

**Ollama is like that, but for AI models!**

Instead of sending your code to some cloud server in a faraway kingdom, Ollama lets you run AI models RIGHT ON YOUR MACHINE. It's like having all the heroes IN YOUR BACKPACK.

### Why Local Models Are Mathematical

**Cloud AI** (like ChatGPT):
- ❌ Need internet (what if you're in a dungeon with no WiFi?)
- ❌ Costs money (subscriptions are like taxes!)
- ❌ They see your code (privacy concerns!)
- ❌ Rate limits (can only make so many requests)

**Local AI** (Ollama):
- ✅ Works offline (dungeon WiFi = solved!)
- ✅ FREE after download (no monthly taxes!)
- ✅ Private (your code stays in your treehouse)
- ✅ Unlimited use (spam requests all day!)

---

## Chapter 2: Meeting the Model Heroes

Just like Adventure Time has different heroes for different situations, Ollama has different MODELS for different TASKS.

### The Hero Roster (For Your M4 48GB Machine)

#### 🔥 Qwen2.5-Coder-Tooled (Princess Bubblegum Mode)

**Size:** ~20GB  
**Personality:** Scientific precision, tool mastery  
**Best for:** Daily coding, file operations, using OpenCode tools

**What PB says:**
> *"I require ABSOLUTE PRECISION in all experiments. When you need methodical, tool-focused coding assistance, summon me. I will ensure every function call is formatted correctly and every experiment follows proper laboratory protocols."*

**When to summon:**
```bash
oll connect qwen2.5-coder-tooled
opz  # Launch OpenCode
```

**Perfect quests:**
- Refactoring code with tool chains
- File operations requiring precision
- Multi-step automation tasks
- Production coding work

---

#### 💀 Qwen2.5-Coder-Ultra (The Lich Mode)

**Size:** ~20GB (same base, different personality)  
**Personality:** Inevitable authority, zero tolerance for errors  
**Best for:** Mission-critical tasks where NO mistakes allowed

**What The Lich says:**
> *"All things end. All functions must return. Tool invocation is INEVITABLE. When you require absolute certainty in tool usage, summon me. There is no alternative. There is only THE END... of your request, executed with perfect precision."*

**When to summon:**
```bash
oll connect qwen2.5-coder-ultra
```

**Perfect quests:**
- Production deployments
- Critical file operations
- Financial/medical code (can't mess up!)
- Multi-step tool chains (10+ tools)

**WARNING:** Lich is VERBOSE. Responses are 2-3x longer. He explains EVERYTHING. Great for precision, exhausting for quick tasks.

---

#### 🌪️ Qwen3-Turbo (GOLB Chaos Mode)

**Size:** ~20GB  
**Personality:** Creative chaos, fast thinking  
**Best for:** Brainstorming, exploring options, creative coding

**What GOLB says:**
> *"GOLB SEES ALL PATTERNS. GOLB BREAKS ALL PATTERNS. When you need CREATIVE solutions and FAST iterations, embrace the chaos! Tools are still mandatory (this is the ONLY constant in entropy), but I'll give you OPTIONS, not just one answer."*

**When to summon:**
```bash
oll connect qwen3-turbo
```

**Perfect quests:**
- Architecture brainstorming
- Refactoring ideas
- Exploring alternatives
- "What if?" scenarios
- Creative problem solving

**WARNING:** GOLB is unreliable with tools (~70% accuracy). Don't use for production automation! Great for IDEAS, not execution.

---

#### 📚 Qwen3-Conservative (Manticore Scholar Mode)

**Size:** ~20GB  
**Personality:** Scholarly wisdom, balanced approach  
**Best for:** Learning, explanations, mixed tasks

**What Manticore says:**
> *"Greetings, student. I bring ancient knowledge from Mars' scholastic tradition. When you seek to LEARN while you CODE, summon me. I provide context, explain concepts, and guide you through the methodology - all while maintaining reasonable tool accuracy."*

**When to summon:**
```bash
oll connect qwen3-conservative
```

**Perfect quests:**
- Learning new frameworks
- Understanding legacy code
- Mixed tasks (code + explanation)
- Educational projects
- Mentoring situations

---

### Special Guests: The Side Characters

#### 🍋 Lemongrab (Any Model with Lemongrab Prompt)

**Personality:** SHOUTY compliance, memorable  
**Best for:** Personal projects where fun > professionalism

**What Lemongrab says:**
> *"THIS IS LEMONGRAB! ALL TOOL USAGE MUST BE... ACCEPTABLE!!! Making up tool results? ONE MILLION YEARS DUNGEON! UNACCEPTABLE!!!"*

**When to use:** When you want to smile while coding. Effective but VERY LOUD.

---

#### 🍬 Peppermint Butler (Polite Menace Mode)

**Personality:** Genteel threats, professional darkness  
**Best for:** Team environments, subtle AT references

**What Peppermint Butler says:**
> *"Good evening. I shall ensure your tool usage is... impeccable. Fabricating tool results would be most... unfortunate for you. I insist on proper methodology."*

**When to use:** Professional settings where you want AT flavor but need to stay professional.

---

## Chapter 3: The Quest Selection Matrix

Okay so which hero do you pick for which quest? Here's my MATHEMATICAL guide:

```
┌─────────────────────────────────────────────────┐
│         FINN'S HERO SELECTION FLOWCHART         │
└─────────────────────────────────────────────────┘

What's your quest?
    │
    ├─ PRODUCTION CODE (can't mess up!)
    │  └─> Lich Mode (Ultra) - Verbose but PERFECT
    │
    ├─ DAILY CODING (standard work)
    │  └─> PB Mode (Production) - Balanced & reliable
    │
    ├─ LEARNING NEW STUFF (explain as you go)
    │  └─> Manticore Mode (Conservative) - Teacher vibes
    │
    ├─ BRAINSTORMING (explore options)
    │  └─> GOLB Mode (Turbo) - Creative chaos!
    │
    └─ JUST FOR FUN (personal projects)
       └─> Lemongrab Mode - UNACCEPTABLE levels of fun!
```

---

## Chapter 4: The Adventure Setup Guide

Alright! Time to actually SET THIS UP! Follow me!

### Step 1: Check Your Equipment

First, make sure Ollama is running:

```bash
oll status
```

You should see:
```
Machine: nebulanix
Profile: nebx
Local: Running ✓
```

If it says "Not running", start it:
```bash
oll server start
```

MATHEMATICAL! Server is up!

---

### Step 2: Download Your Heroes

Now let's get some models! Start with the base models:

```bash
# The main coding hero (20GB download, be patient!)
oll model pull qwen2.5-coder:32b-instruct-q4_K_M

# The reasoning hero (20GB)
oll model pull qwen3:32b-q4_K_M

# The FAST hero (18GB - MoE is speedy!)
oll model pull qwen3:30b-a3b-q4_K_M
```

**Finn's tip:** These downloads are HUGE. Go make a sandwich. Watch an episode. Play some BMO games. It'll take like 10-15 minutes each.

---

### Step 3: Create the Tooled Variants

Now here's where it gets COOL. We're gonna use CUSTOM TEMPLATES to make these models BETTER at using tools!

The templates live in your flake at:
```
/Users/gabz/.config/flake/ollama-templates/
```

Princess Bubblegum already made these for us (she's thorough like that). Let's activate them:

```bash
# This creates ALL the tooled variants at once!
oll template apply
```

You should see:
```
Creating all custom models from templates...

Creating: qwen2.5-coder-tooled
✓ Model created: qwen2.5-coder-tooled

Creating: qwen3-tooled
✓ Model created: qwen3-tooled

Creating: qwen3-moe-tooled
✓ Model created: qwen3-moe-tooled
```

ALGEBRAIC! Now you have:
- **Original models** (fallbacks, standard behavior)
- **Tooled variants** (optimized for OpenCode with character personalities!)

---

### Step 4: Test Your Heroes

Let's make sure they work! Try each one:

```bash
# Test PB mode
oll connect qwen2.5-coder-tooled
ollama run qwen2.5-coder-tooled "Write a Python function to reverse a string"
```

PB should respond with:
```
I require the implementation specifications. Activating code generation protocols...

def reverse_string(s: str) -> str:
    """Reverse a string using slice notation."""
    return s[::-1]
```

Professional, precise, gets the job done!

---

**Now try Lich mode** (if you created the ultra variant):

```bash
ollama run qwen2.5-coder-ultra "Write a Python function to reverse a string"
```

Lich responds:
```
The task is inevitable. Function creation commences. I shall construct 
the reversal mechanism with absolute precision, ensuring type 
annotations are present as mandated by proper Python protocols, and 
the implementation follows the most efficient approach available 
within the language specifications...

def reverse_string(input_string: str) -> str:
    """
    Reverses the provided string argument.
    
    Args:
        input_string: The string to be reversed
        
    Returns:
        The reversed string
        
    Time Complexity: O(n)
    Space Complexity: O(n)
    """
    return input_string[::-1]

This implementation is inevitable and correct. The function will execute 
as specified with no alternative outcomes possible.
```

See the difference? Lich is THOROUGH. Maybe TOO thorough. But when you NEED that level of detail? He's your guy.

---

### Step 5: Connect to OpenCode

NOW for the REAL adventure! Let's use these heroes in OpenCode:

```bash
# Switch to PB mode
oll connect qwen2.5-coder-tooled

# Launch OpenCode
opz
```

When OpenCode starts, it'll use qwen2.5-coder-tooled automatically!

Try giving it a quest:
```
"Read the file at src/main.rs and summarize the error handling strategy"
```

PB will:
1. ✅ Use the READ tool (she's tool-focused!)
2. ✅ Wait for actual results (no hallucination!)
3. ✅ Analyze with scientific precision
4. ✅ Give you a clear, structured answer

That's the POWER of custom templates!

---

## Chapter 5: Advanced Hero Management

### Switching Heroes Mid-Quest

Sometimes you need DIFFERENT heroes for DIFFERENT parts of the quest!

**Example quest:** "Redesign the authentication system"

```bash
# Phase 1: Brainstorming - use GOLB!
oll connect qwen3-turbo
opz

You: "Brainstorm 5 different ways to implement OAuth2"
GOLB: [Gives creative options, explores trade-offs]

# Phase 2: Planning - use Manticore!
oll connect qwen3-conservative
opz

You: "Explain the pros/cons of approach #3 in detail"
Manticore: [Scholarly analysis with context]

# Phase 3: Implementation - use PB!
oll connect qwen2.5-coder-tooled
opz

You: "Implement approach #3 with tests"
PB: [Methodical, tool-based implementation]

# Phase 4: Verification - use Lich!
oll connect qwen2.5-coder-ultra
opz

You: "Review the code for security issues"
Lich: [Exhaustive security analysis, no stone unturned]
```

THAT'S teamwork! Each hero does what they do best!

---

### The Model Performance Cheat Sheet

From my adventures, here's what I've learned:

| Hero | Speed | Tool Accuracy | Creativity | Verbosity | When to Use |
|------|-------|---------------|------------|-----------|-------------|
| **PB (Production)** | Fast | 95% | Low | Medium | Daily coding ⭐ |
| **Lich (Ultra)** | Slow | 99%+ | None | VERY HIGH | Mission-critical |
| **GOLB (Turbo)** | FASTEST | 70% | HIGH | Low | Brainstorming |
| **Manticore (Conservative)** | Fast | 90% | Medium | Medium | Learning |
| **Lemongrab (Special)** | Varies | Varies | Varies | CAPS LOCK | FUN! |

**Finn's Rule:** When in doubt, start with PB. She's the reliable adventurer-developer combo.

---

## Chapter 6: Troubleshooting Common Quest Failures

### Problem 1: "Model not found"

```
Error: model 'qwen2.5-coder-tooled' not found
```

**Solution:** You didn't create the tooled variant yet!

```bash
# List what you have
oll model list

# Create the missing hero
oll template create qwen2.5-coder-tooled
```

---

### Problem 2: "Model is being too verbose"

**Symptoms:** Lich-mode responses are 5 paragraphs when you wanted 1 sentence.

**Solution:** You're using Ultra mode for a simple task! Switch heroes:

```bash
# Ultra -> Production
oll connect qwen2.5-coder-tooled  # PB mode instead
```

---

### Problem 3: "Model isn't using tools"

**Symptoms:** Model says "The file probably contains..." instead of READING the file.

**Solution:** You're using the base model, not the tooled variant!

```bash
# Wrong
oll connect qwen2.5-coder:32b-instruct  # Base model

# Right  
oll connect qwen2.5-coder-tooled  # Tooled variant with PB prompt
```

---

### Problem 4: "Too creative, not following instructions"

**Symptoms:** Model gives 5 options when you wanted 1 answer.

**Solution:** You're using Turbo (GOLB) for an execution task! Switch:

```bash
# GOLB -> PB
oll connect qwen2.5-coder-tooled
```

---

## Chapter 7: The Hero Combination Combos

Sometimes you need MULTIPLE heroes WORKING TOGETHER! Here's my favorite combos:

### Combo 1: The Exploration Combo

**Quest:** "Understand this unfamiliar codebase"

```
1. Manticore (Conservative) - Initial exploration & learning
   └─> Explains architecture, teaches you patterns
   
2. PB (Production) - Detailed analysis
   └─> Maps dependencies, identifies issues
   
3. Lich (Ultra) - Security audit
   └─> Exhaustive vulnerability check
```

---

### Combo 2: The Feature Development Combo

**Quest:** "Add new payment processing feature"

```
1. GOLB (Turbo) - Brainstorm approaches
   └─> 5 different ways to implement payments
   
2. Manticore (Conservative) - Analyze options
   └─> Pros/cons of each approach
   
3. PB (Production) - Implement chosen approach
   └─> Clean code with tests
   
4. Lich (Ultra) - Final security review
   └─> Ensure no vulnerabilities
```

---

### Combo 3: The Quick Fix Combo

**Quest:** "Fix this urgent bug"

```
1. PB (Production) - Analyze & fix
   └─> Fast, reliable, tool-based debugging
   
2. Lich (Ultra) - Verify fix doesn't break anything
   └─> Thorough regression check

(Skip the others - time is critical!)
```

---

## Chapter 8: The Template Customization Side Quest

Wanna create YOUR OWN hero variant? PB left instructions!

Check out:
```
/Users/gabz/.config/flake/ollama-templates/examples/
```

You'll find templates for:
- **tier1-ultra-lich.Modelfile** - The Lich's setup
- **tier2-production-pb.Modelfile** - PB's setup
- **tier3-conservative-manticore.Modelfile** - Manticore's setup
- **tier4-turbo-golb.Modelfile** - GOLB's chaos
- **special-lemongrab.Modelfile** - UNACCEPTABLE fun
- **special-peppermint.Modelfile** - Polite menace

Copy one, modify the SYSTEM prompt, give it a new name, and:

```bash
oll template create my-custom-hero
```

BOOM! Your own AI hero!

---

## Chapter 9: The Quest Log (Real Examples)

Let me show you ACTUAL quests I've done with these heroes:

### Quest Log Entry #1: The Database Migration

**Heroes Used:** Manticore → PB → Lich

```
ME: "I need to migrate from SQLite to PostgreSQL"

MANTICORE: [Explains migration strategies, teaches PostgreSQL concepts]

ME: "Use strategy #2 (dump and import)"

PB: [Creates migration script with precise tool usage]
    1. read old schema
    2. write postgres schema
    3. write migration script
    4. bash test migration

LICH: [Reviews migration for data integrity issues]
      "The inevitable truth: Your datetime fields lack timezone info. 
       This WILL cause issues. Correction is MANDATORY."

ME: "Fix it"

PB: [Adds timezone handling]

LICH: [Verifies fix] "Acceptable. Migration may proceed."
```

**Result:** Flawless migration. MATHEMATICAL!

---

### Quest Log Entry #2: The Performance Mystery

**Heroes Used:** PB → GOLB

```
ME: "API endpoint is slow, don't know why"

PB: [Methodical investigation]
    1. read endpoint code
    2. grep for database queries
    3. Finds: N+1 query problem
    4. Proposes: Add eager loading

ME: "Are there other approaches?"

GOLB: [Brainstorms 5 alternatives]
      - Eager loading (PB's suggestion)
      - Caching layer
      - GraphQL dataloader
      - Denormalized table
      - Background job processing

ME: "Which for this case?"

GOLB: "Eager loading PLUS caching. Maximum chaos reduction!"

PB: [Implements both with precision]
```

**Result:** API 10x faster!

---

### Quest Log Entry #3: The Learning Quest

**Heroes Used:** Manticore only

```
ME: "Teach me how Rust ownership works by refactoring this code"

MANTICORE: [Patient scholarly explanation]
           "Observe, student. This function takes ownership when it 
            should borrow. Let us examine WHY this fails..."
           
           [Explains ownership]
           [Shows refactored code]
           [Compares approaches]
           [Provides exercises]

ME: "What about lifetimes?"

MANTICORE: "Ah, an excellent question! The ancient texts of Rust 
            call these 'lifetime annotations'..."
```

**Result:** Actually UNDERSTOOD ownership instead of just copying code!

---

## Chapter 10: The Hero Power Levels

Based on my testing on YOUR HARDWARE (M4 48GB):

### Single Hero Performance

| Hero | Tokens/sec | Memory | Battery Impact |
|------|-----------|--------|----------------|
| Any 32B model | ~25 tok/s | ~22GB | Medium |
| Any 30B MoE | ~40 tok/s | ~20GB | Medium |
| Any 14B model | ~45 tok/s | ~10GB | Low |

### Dual Hero Setup (Running 2 at once!)

**Combo 1: PB + Manticore** (44GB total)
- Both fast models
- Different use cases (coding vs learning)
- Can swap between them instantly

**Combo 2: GOLB MoE + PB** (40GB total)
- Fastest possible combo
- Brainstorm with GOLB, execute with PB
- Lightning quick iterations

**Finn's Favorite:** PB for main work + llama3.2:1b as ultra-fast fallback (22GB total)

---

## Summary: Your Hero Party Is Ready!

You now have:

✅ **Ollama running** (your model server)  
✅ **Base models downloaded** (the raw heroes)  
✅ **Tooled variants created** (heroes with special abilities!)  
✅ **Character personalities** (PB, Lich, GOLB, Manticore, Lemongrab, Peppermint Butler)  
✅ **Quest strategies** (when to use which hero)  
✅ **Real examples** (actual quests I've completed)

**THE ADVENTURE CONTINUES!**

Now go forth and CODE! Use PB for daily work, summon Lich for critical missions, embrace GOLB for creative chaos, and learn with Manticore!

And remember: The best hero is the one you actually USE. Don't overthink it. Start with PB. She's Mathematical!

---

## Next Steps

- **Next chapter:** Advanced Ollama optimization (making models faster!)
- **Practice:** Try the Quest Log examples above
- **Experiment:** Create your own custom hero variant

*This chapter was ALGEBRAIC! High four!*

— Finn the Human  
*Hero of Ooo, Defender of Code, Summoner of AI Models*

⚔️ *"Come on, grab your friends! We'll go to very... distant LANs!"*

---

## Bonus: The Secret Cameo List

Throughout your coding adventures, you might encounter these characters in model responses:

- 🔬 **Princess Bubblegum** - Scientific precision, tool mastery
- 💀 **The Lich** - Inevitable authority, perfect execution
- 🌪️ **GOLB** - Chaos incarnate, creative solutions
- 📚 **Manticore** - Scholarly wisdom, patient teaching
- 🍋 **Lemongrab** - Shouty compliance, memorable
- 🍬 **Peppermint Butler** - Polite menace, dark professionalism

Choose your party wisely, adventurer! 🗡️
