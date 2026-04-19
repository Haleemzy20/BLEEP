# bleep-state

**State Management, Sharding & Self-Healing for BLEEP**

`bleep-state` owns the canonical ledger state of the BLEEP blockchain: the Sparse Merkle Trie, RocksDB persistence, shard lifecycle management, cross-shard 2PC coordination, snapshot/rollback, and the self-healing orchestrator.

---

## License

Licensed under **MIT**.
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-state
├── state_manager            — StateManager: primary interface for reads/writes
├── state_merkle             — Sparse Merkle Trie (SHA3-256), MerkleProof
├── state_storage            — RocksDB read/write layer
├── transaction              — State-layer transaction wrapper
├── block / consensus / p2p  — State-side representations of cross-crate types
│
├── Sharding
│   ├── shard_manager        — ShardManager: shard CRUD and routing
│   ├── shard_registry       — Global shard registry with DashMap
│   ├── shard_lifecycle      — Shard creation, activation, deactivation
│   ├── shard_epoch_binding  — Shard/epoch synchronisation
│   ├── shard_checkpoint     — Per-shard snapshot engine
│   ├── shard_rollback       — Shard-level rollback to checkpoint
│   ├── shard_isolation      — Fault containment boundaries
│   ├── shard_fault_detection — AI-assisted shard anomaly detection
│   ├── shard_healing        — Automated shard recovery
│   ├── shard_validator_assignment — Validator-to-shard mapping
│   ├── shard_validator_slashing   — Shard-scoped slashing
│   └── shard_ai_extension   — AI advisory hooks for shard decisions
│
├── Cross-Shard
│   ├── cross_shard_transaction  — CrossShardTx type
│   ├── cross_shard_2pc          — Two-Phase Commit coordinator
│   ├── cross_shard_locking      — Account-level distributed locks
│   ├── cross_shard_recovery     — 2PC abort & compensation
│   ├── cross_shard_safety_invariants — Cross-shard safety proofs
│   └── cross_shard_ai_hooks     — AI advisory for cross-shard routing
│
├── Recovery & Healing
│   ├── rollback_engine          — Full-chain rollback to epoch snapshot
│   ├── snapshot_engine          — Epoch-boundary state snapshots
│   ├── self_healing_orchestrator — Coordinates fault response pipeline
│   ├── advanced_fault_detector  — Multi-signal anomaly detection
│   └── phase4_recovery_orchestrator — Phase 4 advanced recovery
│
└── Protocol
    ├── protocol_versioning      — Live protocol rule switching
    └── quantum_secure           — State-layer PQC helpers
```

---

## State Model

Each account is stored in the Sparse Merkle Trie as:

```rust
struct AccountState {
    balance: u128,           // microBLEEP
    nonce: u64,
    code_hash: Option<[u8; 32]>,
    storage_root: [u8; 32],
}
```

The global state root is SPHINCS+-signed by the block producer and verified by all validators.

---

## StateManager

The primary interface for all state reads and writes:

```rust
use bleep_state::state_manager::StateManager;

let manager = StateManager::new(db_path)?;

// Read
let balance = manager.balance(&address)?;
let nonce = manager.nonce(&address)?;
let proof = manager.merkle_proof(&address)?;

// Write (via StateDiff from bleep-vm)
manager.apply(state_diff)?;
```

---

## Cross-Shard 2PC

Transactions touching multiple shards use Two-Phase Commit:

```
Phase 1 (Prepare): All affected ShardManagers acquire locks and return PrepareReceipt
Phase 2 (Commit):  Coordinator commits all if all ready; otherwise Abort
```

Handled by `cross_shard_2pc.rs`. Stale 2PC operations are swept by `bleep-scheduler`'s `cross_shard_timeout_sweep` task.

---

## Self-Healing

```
AdvancedFaultDetector detects anomaly
        ↓
SelfHealingOrchestrator activates
        ↓
  ShardFaultDetection isolates affected shard
        ↓
  RollbackEngine restores last good snapshot
        ↓
  ShardHealing replays validated blocks
        ↓
  Shard re-joins the active set
```

---

## Snapshots & Rollback

- `SnapshotEngine` writes a full state snapshot at each epoch boundary.
- `RollbackEngine` restores any snapshot and replays subsequent validated blocks.
- Fuzz targets in `src/fuzz/` cover Merkle insert and state apply paths.

---

## Testing

```bash
cargo test -p bleep-state
```

Phase 2, Phase 4, and proptest suites are in `phase2_integration_tests.rs`, `phase4_integration_tests.rs`, and `proptest_sprint8.rs`.

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
