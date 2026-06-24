# Aether Desktop

**Local AI gateway for Apple Silicon Macs.**

One OpenAI-compatible endpoint. Local models, cloud providers, usage tracking, and a built-in chat client — packaged into a single macOS app with no terminal required.

> **Beta** · Apple Silicon only · macOS 13+

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/d-ufrik/aether-desktop/main/install.sh | sh
```

OR

```bash
curl -fsSL https://aether-models.ufrik.com/desktop/macos/install.sh | sh
```

The installer downloads the latest DMG from GitHub Releases, installs `Aether.app` into `/Applications`, and launches it.

**Manual download** — grab the latest DMG from the [Releases](../../releases) tab and drag `Aether.app` into Applications.

---

## Pre-loading a model manually (optional)

If the app cannot reach the model download server, place the model file on disk before launching Aether. The app detects the file and skips the download automatically.

**TL;DR — default model (Qwopus 3.5 4B Coder, requires 8 GB RAM):**

```bash
pip install hf
mkdir -p ~/Library/Application\ Support/Aether/models/llamacpp/qwopus-3.5-4b-coder-mtp-q4_k_m
hf download Jackrong/Qwopus3.5-4B-Coder-MTP-GGUF Qwopus3.5-4B-Coder-MTP-Q4_K_M.gguf \
  --local-dir ~/Library/Application\ Support/Aether/models/llamacpp/qwopus-3.5-4b-coder-mtp-q4_k_m
mv ~/Library/Application\ Support/Aether/models/llamacpp/qwopus-3.5-4b-coder-mtp-q4_k_m/Qwopus3.5-4B-Coder-MTP-Q4_K_M.gguf \
   ~/Library/Application\ Support/Aether/models/llamacpp/qwopus-3.5-4b-coder-mtp-q4_k_m/model.gguf
```

Then launch Aether — the wizard detects the file and skips the download.

---

**Other available models:**

| Model | RAM | HF repo | File |
|---|---|---|---|
| Qwopus 3.5 4B Coder | 8 GB+ | `Jackrong/Qwopus3.5-4B-Coder-MTP-GGUF` | `Qwopus3.5-4B-Coder-MTP-Q4_K_M.gguf` |
| Gemma 4 E2B | 8 GB+ | `google/gemma-4-e2b-it-GGUF` | `gemma-4-e2b-it-q4_k_s.gguf` |
| Qwopus 3.6 35B-A3B | 32 GB+ | `unsloth/Qwen3.6-35B-A3B-GGUF` | `Qwen3.6-35B-A3B-Q4_K_S.gguf` |
| Gemma 4 26B-A4B | 32 GB+ | `unsloth/gemma-4-26b-it-GGUF` | `gemma-4-26b-it-IQ2_M.gguf` |

Target directory for each model: `~/Library/Application Support/Aether/models/llamacpp/<model-id>/model.gguf`

| Model | `<model-id>` |
|---|---|
| Qwopus 3.5 4B Coder | `qwopus-3.5-4b-coder-mtp-q4_k_m` |
| Gemma 4 E2B | `gemma-4-e2b-it-q4_k_s` |
| Qwopus 3.6 35B-A3B | `qwopus-3.6-35b-a3b-v1-q4_k_s` |
| Gemma 4 26B-A4B | `gemma-4-26b-a4b-it-ud-iq2_m` |

---

## Requirements

| | |
|---|---|
| **Mac** | Apple Silicon (M1 or later) |
| **macOS** | Ventura 13.0 or later |
| **RAM** | 8 GB minimum · 16 GB or more recommended for local models |
| **Disk** | ~200 MB for the app · model files vary (2–10 GB each) |

Local model inference requires Apple Silicon. Aether Desktop also works on Intel Macs as a cloud provider proxy (no local model support).

---

## What it does

Aether Desktop runs a local HTTP server at `http://127.0.0.1:8181` and exposes a single **OpenAI-compatible endpoint**:

```
http://127.0.0.1:8181/v1
```

Any client that speaks the OpenAI API — Claude Code, Cursor, Opencode, Codex, Python scripts, curl — points to that URL and gets access to every model you configure, local or cloud.

### Local models

- Browse and download curated GGUF models from the built-in catalog
- Aether manages the Inference Server binary, model files, start/stop, and crash recovery
- Multi-Tier Prediction (MTP/speculative decoding) where supported
- Context window and parallel-request settings per machine

### Cloud providers

Connect any OpenAI-compatible cloud provider — OpenAI, Anthropic, NVIDIA NIM, OpenRouter, Kimi, and others. All requests go through the same local endpoint; Aether routes and injects credentials.

### Dashboard and tools

| Section | What's there |
|---|---|
| **Dashboard** | System status, live backend health, request and error charts |
| **Usage** | Token and request history, per-model stats, request log |
| **Providers** | Add and manage local and cloud backends |
| **Models** | All enabled models, copyable client config for common tools |
| **API Keys** | Issue local bearer tokens for clients |
| **Settings** | Port, network binding, Inference Engine configuration |
| **Chat** | Built-in chat window for testing models |

---

## Client configuration

Point any OpenAI-compatible client at the local endpoint. Example with curl:

```bash
curl http://127.0.0.1:8181/v1/chat/completions \
  -H "Authorization: Bearer <your-aether-api-key>" \
  -H "Content-Type: application/json" \
  -d '{"model": "your-model-id", "messages": [{"role": "user", "content": "Hello"}]}'
```

Copy the exact client configuration snippet (with the right model ID and key) from the **Models** section inside the app.

---

## Releases

Each release is published here with a DMG attached. Release notes describe what changed.

The installer script always installs the [latest release](../../releases/latest). To install a specific version, download the DMG from the corresponding release page.

---

## Project site

[aether.ufrik.com](https://aether.ufrik.com)
