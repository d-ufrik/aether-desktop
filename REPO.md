# aether-desktop — Repo Rules

## Purpose

This repo is the public distribution point for Aether Desktop.  
It contains exactly three things:

1. `README.md` — the user-facing project description
2. `install.sh` — the YOLO installer script (mirrored from the source repo)
3. GitHub Releases — one per version, with release notes and the `.dmg` attached

**No source code lives here. No build scripts beyond `install.sh`. No internal docs.**  
The source lives in the private monorepo. This repo is what the public sees.

### Two install URLs

The installer is intentionally available from two sources:

| URL | Purpose |
|---|---|
| `https://aether-models.ufrik.com/desktop/macos/install.sh` | Primary CDN path (R2). Used by the automated pipeline. |
| `https://raw.githubusercontent.com/d-ufrik/aether-desktop/main/install.sh` | GitHub mirror. Acts as a trusted, auditable fallback. |

Both scripts are identical. When updating `install.sh`, update it in both places:
1. `packaging/macos/install.sh` in the source repo (source of truth)
2. `install.sh` in this repo (copy it here and push)

---

## What goes in a release

Every release must have:

| Item | Details |
|---|---|
| **Tag** | `v0.3.x.x` — matches the version in `latest.xml` and the DMG filename |
| **Title** | `Aether Desktop v0.3.x.x` |
| **Release notes** | Plain English. What changed, what was fixed, what is new. Copied and condensed from `backend/standalone/CHANGELOG.md` in the source repo. No internal paths, no NAS references, no developer jargon. |
| **DMG asset** | `Aether-0.3.x.x-arm64.dmg` — the signed build artifact |

Releases should be marked **Pre-release** until the product reaches a stable public milestone.

---

## What does NOT go here

- Source code of any kind (Rust, Swift, TypeScript, shell scripts)
- Internal documentation (build logs, runbooks, design docs)
- Config files, CI workflows, wrangler configs
- Partial or unsigned builds
- Hotfixes pushed without a DMG

If it is not the README or a release artifact, it does not belong here.

---

## Release workflow

A GitHub Release is created **once per version, when the DMG is published to R2**. Do not create a release for every internal build or text-only change. The bar is: **a new DMG was built, uploaded to R2, and validated**.

### What triggers a GitHub Release

| Triggers a release | Does NOT trigger a release |
|---|---|
| New DMG built and uploaded to R2 | Changelog text fix |
| New feature or bug fix shipped | README wording update |
| New local model added to catalog | `install.sh` update (push to main, no release) |
| Version bump in `Cargo.toml` | Documentation-only commit |

### How to publish a release

1. Build, validate, and upload the DMG to R2 (the normal build pipeline).

2. Run from the source repo:
   ```bash
   # Copy condensed release notes from backend/standalone/CHANGELOG.md
   gh release create v0.3.x.x \
     /path/to/Aether-0.3.x.x-arm64.dmg \
     --repo d-ufrik/aether-desktop \
     --title "Aether Desktop 0.3.x.x Beta" \
     --prerelease \
     --notes "$(cat notes.md)"
   ```

3. Release notes format (keep it user-facing — no internal paths, no NAS references, no dev jargon):
   ```markdown
   ## What's new

   - **Feature name** — one sentence description.
   - **Bug fix** — what the user experienced before and what works now.

   ## Requirements

   | | |
   |---|---|
   | **Mac** | Apple Silicon (M1 or later) |
   | **macOS** | Ventura 13.0 or later |
   | **RAM** | 8 GB minimum · 16 GB recommended for local models |
   ```

The R2 install pipeline (`latest.xml`) is updated by the build script independently of GitHub Releases. The two are decoupled — a GitHub Release documents what shipped; R2 delivers it.

---

## Versioning

Versions follow `0.3.x.x` during beta:

- `0.3.0` — initial public beta series
- `0.3.1.x` — incremental builds within the 0.3.1 series
- Version advances only in the source repo (`Cargo.toml` + `AETHER_VERSION`)

Do not create GitHub releases for versions that were never published to R2.

---

## README updates

Update `README.md` only when something user-visible changes — new feature, new requirement, changed endpoint, changed install URL. Keep it accurate and short. Do not add internal details, build instructions, or R2 paths.

---

## Repo settings (one-time)

- Visibility: **Public**
- Issues: off (support goes through other channels)
- Wikis: off
- Discussions: off
- Branch protection: not needed (README-only repo, no CI)
