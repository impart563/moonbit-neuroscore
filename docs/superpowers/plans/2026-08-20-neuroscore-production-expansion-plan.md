# Production Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a tested MoonBit clinical-scoring integration toolkit whose in-scope source and case corpus reach at least 20,000 non-filler lines while preserving the existing API.

**Architecture:** Keep the root package as the public scoring facade. Add focused packages for validation, registry, tabular batch processing, interoperability records, audit/version metadata, and benchmark cases; make the CLI a thin composition layer. Keep production, tests, and fixtures in separate directories so line counts are auditable.

**Tech Stack:** MoonBit stable, Moon package manifests, pure functions, GitHub Actions, PowerShell benchmark/report scripts.

---

### Task 1: Establish package boundaries and error model

**Files:**
- Create: `core/`, `registry/`, `interop/`, `batch/`, `audit/`, `bench/` package manifests
- Create: `core/errors.mbt`, `core/case.mbt`, `audit/events.mbt`
- Modify: `moon.pkg`, `moon.mod`
- Test: `core/core_test.mbt`

- [ ] Write tests for structured invalid-input, missing-field, row/column, and unknown-scale errors.
- [ ] Run `moon test core` and confirm the new tests fail because the types do not exist.
- [ ] Implement immutable error enums and case identifiers with deterministic display helpers.
- [ ] Run `moon fmt`, `moon check --deny-warn`, and targeted tests.
- [ ] Commit `feat: add structured scoring errors and cases`.

### Task 2: Expand domain result and provenance APIs

**Files:**
- Create: `core/result.mbt`, `core/provenance.mbt`, `core/validation.mbt`
- Modify: `types.mbt`, `serialization.mbt`
- Test: `core/result_test.mbt`, `neuroscore_test.mbt`

- [ ] Add tests for result IDs, source/version metadata, deterministic evidence order, and JSON-safe rendering.
- [ ] Implement compatible result extensions without changing existing calculator totals.
- [ ] Add explicit range validators reusable by all calculators.
- [ ] Run wasm-gc and native tests and inspect `moon info` changes.
- [ ] Commit `feat: add auditable score results`.

### Task 3: Build registry and generic evaluator

**Files:**
- Create: `registry/descriptor.mbt`, `registry/registry.mbt`, `registry/evaluator.mbt`
- Modify: `scale_catalog.mbt`
- Test: `registry/registry_test.mbt`, `registry/evaluator_test.mbt`

- [ ] Write tests for catalog listing, lookup, aliases, supported versions, and unknown scale errors.
- [ ] Implement a stable registry with explicit evaluator dispatch for every existing scale.
- [ ] Add composite named-input evaluation with missing fields and deterministic output ordering.
- [ ] Run targeted registry tests and full warning-free checks.
- [ ] Commit `feat: add versioned score registry`.

### Task 4: Implement CSV and batch processing

**Files:**
- Create: `interop/csv_parser.mbt`, `interop/csv_writer.mbt`, `batch/batch_model.mbt`, `batch/batch_runner.mbt`
- Test: `interop/csv_parser_test.mbt`, `batch/batch_runner_test.mbt`

- [ ] Write failing tests for quoted commas, escaped quotes, blank lines, short rows, duplicate headers, and invalid integers.
- [ ] Implement a dependency-free CSV parser with row/column diagnostics.
- [ ] Implement batch evaluation that preserves input order and emits per-row success/error records.
- [ ] Add JSON-lines serialization and golden cases for mixed valid/invalid batches.
- [ ] Run native tests because batch paths target CLI use.
- [ ] Commit `feat: add deterministic CSV batch evaluation`.

### Task 5: Add FHIR-shaped interoperability records

**Files:**
- Create: `interop/fhir_model.mbt`, `interop/fhir_observation.mbt`, `interop/fhir_questionnaire.mbt`
- Test: `interop/fhir_test.mbt`

