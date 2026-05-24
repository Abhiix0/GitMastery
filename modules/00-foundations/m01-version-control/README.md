# m01-version-control

## What's this about

Before you can use Git, you need to know it's installed and tell it who you are. This module covers the two-minute setup that every Git workflow depends on — checking your version and configuring your identity.

---

## The concept

Git is a **distributed version control system**. Every developer has a full copy of the project history, not just the latest snapshot. That means you can work offline, experiment freely, and collaborate without stepping on each other.

If you've ever done any of these, Git is for you:

- Named files `project-final-v2-REAL.zip`
- Said "it was working yesterday, I didn't change anything" (you did)
- Emailed yourself a backup before making changes
- Waited for someone to "unlock" a shared file

### How Git is used

Git runs everywhere — pick whatever fits your workflow:

- **CLI** — the original, most powerful option. Everything else is built on top of it.
- **Code editors** — VS Code, JetBrains, Xcode all have built-in Git support.
- **Hosting services** — GitHub, GitLab, Bitbucket. Where teams collaborate.
- **Desktop apps** — GitHub Desktop, GitKraken, Sourcetree if you prefer a GUI.

### Key commands this module

| Command | What it does |
|---|---|
| `git --version` | Confirm Git is installed |
| `git --help` | Show available commands |
| `git config --global user.name "..."` | Set your display name |
| `git config --global user.email "..."` | Set your email |
| `git config --global --list` | Verify your config |

---

## Lab

### Activity 1: Check your Git installation

Open a terminal and confirm Git is installed:

```bash
git --version
```

You should see something like `git version 2.x.x`. If you get "command not found", Git isn't installed — grab it from [git-scm.com](https://git-scm.com).

Browse the help docs to get a feel for what's available:

```bash
git --help
```

### Activity 2: Set your identity

Git tags every commit with your name and email. Set them once globally and you're done.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

> If you use GitHub and want to keep your personal email private, enable your [noreply address](https://github.com/settings/emails) and use that instead.

Confirm it saved correctly:

```bash
git config --global --list
```

You should see `user.name` and `user.email` in the output.

> **Per-project override:** Working with multiple accounts? Use `--local` instead of `--global` inside a repo to set different credentials just for that project.

---

## Challenge

Open the `sandbox/stack-overflown/` folder and pretend you're setting up Git on a fresh machine before contributing to the game. Without looking at the lab steps, verify Git is installed, check what version you're running, and configure a name and email. Then confirm your config looks right. No step-by-step — just do it from memory. If you get stuck, `git --help` is fair game.

---

## What's next

→ [m02-first-repository](../m02-first-repository/README.md) — initialize a repo, stage files, and make your first commit.

---

**Difficulty:** 🟢 Beginner | **Est. time:** 20 min | **Skills:** `git config`, `git --version`
