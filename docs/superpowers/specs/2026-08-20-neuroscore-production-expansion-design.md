# moonbit-neuroscore Production Expansion Design

## Goal

Expand the existing MoonBit scoring package into a maintainable integration toolkit with approximately 20,000 lines across production library code, adapters, CLI tooling, benchmarks, and independently reported test cases. Preserve deterministic scoring behavior, explicit invalid-input handling, the medical safety boundary, and the existing public calculators.

## Scope and counting policy

The line-count target includes:

- production MoonBit library code;
- CLI and batch-processing code;
- CSV, JSON, and FHIR-shaped interoperability adapters;
- scale registry, version metadata, validation, and audit utilities;
- benchmark harnesses and reproducible case fixtures;
- tests and boundary cases, reported separately from production code.

Generated build output, `_build`, duplicated functions, filler comments, and unverified clinical claims are excluded.

## Architecture

The root package remains the stable facade and owns public domain types. Focused subpackages provide serialization, tabular batch processing, interoperability records, registry/version metadata, and benchmark case execution. The CLI composes these packages but does not contain scoring rules. Each adapter converts into the typed score model and preserves missing/invalid states instead of silently coercing them.

### Domain layer

Retain `RiskBand`, `ScoreResult`, `EvidenceNote`, and existing calculators. Add structured case identifiers, validation diagnostics, score provenance, and aggregation primitives. Every public calculator must document accepted ranges, boundary behavior, and non-clinical usage.

### Registry and evaluation layer

Add stable descriptors for supported scales, version/source metadata, lookup, capability discovery, and a generic evaluator result. The registry is descriptive and cannot invent a score for an unknown scale. Composite evaluation will support named inputs, missing-field reporting, deterministic ordering, and audit events.

### Interoperability layer

Implement dependency-light CSV row parsing, batch evaluation, JSON-lines output, and FHIR Observation/QuestionnaireResponse-shaped records. These are transport representations only; no network or patient-identifying storage is introduced. Parsers return explicit errors with row/field context.

### CLI and benchmarks

Extend the CLI with catalog listing, single-score JSON, batch CSV input, JSON-lines output, and benchmark case execution. Benchmarks report toolchain, sample count, elapsed time, throughput, and case mix. They do not claim clinical validity or cross-machine comparability.

### Test strategy

Use black-box tests for public APIs and focused white-box tests only for parser/validation internals. Cover every supported range endpoint, just-outside invalid values, malformed transport rows, duplicate fields, empty inputs, deterministic ordering, JSON escaping, and representative end-to-end CLI cases. Keep production and test line counts separate in a generated report.

## Non-goals

- diagnosis, prognosis, treatment recommendations, or patient-specific medical advice;
- claiming regulatory approval or clinical validation;
- network services, databases, authentication, or PHI handling;
- modifying `PROPOSAL.md`.

## Acceptance criteria

1. `moon check --deny-warn`, wasm-gc tests, native tests, formatting, and interface generation pass.
2. Existing public calculators retain their current totals and invalid-input semantics.
3. New adapters have deterministic success/error behavior and boundary tests.
4. Benchmark output is reproducible and checked into a dated report without fabricated values.
5. A line-count script reports production MoonBit lines and test/benchmark lines independently; the combined in-scope total is at least 20,000 lines.
6. CI runs the same checks and line-count guard as local validation.
