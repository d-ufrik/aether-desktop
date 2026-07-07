# Aether Desktop — Changelog

Aether Desktop lets you be your own AI provider: run powerful models entirely on your
own Mac — no cloud, no API keys, no friction. Install or update:

```
curl -fsSL https://aether.ufrik.com/desktop/macos/install.sh | sh
```

macOS 12+ on Apple Silicon (arm64).

---

## 0.3.1.62 — 2026-07-06

- **Recommendations that fit your Mac.** Aether now reads your actual RAM and shows the
  strongest models it can genuinely run. A 64 GB Mac is offered the big models; smaller
  Macs see the ones that fit. Models too large to run are clearly marked instead of
  failing silently.
- The Providers screen now shows just your two best-fit models up front; the full catalog
  lives in the Model Shop.

## 0.3.1.61 — 2026-07-06 — Model Shop

- **New Model Shop.** Browse a catalog of local models and install any of them in one
  click. Every model runs through the built-in llama.cpp inference server and is instantly
  usable from Claude Code, Cursor, OpenCode, or anything that speaks the OpenAI API.
- **A real download manager:** cancel, resume, and queue several models at once — all in
  the background, without interrupting the running app.
- **Live catalog.** New models appear automatically; the app pulls the catalog on the fly,
  so you never wait for an app update to try the newest model.
- **Manage your library.** A new Settings panel lists everything you've downloaded and
  frees up disk space in one click.
- Fixed: cancelling a model setup no longer leaves the window stuck "installing."
- Fixed: removing a local model now works reliably.

## 0.3.1.60 — 2026-06-26

- Renaming a provider or model now offers to keep OpenCode in sync in one click, so your
  agent keeps reaching Aether after a rename.

## 0.3.1.59 — 2026-06-26

- Per-model renaming (aliases): give any model a friendlier name.

## 0.3.1.58 — 2026-06-25

- Usage page cleanup and clearer model names.

## 0.3.1.57 — 2026-06-25

- Fixed a crash when closing the Agent window.

## 0.3.1.56 — 2026-06-25

- One-click OpenCode configuration from the Agent screen.

---

Older releases: see the [Releases](https://github.com/d-ufrik/aether-desktop/releases) page.
