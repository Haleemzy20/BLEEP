# bleep-scheduler

**Protocol Task Scheduler for BLEEP**

`bleep-scheduler` manages all time-driven and block-driven protocol maintenance tasks. It provides 20 built-in tasks across 7 categories, runs each in an isolated Tokio task with per-task timeouts, and guarantees that a panic in one task never affects the scheduler or other tasks.

---

## License

Licensed under **MIT** (your choice).
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-scheduler
├── built_in    — 20 built-in task implementations
├── registry    — TaskRegistry: RegisteredTask, TaskContext, dynamic task registration
├── task        — TaskId, TaskKind, Trigger, TaskStatus, ExecutionOutcome, TaskRunRecord
├── metrics     — MetricsStore, SchedulerMetrics, TaskMetrics (Prometheus-compatible)
└── errors      — SchedulerError, SchedulerResult
```

### Execution Model

- **`interval_loop`** fires tasks on wall-clock intervals (1-second tick resolution).
- **`block_loop`** fires tasks on each new block notification from the consensus layer.
- Each task runs in an isolated Tokio task with a configurable `timeout_secs`.
- Hung tasks are cancelled at their timeout boundary; the scheduler continues unaffected.

---

## Built-In Tasks (20 Tasks, 7 Categories)

### EPOCH
| Task | Trigger | Description |
|------|---------|-------------|
| `epoch_advance` | Interval | Transitions to the next epoch; updates validator sets |
| `epoch_metrics_snapshot` | Interval | Captures epoch-end telemetry |

### CONSENSUS
| Task | Trigger | Description |
|------|---------|-------------|
| `validator_trust_decay` | Interval | Decays validator reputation scores over time |
| `validator_reward_distribution` | Block | Distributes block rewards to validators |
| `slashing_evidence_sweep` | Interval | Processes pending slashing evidence |

### HEALING
| Task | Trigger | Description |
|------|---------|-------------|
| `self_healing_sweep` | Interval | Triggers fault detection and recovery orchestration |
| `recovery_timeout_check` | Interval | Cancels stale recovery operations |

### GOVERNANCE
| Task | Trigger | Description |
|------|---------|-------------|
| `governance_proposal_advance` | Block | Checks if proposals have reached quorum |
| `governance_voting_window_close` | Interval | Closes expired voting windows |

### ECONOMICS
| Task | Trigger | Description |
|------|---------|-------------|
| `fee_market_update` | Block | Recalculates the base fee after each block |
| `supply_state_verify` | Interval | Asserts supply conservation invariant |
| `token_burn_execution` | Interval | Executes pending scheduled burns |

### NETWORKING
| Task | Trigger | Description |
|------|---------|-------------|
| `shard_rebalance` | Interval | Redistributes validators across shards |
| `peer_score_decay` | Interval | Decays AI-derived peer quality scores |
| `cross_shard_timeout_sweep` | Interval | Aborts stale cross-shard 2PC transactions |

### MAINTENANCE
| Task | Trigger | Description |
|------|---------|-------------|
| `session_revocation_purge` | Interval | Removes expired JWT deny-list entries |
| `rate_limit_bucket_purge` | Interval | Clears expired rate limiter windows |
| `mempool_prune` | Interval | Evicts low-fee transactions when mempool is full |
| `indexer_checkpoint` | Interval | Writes indexer snapshots for crash recovery |
| `audit_log_rotation` | Interval | Archives and rotates audit log segments |

---

## Safety Invariants

1. Tasks never share mutable state directly — all inter-task communication is via `Arc`/channel.
2. Tasks are bounded by `timeout_secs`; hung tasks are cancelled.
3. Tasks are **idempotent** — safe to re-run after a restart without side effects.
4. `last_run_at` is updated **before** spawning to prevent double-firing on restart.

---

## Quick Start

```rust
use bleep_scheduler::{TaskRegistry, TaskContext};

let registry = TaskRegistry::new();
registry.register_all_built_in(context.clone());
registry.start_interval_loop().await;
registry.start_block_loop(block_rx).await;
```

---

## Custom Tasks

Tasks can be registered dynamically:

```rust
registry.register(RegisteredTask {
    id: TaskId::from("my_task"),
    kind: TaskKind::Interval { secs: 60 },
    timeout_secs: 10,
    handler: Arc::new(|ctx| Box::pin(async move {
        // task implementation
        Ok(ExecutionOutcome::Success)
    })),
});
```

---

## Testing

```bash
cargo test -p bleep-scheduler
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
