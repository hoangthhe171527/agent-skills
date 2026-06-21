# api-contract-guard

A reusable **Claude Code skill** that finds **drift between an API's server and its clients** — renamed/removed fields, wrong method/path, type mismatches, changed status codes — within one repo or across a separate **frontend + backend**. REST, GraphQL, or RPC.

> 🇻🇳 Bản tiếng Việt ở [dưới](#tiếng-việt).

## The bug class it kills
The server changes a field (`district` → `province`), renames an endpoint, or makes a value nullable — and the client keeps reading the old shape. No compiler catches it across the FE/BE boundary; it breaks at runtime. This skill diffs **what the server provides** against **what clients consume** and reports the mismatches with evidence on both sides.

## What it does
1. **Scope & detect** — find providers & consumers, the API style, any existing OpenAPI/GraphQL contract, and the base-path to normalize.
2. **Provider inventory** — every endpoint: method+path, request/response fields+types, status codes, auth (from routes/controllers/validators or the schema).
3. **Consumer inventory** — every call: method+path, request payload, and the response fields/types the client *relies on* (typed models, mappers, query hooks).
4. **Diff & report** — match calls↔endpoints; classify each mismatch with severity + `file:line` on **both** sides + a fix. Optionally emit OpenAPI; in CI, fail on breaking drift.

## Usage
```
/api-contract-guard                          # auto-detect in this repo, full report
/api-contract-guard ../api ../web            # cross-repo: provider path + consumer path
/api-contract-guard diff                     # only drift introduced by the current branch (CI gate)
/api-contract-guard openapi                  # also generate/update an OpenAPI contract doc
```
Or ask: *"check the API contract between the Laravel API and the React app"*, *"did my endpoint change break the frontend?"*.

## Severity
🔴 missing/renamed endpoint · removed field a client reads · type mismatch — 🟠 request/status/enum drift — 🟡 auth gap — 🔵 new unused field (info).

## Install
```bash
ln -s "$PWD/api-contract-guard" ~/.claude/skills/api-contract-guard            # macOS/Linux
cmd /c mklink /J "%USERPROFILE%\.claude\skills\api-contract-guard" "%CD%\api-contract-guard"  # Windows
```

## Structure
```
api-contract-guard/
  SKILL.md
  references/
    00-scope-and-detect.md     # single vs cross-repo, API style, contract, path normalization
    01-provider-inventory.md   # extract endpoints from routes/controllers/schema (Laravel/Express/FastAPI/Spring/GraphQL)
    02-consumer-inventory.md   # extract calls from fetch/axios/react-query/SDKs/mappers
    03-diff-and-report.md      # matching, mismatch taxonomy, severities, CI gate, openapi mode
  templates/contract-report.md
  scripts/scan-api.sh          # heuristic endpoint/call-site scanner (rg/grep)
```

> Report-first: it surfaces drift with suggested fixes and **doesn't edit code** unless you ask. As a CI gate (`diff`/`auto`) it exits non-zero on breaking drift.

---

## Tiếng Việt

**api-contract-guard** — skill phát hiện **lệch hợp đồng API giữa server và client** (đổi/xoá field, sai method/path, sai kiểu, đổi status code) — trong cùng 1 repo hoặc giữa **frontend + backend tách rời**. Hỗ trợ REST, GraphQL, RPC.

**Lớp bug nó bắt:** server đổi field (`district` → `province`), đổi tên endpoint, hay cho phép null — client vẫn đọc cấu trúc cũ → vỡ lúc runtime mà không trình biên dịch nào bắt được qua ranh giới FE/BE. Skill diff **server cung cấp gì** với **client tiêu thụ gì** và báo lệch kèm bằng chứng 2 phía.

**Quy trình:** khoanh vùng & nhận diện (style API, contract sẵn có, base-path) → kiểm kê provider (endpoint: method+path, field/kiểu request-response, status, auth) → kiểm kê consumer (lời gọi + field/kiểu client phụ thuộc, đọc cả mapper/type) → **diff & báo cáo** theo mức độ + `file:line` 2 phía + cách sửa. Tuỳ chọn sinh OpenAPI; chạy CI thì **fail khi lệch nghiêm trọng**.

**Dùng:**
```
/api-contract-guard                 # tự dò trong repo, báo cáo đầy đủ
/api-contract-guard ../api ../web   # 2 repo: đường dẫn provider + consumer
/api-contract-guard diff            # chỉ lệch do nhánh hiện tại gây ra (cổng CI)
/api-contract-guard openapi         # sinh/cập nhật tài liệu OpenAPI
```
Hoặc nói: *"kiểm tra hợp đồng API giữa Laravel API và app React"*.

> Ưu tiên báo cáo + gợi ý sửa, **không tự sửa code** trừ khi bạn yêu cầu.

## License
MIT — see repository `LICENSE`.
