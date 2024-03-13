#!/bin/bash
set -Eeuo pipefail

export address_label=regtest-address
export address=$(bitcoin-cli -datadir=$HOME/.bitcoind getaddressesbylabel $address_label | jq -r 'keys[0]')
echo ${address}

echo "================================================"
echo "Balance:" $(bitcoin-cli -datadir=$HOME/.bitcoind getbalance)
echo "================================================"
echo "Mining 101 blocks to unlock some bitcoin"
echo "bitcoin-cli -datadir=$HOME/.bitcoind generatetoaddress 101" ${address}
bitcoin-cli -datadir=$HOME/.bitcoind -regtest generatetoaddress 101 $address
echo "Mining 6 blocks every 10 seconds"
while echo "Balance:" $(bitcoin-cli -datadir=$HOME/.bitcoind getbalance); do
	bitcoin-cli -datadir=$HOME/.bitcoind -regtest generatetoaddress 6 $address
	sleep 10

done

# If loop is interrupted, stop bitcoind
bitcoin-cli -datadir=$HOME/.bitcoind stop
