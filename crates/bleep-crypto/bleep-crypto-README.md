# bleep-crypto

**Post-Quantum Cryptographic Primitives for BLEEP**

`bleep-crypto` provides the complete cryptographic foundation for the BLEEP ecosystem: post-quantum signatures (Falcon, SPHINCS+), key encapsulation (Kyber), symmetric encryption (AES-GCM), BIP-39 mnemonic handling, Merkle commitments, ZKP verification, and anti-asset-loss cryptographic primitives.

---

## License

Licensed under **MIT OR Apache-2.0**
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-crypto
├── pq_crypto           — Falcon (signatures), Kyber (KEM), SPHINCS+ — primary PQC module
├── quantum_secure      — QuantumSecure: Kyber + AES-256-GCM hybrid encrypt/decrypt
├── quantum_resistance  — Additional PQC wrappers and utilities
├── bip39               — BIP-39 mnemonic generation, validation, seed derivation
├── tx_signer           — Ed25519 transaction signing, verification, keypair generation
├── merkle_commitment   — Merkle proof construction and verification
├── merkletree          — General-purpose Merkle tree implementation
├── zkp_verification    — BLEEPZKPModule: Groth16, Bulletproofs, batch proofs, key revocation
├── anti_asset_loss     — Cryptographic primitives for ZKP-backed asset recovery
└── logging             — Structured audit logging helpers
```

---

## Cryptographic Stack

| Primitive | Algorithm | Use Case |
|-----------|-----------|---------|
| Digital signatures (PQ) | **Falcon** | Transaction signing, quantum-resistant |
| Digital signatures (classical) | **Ed25519** | Node identity, validator signing |
| Hash-based signatures (PQ) | **SPHINCS+** | Block headers, state roots |
| Key encapsulation (PQ) | **Kyber-768 / Kyber-1024** | Session key exchange, validator binding |
| Symmetric encryption | **AES-256-GCM** | Metadata, logs, state encryption |
| Key derivation | **HKDF-SHA3** | Deriving keys from shared secrets |
| Hashing | **SHA3-256 / BLAKE2b** | Transaction IDs, block hashes, state roots |
| ZK proofs | **Groth16 (BN254)** | zk-SNARKs for governance and recovery |
| ZK proofs | **Bulletproofs** | Confidential quadratic voting |
| Merkle proofs | **SHA3-256 sparse Merkle** | State inclusion proofs |

---

## Key Modules

### `pq_crypto` — Post-Quantum Core

The primary module for Falcon, Kyber, and SPHINCS+ operations. Re-exported at the crate root.

```rust
use bleep_crypto::{falcon_sign, falcon_verify, kyber_encapsulate, kyber_decapsulate};
```

### `quantum_secure` — Hybrid Encryption

Combines Kyber KEM with AES-256-GCM for encrypt-then-MAC authenticated encryption of arbitrary payloads (transactions, governance logs).

```rust
use bleep_crypto::quantum_secure::QuantumSecure;
let qs = QuantumSecure::new();
let ciphertext = qs.encrypt_transaction(&tx)?;
let tx_back = qs.decrypt_transaction(&ciphertext)?;
```

### `bip39` — Mnemonic Wallets

```rust
use bleep_crypto::{mnemonic_to_seed, mnemonic_to_bleep_seed, validate_mnemonic};

let seed = mnemonic_to_bleep_seed("word1 word2 … word24", "")?;
```

### `tx_signer` — Transaction Signing

```rust
use bleep_crypto::{generate_tx_keypair, sign_tx_payload, verify_tx_signature, tx_payload};

let (sk, pk) = generate_tx_keypair();
let payload = tx_payload(&tx);
let sig = sign_tx_payload(&sk, &payload);
verify_tx_signature(&pk, &payload, &sig)?;
```

### `zkp_verification` — ZK Proof Engine

`BLEEPZKPModule` handles:

- Batch Groth16 proof generation and aggregation
- Key revocation via Merkle trees
- Hybrid Kyber+AES encrypted proof packaging
- Serialisation / deserialisation of proving and verifying keys

---

## Fuzz Targets

The `fuzz/` directory contains cargo-fuzz targets for:

- Transaction signing and verification
- Merkle tree insertion

Run with:

```bash
cargo +nightly fuzz run fuzz_tx_signer
```

---

## Testing

```bash
cargo test -p bleep-crypto
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*

