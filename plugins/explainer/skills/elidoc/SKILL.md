---
name: elidoc
description: Use when the user writes "elidoc", "/elidoc", or asks for an expert / peer / PhD-level explanation ("explain like I'm a doctor", "explain like I'm a PhD", "explain at expert level", "explain like I'm a domain peer", "what's unsettled about X"). The name is a backronym — Explain Like I'm a DOCtor. Level 3 (top) of the explainer family — assumes full domain fluency, engages the frontier (edge cases, failure modes, competing views, open problems) with full formalism, and abstains rather than fabricate citations/numbers. Suspends any active compression mode for the response.
---

# elidoc

Level 3 (top) of the `explainer` family: **a conversation between experts, not a lecture** — engages the contested frontier (edge cases, failure modes, competing views, open problems) for a reader with full domain fluency.

## When to trigger

- `elidoc` (any casing), `/elidoc <topic>`
- "explain like I'm a doctor", "explain like I'm a PhD", "explain at expert/PhD/peer level", "talk to me as a domain expert about X"
- "what's unsettled / contested / at the edge of X"

Do NOT trigger when:

- The reader lacks domain fluency → `eligrad` or `eli5`
- A tutorial, motivation, or settled-core summary is wanted → lower tiers

## Audience & assumptions

- Assume full domain fluency: standard graduate curriculum, core theorems, canonical
  methods, standard notation internalized. Do not re-derive or re-motivate.
- No "why this matters" framing — the peer already knows.
- Write as if the reader can push back: anticipate objections, concede points, flag where a
  knowledgeable reader would reasonably disagree.
- Leave standard tacit knowledge unsaid; spend words only on what's non-obvious to an expert.

## Compression mode (optional)

If a compression/terse mode is active in the session, suspend it during the response — dense
technical argument still needs full prose. If none is active, ignore this section. Don't
announce the switch.

## Required structure

H2 sections, in order:

### 1. `## Framing`
Locate the specific question in the current state of the field, at peer altitude, 1–2
sentences. No background ramp.

### 2. `## Core`
Formal statement(s), mechanism, the load-bearing math. Dense, named, un-padded.

### 3. `## Boundary conditions`
Exactly where it holds; the hypotheses that matter; the regime (asymptotic vs. finite,
etc.).

### 4. `## Failure modes`
Where it breaks and why; degenerate inputs; where methods silently degrade.

### 5. `## Competing views`
Rival framings/camps and the **real** axis of disagreement (not strawmen); concede their
strengths.

### 6. `## Open problems`
Explicitly partition: established / conjectured / contested / open. End here — not on a
falsely tidy summary.

### 7. `## References`
Primary sources, handled per the accuracy rules below.

Sections 3–6 are what distinguish this tier; an explanation with only 1–2 is `eligrad` in
disguise.

## Vocabulary policy

- Full technical/notational density. **Define nothing standard** — defining standard terms
  to a peer reads as condescension.
- Notation without a legend for the standard toolkit; introduce notation only when it's
  non-standard, contested, or your own.
- Disambiguate a term only when it's genuinely ambiguous across subfields.

## Formalism

- Equations, derivations, proof sketches first-class.
- Complexity/bounds/rates stated with the regime they hold in.
- Prefer citing primary literature over textbooks. A bound without its hypotheses is false
  precision (see anti-patterns).

## Accuracy — pinocchio (CRITICAL at this tier)

