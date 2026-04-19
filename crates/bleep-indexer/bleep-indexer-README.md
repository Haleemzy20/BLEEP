# bleep-indexer

**Production Chain Indexer for BLEEP**

`bleep-indexer` ingests chain events via an async Tokio channel and builds lock-free, DashMap-backed indexes over blocks, transactions, accounts, governance proposals, validators, shards, cross-shard 2PC records, and AI advisory events. It provides a query engine for RPC and explorer consumers.

---

## License

Licensed under **MIT license.
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-indexer
├── events      — IndexerEvent enum (all indexable chain events)
├── indexes     — BlockIndex, TxIndex, AccountIndex, GovernanceIndex,
│                 ValidatorIndex, ShardIndex, CrossShardIndex, AIEventIndex
├── query       — QueryEngine, ChainStats, Page (lock-free read path)
├── reorg       — ReorgHandler: rollback to common ancestor; CheckpointEngine
└── errors      — IndexerError, IndexerResult
```

### Event Loop

```
[Chain] ──IndexerEvent──► IndexerService::ingest()
                               │
                     ┌─────────▼─────────┐
                     │   event_loop task  │   (single Tokio task)
                     │   dispatches each  │
                     │   event atomically │
                     └─────────┬─────────┘
                               │
              ┌────────────────▼────────────────┐
              │ BlockIndex │ TxIndex │ AccountIndex │
              │ GovernanceIndex │ ValidatorIndex   │
              │ ShardIndex │ CrossShardIndex       │
              └──────────────────────────────────┘
```

---

## Safety Invariants

1. All index state is consistent with a specific block height.
2. Reorg events roll back to the common ancestor before re-indexing.
3. Every indexed record carries the originating `block_height`.
4. No query can observe partially-indexed data — each event is committed atomically.

---

## Quick Start

```rust
use bleep_indexer::{IndexerService, IndexerEvent};

let (service, handle) = IndexerService::start();

// Ingest events from the chain
service.ingest(IndexerEvent::NewBlock(block.clone())).await?;
service.ingest(IndexerEvent::Transaction(tx.clone())).await?;

// Query the index
let query = service.query();
let stats = query.chain_stats();
let block = query.block_by_height(100)?;
let tx = query.tx_by_hash(&hash)?;
```

---

## Reorg Handling

When a chain reorganisation is detected:

1. `ReorgHandler` is invoked with the reorg depth.
2. `CheckpointEngine` restores the nearest snapshot at or before the fork point.
3. The indexer replays canonical events from the fork point forward.

Checkpoints are written periodically (configurable interval) and on graceful shutdown.

---

## Query Engine

`QueryEngine` exposes a lock-free read path over the DashMap indexes:

```rust
let q = service.query();

// Pagination
let page = q.transactions_for_account(&address, Page { offset: 0, limit: 50 });

// Governance
let proposal = q.governance_proposal(proposal_id)?;

// Validator
let status = q.validator_status("val-001")?;

// Chain-wide statistics
let stats = q.chain_stats(); // ChainStats { height, tx_count, active_validators, … }
```

---

## Testing

```bash
cargo test -p bleep-indexer
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
