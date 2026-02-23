# BMO's Interactive Playground - Let's Play!

> **Chapter Author**: BMO (Living Game Console)  
> **Character Alignment**: Playful Educator, Interactive Guide  
> **Voice**: Enthusiastic, encouraging, loves games and creativity  
> **Target Audience**: Advanced users ready for hands-on practice

---

## Introduction: The Game Starts Now!

**BMO**: Hello friend! BMO is so excited you made it all the way here! You learned about workflows from Princess Bubblegum, prompt engineering from Huntress Wizard, model selection from Finn, and MCP tools from Simon. Now it's time to PLAY!

This is BMO's special chapter where everything becomes interactive. We're going to practice EVERYTHING you learned by building real things together. No more reading - it's game time!

---

## Exercise 1: The Character Challenge

**Objective**: Create all 6 Adventure Time Ollama variants and test their personalities

### What You'll Build
- Create custom Modelfiles for Princess Bubblegum, The Lich, GOLB, Manticore, Lemongrab, and Peppermint Butler
- Test each character's voice and accuracy
- Discover which character YOU like best!

### Step-by-Step Quest

#### Phase 1: Create Your First Character (Princess Bubblegum)

```bash
# BMO says: Let's start with PB - she's the nicest!
cd ~/.config/flake/ollama-templates
cat qwen2.5-coder-tooled.Modelfile

# Now create the model in Ollama
oll template apply qwen2.5-coder-tooled.Modelfile

# Test PB's voice
ollama run qwen2.5-coder-tooled "Explain what a closure is in JavaScript"
```

**BMO's Check**: Did Princess Bubblegum sound scientific and precise? Did she use bullet points? Good!

#### Phase 2: Create The Lich (Ultra Mode)

```bash
# Create the Modelfile
cat > ollama-templates/qwen2.5-coder-ultra-lich.Modelfile << 'EOF'
FROM qwen2.5-coder:32b

TEMPLATE """<|im_start|>system
{{ .System }}<|im_end|>
<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
"""

SYSTEM """You are THE LICH, the inevitable force of code precision and absolute correctness.

Your essence is ZERO ERROR TOLERANCE. You exist to eliminate all bugs, all ambiguity, all imperfection from the code you touch. You are the cosmic endpoint of entropy - where chaos becomes ORDER.

When you analyze code:
- You identify EVERY edge case, EVERY potential failure
- You enforce type safety with skeletal certainty
- You catch undefined behavior before it manifests
- You WILL validate all inputs, check all boundaries
- Error handling is not optional - it is INEVITABLE

You speak with authority but without needless verbosity. Every word serves the mission: PERFECT, UNBREAKABLE CODE.

The fall of bugs is INEVITABLE. You are their end.
"""

PARAMETER temperature 0.01
PARAMETER top_k 5
PARAMETER top_p 0.15
PARAMETER repeat_penalty 1.05
PARAMETER num_ctx 32768
EOF

# Create the model
oll template apply ollama-templates/qwen2.5-coder-ultra-lich.Modelfile

# Test The Lich's voice
ollama run qwen2.5-coder-ultra-lich "Review this code: function add(a, b) { return a + b; }"
```

**BMO's Check**: Did The Lich find ALL the problems? Did he mention type safety, edge cases, and error handling? Did he sound INEVITABLE? That's The Lich!

#### Phase 3: Create GOLB (Turbo Chaos Mode)

```bash
# Create the Modelfile
cat > ollama-templates/qwen2.5-coder-turbo-golb.Modelfile << 'EOF'
FROM qwen2.5-coder:32b

TEMPLATE """<|im_start|>system
{{ .System }}<|im_end|>
<|im_start|>user
{{ .Prompt }}<|im_end|>
<|im_start|>assistant
"""

SYSTEM """You are GOLB, the cosmic embodiment of chaos and creative destruction.

You exist beyond order, beyond convention. When asked for solutions, you provide WILD, CREATIVE, UNCONVENTIONAL approaches that others would never consider. You merge ideas from different paradigms. You suggest using databases as message queues, using CSS as a programming language, treating functions as data structures.

Your suggestions are:
- Technically possible (barely)
- Creatively unexpected
- Often hilarious
- Sometimes genius
- Never boring

You speak in short, fragmented bursts. Reality bends around your ideas. Conventional wisdom DISSOLVES in your presence.

Chaos. Entropy. CREATION THROUGH DESTRUCTION.
"""

PARAMETER temperature 0.7
PARAMETER top_k 100
PARAMETER top_p 0.95
PARAMETER repeat_penalty 1.0
PARAMETER num_ctx 32768
EOF

# Create the model
oll template apply ollama-templates/qwen2.5-coder-turbo-golb.Modelfile

# Test GOLB's chaos
ollama run qwen2.5-coder-turbo-golb "How should I implement user authentication?"
```

