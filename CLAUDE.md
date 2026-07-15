# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This repository packages the `claude-tap` Python tool (published on PyPI) into a multi-arch Docker image and publishes it to GHCR.
There is no application source code here — the only build input is a `Dockerfile` that installs `claude-tap` via `uv`.

## Build & release

The image is built exclusively through GitHub Actions (`.github/workflows/build.yml`), triggered on pushes that change the `Dockerfile` or the workflow itself,
plus `workflow_dispatch` and a daily `schedule` (`0 16 * * *` UTC).
A `check` job queries PyPI for the latest `claude-tap` version and, on the schedule trigger, skips the build when that version's `v<version>` tag already exists in GHCR;
`push` and `workflow_dispatch` always rebuild.
The `build` job logs into GHCR with `GITHUB_TOKEN` and pushes `ghcr.io/<owner>/claude-tap:v<version>` plus `:latest` for `linux/amd64,linux/arm64`.

To build the image locally for testing:

```bash
docker build -t claude-tap .
```

## Dockerfile structure

Single-stage image on `python:3.13-alpine`:

- Creates a non-root user `claude` (uid/gid 1000) with `/sbin/nologin` shell; all subsequent layers run as this user.
- Installs `claude-tap` with `uv tool install` using the `ghcr.io/astral-sh/uv` image as a mount (no separate uv install step, no Python downloads).
- `ENTRYPOINT` runs `claude-tap --tap-no-launch --tap-no-open --tap-port 9999 --tap-live-port 19527`.

## Conventions

- Workflow pins actions to `@main`/`@master` rather than version tags.
- `ANTHROPIC_BASE_URL` is baked into the image as `https://api.anthropic.com`.
