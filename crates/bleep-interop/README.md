# bleep-interop

**BLEEP Connect — Quantum-Secure Cross-Chain Interoperability**

`bleep-interop` is the single public façade over the 10 BLEEP Connect sub-crates. It enables secure, trust-minimised asset transfers and proof verification across BLEEP and external networks (Ethereum, Polkadot, Cosmos, Solana, and others) via a 4-layer bridge architecture.

---

## License

Licensed under **MIT**
Copyright © 2025 BLEEP Core Team.

---

## Sub-Crate Organisation

```
bleep-interop
├── bleep-connect-types            — Shared types: ChainId, InstantIntent, AssetDescriptor, …
├── bleep-connect-crypto           — SPHINCS+, Kyber-1024, Ed25519, AES-GCM cross-chain crypto
├── bleep-connect-commitment-chain — BFT micro-chain anchoring cross-chain state commitments
├── bleep-connect-adapters         — Per-chain encode/verify adapters (Ethereum, Solana, …)
├── bleep-connect-executor         — Executor node: monitors intent pool, bids, executes
├── bleep-connect-layer4-instant   — Optimistic intents: 200ms–1s, 99.9% of transfers
├── bleep-connect-layer3-zkproof   — STARK proofs + batch aggregation (post-quantum secure)
├── bleep-connect-layer2-fullnode  — Full-node verification for transfers > $100M
├── bleep-connect-layer1-social    — On-chain social governance for catastrophic events
└── bleep-connect-core             — Top-level orchestrator
```

External BLEEP crates (`bleep-governance`, `bleep-vm`, `bleep-core`) import from `bleep-interop` rather than the individual sub-crates directly.

---

## Bridge Architecture (4 Layers)

### Layer 4 — Instant (Optimistic)
- **99.9% of all transfers** use this path.
- Executor nodes optimistically bridge assets within 200ms–1s.
- Backed by a collateral bond; incorrect execution results in slashing.
- Entry point: `POST /rpc/connect/intent`

### Layer 3 — ZK Proof
- Used when Layer 4 optimism is insufficient or challenged.
- Generates STARK proofs (post-quantum, no trusted setup) over the source chain state.
- Proofs are batched and aggregated to minimise on-chain footprint.

### Layer 2 — Full-Node Verification
- Reserved for transfers above a configurable threshold (default: $100M equivalent).
- Requires full-node light client validation of the source chain header.

### Layer 1 — Social Governance
- Catastrophic failure path (bridge exploit, network partition).
- Humans vote via BLEEP governance to authorise recovery actions.
- Highest security, slowest resolution.

---

## Commitment Chain

The `bleep-connect-commitment-chain` is a BFT micro-chain that:

- Anchors cross-chain state roots at each epoch.
- Allows any BLEEP node to verify the state of external networks without running a full node.
- Provides the basis for Layer 3 STARK proof generation.

---

## Nullifier Store

`nullifier_store.rs` maintains a persistent set of spent nullifiers to prevent double-spending in ZKP-based cross-chain transfers. Each nullifier is a hash commitment to the transfer witness; once inserted, it cannot be reused.

---

## Executor Node

Run the BLEEP executor node to participate in the Layer 4 instant intent market:

```bash
cargo run --bin bleep-executor
```

Executor nodes:
1. Monitor the pending intent pool (`GET /rpc/connect/intents/pending`).
2. Bid on intents by posting collateral bonds.
3. Execute cross-chain transfers and claim fees.
4. Submit execution proofs to the commitment chain.

---

## Quick Start (Library)

```rust
use bleep_interop::types::{InstantIntent, ChainId};
use bleep_interop::executor::ExecutorClient;

let intent = InstantIntent {
    source_chain: ChainId::Ethereum,
    destination_chain: ChainId::Bleep,
    asset: "ETH".into(),
    amount: 1_000_000,
    recipient: recipient_address,
    zk_proof: proof_bytes,
};

let client = ExecutorClient::new(node_url);
let result = client.submit_intent(intent).await?;
```

---

## Testing

```bash
cargo test -p bleep-interop
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
