# Solution — m01

> **Try the challenge yourself first.** Seriously — it takes two minutes and you'll remember it better.

---

## Answer

Inside the repo you want to configure differently:

```bash
git config --local user.name "Project Name"
git config --local user.email "project@example.com"
```

Confirm it worked:
```bash
git config --local --list
```

## Why this works

Git has three config levels: `--system` (machine-wide), `--global` (your user account), and `--local` (the current repo only).

`--local` writes to `.git/config` inside the repo. Git reads configs from all three levels and the more specific one wins — so `--local` overrides `--global` for that repo only. Your global identity is untouched everywhere else.

You can verify the layering with:
```bash
git config --list --show-origin
```
This shows every config value and exactly which file it came from.
