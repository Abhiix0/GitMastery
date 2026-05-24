# Git Basics Cheatsheet

Quick command reference. One line per command. No fluff.

---

## Setup

```bash
git --version                              # confirm Git is installed
git config --global user.name "Name"       # set your display name
git config --global user.email "e@mail"    # set your email
git config --global --list                 # view all global config
git config --local user.email "e@mail"     # override config for one repo
```

---

## Init & Clone

```bash
git init                                   # start a new repo in current folder
git clone <url>                            # copy a remote repo locally
git clone <url> my-folder                  # clone into a specific folder name
git remote -v                              # list configured remotes
git remote add origin <url>               # add a remote called origin
```

---

## Staging & Committing

```bash
git status                                 # show what's changed and what's staged
git add <file>                             # stage a specific file
git add .                                  # stage everything in the current directory
git add -p                                 # stage changes interactively (chunk by chunk)
git restore --staged <file>               # unstage a file without losing changes
git commit -m "message"                    # commit staged changes with a message
git commit --amend -m "new message"        # rewrite the last commit message (unpushed only)
git commit --amend --no-edit              # add staged changes to the last commit, keep message
```

---

## History

```bash
git log                                    # full commit history
git log --oneline                          # one commit per line
git log --oneline --graph                  # visual branch diagram
git log --all --oneline --graph            # same, includes all branches
git log --oneline -10                      # last 10 commits only
git log --oneline -- <file>               # history for a specific file
git log --follow --oneline <file>         # history through file renames
git log -S "term"                          # commits that added/removed "term"
git log -G "regex"                         # commits whose diff matches a regex
git show <hash>                            # full details of a specific commit
git diff                                   # unstaged changes vs last commit
git diff --staged                          # staged changes vs last commit
git diff HEAD~1                            # current commit vs previous commit
git diff <branch1>..<branch2>             # diff between two branches
git blame <file>                           # who changed each line and when
git blame -L 10,25 <file>                 # blame a specific line range
```

---

## Undoing Things

```bash
git restore <file>                         # discard unstaged changes to a file ⚠️ irreversible
git restore --staged <file>               # unstage without losing changes
git reset --soft HEAD~1                    # undo last commit, keep changes staged
git reset --mixed HEAD~1                   # undo last commit, keep changes unstaged (default)
git reset --hard HEAD~1                    # undo last commit, discard changes ⚠️ destructive
git revert <hash>                          # create a new commit that undoes a past commit (safe)
git reflog                                 # log of everywhere HEAD has been — recovery lifeline
git stash                                  # shelve uncommitted changes temporarily
git stash push -m "label"                 # stash with a description
git stash list                             # show all stashes
git stash pop                              # restore most recent stash and remove it
git stash apply                            # restore most recent stash, keep it in list
git stash drop stash@{0}                  # delete a specific stash
```

---

## Branches

```bash
git branch                                 # list local branches
git branch -a                              # list local and remote branches
git branch <name>                          # create a branch (don't switch)
git checkout <name>                        # switch to a branch
git checkout -b <name>                     # create and switch in one step
git switch <name>                          # switch branches (Git 2.23+)
git switch -c <name>                       # create and switch (Git 2.23+)
git merge <branch>                         # merge a branch into current (fast-forward if possible)
git merge --no-ff <branch> -m "msg"       # merge with a merge commit (preserves branch in graph)
git merge --squash <branch>               # stage all branch changes as one commit (then commit manually)
git merge --abort                          # cancel a merge in progress
git branch --delete <name>                # delete a merged branch
git branch -D <name>                       # force-delete an unmerged branch ⚠️
git branch --move <old> <new>             # rename a branch
```

---

## Remotes

```bash
git push origin <branch>                  # push a branch to origin
git push -u origin <branch>              # push and set up tracking
git push --tags                            # push all tags
git push origin --delete <branch>         # delete a remote branch
git pull                                   # fetch + merge from tracked remote
git pull origin <branch>                  # pull a specific branch
git fetch origin                           # download remote changes without merging
git fetch --all                            # fetch from all remotes
```

---

## Rebase

```bash
git rebase <branch>                        # replay current branch commits onto <branch>
git rebase -i HEAD~N                       # interactive rebase of last N commits
git rebase --continue                      # continue after resolving a conflict
git rebase --skip                          # skip the current conflicting commit
git rebase --abort                         # cancel the rebase entirely
```

---

## Tags

```bash
git tag                                    # list all tags
git tag v1.0                               # create a lightweight tag at HEAD
git tag -a v1.0 -m "message"             # create an annotated tag
git tag -a v1.0 <hash>                    # tag a specific past commit
git show v1.0                              # show tag details
git push origin v1.0                       # push a single tag
git push --tags                            # push all tags
git tag --delete v1.0                      # delete a tag locally
git push origin --delete v1.0             # delete a tag on the remote
```

---

## Bisect

```bash
git bisect start                           # begin a bisect session
git bisect bad                             # mark current commit as broken
git bisect good <hash>                     # mark a known-good commit
git bisect good                            # mark current checkout as good
git bisect bad                             # mark current checkout as bad
git bisect run <script>                    # automate with a test script
git bisect reset                           # end bisect, return to HEAD
```
