$ErrorActionPreference = "Stop"
moon fmt --check
moon check --deny-warn
moon test --deny-warn
moon info
moon run cmd/main -- calc gcs 3 4 5
moon run cmd/main -- explain ich-score 1 1 1 1 0
