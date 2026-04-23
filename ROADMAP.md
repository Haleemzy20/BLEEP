# BLEEP Roadmap

This document outlines the planned development trajectory for the BLEEP blockchain ecosystem. Milestones are organised by phase. Completed sprints are marked accordingly; upcoming work is subject to change based on governance decisions and community feedback.

> All protocol-level changes after mainnet launch will be proposed and adopted through the BLEEP self-amending governance process.

---

## Status Key

| Symbol | Meaning |
|--------|---------|
| ✅ | Complete |
| 🔄 | In progress |
| 🔲 | Planned |
| 🔵 | Governance-gated |

---

## Phase 1 — Foundation (Sprints 1–2) ✅

**Goal:** Establish the workspace, cryptographic primitives, and core data structures.

- ✅ Cargo workspace with 19 crate members
- ✅ `bleep-crypto`: Falcon, Kyber, SPHINCS+, AES-GCM, Ed25519, BIP-39, HKDF
- ✅ `bleep-core`: Block, ZKTransaction, mempool, networking stubs
- ✅ Genesis configuration (`config/genesis.json`)
- ✅ Project documentation: README, BUILDING, CONTRIBUTING, SECURITY, CODE-OF-CONDUCT, NOTICE, LICENSE

---

## Phase 2 — Consensus & State (Sprints 3–4) ✅

**Goal:** Deliver a working multi-mode consensus engine and Sparse Merkle Trie state layer.

- ✅ `bleep-consensus`: PoS, PBFT, PoW engines; epoch management; validator identity and slashing
- ✅ `bleep-consensus`: AI adaptive mode selection (linfa k-NN); `ConsensusOrchestrator`
- ✅ `bleep-state`: Sparse Merkle Trie, `StateManager`, RocksDB persistence
- ✅ `bleep-state`: Shard manager and registry; protocol versioning
- ✅ `bleep-governance` Phase 2: on-chain governance core; deterministic executor
- ✅ `bleep-crypto`: ZKP module (Groth16, Bulletproofs, key revocation)
- ✅ `bleep-ai` Phase 3: deterministic inference, attestation, constraint validator, consensus integration, feedback loop

---

## Phase 3 — Virtual Machine & Interoperability (Sprints 5–6) ✅

**Goal:** Deploy the multi-engine VM, PAT engine, P2P stack, and economics layer.

- ✅ `bleep-vm` v0.5: 7-layer intent-driven VM (EVM / WASM / ZK engines); unified gas model; deterministic sandbox; `StateDiff`
- ✅ `bleep-vm` BSL-1.1 licence; Change Date: 2028-07-13
- ✅ `bleep-pat` v2: 6-layer intent-driven PAT engine; `PATRegistry`; `PATGasModel`
- ✅ `bleep-interop`: All 10 BLEEP Connect sub-crates; Layer 4 instant intent pool; executor node
- ✅ `bleep-p2p`: Kademlia DHT, Plumtree gossip, onion router, Kyber-768 session crypto
- ✅ `bleep-economics` Phase 1–4: tokenomics, fee market, validator incentives, distribution
- ✅ `bleep-auth`: credentials, session (JWT), RBAC, identity, validator binding, audit log, rate limiter
- ✅ `bleep-scheduler`: 14 built-in protocol maintenance tasks
- ✅ `bleep-telemetry`: Prometheus-compatible metrics; load balancer
- ✅ `bleep-indexer`: Block, Tx, Account, Governance, Validator, Shard indexes
- ✅ `bleep-wallet-core`: Falcon & SPHINCS+ keys, BIP-39 wallets
- ✅ `bleep-cli` Sprint 6: validator staking, governance, AI, ZKP, faucet commands
- ✅ `bleep-governance` Phase 4: constitution, ZK voting, proposal lifecycle, forkless upgrades

---

## Phase 4 — Self-Healing & AI Advisory (Sprints 7–8) ✅

**Goal:** Deliver cross-shard atomicity, self-healing orchestration, and the AI Phase 4 advisory system.

- ✅ `bleep-state`: Cross-shard 2PC (`cross_shard_2pc.rs`), locking, recovery, safety invariants
- ✅ `bleep-state`: Advanced fault detector, self-healing orchestrator, rollback engine, snapshot engine
- ✅ `bleep-state`: Shard lifecycle (create, activate, deactivate), epoch binding, checkpoint, healing
- ✅ `bleep-ai` Phase 4: feature extractor, AI decision module, governance integration
- ✅ `bleep-governance` Phase 5: AI-driven protocol evolution, APAIPs, safety constraints, deterministic activation
- ✅ `bleep-economics` Phase 5: oracle bridge, game-theoretic safety proofs
- ✅ Testnet faucet: 10 BLEEP per address per 24 hours; auto-credit on wallet creation
- ✅ `bleep-zkp`: STARK block validity circuit (Winterfell); post-quantum ZKP constructions
- ✅ `docs/phase4_shard_recovery.md`

---

## Phase 5 — Hardening & Audit (Sprint 9) ✅

