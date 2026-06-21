#!/usr/bin/env bash
# detect-conventions.sh — read-only survey of a workspace's reference repos to mirror their
# stacks and per-module structure. Usage: bash detect-conventions.sh [workspace-dir]
set -u
WS="${1:-.}"
cd "$WS" 2>/dev/null || { echo "No such dir: $WS"; exit 1; }
sec() { printf '\n== %s ==\n' "$1"; }
echo "feature-forge :: workspace convention survey — $(pwd)"

sec "Repos in workspace"
for d in */ ; do
  [ -d "$d" ] || continue
  tag=""
  [ -f "$d/composer.json" ] && tag="$tag PHP"
  [ -f "$d/package.json" ] && tag="$tag JS/TS"
  [ -f "$d/pubspec.yaml" ] && tag="$tag Flutter"
  [ -f "$d/go.mod" ] && tag="$tag Go"
  [ -n "$tag" ] && echo "  ${d%/} →$tag"
done

# Backend (Laravel DDD modules)
for d in */ ; do
  if [ -f "$d/composer.json" ] && [ -d "$d/modules" ]; then
    sec "BACKEND ${d%/} — module layout (mirror this)"
    one=$(find "$d/modules" -maxdepth 1 -mindepth 1 -type d | head -1)
    [ -n "$one" ] && find "$one" -maxdepth 2 -type d | sed "s#$d/modules/##" | head -25
    grep -iE 'laravel/framework|mongodb' "$d/composer.json" | sed 's/^/  dep: /' | head
  fi
done

# Web (TanStack/React modules)
for d in */ ; do
  if [ -f "$d/package.json" ] && [ -d "$d/src/modules" ]; then
    sec "WEB ${d%/} — module layout (mirror this)"
    one=$(find "$d/src/modules" -maxdepth 1 -mindepth 1 -type d | head -1)
    [ -n "$one" ] && find "$one" -maxdepth 2 -type d | sed "s#$d/src/modules/##" | head -20
    grep -iE '"(react|vue|svelte|@tanstack/react-router|@tanstack/react-query|vite)"' "$d/package.json" | sed 's/^/  dep:/' | head
  fi
done

# App (Flutter features)
for d in */ ; do
  if [ -f "$d/pubspec.yaml" ]; then
    sec "APP ${d%/} — feature layout (mirror this)"
    one=$(find "$d/lib/features" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | head -1)
    [ -n "$one" ] && find "$one" -maxdepth 1 -type d | sed "s#$d/lib/features/##" | head
    grep -iE 'riverpod|bloc|dio|freezed|get_it|retrofit' "$d/pubspec.yaml" | sed 's/^/  dep:/' | head
  fi
done

sec "Existing module/feature names (follow this naming — domain nouns, NOT roles)"
for d in */ ; do
  [ -d "$d/modules" ] && { echo "  [BE ${d%/}]"; ls -1 "$d/modules" 2>/dev/null | sed 's/^/    /' | head -20; }
  [ -d "$d/src/modules" ] && { echo "  [Web ${d%/}]"; ls -1 "$d/src/modules" 2>/dev/null | sed 's/^/    /' | head -20; }
  [ -d "$d/lib/features" ] && { echo "  [App ${d%/}]"; ls -1 "$d/lib/features" 2>/dev/null | sed 's/^/    /' | head -20; }
done

sec "Existing infra (reuse — match service names/ports/env)"
for d in */ ; do
  ls -1 "$d"/docker-compose*.yml 2>/dev/null | sed 's/^/  /'
  [ -f "$d/.env.example" ] && grep -hiE '^(DB_|MONGO|AWS_|S3_|MINIO)' "$d/.env.example" 2>/dev/null | sed "s/^/  [${d%/}] /" | head
done

echo
echo "Done. Open one real module per repo and mirror it exactly. Default stack = these repos."
