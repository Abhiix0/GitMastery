# Contributing to GitMastery

Thanks for wanting to help. Here's everything you need to know.

---

## What you can contribute

- A new learning module
- A fix to broken or incorrect content
- A new scenario or boss fight
- Typo/grammar fixes (yes, these matter)

---

## Folder structure

Each module lives in its own folder under `modules/`:

```
modules/
  m01-init-and-clone/
    README.md          ← module overview and learning goals
    guided-lab.md      ← step-by-step walkthrough
    challenge.md       ← do it yourself
    boss-fight.md      ← no hints, real scenario
    assets/            ← diagrams, screenshots (optional)
```

---

## Naming conventions

Modules use the format `mNN-slug`:

- `NN` is a zero-padded number: `m01`, `m02`, ... `m16`
- `slug` is lowercase, hyphen-separated, descriptive: `init-and-clone`, `merge-conflicts`
- No spaces, no uppercase, no underscores

Examples:
- ✅ `m03-branching-basics`
- ❌ `Module3_Branching`
- ❌ `m3-Branching Basics`

---

## How to open a PR

1. Fork the repo
2. Create a branch: `git checkout -b add/m05-rebasing`
3. Make your changes
4. Push and open a PR against `main`
5. Fill out the PR template — it's short, just do it

One module or fix per PR. Don't bundle unrelated changes.

---

## Tone guide

GitMastery content is:

- **Casual** — write like you're explaining to a friend, not writing a textbook
- **Direct** — say what you mean, skip the preamble
- **No fluff** — cut anything that doesn't help the learner do the thing
- **Honest** — if something is confusing, say so and explain why

What to avoid:
- "In this section, we will explore..." → just start explaining
- "It's important to note that..." → just say the thing
- Passive voice where active works fine
- Jargon without a quick definition on first use

---

## Questions?

Open an issue with the `question` label. No question is too basic.
