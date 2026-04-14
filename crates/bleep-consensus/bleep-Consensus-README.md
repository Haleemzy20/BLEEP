# bleep-consensus

**Adaptive, AI-Powered, Quantum-Secure Consensus Engine**

`bleep-consensus` implements BLEEP's multi-mode adaptive consensus mechanism. It dynamically selects between Proof of Stake (PoS), Practical Byzantine Fault Tolerance (PBFT), and Proof of Work (PoW) in real time based on network health signals evaluated by the AI engine.

---

## License

Licensed under **MIT OR Apache-2.0** (your choice).
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-consensus
├── consensus              — BLEEPAdaptiveConsensus, ConsensusMode, Validator
├── engine                 — ConsensusEngine trait, ConsensusError, ConsensusMetrics
├── pos_engine             — Proof of Stake implementation
├── pbft_engine            — Practical Byzantine Fault Tolerance
├── pow_engine             — Proof of Work fallback
├── orchestrator           — ConsensusOrchestrator: selects and delegates to engines
├── epoch                  — EpochConfig, EpochState, epoch transition logic
├── validator_identity     — ValidatorIdentity, ValidatorRegistry, ValidatorState
├── slashing_engine        — SlashingEngine, SlashingEvidence, automatic penalties
├── finality               — FinalityCertificate, FinalityProof, FinalizityManager
├── block_producer         — Block assembly, signing, and broadcast
├── blockchain_state       — In-memory chain state mirror
├── ai_adaptive_logic      — linfa-based k-NN consensus mode predictor
├── networking             — Peer-to-peer proposal and vote relay
├── gossip_bridge          — GossipBridge connecting consensus to bleep-p2p
├── shard_coordinator      — Cross-shard transaction routing during consensus
├── chaos_engine           — Fault injection for testing (ChaosEngine)
├── performance_bench      — TPS benchmarking (target: TARGET_TPS)
└── security_audit         — On-demand audit report generation
```

---

## Consensus Mode Selection

The AI engine uses a k-nearest-neighbour model (via `linfa`) trained on network telemetry to select the optimal consensus mode each epoch:

| Network Reliability Score | Selected Mode | Rationale |
|--------------------------|---------------|-----------|
| `< 0.6` | PoW | Censorship-resistant fallback under attack |
| `0.6 – 0.8` | PBFT | Fast finality in partially trusted validator sets |
| `> 0.8` | PoS | Energy-efficient under stable conditions |

Mode switches are logged, signed, and traceable.

---

## Epoch Lifecycle

Each epoch:
1. `EpochConfig` determines validator set membership and shard assignments.
2. `ConsensusOrchestrator::select_mode()` evaluates current `ConsensusMetrics`.
3. The selected engine produces and validates blocks for the epoch duration.
4. `SlashingEngine` sweeps for evidence at epoch close.
5. `FinalizityManager` emits `FinalityCertificate` for the epoch's terminal block.
6. Validator rewards are distributed by `bleep-economics`.

---

## Slashing

Validators are automatically slashed for:

| Offence | Penalty |
|---------|---------|
| Double signing | Up to 50% stake deduction |
| Prolonged downtime | Progressive small deductions |
| Byzantine vote | Up to 100% stake deduction + ban |

Evidence is submitted via `POST /rpc/validator/evidence` and processed by `SlashingEngine`.

---

## Quick Start

```rust
use bleep_consensus::run_consensus_engine;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    run_consensus_engine()
}
```

---

## Block Producer Constants

| Constant | Value | Description |
|----------|-------|-------------|
| `MAX_TXS_PER_BLOCK` | 10,000 | Maximum transactions per block |
| `BLOCK_INTERVAL_MS` | 500 | Target block time in milliseconds |

---

## Testing

```bash
cargo test -p bleep-consensus
```

Chaos and performance tests are in the `chaos_engine` and `performance_bench` modules.

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
