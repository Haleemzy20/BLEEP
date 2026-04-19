# bleep-pat

**Programmable Asset Token (PAT) Engine v2**

`bleep-pat` implements BLEEP's native programmable asset standard. PATs are intent-driven, gas-metered, protocol-level tokens with embedded compliance rules, ZKP-backed privacy options, and cross-chain portability via BLEEP Connect.

---

## License

Licensed under **MIT** (your choice).
Copyright © 2025 Muhammad Attahir.

---

## Architecture: 6-Layer Intent-Driven Engine

```
┌───────────────────────────────────────────────────────────────┐
│  Layer 1 — Intent Layer                                       │
│  CreateTokenIntent | MintIntent | BurnIntent | TransferIntent │
│  ApproveIntent | TransferFromIntent | FreezeIntent | …        │
├───────────────────────────────────────────────────────────────┤
│  Layer 2 — Error Types                                        │
│  PATError · PATResult<T>                                      │
├───────────────────────────────────────────────────────────────┤
│  Layer 3 — Token State                                        │
│  PATToken · TokenLedger · AllowanceTable                      │
├───────────────────────────────────────────────────────────────┤
│  Layer 4 — StateDiff                                          │
│  PATStateDiff · BalanceDelta · SupplyDelta · PATEvent         │
├───────────────────────────────────────────────────────────────┤
│  Layer 5 — Gas Model                                          │
│  PATGasModel — deterministic cost per operation               │
├───────────────────────────────────────────────────────────────┤
│  Layer 6 — Engine + Registry                                  │
│  PATEngine (pure, produces diff) · PATRegistry (apply diff)   │
└───────────────────────────────────────────────────────────────┘
```

---

## Core Modules

### `intent`

Typed intent structs for all PAT operations. Every PAT operation is expressed as an intent — never as raw function calls — mirroring the design of `bleep-vm`.

Key types: `CreateTokenIntent`, `MintIntent`, `BurnIntent`, `TransferIntent`, `ApproveIntent`, `FreezeIntent`.

### `token`

Token state management: `PATToken` (metadata + supply + ruleset), `TokenLedger` (per-account balances), `AllowanceTable` (ERC-20-style approvals).

### `state_diff`

`PATStateDiff` describes all state changes produced by one PAT operation in a revertable, serialisable form. Applied atomically to `bleep-state`.

### `pat_engine` / `registry`

`PATEngine` is a pure function: given an intent and the current state, it returns a `PATStateDiff` without side effects. `PATRegistry` maintains the canonical set of deployed PATs and applies diffs.

### `gas_model`

`PATGasModel` assigns deterministic gas costs to each operation type, normalised to BLEEP gas units consistent with `bleep-vm`'s `GasModel`.

---

## Token Ruleset

Each PAT carries a `Ruleset` that governs its behaviour:

| Rule | Description |
|------|-------------|
| `transferable` | Whether the token can be transferred |
| `compliance_flags` | Jurisdictional or KYC requirements (e.g. `KYC_REQUIRED`) |
| `freeze_authority` | Account that may freeze balances |
| `mint_authority` | Account that may mint new supply |
| `max_supply` | Hard cap on total supply |
| `expiry` | Optional expiry timestamp |

---

## RPC Integration

PATs are created and queried via the BLEEP RPC:

```bash
# Mint a PAT
POST /rpc/pat/mint

# Query balance
GET /rpc/pat/balance/{address}
```

See the [RPC API Specification](../docs/specs/rpc_api_spec.md) for full details.

---

## Use Cases

- Tokenised real estate and securities
- Enterprise compliance assets with programmatic restrictions
- Dynamic NFTs with mutable metadata
- Supply chain provenance tokens
- Confidential tokenised shares (ZKP transfers)

---

## Testing

```bash
cargo test -p bleep-pat
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