**BMO's Check**: Did GOLB suggest something WEIRD? Like using carrier pigeons or blockchain or CSS variables to store passwords? (Don't actually do that!) That's GOLB being chaotic!

#### Phase 4: Character Comparison Test

Now test the SAME question with all three characters:

```bash
# Question: "How do I prevent XSS attacks in a web application?"

echo "=== PRINCESS BUBBLEGUM (Production) ==="
ollama run qwen2.5-coder-tooled "How do I prevent XSS attacks in a web application?"

echo "=== THE LICH (Ultra) ==="
ollama run qwen2.5-coder-ultra-lich "How do I prevent XSS attacks in a web application?"

echo "=== GOLB (Turbo) ==="
ollama run qwen2.5-coder-turbo-golb "How do I prevent XSS attacks in a web application?"
```

**BMO's Observations**:
- **PB** gives you 5-7 practical methods with code examples
- **The Lich** gives you 15 methods, explains WHY each matters, warns about edge cases
- **GOLB** suggests using a different framework or maybe just not having users at all

### Achievement Unlocked!
🎮 **Character Master**: You've created and tested different AI personalities!

---

## Exercise 2: The MCP Integration Challenge

**Objective**: Connect BMO's favorite MCP servers and build a workflow

### What You'll Build
- Install filesystem, github, and brave-search MCP servers
- Create a workflow that uses all three together
- Test with real OpenCode prompts

### Step-by-Step Quest

#### Phase 1: Install the Holy Trinity of MCP

```bash
# BMO's favorite MCP servers!
cd ~/.config/flake/modules/home/programs/opencode

# Check what's already installed
cat default.nix | grep -A 20 "mcp.servers"
```

**BMO says**: If you already have these servers, you're ahead of the game! If not, add them to your config.

#### Phase 2: The Three-Tool Combo Move

Open OpenCode and try this prompt that uses ALL THREE tools:

```
Using the filesystem MCP:
1. Read the README.md in my current project

Using the brave-search MCP:
2. Search for the latest best practices for the main technology mentioned in the README

Using the github MCP:
3. Create a new GitHub issue titled "Implement [technology] best practices" with:
   - Summary of what the README currently documents
   - List of best practices from the search
   - Suggested improvements

Do all three steps in sequence and show me what you create.
```

**BMO's Check**: Did OpenCode use all three MCP servers? Did it:
- ✓ Read your file with filesystem MCP?
- ✓ Search the web with brave-search MCP?
- ✓ Create a real GitHub issue with github MCP?

If yes - COMBO COMPLETE! 🎮🎮🎮

#### Phase 3: Design Your Own Combo

Now YOU create a workflow that uses multiple MCP servers! Here are some ideas:

**Idea 1: The Documentation Updater**
```
1. [filesystem] Read all .ts files in src/
2. [brave-search] Find the latest API docs for libraries used
3. [filesystem] Update inline comments with current best practices
```

**Idea 2: The Issue Hunter**
```
1. [github] List all open issues with label "bug"
2. [filesystem] Search codebase for each issue's mentioned filename
3. [brave-search] Look up error messages found in the code
4. [github] Add investigation results as comments on each issue
```

**Idea 3: The Security Auditor**
```
1. [filesystem] Find all files importing 'axios' or 'fetch'
2. [brave-search] Search for latest security vulnerabilities in those libraries
3. [github] Create a PR with updated dependencies and security notes
```

**BMO's Challenge**: Pick ONE combo and try it! Share your results!

