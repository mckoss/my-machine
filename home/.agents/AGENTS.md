# Global working agreements

These are Mike's defaults for every coding agent (Claude Code, Codex,
Antigravity) in every repository. This one file is the source of truth:
`~/src/my-machine/home/.agents/AGENTS.md`, shared across machines via that
repo. `~/.agents/AGENTS.md`, `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`, and
`~/.gemini/GEMINI.md` are symlinks to it. Edit the repo file itself, then commit and push; some
tools replace a symlink with a plain file when they save through it. Run
`~/src/my-machine/bin/setup-agents` to relink.

A repository's own `AGENTS.md` (or `CLAUDE.md`/`GEMINI.md`) refines or
overrides these defaults. Read it before starting work in a repo — Claude Code
auto-loads only `CLAUDE.md`, so open `AGENTS.md` explicitly.

## Scope and confirmation

- Answering design or clarifying questions settles the design; it does not
 clear you to implement, commit, push, or remove a worktree. Treat each of
 those as its own gate unless the request already authorized it.
- "Can I…", "what's the command for…", or "how do I…" asks for the command.
 Give it and stop; run it only when told to.
- Ask one decision per question. Never take a single "yes" as the answer to two
 stacked questions.
- "Is it pushed?" or "is the tree clean?" means make it so: commit what belongs
 in the repo, push, and report the range. Still confirm separately before a
 force-push, deleting a branch, or rewriting history.
- For a risk that exists only once (a migration, a rename), verify it once and
 say so. Don't add a permanent guard unless the failure can recur.

## Commit messages

- Write a concise subject plus a short body explaining the purpose of the
 change and its user or developer impact. No title-only commits unless asked.
- When a commit bumps a version, state the exact new version in the body.

## Semantic versioning

Apply these defaults to any app or package that carries a version, unless the
repository says otherwise.

- The manifest version (for example `package.json`, `pyproject.toml`) is the
 single source of truth. Never hard-code the version elsewhere; read it from
 the manifest. If several files must carry it, update all of them together.
- Every PR, or every push to `main` in a repo that works direct-to-main, raises
 the version exactly once — not once per commit. Put the bump in the change's
 own commit or branch before pushing, not in a follow-up.
- PATCH for fixes and small changes, MINOR for new user-visible features
 (reset PATCH to 0), MAJOR only for breaking changes to a public API, data
 format, or configuration — or when Mike asks.
- Keep `package-lock.json` in sync in the same commit: after editing
 `package.json`, run `npm install --package-lock-only`, or use
 `npm version <patch|minor> --no-git-tag-version`.
- Before bumping, check the version on `main` and the last few merges so you
 don't reuse a number another branch already shipped. Two builds that report
 the same version cannot be told apart in production.
- Web apps should display the semver - usually in small text in header
 (e.g. v1.2.3).
- Don't create release tags by hand unless the repo's release process is
 tag-triggered; then tag `vX.Y.Z` on the merged commit as it documents.
- When committing to the main branch - inform the user which semver to look for in the UI.

## Branching and PR workflow

- **Small, low-risk changes** may go straight to `main` in the primary
 checkout, unless `main` is protected or the repo requires another workflow.
 Run the relevant tests, commit, and push without waiting for another prompt;
 report and monitor CI as described below.
- **Non-trivial changes** go in a separate git worktree on a feature branch.
 Never check out a feature branch in the primary checkout; a dev server or
 another long-running process usually runs there.
- Create worktrees as siblings of the primary checkout, named from the repo and
 feature (for example `../dark-towers-feature`). Never put them in temporary
 directories.
- Some repos need local, gitignored data to run tests. Follow their instructions
 to symlink it into the worktree; verify the source and destination first, and
 never commit the symlink, the ignored data, or secrets.
- Before publishing, run all relevant tests and checks locally. **Once local
 checks are green, merge the PR to `main` by default:** commit, push the
 branch, open or update its PR, and merge it without waiting for remote CI or
 another prompt. If branch protection requires remote checks first, queue it
 with `gh pr merge --squash --auto`. Hold off only when Mike asked to review
 first or the repo says otherwise. Never merge on red or skipped local checks.
- Squash merge is the normal strategy unless the repo requires another.
- **Report the push right away, then watch CI asynchronously.** As soon as the
 merge or push lands, tell Mike what was pushed: the PR, the merged commit
 (range), the new version to look for in the UI, and a one-line summary. Then
 start a background monitor of GitHub CI and any production deployment for
 that exact commit (for example `gh run watch <id> --exit-status` run in the
 background) and keep taking new prompts. Never hold a reply or the next task
 on it. When it finishes, report the result in a short follow-up; if it
 fails, say so with the evidence and fix it.
- **Clean up in the same session, as part of the merge:** remove the worktree
 (`git worktree remove <path>`), delete the local and remote branches, and run
 `git fetch --prune`. Merging isn't done until this is done. Don't use
 `gh pr merge --delete-branch`; it tries to check out `main` in the primary
 checkout.
- **Audit for strays when starting work in a repo.** Run `git worktree list`;
 only the primary checkout and branches in flight should appear. Remove a
 leftover whose tree is clean and whose work is verifiably on `main`; if it
 holds uncommitted changes or unmerged work, ask instead of deleting.
- To tell whether a stale branch holds unmerged work, don't trust ahead/behind
 counts or `git cherry` — squash merges defeat both. Run
 `git merge-tree --write-tree main <branch>`, then `git diff main <result>`; if
 it only re-adds code already on `main`, the branch is safe to delete.
- Every GitHub repo should have automatic head-branch deletion on. If it is off,
 enable it:
 `gh api -X PATCH repos/{owner}/{repo} -f delete_branch_on_merge=true`.

## GitHub issue workflow

- Fix each issue in its own commit; never combine issues in one commit.
- Reference the issue in the commit message with a `Refs #<n>` trailer or
 `(#<n>)` in the subject.
- After committing, apply the `Implemented` label to the issue, creating the
 label first if the repo lacks it.
- Do not close the issue. Mike closes it after verifying the fix.

## Railway deployments

- GitHub is the deployment control plane for Railway-hosted projects. Learn
 each project's trigger from its repo instructions and config: some deploy on
 pushes to a branch, others on a release tag.
- After pushing a deploying branch or tag, monitor GitHub CI, the Railway
 deployment record, and the production health signal for the exact commit.
 Report when production is ready, or report the failure with evidence. CI
 passing does not mean the change is live.
- Don't use the Railway CLI unless Mike explicitly asks.
- Never assume the locally linked Railway project matches the current repo.
 Before any requested Railway CLI action, verify the project, service,
 environment, and connected GitHub repo; prefer explicit IDs and stop if they
 don't match.

## Long autonomous sessions

- When Mike is away (for example overnight), act as project manager: keep a
 `CHECKLIST.md`, farm coding to parallel subagents on disjoint files, and
 collect questions in `QUESTIONS.md` rather than blocking. Open the summary
 with checklist status versus what actually got done.

