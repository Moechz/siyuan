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
| Open | `http://<NAS-IP>:8166/` (container port 6806) |
| Runs as | non-root, `user: "1000:1000"` |
| Persistent data | `/data` → `/Volume1/DockerAppData/siyuandocker/data` |
| Logs | `docker logs siyuandocker` (stdout/stderr) |



## Third-party services (API disclosure)

The developer operates no server in this path. The application contacts only the services
**you configure**, plus (optionally) an update check and the image registry.

| Service | Endpoint | Data sent | Destination / region |
|---|---|---|---|
| Services you configure in the app | the address you enter | only the data that feature needs | normally your own LAN or the provider you chose |
| Update check (if enabled) | the upstream project's release feed | current version string | GitHub, US |
| Image pull | `registry-1.docker.io` or your registry mirror | anonymous pull | Docker Hub, US / your mirror |

See `PRIVACY.md` §6 for the full table. Disable any integration in the app's settings if you
do not want it.

## Licence and attributions

| Component | Licence | Notes |
|---|---|---|
| SiYuan | AGPL-3.0 | upstream application, used unmodified inside the image |
| Container image `b3log/siyuan:v3.8.9` | see the image's own metadata | pulled from Docker Hub at install time |
| This packaging | GPL-3.0 (see `LICENSE`) | compose file, metadata, translations, icon |

“SiYuan”, “TerraMaster” and “TOS” are trademarks of their respective owners. This is an
independent community package by Moechz and is not affiliated with the upstream project or
TerraMaster. Full details: [NOTICE.md](NOTICE.md).

## Design highlights

- **Non-root.** `user: "1000:1000"`; verified on real hardware (the container reports uid 1000).
- **Entrypoint wrapper**: the upstream image is built to run as root and keeps state in root-owned paths, so the compose file replaces the entrypoint with `src/entrypoint.sh`, which makes the service run as an unprivileged user. See that file for the details.
- **Fixed image tag, never `:latest`**, Docker Hub only, no `privileged`, no `network_mode: host`, and no Docker socket, no `cap_add`.
- **Health check** probing the service on container port 6806.
- **Deterministic build**: GNU tar with uid/gid 0 and zeroed timestamps, gzip without a timestamp, plus the review-standards self-check above.

## Privacy

This application runs entirely on your NAS. It does not include analytics, telemetry or advertising SDKs, and the packaging contains no code that sends data to the packager. Data is only exchanged with the services you configure yourself (for example media servers, notification endpoints or model APIs), and only from the container. Everything the application stores lives in the application data folder described above; removing the app with its data deletes it.

## Third-party components

The package runs the upstream image `b3log/siyuan:v3.8.9` unmodified. Its components and their licences are those of the upstream project (https://github.com/siyuan-note/siyuan), which is distributed under **AGPL-3.0**. No upstream source code is redistributed in this repository; only the four packaging files are original work.

## Runtime file manifest

Everything the application writes on the NAS lives inside its own data
directory; the container-internal `/tmp` is discarded with the container. The
table lists what is created and how it behaves. Nothing else is written.

| Path | Purpose | Created when | Growth bound | Lifecycle |
|---|---|---|---|---|
| `/Volume1/DockerAppData/siyuandocker/data` | SiYuan application data (everything the container writes outside /tmp) | on first start / on demand | bounded by your own data | persistent; kept on uninstall unless you ask to delete it |

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


## Limitations

- The application runs inside a container; data lives in the application data directory (`/Volume1/DockerAppData/siyuandocker/`) as described above.

---

Packaged for TOS 7 by Moechz. Upstream image used unmodified from Docker Hub.

## Support

- Issues and questions: <https://github.com/Moechz/siyuan/issues>
- Email: moechz@163.com
- Privacy: [PRIVACY.md](PRIVACY.md) · Licence: [NOTICE.md](NOTICE.md)
