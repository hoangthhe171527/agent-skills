#!/usr/bin/env bash
# scan-api.sh — read-only heuristic scan for API endpoints (provider) and call sites (consumer).
# Usage: bash scan-api.sh [dir]   (defaults to CWD). Run it on the provider AND the consumer paths.
# Heuristics only — verify in code. Prefers ripgrep (rg) if available, falls back to grep -r.
set -u
DIR="${1:-.}"
[ -d "$DIR" ] || { echo "No such dir: $DIR"; exit 1; }

if command -v rg >/dev/null 2>&1; then
  SEARCH() { rg -n --no-heading -S "$1" "$DIR" 2>/dev/null | head -"${2:-60}"; }
else
  SEARCH() { grep -rnIE "$1" "$DIR" 2>/dev/null | head -"${2:-60}"; }
fi
sec() { printf '\n== %s ==\n' "$1"; }

echo "api-contract-guard :: scan — $DIR"

sec "Existing contract (source of truth if present)"
ls -1 "$DIR"/**/openapi*.{yaml,yml,json} "$DIR"/openapi*.{yaml,yml,json} 2>/dev/null | sed 's/^/  /'
find "$DIR" -maxdepth 4 \( -iname 'openapi*.y*ml' -o -iname 'swagger*.json' -o -iname '*.graphql' -o -iname 'schema.gql' \) 2>/dev/null | sed 's/^/  /' | head

sec "PROVIDER — server routes (REST)"
SEARCH 'Route::(get|post|put|patch|delete)\(' 30          # Laravel
SEARCH '(app|router)\.(get|post|put|patch|delete)\(' 30   # Express
SEARCH '@(Get|Post|Put|Patch|Delete)Mapping' 20           # Spring
SEARCH '@(app|router)\.(get|post|put|patch|delete)' 20    # FastAPI
SEARCH '@(Get|Post|Put|Patch|Delete)\(' 20                # NestJS

sec "PROVIDER — GraphQL / RPC"
SEARCH '\b(type Query|type Mutation|extend type)\b' 15
SEARCH '\b(t\.(query|mutation)|publicProcedure|@(Query|Mutation)\()' 15

sec "PROVIDER — request validation / DTOs (request shape)"
SEARCH '(->validate\(|FormRequest|class .*Request|Pydantic|BaseModel|class-validator|@IsString|serializers\.)' 20

sec "CONSUMER — HTTP calls"
SEARCH '(fetch\(|axios\.(get|post|put|patch|delete)|\.(get|post|put|patch|delete)\(`?["'"'"'/])' 40
SEARCH '(useQuery|useMutation|queryFn|mutationFn|useSWR)' 20
SEARCH '(apiFetch|apiClient|httpClient|baseURL|API_BASE|BASE_URL)' 20

sec "CONSUMER — response types / mappers (relied-on fields)"
SEARCH '(to[A-Z][A-Za-z]+View|interface .*(Record|Response|Dto)|type .*(Record|Response) =)' 25

echo
echo "Done. Build the provider & consumer inventories from these, normalize paths, then diff."
