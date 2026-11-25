# Privacy Policy — SiYuan for TerraMaster TOS (`siyuandocker`)

**Last updated:** 25 November 2026
**Data controller / contact:** Moechz — moechz@163.com
**Applies to:** version 3.8.12-1 of the TOS package `siyuandocker`

This policy covers the TOS application `siyuandocker` (the “app”) and this packaging.
It describes what the app stores on your NAS, what leaves the NAS, and the endpoints it can
contact. It is written against the behaviour of the packaged upstream version
(SiYuan 3.8.12, image `b3log/siyuan:v3.8.12`), not against older releases.

## 1. Summary

- The app runs **entirely on your NAS**. The developer receives nothing: no account is
  required, no telemetry, no analytics, no crash reporting and no advertising SDK is
  included in this package.
- Notes are stored as ordinary files in the application data folder. The developer has no
  access to them and holds no copy.
- The app is **local-first**: on a fresh install it works without any outbound connection.
  Network access is only used for the optional features in §3, and only when you use them.
- The access code that protects the web UI is generated **on your NAS** at first start. It
  is not hard-coded, and it is never written to the container log.

## 2. What is stored, and where

| Path on the NAS | Content | Written by |
|---|---|---|
| `/Volume1/DockerAppData/siyuandocker/data/` | SiYuan workspace: notebooks (`*.sy` files), assets, templates, appearance, configuration, search index | the app |
| `/Volume1/DockerAppData/siyuandocker/data/.access-code` | the generated access code for the web UI, mode `0600` | the entrypoint wrapper, first start only |

The container writes nothing outside its workspace except scratch files in `/tmp`, which
are discarded with the container. Nothing is written outside `/Volume1/DockerAppData/siyuandocker/`.

Uninstalling the app **keeps** this folder unless you tick “delete data” in the App Center;
see §5 for how to remove it completely.

## 3. What leaves the NAS — third-party endpoints (C6 / C8)

The developer operates no server in this path and receives no data. The table lists every
endpoint the packaged version can contact, what is sent, when, and where it goes.

| # | Feature | Endpoint | Data sent | Trigger | Destination / region |
|---|---|---|---|---|---|
| 1 | Docker image pull | `registry-1.docker.io` (or your mirror) | anonymous image pull | install / update | Docker Hub — United States |
| 2 | Marketplace (Bazaar) index and packages | `https://oss.b3logfile.com/bazaar`, `https://bazaar.b3logfile.com` | **download only** — an HTTP GET for the index/ratings and for the package file you choose | only when you open the Marketplace or install a plugin/theme | Qiniu Cloud CDN (China-based provider, global edge) |
| 3 | Update check | `https://api.github.com/repos/siyuan-note/siyuan/releases` | an anonymous request for the release list — no workspace content, no identifier | only when you click *Check update* | GitHub, Inc. — United States |
| 4 | SiYuan Cloud sync and account (optional, paid) | `https://siyuan-sync.b3logfile.com`, `wss://siyuan-sync.b3logfile.com`, `https://siyuan-data.b3logfile.com`, `https://ld246.com` | your account e-mail and the notebook files **encrypted on the NAS** with your sync password | only after you log in and enable sync with the China region | Alibaba Cloud + Qiniu, mainland China |
| 5 | SiYuan Cloud sync, North America region (optional, paid) | `https://siyuan-cloud.liuyun.io`, `https://siyuan-data.liuyun.io`, `https://liuyun.io` | same as #4 | only if you choose the North America region | Cloudflare + Qiniu — United States |
| 6 | Member image hosting for export preview (optional, subscription) | `https://assets.b3logfile.com/siyuan/`, `https://assets.liuyun.io/siyuan/` | the images already embedded in the note you preview/export | only when a subscribed member uses that preview | Qiniu CDN, mainland China / United States |
| 7 | AI assistant (optional) | the provider you configure, e.g. `https://openrouter.ai/api/v1`, `https://api.minimaxi.com/v1` | the text you send to the model plus your provider API key | only when you use an AI feature | the provider you chose |
| 8 | AI model catalogue | `https://models.dev/api.json`, `https://openrouter.ai/api/v1/models` | a request for the public model list | only when you open the AI provider settings | the provider you chose |
| 9 | PlantUML diagrams (optional) | `https://www.plantuml.com/plantuml/svg/` | the diagram source you ask to render | only when you render a PlantUML block | public PlantUML server |
| 10 | Publish to the SiYuan community (optional) | `https://ld246.com`, `https://liuyun.io` | the post content and your account | only when you publish a post | B3log / Liuyun — China or United States |
| 11 | Self-hosted sync you configure (optional) | the S3/WebDAV endpoint you enter | the notebook files | only when you enable that sync | the server you chose |

