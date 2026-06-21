# Phase 3 — Infrastructure (MongoDB + MinIO on Docker)

Goal: a reproducible local stack the backend can talk to — **MongoDB** for data, **MinIO** for object storage — wired exactly how the backend expects them.

## Match how the backend already uses them
First read the backend's existing `docker-compose*.yml`, `.env.example`, and storage config. Reuse the **same** service names, ports, DB name, and S3/bucket variables — don't invent new ones. (In this workspace the backend already expects `DB_HOST=mongodb` and S3-style storage; mirror it.) For greenfield, base the compose on `templates/docker-compose.yml`.

## MongoDB
- Service `mongodb` (image `mongo:7` to match the workspace), persistent volume, exposed port.
- **Transactions need a replica set.** If the backend uses multi-document transactions (Laravel + MongoDB often does), run mongo with `--replSet rs0` and initialize it once (`rs.initiate()` via a one-shot init container or healthcheck hook). Otherwise a single node is fine.
- Healthcheck (`mongosh --eval "db.adminCommand('ping')"`) so dependents wait for readiness.

## MinIO (S3-compatible object storage)
- Service `minio` (`minio/minio`), console + API ports, persistent volume, root user/password from env.
- A one-shot `mc` (MinIO Client) init service that waits for MinIO, then **creates the bucket(s)** the app needs and sets policy — so storage works on first boot.
- Wire the backend's S3 config to MinIO: `endpoint` = `http://minio:9000`, `use_path_style_endpoint=true`, access/secret keys, bucket, region. Put these in `.env`/compose env, never hard-coded.

## Env wiring
- Produce/update `.env` (and `.env.example`) for the backend with the Mongo + MinIO values matching the compose. Keep secrets out of committed files (`.env.example` has placeholders).
- For greenfield, also wire the web app's `API_BASE`/`baseURL` and the Flutter app's Dio base URL to the backend service.

## Bring it up & verify
- `docker compose up -d`, wait for healthchecks, then verify: Mongo reachable (`ping`), MinIO bucket exists, backend can connect (run a migration/seed or a health endpoint).
- Remember the **container caveat**: service hostnames (`mongodb`, `minio`) resolve only inside the compose network — run artisan/seed/tests via `docker compose exec <app> …`.

## Output
- `docker-compose.yml` (or updated) with mongodb + minio (+ init) + app services for greenfield.
- Updated `.env`/`.env.example`.
- A verified "stack is up" check before scaffolding modules that need storage/DB.

Proceed to Phase 4 (scaffold: `references/04-scaffold-backend.md`).
