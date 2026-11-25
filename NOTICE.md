# NOTICE — third-party components, licences and attributions

This package (`siyuandocker`, TOS 7 Docker application) is an independent packaging by
Moechz of the upstream **SiYuan** project. It is **not** an official SiYuan build and is not
affiliated with, sponsored or endorsed by the upstream project or TerraMaster.

## 1. Upstream application — SiYuan

| | |
|---|---|
| Project | <https://github.com/siyuan-note/siyuan> |
| Licence | **GNU Affero General Public License, version 3.0 (AGPL-3.0)** — verified against the `LICENSE` file of the upstream repository at tag `v3.8.12` |
| Copyright | © 2020–present, the SiYuan authors (siyuan-note / B3log) |
| Relationship | the application is used **unmodified**. This repository contains no upstream source code; only the packaging files listed in §4 are original work. |

AGPL-3.0 requires that users who interact with a modified version over a network are offered
its source. This package does **not** modify SiYuan: the upstream image is pulled unchanged
from Docker Hub. The complete corresponding source of the packaged version is available from
upstream at <https://github.com/siyuan-note/siyuan/tree/v3.8.12> (tag `v3.8.12`). The
packaging code in this repository is published under MIT (see §4) and is available at
<https://github.com/Moechz/siyuan>.

## 2. Container image — `b3log/siyuan:v3.8.12`

- Registry: Docker Hub (`b3log/siyuan:v3.8.12`), maintained by the upstream project (b3log).
- It is a **multi-architecture OCI index**:
  - index digest `sha256:3e1b65ce633e437fed4ed440367d0dc316039b02d4554a47bdda16790b6a973d`
  - `linux/amd64` manifest `sha256:a467b06866cb3f2d76efcf8595eb58bc36761e7dd3fa4893fe972674c41bb9b2`
  - `linux/arm64` manifest `sha256:e017b1d1ded0f23e5c239811cf0f8364469b5903683ff2369385c01debcc629a`
- The image is pulled at install/update time and is **not redistributed** in this repository
  or in the TOS package. The x86_64 and aarch64 packages use the same pinned tag, and Docker
  resolves the matching manifest for each NAS architecture.
- Licences of the components **inside** the image (Alpine/Debian base, Go toolchain, the
  SiYuan kernel, the bundled fonts and JavaScript libraries) are documented in the image's
  own licence files and package metadata, and apply as shipped by the image maintainer. The
  SiYuan kernel and front-end in that image are AGPL-3.0.

## 3. Upstream version and security note (T1)

The package pins **SiYuan 3.8.12**, released upstream on 2026-11-24, replacing 3.8.9. The
upgrade follows the review's high-severity CVE finding for the older image; the release
notes of 3.8.10–3.8.12 contain the upstream fixes, and the image index digest above is the
immutable reference used for verification. The tag is a fixed version tag (never `latest`).

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`siyuandocker.lang`, `siyuandocker.svg`, `entrypoint.sh`, the build and verification
scripts, and the documentation — are released under the **MIT licence** (see `LICENSE`).

They contain no upstream code except the small shell wrapper that starts the upstream
kernel with a non-root user.

## 5. Icon

The application icon `src/siyuandocker.svg` is a glyph from the Simple Icons set
(`simple-icons:siyuan`), distributed under **CC0 1.0**, used only to identify the SiYuan
application. “SiYuan”, “TerraMaster” and “TOS” are trademarks or registered trademarks of
their respective owners; their use here is descriptive only.

## 6. TerraMaster tooling

`TOSAppSelfTestingTool` in this repository is an official TerraMaster utility, redistributed
unmodified for local package validation. It is not part of the submitted package
(`siyuandocker.tar.gz`).

## 7. Contact

Moechz — moechz@163.com — <https://www.moechz.com/>
