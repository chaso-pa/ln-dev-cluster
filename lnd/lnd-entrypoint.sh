#!/bin/bash
set -Eeuo pipefail

source /usr/local/bin/wait-for-bitcoind.sh

echo Starting lnd...
lnd --lnddir=$HOME/.lnd --noseedbackup >/dev/null &

until lncli --lnddir=$HOME/.lnd -n regtest getinfo >/dev/null 2>&1; do
	sleep 1
done
echo "Startup complete"
echo "Funding lnd wallet"
source /usr/local/bin/fund-lnd.sh

exec "$@"
