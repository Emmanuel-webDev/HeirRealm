#!/bin/sh
# HeirRealm — deploy to the Gno Onyx testnet (onyx-1).
#
# Usage:
#   ./scripts/deploy.sh <key-name> <your-address>
#
# Example:
#   ./scripts/deploy.sh deployer g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e
#
# Prerequisites (see README.md):
#   1. Adena wallet installed, with a recovery phrase you control.
#   2. Testnet GNOT from https://faucet.gno.land for your address (Onyx).
#   3. The same mnemonic added to gnokey:
#        gnokey add <key-name> --recover
#   4. gnomod.toml updated so the module line matches the realm path below
#      (gno.land/r/<your-address>/heirrealm).
#
# This script only deploys. It does not register or submit anything to
# DoraHacks — that step is yours, in SUBMISSION.md.
set -eu

KEY_NAME="${1:-}"
DEPLOYER_ADDR="${2:-}"
if [ -z "$KEY_NAME" ] || [ -z "$DEPLOYER_ADDR" ]; then
  echo "Usage: $0 <key-name> <your-address>" >&2
  exit 1
fi

# A realm's path is derived from its deployer address namespace.
PKGPATH="gno.land/r/${DEPLOYER_ADDR}/heirrealm"
RPC="https://rpc.onyx.testnets.gno.land:443"
CHAINID="onyx-1"

# Package upload + AST storage uses ~31M gas on Onyx; 40M gives comfortable headroom.
GAS_FEE="200000ugnot"
GAS_WANTED="40000000"
MAX_DEPOSIT="50000000ugnot"

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
REALM_DIR="$SCRIPT_DIR/../r/heirrealm"

echo "Deploying HeirRealm"
echo "  realm:       $REALM_DIR"
echo "  pkgpath:     $PKGPATH"
echo "  key:         $KEY_NAME"
echo "  rpc:         $RPC"
echo "  chain:       $CHAINID"
echo "  max-deposit: $MAX_DEPOSIT"
echo ""
echo "Make sure r/heirrealm/gnomod.toml has module $PKGPATH before continuing."
printf "Press Enter to deploy, or Ctrl-C to stop: "
read -r _

gnokey maketx addpkg \
  -pkgpath "$PKGPATH" \
  -pkgdir "$REALM_DIR" \
  -gas-fee "$GAS_FEE" \
  -gas-wanted "$GAS_WANTED" \
  -max-deposit "$MAX_DEPOSIT" \
  -chainid "$CHAINID" \
  -remote "$RPC" \
  "$KEY_NAME"

echo ""
echo "Deployed. Verify at:"
echo "  https://onyx.testnets.gno.land/r/${DEPLOYER_ADDR}/heirrealm"
echo "Then add the link to your DoraHacks submission — see SUBMISSION.md."