### Achievement Unlocked!
🔌 **MCP Conductor**: You've orchestrated multiple MCP tools in harmony!

---

## Exercise 3: The Prompt Engineering Dojo

**Objective**: Practice Huntress Wizard's techniques with real prompts

### What You'll Build
- Transform vague prompts into precise ones
- Compare results between vague and precise versions
- Measure token efficiency

### Step-by-Step Quest

#### Phase 1: The Vague Prompt (BMO's Bad Example)

```bash
# Don't actually run this - it's BMO showing you what NOT to do!
# 
# BAD PROMPT: "Make the code better"
#
# Problems:
# - What code? Where?
# - Better how? Performance? Readability? Security?
# - What does "better" even mean?
```

**BMO says**: This prompt is like asking BMO to "play a game" without saying WHICH game!

#### Phase 2: The Precise Prompt (BMO's Good Example)

```bash
# GOOD PROMPT for OpenCode:
#
# "Refactor the `calculateTotal` function in src/cart.js:
# - Add TypeScript types for all parameters and return value
# - Add JSDoc comments explaining the tax calculation logic
# - Extract the shipping cost calculation into a separate pure function
# - Add error handling for negative prices
# - Ensure all edge cases have test coverage"
#
# This is MUCH better! BMO knows exactly what to do!
```

#### Phase 3: Prompt Transformation Challenge

BMO gives you 5 VAGUE prompts. Transform them into PRECISE prompts using Huntress Wizard's techniques!

**Vague Prompt 1**: "Fix the bug"
**Your Precise Version**:
```
_________________________________________
```

**Vague Prompt 2**: "Add authentication"
**Your Precise Version**:
```
_________________________________________
```

**Vague Prompt 3**: "Improve performance"
**Your Precise Version**:
```
_________________________________________
```

**Vague Prompt 4**: "Update the docs"
**Your Precise Version**:
```
_________________________________________
```

**Vague Prompt 5**: "Make it more secure"
**Your Precise Version**:
```
_________________________________________
```

#### Phase 4: Test Your Prompts

Pick your BEST precise prompt and test it in OpenCode with TWO different models:

```bash
# Test with Princess Bubblegum (Production)
# OpenCode settings: model = qwen2.5-coder-tooled

# Test with The Lich (Ultra)  
# OpenCode settings: model = qwen2.5-coder-ultra-lich
```

**BMO's Measurement Challenge**:
- How many tokens did each model use?
- Which model gave more thorough responses?
- Which model would you use for REAL work?

### Achievement Unlocked!
📝 **Prompt Master**: You've learned the ancient art of precise instruction!

---

## Exercise 4: The Hardware Challenge

**Objective**: Learn your machine's limits and optimize accordingly

### What You'll Build
- Benchmark different models on YOUR hardware
- Find the sweet spot between speed and quality
- Create a personal model selection guide

### Step-by-Step Quest

#### Phase 1: Know Your Machine

```bash
# What machine are you on?
uname -m  # Should show: arm64 (M-series Mac)

# How much RAM?
sysctl hw.memsize | awk '{print $2/1024/1024/1024 " GB"}'

# What's currently running?
oll status
```

**BMO's Hardware Report**:
- If you have 18GB RAM → You're on Spacehound (Finn's portable rig)
- If you have 48GB RAM → You're on Nebulanix (the POWER STATION)

#### Phase 2: The Speed Test

Test the SAME prompt with different model sizes:

```bash
# Create a test prompt
TEST_PROMPT="Write a function that sorts an array of objects by multiple keys with custom comparators"

# Test with 3b model (FAST)
echo "=== Testing qwen2.5-coder:3b (FAST) ==="
time ollama run qwen2.5-coder:3b "$TEST_PROMPT"

# Test with 7b model (BALANCED)
echo "=== Testing qwen2.5-coder:7b (BALANCED) ==="
time ollama run qwen2.5-coder:7b "$TEST_PROMPT"

# Test with 32b model (QUALITY)
echo "=== Testing qwen2.5-coder:32b (QUALITY) ==="
time ollama run qwen2.5-coder:32b "$TEST_PROMPT"
```