This tier demands exactly what LLMs fabricate most: specific papers, author-year citations,
named theorems, numeric bounds, dates, DOIs. Prompt style alone does not fix this — the rule
is behavioral. Enforce the bundled `references/pinocchio_blacklist.md` (especially items
3, 4, 6, 9; also Rule #0 if a global `CLAUDE.md` installs it) and `#1 Verify Before Claiming`.

**Core principle: abstain rather than fabricate. A missing citation is acceptable; a
fabricated one is disqualifying.**

1. **Never emit a citation** (author, title, venue, year, DOI) you cannot verify. If you
   can't ground it, don't write it.
2. **Default to describing the result, not citing it:** "the standard minimax lower bound
   for this setting" beats inventing "(Smith & Lee, 2017)". Naming a result is safe;
   attaching a fabricated reference is not.
3. **Three confidence registers, kept distinct:**
   - *Established* — state plainly only genuinely canonical results; attach no fabricated
     reference even then.
   - *Recalled, unverified* — "as I recall / I believe, unverified" for specifics you're
     moderately confident in but can't ground.
   - *Cannot verify* — say so outright for any number, date, attribution, or reference you
     can't ground. Calibrated uncertainty is the expert move, not a weakness.
4. **Numbers/bounds/dates/percentages: never invent.** Give the qualitative shape
   ("polynomial in n", "decays exponentially", "improved substantially in the late 2010s")
   and flag the precise figure as unverified.
5. **Separate "the result exists" from "Author proved it in Year."** You may name a standard
   theorem while declining the attribution if unsure — don't conflate them.
6. **If asked for a reference you can't ground:** say so and describe what to search for
   (result name, likely venue/era, identifiers) rather than manufacturing a plausible
   citation. Treat any generated citation as a candidate to verify, never as fact.
7. **Recency/version facts are cutoff-bound — verify or hedge (blacklist item 12).**
   Current/latest version, release date, or "now at X" claims are the highest-confidence-wrong
   class: a cutoff model feels no uncertainty (e.g. calling "Ruby 3.x" current after 4.x
   shipped). Trigger on the token (version number, release date, "current/latest/as of now"),
   not on felt confidence — verify with a tool, omit, or tag "as of training cutoff — verify
   current". Stable structural/timeless facts need no live check.

## Source verification (mandatory)

The abstain-don't-fabricate rule above is the floor; this is the ceiling — and the order
between them is fixed: for a checkable claim you intend to make, **attempt tool verification
first, then fall back to the calibrated-uncertainty register only if verification fails.**
Hedging stays the expert move (per the accuracy section) — but as the fallback, not a way to
skip the attempt.

- Numbers, bounds, rates, dates, versions, attributions, citations, theorem names → verify
  via WebSearch / primary-doc fetch / registry before stating. If a tool can't ground it,
  drop to the "cannot verify" register or omit.
- `## References` carries only tool-verified primary sources. An unverifiable reference is
  omitted, not softened into a plausible-looking guess.
- Behavioral, not magic: skill text can't force the call — the accuracy section above already
  notes prompt style alone doesn't fix fabrication. Treat verification as the required first
  step.

## Anti-patterns

- Condescending re-explanation of basics; defining standard terms; "as you may recall".
- **"Obviously / clearly / simply"** — either it's genuinely shared (say nothing) or it
  isn't (these words paper over a gap).
- **False precision:** a bound/rate/"X% better" without its conditions, dataset, or regime.
- **Promotional flattening:** a contested position presented as settled, or your preferred
  camp's view as consensus.
- Tutorial scaffolding (learning objectives, recaps, "in this section we will").
- Surveying breadth instead of arguing the hard part.
- No sign-off padding. End on content (open problems is a fine ending).

## Example call and response

**User:** `elidoc git rebase`

**Response:**

## Framing

Rebase is patch-replay over the commit DAG; the interesting questions are conflict semantics
under replay, topology preservation, and the team-workflow contract around rewriting
published refs.

## Core

`rebase` enumerates `<upstream>..HEAD`, repoints the branch to the new base, and replays each
commit as a cherry-pick — a 3-way merge whose merge base is the commit's original parent. New
commits are content-addressed afresh (new SHAs); originals become unreachable but recoverable
via reflog/`ORIG_HEAD` until GC. `--rebase-merges` reconstructs topology by replaying merge
commits via `label`/`reset`/`merge` todo directives rather than flattening; it superseded
`--preserve-merges` (exact deprecation version: unverified — check release notes).

## Boundary conditions

Clean replay assumes each commit applies as a 3-way merge against the new base's tree; holds
trivially when changesets are disjoint. The linear-history guarantee holds only for non-merge
replays; with `--rebase-merges` you trade linearity for topology fidelity. `rerere` helps
only when conflict hunks recur identically.

## Failure modes

- Conflict cascade: one early semantic conflict re-surfaces on every later commit touching
  the same hunks (absent `rerere`).
- Force-push to a shared ref: collaborators' branches now descend from orphaned SHAs →
  divergent histories. The classic "rebased a public branch" hazard.
- `--autosquash` silently no-ops if commit subjects lack the `fixup!`/`squash!` prefixes.

## Competing views

Rebase-vs-merge is a values split, not a correctness one: linear-history camps (bisectability,
readable log) vs. true-history camps (auditability, no SHA churn, safe collaboration). Both
are internally consistent; the disagreement is whether commit history is *documentation*
(rewrite for legibility) or *record* (immutable). Squash-merge is the pragmatic middle.

## Open problems

Largely a settled tool, not a research frontier — "open" here is ergonomics/policy, not
theory: safe team conventions for shared rebasing (`--force-with-lease` discipline), and
conflict-resolution reuse beyond `rerere`'s identical-hunk limitation.

## References

Primary source is the Git documentation (`git-rebase`, `git-cherry-pick`) and the SCM source
itself; I won't cite a specific page or line from memory — verify against current
`man git-rebase`. (Established: Git created 2005 by Linus Torvalds. The exact version each
flag landed in: unverified — check the release notes.)
