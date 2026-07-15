FROM python:3.13-alpine AS python
RUN apk add --no-cache shadow && \
    groupadd --gid 1000 claude && \
    useradd -u 1000 -g 1000 --create-home -s /sbin/nologin claude && \
    apk del -r shadow

USER claude
WORKDIR /home/claude
ENV PATH=/home/claude/.local/bin:$PATH \
    ANTHROPIC_BASE_URL=https://api.anthropic.com

EXPOSE 9999 19527

RUN --mount=from=ghcr.io/astral-sh/uv:latest,source=/uv,target=/bin/uv \
    uv tool install --no-python-downloads --no-cache --compile-bytecode claude-tap

ENTRYPOINT ["claude-tap", "--tap-no-launch", "--tap-no-open", "--tap-port", "9999", "--tap-live-port", "19527"]
