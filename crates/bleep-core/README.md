# bleep-core

**Core Blockchain Logic, Transactions & Protocol Enforcement**

`bleep-core` is the foundational crate of the BLEEP blockchain. It owns block and transaction structures, the mempool, protocol invariant enforcement, anti-asset-loss recovery logic, and proof-of-identity primitives.

---

## License

Licensed under **MIT**.
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-core
├── block                  — Block struct, derive_block_keypair, hash computation
├── block_validation       — Structural and cryptographic block validation rules
├── blockchain             — In-memory chain ledger
├── transaction            — ZKTransaction: quantum-signed transaction type
├── transaction_manager    — Lifecycle management: creation → validation → broadcast
├── transaction_pool       — Priority-ordered mempool pool
├── mempool                — DashMap-backed in-memory mempool
├── mempool_bridge         — Async bridge from mempool to consensus (run_mempool_bridge)
├── state                  — Lightweight state mirror (account balances/nonces)
├── networking             — Core P2P message dispatch
├── proof_of_identity      — ZKP-based identity proof primitives
├── anti_asset_loss        — Asset recovery request lifecycle
├── protocol_invariants    — Declarative invariant definitions
├── invariant_enforcement  — Runtime invariant assertion engine
├── decision_attestation   — Attested on-chain decisions (signed outcomes)
├── decision_verification  — Verification of attested decisions
└── tests                  — Unit test suite
```

---

## Key Types

### `ZKTransaction`

All transactions on BLEEP are `ZKTransaction` — quantum-signed payloads carrying:

- `from` / `to` addresses
- `amount` (microBLEEP)
- `nonce` (anti-replay)
- `gas_limit`
- Falcon or Ed25519 signature
- Optional ZK auxiliary data

### `Block`

A block contains an ordered list of `ZKTransaction`s, links to the previous block hash, a SPHINCS+-signed state root, and a timestamp.

### `AntiAssetLoss`

Allows token holders to submit a ZKP-backed ownership proof when keys are lost. The request enters a governance queue for quorum approval.

---

## Protocol Invariants

`bleep-core` defines the canonical set of protocol invariants checked by `InvariantEnforcement` at runtime:

- Total supply conservation (minted − burned = circulating)
- Nonce monotonicity per account
- No negative balances
- Block hash chain continuity
- ZK proof inclusion in recovery requests

---

## Mempool Bridge

`run_mempool_bridge()` is an async task that monitors the mempool and forwards transactions to the `bleep-consensus` block producer over a Tokio channel. It applies:

- Fee-based prioritisation
- Max mempool size enforcement (oldest low-fee txs are evicted)
- Duplicate detection by transaction hash

---

## Quick Start

```rust
use bleep_core::{Block, ZKTransaction, run_mempool_bridge};

// Transactions are created via the wallet and submitted to the mempool.
// The mempool bridge forwards them to consensus automatically.
tokio::spawn(run_mempool_bridge(mempool.clone(), tx_channel));
```

---

## Testing

```bash
cargo test -p bleep-core
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
