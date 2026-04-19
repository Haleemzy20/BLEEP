# bleep-rpc

**HTTP/JSON RPC Server for BLEEP**

`bleep-rpc` exposes the BLEEP node's state, validator management, economics, oracle, cross-chain intent, and PAT operations over a Warp-based HTTP API. It reads directly from a live `StateManager` and always reflects the most recently committed block.

---

## License

Licensed under **MIT**.
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-rpc
├── lib.rs       — rpc_routes_with_state(), RpcState, all route handlers
├── rpc.rs       — Lightweight re-export shim
└── bin/rpc.rs   — Standalone RPC server binary entry point
```

`rpc_routes_with_state()` returns a Warp `Filter` that can be plugged directly into the main node binary or run standalone as `bleep-rpc`.

`RpcState` is an `Arc`-wrapped struct carrying:
- `Arc<Mutex<StateManager>>` — live account state
- `Arc<ValidatorRegistry>` — active validator set
- `Arc<SlashingEngine>` — slashing evidence processor
- Economics and oracle state handles

---

## Endpoint Summary

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/rpc/state/{address}` | Live balance & nonce |
| `GET` | `/rpc/proof/{address}` | Sparse Merkle inclusion proof |
| `POST` | `/rpc/validator/stake` | Register / increase stake |
| `POST` | `/rpc/validator/unstake` | Initiate graceful exit |
| `GET` | `/rpc/validator/list` | Active validator set |
| `GET` | `/rpc/validator/status/{id}` | Validator detail + slashing history |
| `POST` | `/rpc/validator/evidence` | Submit slashing evidence |
| `GET` | `/rpc/economics/supply` | Circulating supply metrics |
| `GET` | `/rpc/economics/epoch/{epoch}` | Epoch emission & burn stats |
| `GET` | `/rpc/economics/fee` | Current base fee |
| `GET` | `/rpc/oracle/price/{asset}` | Latest aggregated price |
| `POST` | `/rpc/oracle/update` | Submit oracle price update |
| `GET` | `/rpc/connect/intents/pending` | Pending Layer 4 intents |
| `POST` | `/rpc/connect/intent` | Submit new cross-chain intent |
| `GET` | `/rpc/connect/intent/{id}` | Intent status |
| `POST` | `/rpc/pat/mint` | Mint PAT tokens |
| `GET` | `/rpc/pat/balance/{address}` | PAT token balance |

Full request/response schemas: [RPC API Specification](../docs/specs/rpc_api_spec.md).

---

## Running the Standalone RPC Server

```bash
cargo run --bin bleep-rpc
```

Default listen address: `0.0.0.0:8545`

Override with environment variables:

```bash
RPC_HOST=127.0.0.1 RPC_PORT=9000 cargo run --bin bleep-rpc
```

---

## Embedding in the Main Node

```rust
use bleep_rpc::{rpc_routes_with_state, RpcState};

let state = RpcState::new(state_manager, validator_registry, slashing_engine);
let routes = rpc_routes_with_state(state);
warp::serve(routes).run(([0, 0, 0, 0], 8545)).await;
```

---

## Live Counters

`RpcState` exposes atomic counters updated by the node on each committed block:

- `requests_total` — total RPC requests served
- `blocks_seen` — blocks committed since node start
- `tx_count` — transactions processed

These feed into `bleep-telemetry` metrics.

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