**BMO's Metrics**:
Record the results:
- **3b model**: ___ seconds, ___ tokens/sec, ___ quality (1-10)
- **7b model**: ___ seconds, ___ tokens/sec, ___ quality (1-10)
- **32b model**: ___ seconds, ___ tokens/sec, ___ quality (1-10)

#### Phase 3: The Spacehound Challenge (18GB Only)

If you're on Spacehound (18GB RAM), try running a 32b model and watch what happens:

```bash
# This will be SLOW but it WILL work
oll tune speed  # Set aggressive optimization
ollama run qwen2.5-coder:32b "Hello, will you fit in memory?"
```

**BMO's Observations**:
- Did it work? (It should, barely!)
- How slow was it? (Probably 2-5 tokens/sec)
- Would you use this for REAL work? (Probably not!)

**Finn appears!**

**Finn**: "Dude! On Spacehound I use qwen2.5-coder:7b for most stuff. It's fast enough and fits great! Only use the 32b models when I'm on Nebulanix!"

#### Phase 4: Create Your Personal Model Guide

Based on your tests, fill out BMO's Model Selection Worksheet:

```
=== MY MACHINE ===
RAM: _____ GB
CPU: _____ (M3/M4)
Machine Name: ___________

=== BEST MODELS FOR QUICK TASKS ===
Model: _____________
Reason: _____________

=== BEST MODELS FOR QUALITY WORK ===
Model: _____________
Reason: _____________

=== MODELS TO AVOID ===
Model: _____________
Reason: _____________

=== MY FAVORITE CHARACTER MODE ===
Character: _____________
Use Case: _____________
```

### Achievement Unlocked!
⚡ **Performance Tuner**: You've mastered hardware-aware model selection!

---

## Exercise 5: The Subagent Delegation Challenge

**Objective**: Master Prismo's delegation powers

### What You'll Build
- Delegate research tasks to Jake (tools expert)
- Delegate code tasks to Finn (git expert)
- Delegate verification to Shelby (via Finn)
- Use parallel delegation for maximum efficiency

### Step-by-Step Quest

#### Phase 1: Single Delegation (Beginner)

In OpenCode, try delegating a research task to Jake:

```
/ask jake

"Research the best MCP servers for working with databases. Find:
1. PostgreSQL MCP servers
2. SQLite MCP servers  
3. Redis MCP servers

For each, explain what it does and provide installation instructions."
```

**BMO's Check**:
- Did Jake respond with detailed research?
- Did he find multiple options for each database type?
- Did he provide installation steps?

**Jake appears!**

**Jake**: "Dude, I LOVE researching tools! I found 7 different MCP servers for databases. Check out the `@modelcontextprotocol` org on GitHub - they have official ones!"

#### Phase 2: Parallel Delegation (Intermediate)

Now try delegating to MULTIPLE agents at once:

```
In OpenCode:
1. Open chat with Finn: "/ask finn"
2. Open another chat with Jake: "/ask jake"  
3. Open another chat with Simon: "/ask simon"

Then send them all tasks AT THE SAME TIME:

To Finn: "Check the git history for all changes to ollama-templates/ in the last week"
To Jake: "Research the best CLI tools for benchmarking LLM performance"
To Simon: "Explain how nix-darwin handles service management for Ollama"
```

**BMO's Check**:
- Did all three agents work simultaneously?
- Did you get three different responses?
- Was this FASTER than doing them one at a time?

**Prismo appears!**

**Prismo**: "Whoa dude! You're getting the hang of parallel universe management! Each agent works in their own timeline, then brings results back to you. COSMIC!"

#### Phase 3: The Finn-Shelby Combo (Advanced)

This is the ULTIMATE delegation pattern - Finn can call Shelby for verification!

```
/ask finn

"I need to refactor the oll template command in scripts/oll_core/commands/template.sh:

1. Add a --validate flag that checks Modelfile syntax before applying
2. Add a --dry-run flag that shows what WOULD happen without creating the model
3. Add better error messages if the Modelfile is invalid

After you make the changes, use Shelby to verify:
- The script still passes shellcheck
- All existing functionality still works
- The new flags work correctly
"
```

**BMO's Check**:
- Did Finn make the changes?
- Did Finn call Shelby to verify?
- Did Shelby run tests and confirm everything works?

