# HeirRealm demo — the 60-second flow

**"Set beneficiary → fast-forward timer → keeper triggers → funds move."**

This is the exact demo that was run live on a local chain on 2026-11-25. Every command below is copy-pasteable, and every expected output is what actually came back. Total runtime: about 3 minutes, most of it waiting for the 60-second timer.

## Setup (once)

```sh
export PATH="$HOME/.gno/bin:$HOME/.local/go/bin:$PATH"
export GNOROOT=/tmp/gno-src        # only needed if you run tests from the repo clone (see below)

cd r/heirrealm
gnodev .                           # serves gnoweb at http://localhost:8888/r/dev/heirrealm
```

In a second terminal, create three throwaway local keys (owner, beneficiary, keeper). The password flag is for local demo use only — never use `-insecure-password-stdin` with a real key:

```sh
printf 'testpass123\ntestpass123\n' | gnokey add -insecure-password-stdin alice
printf 'testpass123\ntestpass123\n' | gnokey add -insecure-password-stdin bob
printf 'testpass123\ntestpass123\n' | gnokey add -insecure-password-stdin carol
gnokey list
# alice  g18r43mzyzp0p9dwzasj29n2f0er2dqndrcamac3   (owner)
# bob    g1w7a7rfdxv4atzvrjmvzkxym5s95u59tueg49w0   (beneficiary)
# carol  g1g9yv2ccu8pe6aznnmp6stszw8hdklnagqr6k48   (keeper)
```

> **Important:** create the keys *before* starting `gnodev` — it prefunds every key in the local keybase at startup (10,000,000,000,000 ugnot each). Keys added after startup are not funded. If you already started `gnodev`, restart it.

## The demo

### 1. Alice creates a vault for Bob — 60-second window, 1,000 ugnot

```sh
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "gno.land/r/dev/heirrealm" -func "CreateVault" \
  -args "g1w7a7rfdxv4atzvrjmvzkxym5s95u59tueg49w0" -args 60 \
  -send 1000ugnot -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 alice
```

Expected: `OK!`, `GAS USED: ~4,565,484`, return value `(1 int)` — vault #1. The first vault is expensive because the storage tree is initialised on first write.

Check the page:

```sh
curl -s http://localhost:8888/r/dev/heirrealm | grep -o "Vault #[^<]*"
# Vault #1 — active — balance 1000 ugnot — deadline 2026-11-25T09:28:19Z
```

### 2. Alice checks in — the deadline moves

```sh
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "gno.land/r/dev/heirrealm" -func "CheckIn" -args 1 \
  -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 alice
```

Expected: `OK!` and the deadline moves to 60 seconds after the check-in (in the live run: `09:28:32Z`). Nothing else changes — the balance stays 1,000 ugnot.

### 3. Wait 65 seconds — Alice "disappears"

Do nothing. The deadline passes. (In the live run the deadline was 09:28:32Z and we waited until ~09:29:30.)

### 4. A keeper triggers the release — and gets paid

**gnodev quirk, read this first:** on a local devnet, chain time only advances when blocks are committed, and a *failing* transaction does not commit a block. So the first `TriggerRelease` attempt can fail with `heirrealm: vault has not expired yet` even though wall-clock time has passed — the chain's clock is still behind. Fix: submit one successful transaction to advance the chain (a tiny deposit works), then trigger again. On Onyx testnet blocks are produced continuously, so this step is not needed there.

```sh
# advance the chain with a successful tx (alice tops up 100 ugnot)
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "gno.land/r/dev/heirrealm" -func "Deposit" -args 1 \
  -send 100ugnot -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 alice
# Expected: OK!  (1100 int64)  — balance is now 1,100 ugnot

# carol the keeper triggers the release
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "gno.land/r/dev/heirrealm" -func "TriggerRelease" -args 1 \
  -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 carol
```

Expected: `OK!`, return values `(1078 int64)` and `(22 int64)`, and events showing `22ugnot` to carol and `1078ugnot` to bob. **1,100 × 2% = 22 to the keeper, 1,078 (98%) to the beneficiary.** Gas used ~5.3M.

### 5. Verify — on the page and on the balances

```sh
curl -s http://localhost:8888/r/dev/heirrealm | grep -o "Vault #[^<]*"
# Vault #1 — released — balance 1100 ugnot — deadline 2026-11-25T09:28:32Z

gnokey query bank/balances/g1w7a7rfdxv4atzvrjmvzkxym5s95u59tueg49w0 -remote 127.0.0.1:26657
# data: "10000000001078ugnot"     <- bob: funded 10^13 + 1,078
gnokey query bank/balances/g1g9yv2ccu8pe6aznnmp6stszw8hdklnagqr6k48 -remote 127.0.0.1:26657
# data: "9999999972622ugnot"      <- carol: funded 10^13 + 22 fee - 27,400 tx costs
```

## What the demo proves (for the judges)

| Claim | Evidence |
|---|---|
| Vaults hold real funds | 1,000 ugnot left alice and sat in the realm (event + balance) |
| Check-in resets the timer | Deadline moved from 09:28:19Z to 09:28:32Z after `CheckIn` |
| Release is impossible before expiry | `TriggerRelease` before the deadline aborts: `heirrealm: vault has not expired yet` |
| Keeper cannot be owner/beneficiary | Unit tests `TestKeeperCannotBeOwnerOrBeneficiary` (and the realm rejects both) |
| The split is exactly 98/2 | 1,100 → 1,078 to bob, 22 to carol, verified in tx events and final balances |
| No double-release | `TestExpiredReleaseSplits` asserts a second trigger aborts with `already released` |

## Running the unit tests

```sh
cd r/heirrealm
gno test -v ./...
```

Expected output — 9 tests, all PASS (verified 2026-11-25, gno v1.8.0):

```
=== RUN   TestCreateVault
--- PASS: TestCreateVault (0.00s)
=== RUN   TestCreateVaultGuards
--- PASS: TestCreateVaultGuards (0.00s)
=== RUN   TestDeposit
--- PASS: TestDeposit (0.00s)
=== RUN   TestCheckInResetsTimer
--- PASS: TestCheckInResetsTimer (0.00s)
=== RUN   TestEarlyReleaseFails
--- PASS: TestEarlyReleaseFails (0.00s)
=== RUN   TestExpiredReleaseSplits
--- PASS: TestExpiredReleaseSplits (0.00s)
=== RUN   TestKeeperCannotBeOwnerOrBeneficiary
--- PASS: TestKeeperCannotBeOwnerOrBeneficiary (0.00s)
=== RUN   TestCancelRefunds
--- PASS: TestCancelRefunds (0.00s)
=== RUN   TestRender
--- PASS: TestRender (0.00s)
ok      .   2.11s
```

> **If `gno test` fails with `unable to call RPC "https://rpc.gno.land:443"`** — the toolchain is trying to download `gno.land/p/nt/*` from mainnet and your network blocks it. Workaround used for this build: clone `gnolang/gno`, copy the realm to `examples/gno.land/r/dev/heirrealm` inside the clone, and run `GNOROOT=<clone> gno test -v ./...` from there. On a machine with normal internet access the tests run directly from `r/heirrealm`.
