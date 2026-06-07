# explainer

A reusable template for Claude Code with two purposes: **explain well at the right level**
(the `explainer` family of skills, starting with `eli5`) and **don't lie** (conduct rules +
a catalog of failure modes). Designed to plug into **any project, by anyone, in any
language** — no dependency on stack, repo or domain.

The `explainer` family scales across abstraction levels. Each name is a backronym of
*Explain Like I'm…*:

- **`eli5`** — **E**xplain **L**ike **I**'m **5** (a five-year-old): basic, metaphor, no jargon.
- **`eligrad`** — **E**xplain **L**ike **I**'m **GRAD**uated: graduate level, mechanism + trade-offs.
- **`elidoc`** — **E**xplain **L**ike **I**'m a **DOC**tor (PhD): expert/peer, frontier + full formalism.

Each level is its own drop-in skill. The anti-lie layer (`pinocchio_blacklist.md`) is the
single source of truth at the repo root, copied into each skill's `references/` by
`sync-references.sh` so every skill is self-contained (see [Structure](#structure)).

All content is generic and **prescriptive**: it describes failure modes to avoid, applicable
to any stack or domain.

## Structure

```
explainer/                              # repo root = plugin marketplace
├── README.md
├── LICENSE                             # MIT
├── CLAUDE.md                           # conduct rules: blacklist (#0) + #1/#1.5/#2/#3
├── pinocchio_blacklist.md              # CANONICAL anti-lie reference (single source of truth)
├── sync-references.sh                  # copies the canonical file into each skill's references/
├── .claude-plugin/
│   └── marketplace.json                # marketplace catalog → points at plugins/explainer
└── plugins/
    └── explainer/                      # the plugin (bundles all three skills)
        ├── .claude-plugin/
        │   └── plugin.json
        └── skills/
            ├── eli5/
            │   ├── SKILL.md            # level 1: basic (metaphor, no jargon)
            │   └── references/
            │       └── pinocchio_blacklist.md   # synced copy
            ├── eligrad/
            │   ├── SKILL.md            # level 2: graduate (mechanism + trade-offs)
            │   └── references/
            │       └── pinocchio_blacklist.md   # synced copy
            └── elidoc/
                ├── SKILL.md            # level 3: expert/peer (frontier, full formalism)
                └── references/
                    └── pinocchio_blacklist.md   # synced copy
```

**Why three copies of the blacklist?** A Claude Code skill can only load files inside its
own directory — there is no supported way for `SKILL.md` to read a file at the plugin root.
So the canonical `pinocchio_blacklist.md` at the repo root is the single source of truth, and
`sync-references.sh` propagates it into each skill's `references/`. Edit the root file, then
run the script. (Verified against the official plugins docs: files outside a plugin's own
directory aren't copied to the install cache, so the repo-root copy can't be referenced
post-install; and `${CLAUDE_PLUGIN_ROOT}` expands only in hook / MCP / LSP / monitor command
strings, never in skill body prose.)

## The pieces

All three skills live under `plugins/explainer/skills/<name>/SKILL.md`:

- **`eli5` (level 1 — basic)** — three layers (what it is / metaphor / history),
  concrete metaphor, zero jargon. Bloom: Remember/Understand.
- **`eligrad` (level 2 — graduate)** — teaches mechanism and trade-offs, introduces
  real terminology (defined on first use), controlled formalism. Assumes foundational
  background. Bloom: Understand/Apply/Analyze.
- **`elidoc` (level 3 — expert/peer)** — engages the frontier (edge cases, failure
  modes, competing views, open problems) at full notational density. Assumes domain fluency.
  Its accuracy section is the strictest: **abstain rather than fabricate citations/numbers**.
- All three suspend any active compression mode during the response, and route their factual
  claims through their bundled `references/pinocchio_blacklist.md` (the higher the tier, the
  more technical the claims and the heavier the anti-hallucination discipline).
- **`pinocchio_blacklist.md` (anti-lie accessory)** — 11 AI-agent failure modes that
  produce false or inflated claims (opinion dressed as a bug, "I verified" without reading,
  best-practice from training memory, paraphrasing errors instead of quoting, inflating a
  PR/ticket, overengineering as diagnosis…).
- **`CLAUDE.md` (glue)** — conduct rules. **Rule #0** requires consulting the blacklist
  before asserting/recommending/reviewing; without it the catalog is inert. Also
  `#1 Verify Before Claiming`, `#1.5 Never Leak Secrets`, `#2 Evaluate, Don't Just Agree`,
  `#3 Communicate Step by Step`.

## Install

### Option A — plugin marketplace (one command per step)

Skills install as a single bundled plugin. From inside Claude Code:

```
/plugin marketplace add hobsyllwin5/explainer
/plugin install explainer@explainer
```

This installs all three skills (`eli5` / `eligrad` / `elidoc`); each carries its own bundled
`pinocchio_blacklist.md`, so they are self-contained. The plugin does **not** install the
global `CLAUDE.md` conduct rules — copy those manually if you want Rule #0 enforced globally
(see Option B's last two lines).

> Before publishing: run `./sync-references.sh` so the per-skill `references/` copies are
> up to date, then commit.

### Option B — manual copy

```bash
# explainer skills (install the levels you want), with their bundled reference
for lvl in eli5 eligrad elidoc; do
  cp -r plugins/explainer/skills/$lvl ~/.claude/skills/$lvl
done

# global rules
cp CLAUDE.md ~/.claude/CLAUDE.md

# blacklist — Rule #0 defaults to the path below
cp pinocchio_blacklist.md ~/.claude/pinocchio_blacklist.md
```

Rule #0 in `CLAUDE.md` already points at the `cp` target above
(`~/.claude/pinocchio_blacklist.md`). Only edit it if you installed the file elsewhere —
in that case, swap the backticked string on the Rule #0 line:

```
# on the Rule #0 line, change only this string:
~/.claude/pinocchio_blacklist.md   →   <your/path/to/pinocchio_blacklist.md>
```

## Notes

- The `eli5`/`eligrad`/`elidoc` skills, `CLAUDE.md` and `pinocchio_blacklist.md` are generic
  and self-contained.
- The frontmatter (`name`, `description`, `metadata`) of `pinocchio_blacklist.md` follows
  the Claude Code memory-file convention. If you don't use that system, the fields are
  **inert** — the file works as plain reference markdown. The slug `name: pinocchio-blacklist`
  (kebab-case) is the logical ID; the filename (`pinocchio_blacklist.md`) may differ from
  the slug without issue.

## License

MIT — see [`LICENSE`](LICENSE).
