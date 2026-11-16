# NOTICE — third-party components and attributions

This package (`siyuandocker`, TOS 7 Docker application) is an independent packaging by Moechz of
the upstream **SiYuan** project.

## 1. Upstream application — SiYuan

- Project: https://github.com/siyuan-note/siyuan
- Licence: **AGPL-3.0**
- Relationship: the upstream application is used **unmodified**, inside the container
  image. No upstream source code is redistributed in this package.

## 2. Container image — b3log/siyuan:v3.8.9

- Registry: Docker Hub (`b3log/siyuan:v3.8.9`)
- Maintainer: b3log
- The image is pulled from Docker Hub at install time and is not redistributed here.

## 3. Components inside the image

The image is built by its maintainer on top of a base distribution and bundles the
application's own dependencies. Their licences are documented in the image's package
metadata; they are shipped inside the image only and are not redistributed as separate
files by this package.

## 4. This packaging

The files authored for this package — `docker-compose.yml`, `config.ini`,
`siyuandocker.lang`, `siyuandocker.svg`, `entrypoint.sh` (when present), build scripts and this
documentation — are released under the same licence as the upstream project where
required, and otherwise under **GPL-3.0** (see `LICENSE`).

## 5. Trademarks

“SiYuan”, “TerraMaster” and “TOS” are trademarks or registered trademarks of their
respective owners. Their use here is descriptive only. This package is **not affiliated
with, sponsored or endorsed by** the upstream project or TerraMaster.

## 6. Icon

The application icon in `src/siyuandocker.svg` is a mark drawn or assembled for this package; it
does not reproduce a third-party logo unless the icon was taken from the upstream project,
in which case it is used only to identify that project.

## 7. Contact

Moechz — moechz@163.com — <https://www.moechz.com/>
