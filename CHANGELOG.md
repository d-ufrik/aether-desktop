# Aether Desktop — Changelog

Aether Desktop lets you be your own AI provider: run powerful models entirely on your
own Mac — no cloud, no API keys, no friction. Install or update:

```
curl -fsSL https://aether.ufrik.com/desktop/macos/install.sh | sh
```

macOS 12+ on Apple Silicon (arm64).

---

## 0.3.1.64 — 2026-07-09

- **Hermes Agent reliability.** Hermes is now pointed at the correct, running local model automatically (fixes an "Unknown model" error). Agents only offer models whose server is actually running.
- **Your Hermes config is protected.** Before Aether points Hermes at your model, it keeps a pristine one-time backup plus rolling timestamped backups of `~/.hermes/config.yaml`, and preserves your other Hermes settings.
- **Clearer install.** Installing Hermes now explains up front that it runs its own multi-minute setup automatically.
- **Proactive checks.** Both Hermes and OpenCode now tell you if there's no model running to use, instead of launching into nothing.
- **What's New.** A short in-app summary now appears once after each update.

## 0.3.1.63 — 2026-07-08 — Hermes Agent

- **Install the Hermes Agent from the Agents tab.** Hermes (by Nous Research) installs and runs on your own local models through Aether — no subscription, no Terminal. Pick a model, click Install, and Aether wires it up.
- The Agent tab is now **Agents**, with Hermes and OpenCode side by side.

## 0.3.1.62 — 2026-07-06

- **Recommendations that fit your Mac.** Aether reads your actual RAM and shows the strongest models it can genuinely run. Models too large are clearly marked instead of failing silently.
- The Providers screen shows your two best-fit models up front; the full catalog is in the Model Shop.

## 0.3.1.61 — 2026-07-06 — Model Shop

- **New Model Shop.** Browse a catalog of local models and install any in one click. Every model runs on the built-in llama.cpp inference server and is instantly usable from Claude Code, Cursor, OpenCode, or anything that speaks the OpenAI API.
- **A real download manager:** cancel, resume, and queue several models at once — in the background.
- **Live catalog.** New models appear automatically — no app update needed.
- **Manage your library.** A Settings panel lists downloads and frees disk in one click.
- Fixed: cancelling a setup no longer leaves the window stuck "installing"; removing a local model works reliably.

## 0.3.1.60 — 2026-06-26

- Renaming a provider or model offers to keep OpenCode in sync in one click.

## 0.3.1.59 — 2026-06-26

- Per-model renaming (aliases).

## 0.3.1.58 — 2026-06-25

- Usage page cleanup and clearer model names.

## 0.3.1.57 — 2026-06-25

- Fixed a crash when closing the Agent window.

## 0.3.1.56 — 2026-06-25

- One-click OpenCode configuration from the Agents screen.

---

Older releases: see the [Releases](https://github.com/d-ufrik/aether-desktop/releases) page.
