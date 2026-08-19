# Benchmarks

The benchmark is a CLI-throughput smoke measurement, not a clinical accuracy study. It executes the real `cmd/main` path repeatedly with deterministic valid GCS inputs, so the result includes process startup and JSON output overhead.

## Reproduction

```powershell
pwsh ./scripts/benchmark.ps1
```

## Recorded run

| Date | Toolchain | Samples | Elapsed | Throughput |
| --- | --- | ---: | ---: | ---: |
| 2026-08-20 | moon 0.1.20260807 (4da23f8) | 100 | 12,515.47 ms | 7.99 requests/s |

This run was performed on the maintainer workstation. Results vary with operating system, filesystem cache, CPU, and process-launch cost; compare runs only on the same environment.
