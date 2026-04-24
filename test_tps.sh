#!/bin/bash
set -e

CLI="./target/release/bleep-cli"
START=$(date +%s%N)
COUNT=10

echo "Starting $COUNT transactions at $(date)"

for i in $(seq 1 $COUNT); do
  TO="BLEEP$(printf "%040x" $i)"
  $CLI tx send $TO 1
done

END=$(date +%s%N)
DURATION=$(( (END - START) / 1000000 ))  # ms
TPS=$(( COUNT * 1000 / DURATION ))

echo "Completed $COUNT transactions in ${DURATION}ms"
echo "TPS: $TPS"