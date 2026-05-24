# Lab — Git identity setup

**Working directory:** `sandbox/stack-overflown/`

---

## Steps

**1. Open a terminal in the `sandbox/stack-overflown/` folder.**

**2. Check your Git version:**
```bash
git --version
```

**3. Check if identity is already set:**
```bash
git config --global --list
```
If you see `user.name` and `user.email` in the output, you're already configured. Still run through the steps below to know how it works.

**4. Set your name:**
```bash
git config --global user.name "Your Name"
```

**5. Set your email:**
```bash
git config --global user.email "you@example.com"
```

**6. Confirm both are set:**
```bash
git config --global --list
```

**7. Check what editor Git will use for commit messages:**
```bash
git config --global core.editor
```
If nothing comes back, Git will use the system default (usually `vi` or `nano`). You can set it explicitly — e.g. `git config --global core.editor "code --wait"` for VS Code.

---

## Verification

Run `git config --global --list` — you should see `user.name` and `user.email` in the output.
