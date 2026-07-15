# claude-tap-docker

Multi-arch Docker image for [`claude-tap`](https://github.com/liaohch3/claude-tap), published to GHCR.

This repository contains no application source — only a [`Dockerfile`](Dockerfile) that installs `claude-tap` via [`uv`](https://docs.astral.sh/uv/) on top of `python:3.13-alpine`,
plus the GitHub Actions workflow that builds and publishes the image.

## Image

The image is built through GitHub Actions (see [`.github/workflows/build.yml`](.github/workflows/build.yml)) and pushed for the following platforms:

- `linux/amd64`
- `linux/arm64`

```bash
docker pull ghcr.io/zydou/claude-tap-docker/claude-tap:latest
```

### Defaults

The image runs as a non-root user `claude` (uid/gid 1000) and exposes:

- `9999` — tap port
- `19527` — live port

`ENTRYPOINT` runs:

```text
claude-tap --tap-no-launch --tap-no-open --tap-port 9999 --tap-live-port 19527
```

`ANTHROPIC_BASE_URL` is baked in as `https://api.anthropic.com`.

## Usage

```bash
docker run --rm -p 9999:9999 -p 19527:19527 ghcr.io/zydou/claude-tap-docker/claude-tap:latest
```

## Build locally

```bash
docker build -t claude-tap .
```

## License

This packaging repository follows the license of the upstream [`claude-tap`](https://github.com/liaohch3/claude-tap) project.
