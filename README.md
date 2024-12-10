[![update-flake-lock](https://github.com/karpfediem/yara-sigs/actions/workflows/auto-update-flake.yml/badge.svg)](https://github.com/karpfediem/yara-sigs/actions/workflows/auto-update-flake.yml)

# Run

### With yara available in your PATH

```bash
nix run git+https://github.com/karpfediem/yara-sigs local/path/to/scan
nix run . local/path/to/scan
```

### Without yara available in your PATH

```bash
nix develop git+https://github.com/karpfediem/yara-sigs -c yara-sigs local/path/to/scan
nix develop . -c yara-sigs local/path/to/scan
```

# Components

## Signatures
A collection of malware signatures: https://github.com/Neo23x0/signature-base

Some signatures are only compatible with proprietary signature checkers [THOR or LOKI](https://github.com/Neo23x0/signature-base?tab=readme-ov-file#external-variables-in-yara-rules). Signatures incompatible with yara are filtered out.

## Wrapper script
A tiny wrapper script around `yara` (https://github.com/VirusTotal/yara) - `yara-sigs` which calls yara with the directory of the filtered signatures above.