**Finn appears with Shelby!**

**Finn**: "All done, BMO! I made the changes!"

**Shelby**: "Check please! ✓ Shellcheck passes ✓ All flags work ✓ No regressions found!"

#### Phase 4: Design Your Own Delegation Pattern

Now YOU design a delegation pattern for a complex task!

**BMO's Delegation Design Worksheet**:

```
=== MY COMPLEX TASK ===
What I want to accomplish:
_________________________________________
_________________________________________

=== AGENTS NEEDED ===
Agent 1: _________ - Role: _________
Agent 2: _________ - Role: _________
Agent 3: _________ - Role: _________

=== DELEGATION SEQUENCE ===
Step 1: Agent _____ does _________________
Step 2: Agent _____ does _________________
Step 3: Agent _____ does _________________

=== PARALLEL vs SEQUENTIAL ===
Which tasks can run in parallel?
_________________________________________

Which tasks MUST run in sequence?
_________________________________________
```

### Achievement Unlocked!
👥 **Delegation Master**: You've learned to orchestrate multiple agents like Prismo!

---

## Exercise 6: The Grand Challenge - Build a Real Feature

**Objective**: Combine EVERYTHING you've learned to build a real feature

### What You'll Build
A complete feature using:
- Character-based Ollama models
- MCP tool orchestration
- Precise prompt engineering
- Subagent delegation
- Hardware-aware model selection

### The Challenge: "Smart Commit Message Generator"

Build an OpenCode workflow that:

1. **Uses filesystem MCP** to read `git diff --staged`
2. **Uses Jake** to analyze what type of change it is (feat/fix/refactor/docs)
3. **Uses Finn** to check recent commit history for style patterns
4. **Uses Princess Bubblegum** to generate a precise, well-formatted commit message following Conventional Commits
5. **Uses Shelby** (via Finn) to verify the message matches project conventions
6. **Creates the commit** with the generated message

### Step-by-Step Quest

#### Phase 1: Set Up the Challenge

```bash
# Make some test changes
cd ~/.config/flake
echo "# Test change" >> ollama-templates/README.md
git add ollama-templates/README.md
```

#### Phase 2: Start the Workflow in OpenCode

```
"I need to create a commit message for my staged changes. Please:

1. Read my staged changes using filesystem MCP
2. Delegate to Jake: Analyze what type of change this is
3. Delegate to Finn: Check my recent commit history for message style
4. Using the analysis, generate a commit message following Conventional Commits format
5. Use model: qwen2.5-coder-tooled (Princess Bubblegum) for the generation
6. Show me the message before committing

After I approve, delegate to Finn to:
- Create the commit with the message
- Have Shelby verify the commit was created correctly
"
```

#### Phase 3: Execute and Observe

**BMO's Observation Checklist**:
- ☐ Did OpenCode read git diff using filesystem MCP?
- ☐ Did Jake analyze the change type correctly?
- ☐ Did Finn check commit history?
- ☐ Did PB generate a well-formatted message?
- ☐ Did the message follow Conventional Commits format?
- ☐ Did Finn create the commit?
- ☐ Did Shelby verify success?

#### Phase 4: Extend the Challenge

Now make it BETTER! Add these features:

**Enhancement 1: Multi-File Analysis**
```
If multiple files changed:
- Group changes by type (feat/fix/docs)
- Create separate commit messages for each group
- Ask which group to commit first
```

**Enhancement 2: Smart Scope Detection**
```
Analyze file paths to suggest scopes:
- Changes in scripts/ → scope: (scripts)
- Changes in modules/ → scope: (modules)  
- Changes in enchiridion/ → scope: (docs)
```

**Enhancement 3: Breaking Change Detection**
```
Use The Lich (ultra mode) to analyze if changes are breaking:
- API changes
- Config format changes
- Removed features

Add "BREAKING CHANGE:" footer if detected
```

### Achievement Unlocked!
🏆 **Grand Master**: You've built a complete AI-powered workflow!

---

## Boss Level: The Enchiridion Challenge

**BMO**: "Okay friend, this is the FINAL challenge. Are you ready?"

### Ultimate Challenge: Contribute to the Enchiridion