**Goal:** Security audit preparation, chaos testing, fuzz testing, and documentation completeness.

- ✅ `bleep-consensus`: chaos engine (`ChaosEngine`); performance benchmarking (`PerformanceBenchmark`)
- ✅ `bleep-consensus`: `security_audit.rs` for on-demand audit report generation
- ✅ `bleep-state` fuzz targets: `fuzz_merkle_insert`, `fuzz_state_apply_tx`
- ✅ `bleep-crypto` fuzz targets: transaction signing, Merkle commitment
- ✅ `bleep-state`: 40+ property-based tests (`proptest_sprint8.rs`)
- ✅ `tests/sprint9_integration.rs`: end-to-end integration suite
- ✅ `docs/THREAT_MODEL.md`, `docs/SECURITY_AUDIT_SPRINT9.md`
- ✅ All `docs/specs/` and `docs/tutorials/` placeholders replaced with full content
- ✅ `docs/glossary.md` populated
- ✅ Per-crate `README.md` files for all 18 workspace crates
- ✅ `CHANGELOG.md` published
- ✅ `ROADMAP.md` published
- ✅ `LICENSE_BSL.md` for `bleep-vm`

---

## Phase 6 — External Audit & Testnet Beta (Q2 2026) 🔄

**Goal:** Independent third-party security audit, bug bounty programme, and public testnet beta.

- 🔄 Engage independent security auditors for `bleep-crypto`, `bleep-consensus`, `bleep-state`, `bleep-interop`
- 🔲 Publish audit reports on GitHub
- 🔲 Launch public bug bounty programme
- 🔲 Deploy `bleep-testnet-1` with public validator registration
- 🔲 Distribute testnet BLP to early contributors and validators
- 🔲 Publish BLEEP Whitepaper v1.0
- 🔲 Explorer UI for block, transaction, and governance browsing
- 🔲 Developer documentation site (`docs.bleepecosystem.com`)

---

## Phase 7 — Mainnet Candidate (Q3–Q4 2026) 🔲

**Goal:** Mainnet readiness — economic activation, ecosystem tooling, and final governance ratification.

- 🔲 Mainnet genesis ceremony (validator set selection via governance)
- 🔲 BLP token generation event (TGE)
- 🔲 Activate `bleep-economics` mainnet emission schedule
- 🔲 Launch BLEEP Connect Layer 4 on mainnet (Ethereum bridge first)
- 🔲 Rust SDK v1.0 release (`bleep-sdk`)
- 🔲 TypeScript/JavaScript SDK release
- 🔲 BLEEP Wallet mobile app (iOS + Android)
- 🔲 `ink!` developer documentation and contract template library
- 🔄 EVM contract compatibility layer (full Solidity developer documentation)

---

## Phase 8 — Ecosystem Expansion (2027) 🔲

**Goal:** Expand cross-chain integrations, Layer 3 STARK bridges, and developer ecosystem.

- 🔲 BLEEP Connect Layer 3 (STARK proof relay): Ethereum, Polkadot, Cosmos
- 🔲 BLEEP Connect Layer 2 (full-node verification): $100M+ transfer path
- 🔲 BLEEP Connect Layer 1 (social governance): catastrophic failure recovery
- 🔵 Governance vote: activate additional supported chains (BSC, Solana, Avalanche)
- 🔲 `bleep-vm`: Move language engine (alongside EVM and WASM)
- 🔲 `bleep-vm` BSL-1.1 → Apache-2.0 Change Date: **2028-07-13**
- 🔲 Sub-second block times (target: 200ms) via optimised PBFT with pipelined signing
- 🔲 zkEVM compatibility mode for Ethereum dApp portability
- 🔲 AI model governance: community-submitted model proposals via APAIPs

---

## Phase 9 — Quantum-Safe Mainnet (2028+) 🔲

**Goal:** Full post-quantum security across all network paths, and BSL → Apache-2.0 conversion for `bleep-vm`.

- 🔲 Mandatory Falcon signatures for all transaction types (Ed25519 sunset)
- 🔲 SPHINCS+ state root signing enforced for all validators
- 🔲 Kyber-1024 mandatory for all session key establishment
- 🔲 `bleep-vm` licence converts from BSL-1.1 to Apache-2.0 (2028-07-13)
- 🔵 Governance vote: post-quantum cryptography enforcement across BLEEP Connect bridges
- 🔲 Quantum-safe ZK voting for all governance proposals
- 🔲 Long-range quantum attack mitigation research publication

---

## Community & Governance Contributions

The BLEEP roadmap is not fixed. Any community member may propose changes to priorities, timelines, or scope via the governance system:

```bash
bleep-cli governance propose ./my_proposal.json
```

High-priority items identified by the community can be fast-tracked via the `ProtocolUpgrade` proposal type. See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to get involved.

---

*Last updated: April 2026 — BLEEP V1 / Sprint 9*
*Website: [bleepecosystem.com](https://www.bleepecosystem.com) | GitHub: [BleepEcosystem/BLEEP-V1](https://github.com/BleepEcosystem/BLEEP-V1)*
