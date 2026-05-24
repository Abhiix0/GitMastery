# Learner Guide

How to use this repo effectively.

---

## Picking a starting point

**Never used Git before?** Start at m01 and go in order through Phase 0.

**Know the basics but get confused by branches?** Jump to Phase 1 (m05).

**Comfortable with local Git but struggle with remotes and PRs?** Start at Phase 2 (m09).

**Want to level up on advanced stuff?** Phase 3 (m13) is for you.

If you're not sure, start at m01. The early modules are short and you can skip ahead once things feel obvious.

---

## How exercises work

Every module has three parts:

### 1. Guided Lab
A step-by-step walkthrough. Commands are given to you. The goal is to see the concept in action and understand what's happening at each step. Don't just copy-paste — read the explanations.

### 2. Challenge
You're given a goal and some hints, but not the exact commands. You have to figure out the steps yourself. This is where the learning actually sticks.

### 3. Challenge (advanced)
The challenge file has two parts: a standard unguided task, and a harder scenario at the end with no hints at all. That harder part is the "boss fight" — it's just not a separate file. These are designed to feel slightly uncomfortable — that's the point.

---

## How to verify your work

Each exercise includes a **verification section** at the bottom. It tells you exactly what to run and what the output should look like if you did it right.

Example:
```
Run: git log --oneline -3
Expected: three commits with messages matching the pattern described above
```

If your output doesn't match, re-read the exercise from the step where things diverged. Don't skip ahead.

---

## Tips

- **Use a throwaway repo for practice.** `git init practice-repo` and experiment freely.
- **Read error messages.** Git's errors are actually pretty descriptive once you know what to look for.
- **Don't memorize commands.** Understand what they do. The syntax comes naturally after that.
- **Stuck?** Open an issue with the `question` label. Include what you tried and what happened.

---

## What this repo is not

- Not a video course
- Not a certification program
- Not a replacement for actually using Git on real projects

The goal is to get you comfortable enough that Git stops being a source of anxiety. After that, real projects do the rest.