Notes on #4/#5: sync is an **optional paid** SiYuan Cloud feature. Notebook data is
encrypted on the NAS with a key derived from your sync password before it is uploaded, so
the service stores ciphertext. If you do not log in, no sync traffic occurs at all.
Self-hosted sync (WebDAV/S3, #11) goes only to the endpoint you configure.

There is **no telemetry, no usage statistics, no crash upload and no advertising SDK**. The
Marketplace calls in #2 are plain downloads; they do not send the list of installed packages
or anything about your notes. The update check in #3 is manual.

## 4. Retention period

| Data | Retention |
|---|---|
| Workspace / notes | until **you** delete it; no automatic expiry, no upload |
| `.access-code` | until you delete the data folder; regenerated only if you delete it |
| Container log (`docker logs siyuandocker`) | stdout, kept by the Docker logging driver and rotated by it; contains no credentials |
| `/tmp` scratch | discarded with the container |
| Data held by optional services (#4–#11) | governed by the provider you chose; nothing is held by the developer |

## 5. Your rights and the deletion channel (C7)

| Right | How |
|---|---|
| Access / export | Copy `/Volume1/DockerAppData/siyuandocker/data/` — it is the complete state. SiYuan also has *Export* (Markdown, PDF, Word) in its own UI. |
| Correct | Edit the notes, settings and access code in the app. |
| Delete | Uninstall the app with “delete data”, or stop the container and remove `/Volume1/DockerAppData/siyuandocker/`. To remove a cloud copy, delete the sync directory in SiYuan Cloud from the app or the account portal. |
| Restrict / object | Do not enable the optional features in §3; the app then makes no outbound connection. |
| Assistance | E-mail **moechz@163.com** with the subject “SiYuan data request”; a reply follows within 30 days. |

Because the developer holds no copy of your data, deletion is completed by removing the
folder on your own NAS. The e-mail channel covers questions and requests about this package
and the publisher's website records.

## 6. Security measures

- The container runs as **uid 1000**, never root, with `cap_drop: [ALL]` and
  `no-new-privileges:true`; no `privileged`, no host network, no Docker socket.
- The web UI is protected by an access code that is **generated on first start** and stored
  in `.access-code` (`0600`, owned by the app user). It is never logged, never in the image
  and never in the compose file. You can supply your own via `ACCESS_AUTH_CODE`.
- Only the application port (8166) is published; the kernel listens on 6806 inside the
  container.
- The image tag is **pinned** to `b3log/siyuan:v3.8.12` (Docker Hub, multi-arch); the package
  is rebuilt when upstream ships security fixes.
- Data stays inside the application data folder, owned by the app user.
- The web UI is plain HTTP on the LAN. If you expose it outside the LAN, put it behind a
  TLS reverse proxy and keep the app updated.

## 7. Children

The app is a self-hosted note-taking tool and is not directed at children.

## 8. Changes

Material changes are published in this file and reflected in the “Last updated” date. A
change of the packaged upstream version that adds a new endpoint is disclosed here in the
same release.

## 9. Contact

Moechz — **moechz@163.com** — <https://www.moechz.com/privacy.html>
Source of this package: <https://github.com/Moechz/siyuan>
