# Version — Deep Reference

## Semver Bump Rules

| Bump | Rule | Example commit |
|------|------|----------------|
| **major** | Breaking API/schema change | `feat!: drop legacy sync endpoint` |
| **minor** | New feature, backward-compatible | `feat: add B12 schedule screen` |
| **patch** | Bug fix, refactor, style, chore | `fix: theme color regression` |

The highest severity across all commits for a package wins. One `feat` among ten `fix` commits → **minor** bump.

## Conventional Commit Parsing

Extract type from subject line using: `^(\w+)(\(.+\))?(!)?:\s`

- Group 1: type (`feat`, `fix`, `refactor`, etc.)
- Group 3: `!` = breaking change
- Body: scan for line starting with `BREAKING CHANGE:` or `BREAKING-CHANGE:`

## Build Number Logic

The `+N` suffix is the Android `versionCode`.

- Read: `grep '^version:' pubspec.yaml` → extract digits after `+`
- Increment by 1 on every release, regardless of semver bump type
- `sorgvry_shared` has no `+N` and never gets one

Example: `0.1.0+1` with minor bump → `0.2.0+2`

## Path-to-Package Mapping

| Path prefix | Package | pubspec.yaml |
|-------------|---------|-------------|
| `app/` | sorgvry | `app/pubspec.yaml` |
| `backend/` | sorgvry_backend | `backend/pubspec.yaml` |
| `packages/sorgvry_shared/` | sorgvry_shared | `packages/sorgvry_shared/pubspec.yaml` |
| `docs/`, `.claude/`, `.gitignore`, `melos.yaml`, `*.sh`, root configs | (none) | skip |

## Tag Format

Single unified tag from the app version: `v{major}.{minor}.{patch}`

No per-package tags. The tag represents the mono-repo state at release time.

## First Release (No Prior Tags)

When `git tag -l 'v*'` returns nothing:

1. Use `git rev-list --max-parents=0 HEAD` as the base
2. All commits from initial to HEAD are analyzed
3. Expected to produce a large changeset — the summary table still applies

## Changelog Format

Single root `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/):

```markdown
# Changelog

## [v0.2.0] - 2026-03-29

### app
#### Added
- Redesign meds screen with dosage details (d1a3f25)

#### Fixed
- Replace hardcoded Colors.blue with theme colors (f37ff7b)

### backend
#### Changed
- Extract shared middleware (abc1234)

### sorgvry_shared
#### Added
- Add medication schedule tables (def5678)
```

### Commit Type → Changelog Section

| Commit type | Section |
|-------------|---------|
| `feat` | Added |
| `fix` | Fixed |
| `refactor`, `perf` | Changed |
| `style`, `chore`, `docs`, `test` | omit (include under Maintenance if user requests) |
| breaking | prefix entry with **BREAKING**: |

## Edge Cases

| Situation | Handling |
|-----------|----------|
| Commit touches multiple packages | Count toward ALL matched packages |
| Commit touches only root/docs | No package bumped |
| All commits are chore/docs type | Patch bump for touched packages |
| User requests override in step 7 | Re-present table with adjusted bumps, re-confirm |
| pubspec.yaml has no version line | Error — inform user, skip package |
| Merge commits | Include — they carry file changes |
| `--dry-run` flag | Stop after summary table (step 6), no modifications |
| Existing CHANGELOG.md | Prepend new version section below the `# Changelog` header |

## Git Commands Reference

```bash
# Find last version tag
git tag -l 'v*' --sort=-v:refname | head -1

# Get initial commit (fallback)
git rev-list --max-parents=0 HEAD

# List commits with files since base
git log <base>..HEAD --format="COMMIT:%H|||%s|||%b" --name-only

# Create local tag
git tag v0.2.0

# Push tag (user action, never automated)
git push origin v0.2.0
```
