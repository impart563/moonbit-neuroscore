# moonbit-neuroscore

Typed, explainable neurosurgical scoring primitives for MoonBit. The library is designed for teaching tools, research prototypes, data-quality pipelines, and integration adapters that need deterministic ordinal calculations with explicit invalid-input handling.

## Core capabilities

- GCS, mRS, Hunt–Hess, WFNS, modified Fisher, ICH Score, and ASPECTS calculators.
- A common `ScoreResult` model with total, risk band, missing fields, explanation, and evidence notes.
- Deterministic JSON output and a small CLI for smoke tests and demos.
- Pure functions with explicit range validation; invalid values never become a plausible score.

## Quick start

Requires the current MoonBit stable toolchain.

```bash
moon check --deny-warn
moon test --deny-warn
moon run cmd/main -- calc gcs 3 4 5
```

## CLI

```text
neuroscore calc gcs EYE VERBAL MOTOR
neuroscore explain ich-score GCS AGE VOLUME IVH INFRATENTORIAL
```

The CLI emits one JSON object per command and is suitable for shell pipelines. It is intentionally a calculation/demo interface, not a clinical decision system.

## Architecture

The root package contains domain types and score functions. Serialization is kept separate from scoring so callers can use the typed API without depending on JSON. `cmd/main` is a thin adapter over the library. `SOURCES.md` records formula provenance and the safety boundary.

## Benchmarks

Run `pwsh ./scripts/benchmark.ps1` for a local, reproducible throughput measurement. The script reports the command, toolchain, sample count, elapsed time, and requests/second; it does not claim clinical accuracy or compare hardware across machines. See [BENCHMARKS.md](BENCHMARKS.md) for the recorded run and limitations.

## Tests and CI

`moon test --deny-warn` covers normal cases and invalid/range boundaries. CI runs formatting, warning-free checks, interface generation, wasm-gc tests, native tests, coverage summary, and CLI smoke tests on every push and pull request.

## License

MIT; see [LICENSE](LICENSE).

Further tested package documentation is in [README.mbt.md](README.mbt.md).
