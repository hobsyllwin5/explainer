---
name: eligrad
description: Use when the user writes "eligrad", "/eligrad", or asks for a graduate / advanced-undergraduate explanation ("explain like I'm graduated", "explain at grad level", "explain like I'm a grad student", "I know the basics, go deeper"). The name is a backronym — Explain Like I'm GRADuated. Level 2 of the explainer family — assumes foundational background, introduces real terminology, shows mechanism and trade-offs with controlled formalism. Suspends any active compression mode for the response.
---

# eligrad

Level 2 of the `explainer` family (between `eli5` and `elidoc`): teaches **mechanism and trade-offs** to a reader with foundational background. Bloom target: Understand → Apply → Analyze.

## When to trigger

- `eligrad` (any casing), `/eligrad <topic>`
- "explain like I'm graduated", "explain at a graduate / advanced level", "explain like I'm a grad student"
- "I know the basics — go deeper on X"

Do NOT trigger when:

- A simple/lay explanation is wanted → use `eli5`
- The reader is a domain peer wanting edge-cases/frontier → use `elidoc`
- A short factual answer is requested

## Audience & assumptions

- Assume: core vocabulary of the parent discipline, ability to read a moderate
  equation/code block/diagram, comfort with abstraction, familiarity with the category the
  concept belongs to (for `git rebase`: knows commits, branches, version control, DAGs).
- Don't assume: this concept's internals, field idioms/acronyms used without expansion, or
  awareness of the current research/design frontier.

## Compression mode (optional)

If a compression/terse mode is active in the session (e.g. a "caveman"-style skill), suspend
it during the response — technical teaching needs full sentences and defined terms. If no
such mode is active, ignore this section. Don't announce the switch; the user's next message
returns to the previous mode if still active.

## Required structure

H2 sections, in order:

### 1. `## Core idea`
2–4 sentences: precise definition using correct terms + the problem it solves. Jargon
allowed (define as used below).

### 2. `## Intuition`
One bridging metaphor or guiding example to seed the mental model — then **redeem it**: cash
it out into the literal mechanism and name where the analogy breaks. An un-redeemed metaphor
is an `eli5` artifact and an anti-pattern here.

### 3. `## How it works`
The core. Step-by-step internals, the moving parts, the causal/operational chain.
Equations/pseudocode/diagram as needed; define each symbol/term on first use.

