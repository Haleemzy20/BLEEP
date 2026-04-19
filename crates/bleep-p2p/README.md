# bleep-p2p

**Production-Grade P2P Networking for BLEEP**

`bleep-p2p` implements the peer-to-peer networking stack for BLEEP nodes: encrypted transport, Kademlia DHT peer discovery, Plumtree gossip propagation, AI-scored peer management, Sybil detection, and an onion router for privacy-preserving message routing.

---

## License

Licensed under **MIT**
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      P2PNode                            │
│  ┌──────────────┐  ┌─────────────┐  ┌───────────────┐  │
│  │ PeerManager  │  │  Gossip     │  │ OnionRouter   │  │
│  │  + AI Score  │  │  Protocol   │  │ (dark routing)│  │
│  │  + Sybil Det │  │  Plumtree   │  │  Kyber/AES    │  │
│  └──────────────┘  └─────────────┘  └───────────────┘  │
│  ┌──────────────────────────────────────────────────┐   │
│  │              MessageProtocol                     │   │
│  │  TCP framing · AES-256-GCM · Ed25519 sig        │   │
│  │  Kyber-768 KEM · Anti-replay nonce cache        │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │              KademliaDHT                         │   │
│  │  256 K-buckets · XOR metric · k=20              │   │
│  └──────────────────────────────────────────────────┘   │
│  ┌──────────────────────────────────────────────────┐   │
│  │              QuantumCrypto                       │   │
│  │  Kyber-768 · SPHINCS+-SHA2-128s · Ed25519       │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Key Components

### `P2PNode`

The top-level network participant. Manages all sub-components and exposes an async API for the node binary.

```rust
use bleep_p2p::p2p_node::{P2PNode, P2PNodeConfig};

#[tokio::main]
async fn main() {
    let config = P2PNodeConfig::default();
    let (node, handle) = P2PNode::start(config).await.unwrap();
    println!("Node started: {}", node.node_id);
    handle.await.unwrap();
}
```

Default listen address: `/ip4/0.0.0.0/tcp/7700`

### `KademliaDHT`

Structured peer discovery using 256 K-buckets with XOR metric and k=20 contacts per bucket. Supports `find_node`, `store`, and `find_value` operations as defined in the Kademlia paper.

### `PeerManager`

Maintains the active peer set with AI-derived peer quality scores based on latency, uptime, and message validity rate. Sybil detection flags peers that exhibit correlated behaviour patterns.

### `GossipProtocol` (Plumtree)

Epidemic broadcast protocol for efficiently propagating blocks, transactions, and governance messages with O(log n) bandwidth overhead. Lazy-push fallback prevents message loss.

### `OnionRouter`

Encrypts messages in multiple layers (Kyber KEM + AES-256-GCM) to route traffic through relay nodes, obscuring the originating IP address for privacy-sensitive operations.

### `MessageProtocol`

The transport-layer framing protocol:
- TCP with length-prefixed frames
- AES-256-GCM authenticated encryption per connection
- Ed25519 message signatures for integrity
- Kyber-768 KEM for forward-secret session establishment
- Anti-replay nonce cache (64k slots, LRU eviction)

### `QuantumCrypto`

Post-quantum cryptographic primitives scoped to the P2P layer: Kyber-768 for session keys, SPHINCS+-SHA2-128s for long-term node identity, Ed25519 for ephemeral handshake messages.

---

## Configuration

`P2PNodeConfig` fields:

| Field | Default | Description |
|-------|---------|-------------|
| `listen_addr` | `0.0.0.0:7700` | TCP listen address |
| `bootstrap_peers` | `[]` | Initial peers for DHT seeding |
| `max_peers` | `50` | Maximum connected peers |
| `gossip_fanout` | `6` | Plumtree eager-push fanout |
| `enable_onion` | `false` | Enable onion routing |
| `quantum_mode` | `true` | Use PQC for all sessions |

---

## Testing

```bash
cargo test -p bleep-p2p
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*

