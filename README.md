# siyuan-for-tos

> TerraMaster TOS 7 App Center — **Docker application** package for
> [SiYuan](https://github.com/siyuan-note/siyuan).

## What this is

A four-file TOS Docker application archive (`siyuandocker.tar.gz`) that installs
SiYuan on TOS 7 through the App Center:

- `config.ini` — TOS application metadata (`application_type: docker`, id `siyuandocker`)
- `siyuandocker.lang` — 23-language superset (TOS requires 14)
- `siyuandocker.svg` — application icon (379 bytes, 3 SVG elements)
- `docker-compose.yml` — one service, image `b3log/siyuan:v3.8.9`

## How it works

| | |
|---|---|
| Container image | `b3log/siyuan:v3.8.9` (Docker Hub, used unmodified) |
| Open | `http://<NAS-IP>:8038/` (container port 6806) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/siyuan/workspace` → `/Volume1/DockerAppData/siyuandocker/workspace` |
| Logs | `docker logs siyuandocker` (stdout/stderr) |

`/siyuan/workspace` (mounted from `DockerAppData/siyuandocker/workspace`) holds the notes (`data/`), the workspace config (`conf/`) and `.access-code`. The kernel's HOME is pointed at the same folder so its cache stays persistent.

## Design highlights

- **Non-root.** `user: "1000:1000"`; verified on real hardware (the container reports uid 1000).
- **Entrypoint wrapper**: the upstream image's entrypoint needs root to create a user and chown `/opt/siyuan`; this package starts the SiYuan kernel directly as uid 1000, keeps `HOME` inside the workspace and generates a stable access code on first start.
- **Fixed image tag, never `:latest`**, Docker Hub only, no `privileged`, no `network_mode: host`, and no Docker socket, no `cap_add`.
- **Health check** probing the service on container port 6806.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a timestamp, plus the review-standards self-check above.
- **Kernel started directly.** The upstream entrypoint needs root (it creates a user and chowns the app directory); the wrapper starts `/opt/siyuan/kernel` as uid 1000 instead.
- **Access code generated once.** No password is baked into the package: the wrapper creates a random code on first start, prints it to the log and reuses it from the workspace afterwards.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own data
directory; the container-internal `/tmp` is discarded with the container. The
table lists what is created and how it behaves. Nothing else is written.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `/Volume1/DockerAppData/siyuandocker/workspace` | SiYuan application data (everything the container writes outside /tmp) | on first start / on demand | bounded by your own data | persistent; kept on uninstall unless you ask to delete it |

## Build

```bash
scripts/build.sh                  # -> out/siyuandocker.tar.gz + .sha256
scripts/build.sh 3.8.9-2   # packaging iteration bump
scripts/build.sh 3.8.9-1 aarch64
```

The build stages the four files, substitutes the version/platform placeholders,
embeds `src/entrypoint.sh` into the compose file (escaping every `$` as `$$`), removes CRLF/BOM/AppleDouble, then runs
`tools/verify.py`, a review-standards self-check (archive layout, JSON validity,
required fields, 14+ language coverage, version consistency, Docker-Hub-only
images, fixed tag, reserved/recommended host ports, non-root user, per-service
healthcheck/TZ/restart, data path below the application data root, never the
`/Volume*` wildcard, comment-free sequence blocks, `x-app-meta` position, no
literal secrets and the SVG size/element limits).

## Local verification

```bash
./TOSAppSelfTestingTool -c out/siyuandocker.tar.gz   # official spec check
bash test/install-and-verify.sh                  # on-device E2E (needs root)
```

> Docker applications cannot be side-loaded through the App Center's manual
> install page (it accepts `.deb` only); the official self-testing tool's `-i`
> mode or `docker compose` are the only ways to install one for testing.

## Store submission checklist

1. Public GitHub repo (code + README only).
2. Release **tag `v3.8.9-1`**, assets `siyuandocker.tar.gz` +
   `siyuandocker.tar.gz.sha256` (Docker asset naming: `<app_id>.tar.gz`, **no
   platform suffix**).
3. Developer platform → Add Application: ID `siyuandocker`, package type Docker,
   repository URL, architecture `x86_64`.
4. Version Management → Add Version `3.8.9-1` → automated validation → review.

## License / branding

SiYuan is distributed by its upstream authors under **AGPL-3.0**. The container image is the official image from Docker Hub (`b3log/siyuan:v3.8.9`) and is used unmodified; no upstream source code is redistributed here. This packaging is an independent community submission by Moechz and is not affiliated with the upstream project or TerraMaster.

## Limitations

- The access code is shown in the container log and stored in the workspace; change it by editing `.access-code` and restarting the app.
- The web UI is plain HTTP; use a TLS reverse proxy before exposing it to the internet.
- SiYuan's own sync/marketplace features need outbound access; the package does not configure them.

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.
