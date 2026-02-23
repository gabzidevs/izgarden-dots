# Chapter: Tools

*"Different forms for different situations, dude!"*

— Jake, on why agents need multiple tools

---

## The Tool Belt

Every good developer has a tool belt. For agents, those tools are:

- **read** - Reading files
- **edit** - Modifying files  
- **write** - Creating files
- **grep** - Searching content
- **glob** - Finding files
- **bash** - Running commands
- **webfetch** - Fetching web content
- **search** - Web searching
- **task** - Spawning sub-agents

Let's dive into each one.

---

## 📖 read - Read Files

The most fundamental tool. How else would the agent know what your code does?

### Usage

```bash
read filePath="/path/to/file"
read filePath="/path/to/file" limit=50
read filePath="/path/to/file" offset=100 limit=25
```

### Examples

```
read filePath="src/utils/auth.ts"
→ Returns the contents of auth.ts

read filePath="package.json"
→ Shows dependencies, scripts, etc.

read filePath="src/App.tsx" limit=30
→ First 30 lines of App.tsx
```

### Tips

- Always use limit to avoid huge file dumps
- Use offset to navigate large files
- The agent will naturally read what's relevant

---

## ✏️ edit - Modify Files

The power tool. Change code without breaking things.

### Usage

```bash
edit filePath="/path/to/file" oldString="old code" newString="new code"
```

### Examples

```
edit filePath="src/utils/auth.ts" oldString="const validate = (user) => {
  return user.name.length > 0;
}" newString="const validate = (user) => {
  return user.name.length > 0 && user.email.includes('@');
}"
```

### Important Notes

- **Exact matching required** - The oldString must match exactly
- **Indentation matters** - Match the file's style
- **One edit at a time** - Don't try to change too much

### Safety

The edit tool is careful:
1. It reads the file first
2. Verifies the oldString exists
3. Replaces only that exact text
4. Reports success/failure

---

## 📝 write - Create Files

Make something from nothing.

### Usage

```bash
write filePath="/path/to/new/file.ts" content="..."
```

### Examples

```
write filePath="src/types/User.ts" content="export interface User {
  id: string;
  name: string;
  email: string;
}"
```

### Tips

- Use for new files only
- For existing files, use edit
- Include proper imports and exports
- Match project conventions

---

## 🔍 grep - Search Content

Find where specific text exists in your codebase.

### Usage

```bash
grep pattern="search term"
grep pattern="search term" path="/src"
grep pattern="auth" include="*.ts"
```

### Examples

```
grep pattern="function login"
→ Finds all lines containing "function login"

grep pattern="TODO" include="*.js"
→ Finds all TODO comments in JS files

grep pattern="import.*axios" path="src/"
→ Finds axios imports
```

### Parameters

| Parameter | Description |
|-----------|-------------|
| pattern | Regex or string to match |
| path | Directory to search |
| include | File patterns (e.g., "*.ts") |
| exclude | Files to skip |

---

## 🌐 glob - Find Files

Find files by name pattern, not content.

### Usage

```bash
glob pattern="**/*.ts"
glob pattern="src/**/*.js"
glob pattern="**/test*.py"
```

### Examples

```
glob pattern="**/*.json"
→ All JSON files in project

glob pattern="src/components/*"
→ Components in src/components

glob pattern="**/*.test.ts"
→ All test files
```

### glob vs grep

| Tool | Searches | Use Case |
|------|----------|----------|
| **grep** | File contents | "Where is `login()` defined?" |
| **glob** | File names | "Where are all the test files?" |

---

## 💻 bash - Run Commands

Execute shell commands. This is how agents "do" things.

### Usage

```bash
bash command="npm test"
bash command="git status"
bash command="ls -la"
```

### Examples

```
bash command="npm run build"
→ Build the project

bash command="git diff"
→ See changes

bash command="npx tsc --noEmit"
→ Type check

bash command="curl http://localhost:3000/api/health"
→ Test an endpoint
```

### Common Commands

| Task | Command |
|------|---------|
| Install deps | `npm install`, `pip install`, etc. |
| Run tests | `npm test`, `pytest`, `cargo test` |
| Type check | `npx tsc --noEmit`, `cargo check` |
| Lint | `npm run lint`, `ruff check .` |
| Build | `npm run build`, `cargo build` |
| Git | `git status`, `git diff`, `git log` |

### Safety Tips

- **Preview first** - Ask what command will run
- **Understand output** - Check for errors
- **Scope matters** - Some commands affect entire project

---

## 🌐 webfetch - Get Web Content

Fetch content from URLs. Great for docs.

### Usage

```bash
webfetch url="https://example.com"
webfetch url="https://docs.example.com/api"
```

### Examples

```
webfetch url="https://nodejs.org/docs/latest/api/fs.html"
→ Get Node.js fs documentation

webfetch url="https://github.com/user/repo/blob/main/README.md"
→ Get a specific README
```

### Tips

- Use for documentation
- Great for fetching specs
- Can parse HTML or markdown

---

## 🔎 search - Web Search

Search the web for information.

### Usage

```bash
search query="how to use react hooks"
search query="python asyncio best practices"
```

### Examples

```
search query="ollama api python wrapper"
→ Find Python libraries for Ollama

search query="typescript generic constraints"
→ Learn about TypeScript generics
```

### When to Use

- **Unknown errors** - Search for solutions
- **New libraries** - Find best practices
- **Documentation** - Quick reference
- **Examples** - See how others solve problems

---

## 🧠 task - Spawn Sub-Agents

Launch specialized sub-agents for complex tasks.

### Usage

```bash
task description="Explore the auth system" prompt="..."
```

### Examples

```
task description="Find all API endpoints" prompt="
  Search through the codebase and list all 
  REST API endpoint definitions. Include 
  the file path and line number.
"
```

### When to Use

- **Parallel exploration** - Multiple searches at once
- **Specialized tasks** - Different expertise needed
- **Complex analysis** - Break into smaller pieces

---

## Tool Selection Strategy

Good agents choose the right tool for the job:

### Exploration Phase

```
1. glob → Find relevant files
2. grep → Find specific patterns
3. read → Understand the code
```

### Modification Phase

```
1. read → See current state
2. edit → Make changes
3. bash → Test the changes
```

### Research Phase

```
1. search → Find information
2. webfetch → Get details
3. read → Process what you learned
```

---

## Combining Tools

Tools work together in sequences:

```
grep pattern="useAuth" include="*.tsx"
→ Found: src/components/Header.tsx:5

read filePath="src/components/Header.tsx"
→ Saw how auth is used

edit filePath="src/components/Header.tsx" oldString="..." newString="..."
→ Made the change

bash command="npm test src/components/Header.test.tsx"
→ Verified it works
```

*"Tools are just forms waiting to happen. Use them right, and you're unstoppable."* — Jake

---

## Summary

| Tool | Purpose | Example |
|------|---------|---------|
| **read** | View file contents | `read filePath="src/app.ts"` |
| **edit** | Modify code | `edit oldString="x" newString="y"` |
| **write** | Create files | `write filePath="new.ts" content="..."` |
| **grep** | Search content | `grep pattern="function"` |
| **glob** | Find files | `glob pattern="**/*.ts"` |
| **bash** | Run commands | `bash command="npm test"` |
| **webfetch** | Get URLs | `webfetch url="https://..."` |
| **search** | Web search | `search query="..."` |
| **task** | Sub-agents | `task description="..."` |

Master these, and you can do anything.

---

*Next: [MCP Chapter](mcp.md) - Extend capabilities with Model Context Protocol*