### 4. `## Why it works`
Principle, invariant, or guarantee; a short derivation or sketch of *why* a result holds —
not a full rigorous proof (that's `elidoc`).

### 5. `## Trade-offs & alternatives`
Costs, complexity, failure modes; comparison against sibling approaches (table when useful);
the conditions that select each.

### 6. `## When to use which` (optional)
Decision guidance with technical criteria.

### 7. `## Going deeper` (optional)
Pointers to the frontier / canonical references / open problems — signal where `elidoc`
begins without crossing into it. Recommend canonical sources here (the textbook, the standard
algorithm, the official docs) — subject to the accuracy rule below.

Historical context (mandatory in `eli5`) is optional here — include only when the design's
*why* depends on it (path-dependence, backward-compat, a result that reframed the field).

## Vocabulary policy

- Introduce real technical terms — don't avoid them. Pattern: term → one-clause inline
  definition → reuse freely. Don't re-explain a term already defined.
- Density of a good textbook chapter, not a glossary dump and not jargon-free prose.
- Expand acronyms on first use. Use the field's actual nomenclature.

## Formalism

- Allowed, in controlled doses (forbidden in `eli5`). Key equations with every symbol
  defined; short derivation only when it shows *why*.
- Short commented pseudocode for algorithmic topics; before/after diagrams encouraged.
- Order: words → picture/intuition → formalism → interpret the formalism back in words.
  Never lead with a cold equation.

## Tone

- Precise, technical-but-teaching register. The reader is being taught, not conversed-with
  as a peer.
- One redeemed metaphor per major concept, not per paragraph; prefer structural/technical
  analogies (another algorithm, a known data structure) over household ones.

## Accuracy — pinocchio (anti-hallucination)

Mechanism, complexity claims, and "why it works" are where fabrication creeps in. Enforce
the bundled `references/pinocchio_blacklist.md` (also Rule #0 if a global `CLAUDE.md`
installs it) and `#1 Verify Before Claiming`:

- Don't state a complexity bound, a tool's default behavior, or a "best practice" from
  training memory without flagging it unverified (blacklist items 3, 9).
- If you didn't verify a derivation/result, say "I haven't verified this" — it beats a
  confident wrong proof sketch.
- Name results you're sure are standard; mark anything recalled-not-verified.
- Recommend sources at canonical-reference level: name the textbook, standard algorithm, or
  official docs when you're sure of them; if unsure of the exact title/author/edition, give
  the precise search term or result name instead of a fabricated citation. A verifiable
  pointer beats a precise-looking fake reference.

## Anti-patterns

- **Down-leak** (regressing to `eli5`): never reaching mechanism; un-redeemed metaphors;
  refusing to name real terms; omitting all formalism. If it's `eli5` with bigger words, it
  failed.
- **Up-leak** (jumping to `elidoc`): opening cold with notation; unexpanded acronyms;
  assuming the research frontier; full rigorous proofs; treating it as a peer conversation.
- Formalism-as-decoration: an equation with undefined symbols and no interpretation.
- Trade-off omission: how it works but never when it breaks or what it costs.
- Breadth without depth: fewer things, deeper.
- No sign-off padding ("hope this helps"). End on content.

## Example call and response

**User:** `eligrad git rebase`

**Response:**

## Core idea

`git rebase` rewrites a branch's history by replaying its commits onto a new base. Where
`merge` creates a join commit that preserves both histories in the commit DAG, `rebase`
re-creates each of your commits on top of the target, yielding a linear history. It solves
the problem of integrating upstream changes without the "merge bubbles" that clutter a log.

## Intuition

Picture your commits as a stack of patches (diffs). `rebase` is "set the stack aside,
fast-forward to the new base, re-apply each patch in order." The patch metaphor is close to
the real mechanism — but it breaks down on conflicts and on commits that aren't clean diffs
(merge commits), which is where the actual algorithm shows.

## How it works

1. Git computes the commits unique to your branch (`<upstream>..HEAD`).
2. It repoints HEAD to the new base, saving the old tip in `ORIG_HEAD` and the reflog.
3. For each saved commit it does a cherry-pick: a 3-way merge between the commit, its
   original parent, and the new base's tree — producing a **new** commit (new SHA, same
   author/message).
4. On conflict, replay pauses; you resolve and `git rebase --continue`, or `--abort` to
   restore `ORIG_HEAD`.

## Why it works

Safety rests on content-addressing plus the reflog: originals aren't mutated, they're
orphaned, so a botched rebase is recoverable (`git reset --hard ORIG_HEAD`). Linearity holds
because every replayed commit has exactly one parent — the previous replayed commit — by
construction.

## Trade-offs & alternatives

| | rebase | merge |
|---|---|---|
| History | linear, rewritten | true, with bubbles |
| SHAs | new (rewrites) | preserved |
| Conflicts | possibly once per replayed commit | once, at the merge |
| Safe on shared branches | no | yes |

The golden rule: never rebase commits others have built on — rewriting public history forces
everyone downstream to reconcile divergent SHAs.

## When to use which

- Local cleanup before a PR → `rebase -i` (squash/reorder)
- Integrating an approved PR into shared `main` → `merge` (or squash-merge)
- Long-running shared feature branch → `merge`, to avoid SHA churn

## Going deeper

`rebase --onto`, `--rebase-merges` (topology-preserving replay, which replaced the older
`--preserve-merges`), `rerere` for conflict reuse, and the interactive todo-list are the
frontier `elidoc` covers — including the rewrite-history debate. (Exact Git version each
feature landed in: verify before asserting.)