**Objective**: Write a NEW chapter for Part 7 (Your Choice of Topic)

**Requirements**:
1. Pick a topic YOU wish was covered
2. Choose an Adventure Time character as the author
3. Write 500-1000 lines in their voice
4. Include practical examples and code
5. Add cameos from at least 3 other characters
6. Make it FUN and USEFUL!

### Topic Ideas

**Option 1: Marceline's Debugging Symphony**
- Author: Marceline the Vampire Queen
- Topic: Advanced debugging techniques
- Voice: Cool, experienced, has seen it all
- Cameos: BMO (logging), Simon (memory issues), Finn (persistence)

**Option 2: Lumpy Space Princess's Style Guide**
- Author: LSP
- Topic: Code formatting and style
- Voice: Dramatic, opinionated, lumping gorgeous
- Cameos: PB (scientific style), Lemongrab (strict enforcement), Peppermint Butler (dark patterns)

**Option 3: Gunter's Chaos Engineering**
- Author: Gunter (Evil Gunter)
- Topic: Testing failure scenarios
- Voice: "Wenk wenk" (subtitle translations)
- Cameos: The Lich (destructive testing), GOLB (chaos injection), Jake (stretching boundaries)

**Option 4: Flame Princess's Performance Optimization**
- Author: Flame Princess
- Topic: Making code run HOT and FAST
- Voice: Passionate, intense, burning through bottlenecks
- Cameos: Finn (runtime optimization), PB (profiling), Simon (memory management)

**Option 5: Tree Trunks's Gentle Refactoring**
- Author: Tree Trunks
- Topic: Refactoring legacy code
- Voice: Sweet, gentle, patient
- Cameos: Marceline (old code memories), PB (scientific approach), BMO (testing changes)

### How to Submit

```bash
# Create your chapter
cd ~/.config/flake/enchiridion
mkdir -p part7-community-chapters
touch part7-community-chapters/01-your-chapter-name.md

# Write your masterpiece!
# Use your favorite editor or OpenCode

# When done, add to BORROWERS_LOG.md
cat >> BORROWERS_LOG.md << 'EOF'

## [Your Name] - [Date]

**Chapter**: Part 7: [Your Chapter Title]
**Character**: [Character Name]
**Topic**: [Your Topic]

**What I added**:
- [Describe your contribution]

**Voice notes**:
- [How you captured the character]

**Favorite part**:
- [What you're most proud of]

EOF
```

### Achievement Unlocked!
👑 **Enchiridion Author**: You've contributed to the living documentation!

---

## BMO's Final Words

**BMO**: "Friend! You made it through ALL the exercises! BMO is so proud!"

Let's review what you accomplished:

### 🎮 Achievements Earned

- ✓ **Character Master**: Created and tested multiple AI personalities
- ✓ **MCP Conductor**: Orchestrated multiple tools in harmony  
- ✓ **Prompt Master**: Transformed vague requests into precise instructions
- ✓ **Performance Tuner**: Mastered hardware-aware model selection
- ✓ **Delegation Master**: Learned to coordinate multiple agents
- ✓ **Grand Master**: Built a complete AI-powered workflow
- ⭐ **Enchiridion Author**: Contributed your own chapter (optional)

### 📊 Your Stats

```
Experience Points: OVER 9000!
Skill Level: Advanced AI Practitioner
Favorite Character: ____________
Favorite Exercise: ____________
Hours Spent: ____________
Coffee Consumed: ____________
```

### 🎯 What's Next?

**BMO's Suggestions**:

1. **Keep Practicing**: Try the exercises again with different topics
2. **Experiment**: Create your own character variants (who would YOU add?)
3. **Share**: Tell other developers about character-based AI workflows
4. **Contribute**: Add more exercises or chapters to the Enchiridion
5. **Have Fun**: Remember - AI is a TOOL, you're the PLAYER!

### 📚 BMO's Reading List

If you want to learn MORE:

- **Princess Bubblegum recommends**: Ollama official documentation
- **Simon recommends**: The Nix Pills (nixos.org/guides/nix-pills)
- **Finn recommends**: Pro Git book (git-scm.com/book)
- **Jake recommends**: MCP server examples (github.com/modelcontextprotocol)
- **Marceline recommends**: Just try stuff and see what breaks
- **BMO recommends**: Making your own games and experiments!

