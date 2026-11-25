# Changelog

All notable user-visible changes to the SiYuan TOS application package.

## 3.8.12-1 — 2026-11-25

Remediation of the App Listing review findings for 3.8.9-2 (x86_64 C3 C8 C9 T1 +
S11 S6; aarch64 C10 C2 C6 C8 C9 T1 + F10 F9 S12 S6; both: *App Center installation
failed — cannot be opened*).

### Fixed

- **Online install / “cannot be opened” (F2-class blocking item).** The App Center entry
  used `/`, which SiYuan answers with **401** for unauthenticated clients. `config.ini`
  `path` and `tosapp.json.http_path` now point at `/check-auth`, the upstream access-code
  page, which returns **200**; the health check probes the same URL.
- **S6 / F10 — hard-coded credentials and secrets in logs.** The access code is no longer
  the literal `siyuan` in `environment:`. It is generated once on first start
  (`/dev/urandom`), stored in `…/data/.access-code` with mode `0600`, and passed to the
  kernel via `SIYUAN_ACCESS_AUTH_CODE` (process environment, not argv). It is never
  printed to the container log. Users may supply their own with `ACCESS_AUTH_CODE`.
- **S11 — file permissions.** The workspace and the code file are created with `umask 077`;
  the compose file adds `cap_drop: [ALL]` and `no-new-privileges:true` on top of
  `user: "1000:1000"`.
- **F9 — recovery after a NAS restart.** `restart: unless-stopped` is kept, the entrypoint
  is idempotent (it reuses the stored code and re-checks the mount), and the health check
  now targets `/check-auth`, so a restarted container reports healthy as soon as the
  kernel is up. `start_period` raised to 60 s for slow ARM devices.
- **C6 — data collection vs. declaration.** The README/PRIVACY no longer claim “runs
  entirely on your NAS, no network” without qualification: the actual default behaviour
  (no telemetry; outbound traffic only through the optional features) and the trigger for
  each one are documented.
- **C8 — third-party API disclosure.** PRIVACY.md §3 lists every endpoint (marketplace CDN,
  GitHub update check, SiYuan Cloud China/NA, AI providers, PlantUML, community publish,
  Docker Hub) with the data sent, the trigger and the destination region.
- **C9 / F5 — description matches the delivered app.** The zh-cn and zh-hk texts no longer
  carry the beaverhabits habit-tracker copy; all three language blocks were rewritten for
  SiYuan and contain no ASCII semicolon.
- **C2 — licence notice.** NOTICE.md now records **AGPL-3.0** (verified at upstream tag
  `v3.8.12`), the multi-arch index and per-architecture digests, the trademark statement
  and the MIT licence of this packaging (the previous file claimed GPL-3.0 for the
  packaging while LICENSE said MIT).
- **T1 — high-severity CVE.** Image `b3log/siyuan:v3.8.9` → `b3log/siyuan:v3.8.12`
  (upstream release 2026-11-24). Data folder and port unchanged; see README for the
  3.8.9-1 workspace-path note.
- **C10 — repository and README.** README gained Repository layout, Privacy, Notices,
  Build, Data/uninstall and upgrade sections; the spec lost the stale
  `probe`/`entrypoint_file` leftovers (the old `entrypoint_file` pointed at a
  non-existent `specs/` path).
- **S12 / V7 — checksum.** Packages are rebuilt deterministically and both arch assets are
  re-uploaded; the platform `file_hash` is verified against the local `sha256sum` after
  submission.

## 3.8.9-2 — 2026-11-17

### Changed

- Host port 8038 → 8166; category `Web_Services` → `Utilities`; workspace
  `…/siyuandocker/workspace` → `…/siyuandocker/data`; fixed access code `siyuan`
  (replaced in 3.8.12-1).

## 3.8.9-1 — 2026-11-14

### Added

- First release. SiYuan (`b3log/siyuan:v3.8.9`, Docker Hub official image, unmodified)
  packaged as a TOS 7 Docker application on port 8038, running as a non-root user
  (1000:1000), with a generated access code stored in the workspace.
