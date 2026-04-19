# bleep-telemetry

**Metrics, Monitoring & Load Balancing for BLEEP**

`bleep-telemetry` provides Prometheus-compatible metrics collection, shard/validator load tracking, and energy consumption monitoring for BLEEP nodes.

---

## License

Licensed under **MIT**.
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-telemetry
├── metrics        — Counters, gauges, histograms (Prometheus-compatible)
├── load_balancer  — Shard and validator load tracking
└── energy_module  — Energy consumption monitoring (requires `ml` feature / LibTorch)
```

---

## Modules

### `metrics`

Exposes Prometheus-compatible metric types:

| Metric type | Description |
|-------------|-------------|
| `Counter` | Monotonically increasing count (e.g. total transactions) |
| `Gauge` | Instantaneous value (e.g. mempool size, peer count) |
| `Histogram` | Distribution of values (e.g. block time, RPC latency) |

Metrics are collected by `bleep-scheduler`'s `epoch_metrics_snapshot` task and exposed at a configurable scrape endpoint.

Key metrics tracked:

- `bleep_blocks_total` — total blocks produced
- `bleep_transactions_total` — total transactions processed
- `bleep_mempool_size` — current mempool depth
- `bleep_peers_connected` — active P2P peer count
- `bleep_consensus_mode` — current consensus mode (0=PoW, 1=PBFT, 2=PoS)
- `bleep_validator_reputation{id}` — per-validator reputation score
- `bleep_shard_load{shard}` — transaction load per shard
- `bleep_rpc_latency_ms` — RPC handler latency histogram

### `load_balancer`

Tracks transaction and state load per shard and per validator, publishing snapshots consumed by `bleep-ai` for shard rebalancing recommendations and by `bleep-scheduler`'s `shard_rebalance` task.

```rust
use bleep_telemetry::load_balancer::LoadBalancer;

let lb = LoadBalancer::new();
lb.record_shard_tx(shard_id, gas_used);
let load_report = lb.snapshot();
```

### `energy_module`

Monitors per-node energy consumption using CPU and IO metrics. Requires the `ml` feature flag (LibTorch / `tch` dependency). Used in Phase 4 AI advisory for sustainability scoring.

```toml
# Enable in Cargo.toml
bleep-telemetry = { path = "crates/bleep-telemetry", features = ["ml"] }
```

---

## Initialisation

```rust
use bleep_telemetry::init_telemetry;

init_telemetry()?;
// Metrics scrape endpoint is now active.
// Collection is driven by bleep-scheduler tasks.
```

---

## Testing

```bash
cargo test -p bleep-telemetry
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