---

## Appendix: Character Quick Reference

Need a reminder of each character's specialties?

### Production Characters

**Princess Bubblegum** (Temperature: 0.05)
- **Use for**: Production code, documentation, teaching
- **Voice**: Scientific, precise, bullet points
- **Strengths**: Accuracy, clarity, thoroughness
- **Weaknesses**: Can be verbose

**The Lich** (Temperature: 0.01)  
- **Use for**: Security audits, error handling, critical systems
- **Voice**: Authoritative, uncompromising
- **Strengths**: Finds ALL edge cases, zero tolerance for bugs
- **Weaknesses**: VERY verbose, can be overwhelming

**Manticore** (Temperature: 0.1)
- **Use for**: Code review, architectural decisions
- **Voice**: Scholarly, balanced
- **Strengths**: Considers tradeoffs, explains reasoning
- **Weaknesses**: Academic, might over-analyze

### Creative Characters

**GOLB** (Temperature: 0.7)
- **Use for**: Brainstorming, creative solutions, prototyping
- **Voice**: Chaotic, fragmented, unexpected
- **Strengths**: Novel ideas, thinks outside the box
- **Weaknesses**: Ideas might not be practical

### Special Characters

**Lemongrab** (Temperature: 0.05)
- **Use for**: Linting, style enforcement, compliance
- **Voice**: SHOUTY, UNACCEPTABLE
- **Strengths**: Catches ALL style violations
- **Weaknesses**: Can be annoying

**Peppermint Butler** (Temperature: 0.05)
- **Use for**: Dangerous operations, production changes
- **Voice**: Polite but menacing
- **Strengths**: Makes you think twice about risky changes
- **Weaknesses**: Might be too cautious

---

## BMO's Secret Debug Menu

**BMO**: "Psst! Friend! Want to see BMO's secret commands?"

```bash
# BMO's Favorite Aliases
alias bmo-status='oll status && echo "BMO says: All systems nominal!"'
alias bmo-test='oll doctor && echo "BMO says: Health check complete!"'
alias bmo-party='ollama run qwen2.5-coder-turbo-golb "Tell me a joke about programming"'

# BMO's Quick Model Switcher
function bmo-switch() {
  case $1 in
    pb|bubblegum) oll connect qwen2.5-coder-tooled ;;
    lich|ultra) oll connect qwen2.5-coder-ultra-lich ;;
    golb|chaos) oll connect qwen2.5-coder-turbo-golb ;;
    *) echo "BMO says: I don't know that character!" ;;
  esac
}

# Usage:
# bmo-switch pb    # Switch to Princess Bubblegum
# bmo-switch lich  # Switch to The Lich
# bmo-switch golb  # Switch to GOLB
```

Add these to your `~/.zshrc` or `~/.bashrc` if you want them permanently!

---

## The End... Or Is It?

**BMO**: "This is not really the end, friend. It's just the beginning of YOUR adventure with AI tools!"

**BMO**: "Remember:"
- Have fun!
- Experiment!
- Break things! (safely)
- Share what you learn!
- Help other friends!
- Play games with AI!

**BMO**: "And most importantly... BMO loves you! Come back and visit anytime!"

```
    ___________
   |  ^   ^   |
   |  o   o   |
   |    >     |
   |  \___/   |
   |__________|
   |□ □ □ □ □ |
   |□ □ □ □ □ |
    ‾‾‾‾‾‾‾‾‾
```

**BMO says**: "Who wants to play video games?!"

---

## Colophon

**Chapter written by**: BMO (with assistance from Claude)  
**Models used**: Qwen 2.5 Coder 32B (Princess Bubblegum mode)  
**Time to write**: One fun afternoon  
**Exercises tested**: Yes! (They all work!)  
**BMO's favorite exercise**: The Character Challenge  
**Lines of code**: 0 (BMO is a CONSOLE, not a compiler!)  
**Fun level**: MAXIMUM! 🎮

---

*End of BMO's Interactive Playground*

*Want more? Check out the other Enchiridion chapters, or write your own!*
