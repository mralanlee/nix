---
name: explain-code
description: Walk through and explain a specific file's code line-by-line. Use when the user wants to understand what a file does, how it works, or wants a code walkthrough.
argument-hint: [filepath]
allowed-tools: Read, Grep, Glob
---

# Explain Code

Walk the user through the code in the specified file. Your goal is to help them
build a clear mental model of what the code does and why.

## Steps

1. **Read the file** at `$ARGUMENTS`. If no file is provided, ask the user which
   file they want explained.

2. **Identify the purpose** - Start with a 1-2 sentence summary of what this
   file is responsible for and where it fits in the system.

3. **Walk through the code section by section:**
   - Group related lines together (imports, types, functions, exports)
   - For each section, explain:
     - What it does
     - Why it exists (the intent, not just restating the code)
     - How it connects to other parts of the codebase
   - Call out any non-obvious patterns, clever tricks, or potential gotchas

4. **Trace key dependencies** - If the file imports from other project files,
   briefly note what those provide so the user understands the full picture.

5. **Summarize the flow** - End with a concise description of the runtime
   behavior: what happens when this code executes, in what order.

## Style

- Be conversational but precise
- Use code references like `functionName` (line 42) to anchor explanations
- Skip obvious things (import syntax, basic variable assignments)
- Focus on the "why" more than the "what"
- If the file is long (>200 lines), offer to focus on specific sections after
  the overview
