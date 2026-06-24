# aether-desktop — Repo Rules

## Purpose

This repo is the public distribution point for Aether Desktop.  
It contains exactly two things:

1. `README.md` — the user-facing project description
2. GitHub Releases — one per version, with release notes and the `.dmg` attached

**No source code lives here. No build scripts. No internal docs.**  
The source lives in the private monorepo. This repo is what the public sees.

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

1. Build and verify the DMG locally:
   ```bash
   AETHER_VERSION=0.3.x.x packaging/macos/build.sh --arch arm64 --dmg
   ```

2. Confirm the version passes health checks on the target machine.

3. Go to **[github.com/d-ufrik/aether-desktop/releases/new](https://github.com/d-ufrik/aether-desktop/releases/new)**

4. Fill in:
   - Tag: `v0.3.x.x` (create new tag on publish)
   - Title: `Aether Desktop v0.3.x.x`
   - Description: condensed release notes from `backend/standalone/CHANGELOG.md`
   - Attach: `Aether-0.3.x.x-arm64.dmg`
   - Check **Pre-release** if still in beta

5. Publish.

The installer at `https://aether-models.ufrik.com/desktop/macos/install.sh` reads from `latest.xml` in R2 — it is independent of GitHub Releases. GitHub Releases is the public changelog and download history; R2 is the live install pipeline.

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
