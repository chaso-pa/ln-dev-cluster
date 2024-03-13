#!/bin/bash
set -Eeuo pipefail

# Start bitcoind
echo "Starting bitcoind..."
bitcoind -datadir=$HOME/.bitcoind -daemon

# Wait for bitcoind startup
echo -n "Waiting for bitcoind to start"
until bitcoin-cli -datadir=$HOME/.bitcoind -rpcwait getblockchaininfo >/dev/null 2>&1; do
	echo -n "."
	sleep 1
done
echo
echo "bitcoind started"

# Load private key into wallet
export address_label=regtest-address

# If restarting the wallet already exists, so don't fail if it does,
# just load the existing wallet:
bitcoin-cli -datadir=$HOME/.bitcoind -regtest createwallet regtest >/dev/null || bitcoin-cli -datadir=$HOME/.bitcoind -regtest loadwallet regtest >/dev/null
bitcoin-cli -datadir=$HOME/.bitcoind -regtest getnewaddress $address_label >/dev/null || true

export address=$(bitcoin-cli -datadir=$HOME/.bitcoind getaddressesbylabel $address_label | jq -r 'keys[0]')

echo "================================================"
echo "Created address"
echo "Bitcoin address: " ${address}
echo "================================================"

# Executing CMD
exec "$@"
