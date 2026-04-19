# bleep-economics

**Economic Nervous System for BLEEP**

`bleep-economics` implements the complete tokenomics layer of BLEEP: emission schedules, fee markets, validator incentives, burn mechanics, supply tracking, oracle integration, and game-theoretic safety guarantees. After this layer, BLEEP survives not just bugs — but rational adversaries.

---

## License

Licensed under **MIT**.
Copyright © 2025 Muhammad Attahir.

---

## Architecture

```
bleep-economics
├── tokenomics          — CanonicalTokenomicsEngine, EmissionSchedule, BurnConfig, SupplyState
├── distribution        — GenesisAllocation, VestingPolicy, FeeDistribution, BucketSnapshot
├── fee_market          — EIP-1559-style adaptive base fee with BLEEP-specific tuning
├── validator_incentives — Per-epoch reward calculation, commission splits
├── oracle_bridge       — Trust-minimised price feed aggregation
├── game_theory         — Mechanism design safety proofs & adversarial modelling
└── runtime             — Runtime hooks called by bleep-scheduler each epoch
```

---

## Token Allocation

The genesis supply is fixed at **1,000,000,000 BLP** (1 billion), allocated as follows:

| Bucket | Allocation | Vesting |
|--------|-----------|---------|
| Validator Rewards | `ALLOC_VALIDATOR_REWARDS` | Per-epoch emission |
| Ecosystem Fund | `ALLOC_ECOSYSTEM_FUND` | 4-year linear |
| Community Incentives | `ALLOC_COMMUNITY_INCENTIVES` | 2-year linear |
| Foundation Treasury | `ALLOC_FOUNDATION_TREASURY` | 3-year linear with 6-month cliff |
| Core Contributors | `ALLOC_CORE_CONTRIBUTORS` | 4-year linear with 1-year cliff |
| Strategic Reserve | `ALLOC_STRATEGIC_RESERVE` | Governance-locked |

Initial circulating supply: `INITIAL_CIRCULATING_SUPPLY` microBLEEP.

---

## Emission Schedule

Validator emissions decrease over time following a configurable `EmissionSchedule`. The first year emits `VALIDATOR_EMISSION_YEAR` microBLEEP, halving or decaying on a per-governance-decision basis.

Emission types: `Block`, `Epoch`, `Governance`, `Bootstrap`.

---

## Fee Market

BLEEP uses an EIP-1559-style adaptive base fee:

- Base fee adjusts per block based on block fullness relative to the target.
- **`FEE_BURN_BPS`** of the base fee is burned, reducing supply.
- **`FEE_VALIDATOR_REWARD_BPS`** goes to the block producer.
- **`FEE_TREASURY_BPS`** flows to the Foundation Treasury bucket.

```rust
use bleep_economics::fee_market::FeeMarket;
let base_fee = FeeMarket::current_base_fee(&supply_state);
```

---

## Validator Incentives

Each epoch, `ValidatorEmissionSchedule` distributes rewards proportional to:
- Stake weight
- Uptime
- Reputation score (from `bleep-consensus`)
- Commission rate

Slashing deductions applied by `bleep-consensus` are reflected in the `SupplyState` burn counter.

---

## Oracle Bridge

The oracle bridge aggregates price feeds from multiple authorised providers, applies a median filter, and stores the result for use in fee denominations and governance quorum calculations. Malicious providers are flagged and weight-penalised.

---

## Supply Invariant

At all times:

```
total_minted - total_burned = circulating_supply + locked_supply
```

This invariant is verified by `bleep-core`'s `InvariantEnforcement` on every block.

---

## Testing

```bash
cargo test -p bleep-economics
```

---

*Part of the [BLEEP Ecosystem](https://github.com/BleepEcosystem/BLEEP-V1)*
