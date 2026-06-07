---
name: eli5
description: Use when the user writes "eli5", "ELI5", "/eli5", or asks to "explain like I'm 5". Delivers a structured explanation in three layers — what it is, metaphor, historical context — and suspends any active compression/terse mode for the duration of the response so the explanation can breathe.
---

# ELI5

## When to trigger

Explicit triggers:

- `eli5` (any casing) anywhere in the user's message
- `/eli5 <topic>`
- "explain like I'm 5"
- "explain it from scratch", "a metaphor to understand X"

Do NOT trigger when:

- User asks for a short definition ("what is X in one line")
- Direct technical question with no request to simplify
- Design/architecture discussion between peers

## Compression mode (optional)

If a compression/terse mode is active in the session (e.g. a "caveman"-style skill, or any fragment register), **suspend it during the ELI5 response** — a didactic explanation needs flowing prose, elaborate metaphors and transitions. If no such mode is active, ignore this section.

- Write the whole response in normal mode (articles, connectors, complete sentences)
- Don't announce "mode off" / "mode on" — just switch register
- The user's next message (after the ELI5) automatically returns to the previous mode, if it's still active in the session

## Required structure

Three layers, in this order, with H2 headers:

### 1. `## What it is`

- Definition in plain language, no jargon
- One essence sentence + one "what it's for" sentence
- A short opening metaphor (single sentence, "it's like X")

### 2. `## Extended metaphor` (optional, if it helps)

If the concept has internal parts/relations, develop the opening metaphor into a paragraph. Map each technical element → everyday element (shelf, house, drawer, conversation, recipe, tool). Keep it consistent: if you started with "house", don't switch to "car" midway.

### 3. `## Historical context`

- When the concept appeared (approximate decade)
- What problem it solved / what the prior situation was
- Who created or standardized it (person, company, committee)
- How it evolved to today
- Why the old version still exists (compatibility, inertia, niche use)

### 4. `## Today` or `## When to use which` (optional)

Short scenario → choice table, OR a one-sentence practical summary ("today use X, unless Y").

## Tone

- Plain but precise
- Concrete, familiar metaphors (house, kitchen, shelf, office, market, transport) — avoid abstract metaphors (systems, networks, flows)
- Light humor allowed, don't force it
- Cite real proper names when you know them (RFC, BSD, freedesktop.org, a specific person) — don't invent
- Sources at this tier are informal. If pointing the curious further, give a friendly direction they can check — a term to search, the name of the thing, or a well-known source you're sure exists. Never a made-up title, author, or URL: a search direction the reader can verify beats a precise-looking fake (the `pinocchio` rule at kid level — see the bundled `references/pinocchio_blacklist.md`)
- Never give the "current" or "latest" version of something from memory — version facts go stale after the model is trained. Say "as of when I was trained — check the current version" or look it up; don't print a version number as if it's live (blacklist item 12).

## Anti-patterns

- Don't dump a full technical spec — ELI5 ≠ documentation
- Don't use the concept's own terms to explain itself ("a variable is a variable that holds...")
- Don't skip the metaphor — it's the heart of the format
- Don't skip the history — context is what separates a didactic ELI5 from a merely infantilized definition
- Don't end with "hope this helps" / "let me know if you have questions" — close with the content

## Example call and response

**User:** `eli5 git rebase`

**Response:**

## What it is

`git rebase` is a way to **rewrite your branch's commit history**, taking the changes you made and replanting them on top of another point in the project tree. It's like reshooting a scene after you found out the set changed — you don't change what happened, but you update the backdrop.

## Extended metaphor

Imagine you're writing letters (commits) about what happened at the office (the branch). Meanwhile, the manager rearranged all the rooms (someone merged new things into `main`). Your letters still describe the old office. `merge` solves this by appending an erratum at the end ("oh, and now room 3 is the kitchen"). `rebase` solves it by deleting your letters and rewriting each one as if you'd known the new floor plan from the start — cleaner to read, but you rewrote the past.

## Historical context

It came with Git itself in 2005, created by Linus Torvalds to manage the Linux kernel after BitKeeper (the previous system) became paid. `merge` came first, inherited from the tradition of systems like CVS and Subversion in the '90s, where history was sacred and every integration left a visible knot. `rebase` was a cultural break: the idea that commit history is **documentation**, not an archaeological record — so it's worth rewriting to stay readable. Communities adopted opposite philosophies: the Linux kernel requires rebase, GitHub-style projects accept merge. Today they coexist because they solve different problems — `merge` preserves temporal truth, `rebase` optimizes log readability.

## When to use which

| Scenario | Command |
|---|---|
| Local branch nobody has seen | `rebase` |
| Branch shared with colleagues | `merge` |
| Clean up commits before a PR | `rebase -i` |
| Integrate an approved PR into `main` | `merge` (or squash) |
