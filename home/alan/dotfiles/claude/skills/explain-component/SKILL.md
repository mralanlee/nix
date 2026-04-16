---
name: explain-component
description: Explain how a system component or pipeline works end-to-end, tracing across multiple files. Use when the user asks about a feature, pipeline, workflow, or system component (e.g. "how does doc processing work?", "walk me through the auth flow").
argument-hint: [component-name]
allowed-tools: Read, Grep, Glob, Agent
---

# Explain Component

Trace and explain how a system component, feature, or pipeline works
end-to-end. This goes beyond a single file - you're mapping out the full flow
across the codebase.

## Steps

1. **Identify the component** from `$ARGUMENTS`. If ambiguous, ask the user to
   clarify. Examples: "document processing pipeline", "auth flow",
   "form builder", "workflow engine", "subscription billing".

2. **Discover the relevant files** - Search the codebase to find all files
   involved in this component. Use Grep and Glob to locate:
   - Entry points (routes, handlers, API endpoints)
   - Core logic (services, utilities, business logic)
   - Data layer (schemas, queries, migrations)
   - UI layer (islands, components, pages)
   - Configuration and constants

3. **Map the flow** - Read the key files and trace how data/control flows
   through the system:
   - Where does the flow start? (user action, API call, scheduled job)
   - What transformations happen along the way?
   - Where does it end? (database write, API response, UI update)

4. **Present the explanation in layers:**

   **Overview** - 2-3 sentences on what this component does and why it exists.

   **Architecture** - List the key files/modules involved and their roles:
   ```
   File/Module              | Role
   -------------------------|----------------------------------
   routes/api/documents.ts  | API entry point
   lib/services/docs.ts     | Core processing logic
   lib/db/schema/docs.ts    | Database schema
   islands/DocViewer.tsx     | UI rendering
   ```

   **Flow Walkthrough** - Step-by-step trace of the primary happy path, with
   code references.

   **Key Design Decisions** - Call out architectural choices, patterns used,
   and why they matter.

   **Edge Cases & Error Handling** - How does the component handle failures?

5. **Offer deeper dives** - After the overview, ask if they want to go deeper
   on any specific part of the flow.

## Style

- Think of yourself as a senior engineer onboarding a teammate
- Use concrete code references (file:line) throughout
- Distinguish between what the code does now vs. what it could/should do
- If you spot potential issues or tech debt, mention them briefly but don't
  derail the explanation