- [ ] Write tests for observation status, code/display mapping, score value, missing values, and round-trip stable JSON.
- [ ] Implement transport-only FHIR-shaped records with no patient-identifying fields.
- [ ] Add conversion from `ScoreResult` and explicit unsupported/missing semantics.
- [ ] Run formatter, check, and native tests.
- [ ] Commit `feat: add FHIR-shaped score adapters`.

### Task 6: Add audit, version, and reproducibility utilities

**Files:**
- Create: `audit/version.mbt`, `audit/trace.mbt`, `audit/reproducibility.mbt`
- Test: `audit/audit_test.mbt`

- [ ] Write tests for stable event ordering, source hashes supplied by callers, and deterministic run summaries.
- [ ] Implement append-only in-memory audit records and reproducibility metadata.
- [ ] Ensure audit records contain no implicit patient data.
- [ ] Run all tests and review public API output with `moon info`.
- [ ] Commit `feat: add reproducibility and audit records`.

### Task 7: Extend CLI and create real case runner

**Files:**
- Modify: `cmd/main/main.mbt`, `cmd/main/moon.pkg`
- Create: `cmd/main/commands.mbt`, `cmd/main/output.mbt`, `cmd/main/usage.mbt`
- Test: `cmd/main/main_test.mbt`

- [ ] Write CLI cases for catalog, single evaluation, batch CSV, malformed input, and JSON-lines output.
- [ ] Implement thin command parsing over public registry/batch APIs.
- [ ] Keep exit behavior deterministic and preserve the existing commands.
- [ ] Run CLI smoke tests on wasm-gc and native targets.
- [ ] Commit `feat: extend neuroscore CLI workflows`.

### Task 8: Build benchmark suite and auditable line-count tooling

**Files:**
- Create: `bench/cases.mbt`, `bench/runner.mbt`, `bench/metrics.mbt`, `bench/benchmark_test.mbt`
- Create: `scripts/count-lines.ps1`, `scripts/run-benchmarks.ps1`
- Modify: `scripts/benchmark.ps1`, `BENCHMARKS.md`

- [ ] Write benchmark tests for case generation, warmup exclusion, throughput calculation, and zero-duration protection.
- [ ] Implement deterministic case families covering valid endpoints, invalid values, registry lookup, CSV batches, and FHIR conversion.
- [ ] Implement separate production/test/fixture line counts and fail the guard below 20,000 in-scope lines.
- [ ] Run benchmarks twice and record both raw outputs and environment information.
- [ ] Commit `feat: add reproducible benchmark and size reports`.

### Task 9: Expand real boundary and integration corpus

**Files:**
- Create: `cases/` fixture packages, one focused file per scale/adapter family
- Create: `tests/` integration packages and golden outputs
- Modify: `.github/workflows/test.yml`, `README.md`, `README.mbt.md`, `CHANGELOG.md`

- [ ] Add reviewed, non-clinical synthetic cases for every supported domain endpoint and transport failure mode.
- [ ] Add integration tests for single score → registry → JSON/FHIR, CSV → batch → JSON-lines, and CLI workflows.
- [ ] Run the line-count report and reject any generated filler or duplicated case blocks.
- [ ] Add CI steps for native tests, benchmark smoke, and the line-count guard.
- [ ] Commit `test: add comprehensive score and adapter corpus`.

### Task 10: Final verification, publish, and handoff

**Files:**
- Modify: `moon.mod`, `CHANGELOG.md`, `BENCHMARKS.md`
- Verify: all source, tests, workflows, and generated interfaces

- [ ] Run `moon fmt --check`, `moon check --deny-warn`, wasm-gc tests, native tests, `moon info`, CLI cases, benchmarks, and line counts.
- [ ] Confirm `PROPOSAL.md` has no diff and `_build` is excluded.
- [ ] Review `git diff`, commit history, default branch, and remote status.
- [ ] Commit the release version only after all verification commands pass.
- [ ] Push GitHub `main`, publish the new Mooncakes version, and re-check the remote state.
