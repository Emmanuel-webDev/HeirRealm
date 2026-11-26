# HeirRealm demo — Heartbeat revival & post-grace 98/2 release

**"Set beneficiary → miss deadline → revive during grace with Heartbeat, OR let grace expire → keeper triggers 98/2 release."**

This is the exact demo run live on a local `gnodev` chain on 2026-11-26 (`gno v1.8.0`). Every command below is copy-pasteable, and every output shown is from the live local run.

- **Check-in interval (demo):** `60` seconds (`MinCheckInIntervalSeconds = 60`)
- **Grace period (demo):** `60` seconds (`GracePeriodSeconds = 60 // 60s for demo, 7 days in production`, alongside `ProductionGracePeriodSeconds = 7 * 24 * 60 * 60`)

## Setup (once)

```sh
export PATH="$HOME/.gno/bin:$HOME/.local/go/bin:$PATH"
export GNOROOT="$HOME/.gno/src"

cd r/heirrealm
gnodev .   # serves gnoweb at http://127.0.0.1:8888
```

In a second terminal, create three throwaway local keys (owner, beneficiary, keeper). The `-insecure-password-stdin` flag is strictly for throwaway local keys — never use it with a real wallet:

```sh
printf 'testpass123\ntestpass123\n' | gnokey add -insecure-password-stdin alice
printf 'testpass123\ntestpass123\n' | gnokey add -insecure-password-stdin bob
printf 'testpass123\ntestpass123\n' | gnokey add -insecure-password-stdin carol
gnokey list
# alice  g1crljs0ctzjqreyqzadyqfs0qqv4xpf78rnxfvq   (owner)
# bob    g1y5lxm4jqzcu9djpgvxeqypag2hszwcdh422fyw   (beneficiary)
# carol  g1aqs2v5kagldvw6tfksaqdwc0qhg55mhk9c30j6   (keeper)
```

> **Important:** create the keys *before* starting `gnodev` — it prefunds every key in the local keybase at startup (`10,000,000,000,000 ugnot` each). Set `PKG` from `r/heirrealm/gnomod.toml` (e.g. `PKG="$(sed -n 's/^module = "\(.*\)"/\1/p' r/heirrealm/gnomod.toml)"`).

> **`gnodev` block-clock note:** On local `gnodev`, block timestamps only advance when valid transactions commit blocks (failing transactions do not commit blocks, and the first block after an idle gap uses the previous commit's timestamp). Sending two tiny `1ugnot` self-transfers from `alice` to `alice` syncs `gnodev`'s BFT block clock to current wall-clock time without altering any vault balance:
> ```sh
> sync_clock() {
>   printf 'testpass123\n' | gnokey maketx send -insecure-password-stdin \
>     -to "$ALICE_ADDR" -send 1ugnot -gas-fee 8000ugnot -gas-wanted 2000000 \
>     -chainid dev -remote 127.0.0.1:26657 alice >/dev/null
> }
> ```

---

## Part A — Post-deadline grace period & `Heartbeat` revival

### 1. Alice creates a vault for Bob — 60s check-in window + 60s grace period, 1,000 ugnot

```sh
sync_clock && sync_clock

printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "$PKG" -func "CreateVault" \
  -args "$BOB_ADDR" -args 60 \
  -send 1000ugnot -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 alice
```

Live output (`OK!`, `GAS USED: 5,147,623`):
- `Status: active`
- `Balance: 1000 ugnot`
- `Deadline: 2026-11-26T08:44:56Z`
- `Grace period ends: 2026-11-26T08:45:56Z (60 seconds)`

### 2. Wait ~65 seconds — deadline passes, vault enters the 60-second grace period

Once wall-clock time passes `Deadline` (`08:44:56Z`) but is still before `Deadline + GracePeriod` (`08:45:56Z`), sync the devnet clock and inspect `gnoweb`:

```sh
sync_clock && sync_clock
curl -s "http://localhost:8888${PKG#gno.land}" | grep -o "Vault #[^<]*"
# Vault #3 — in grace period — awaiting heartbeat — balance 1000 ugnot — deadline 2026-11-26T08:44:56Z
```

### 3. Keeper Carol tries `TriggerRelease` during the grace period — BLOCKED

```sh
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "$PKG" -func "TriggerRelease" -args 3 \
  -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 carol
```

Live output — aborts as required:

```text
panic: heirrealm: vault is in grace period, cannot release before deadline + grace
```

### 4. Owner Alice calls `Heartbeat` during the grace period — vault revived & deadline reset

```sh
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "$PKG" -func "Heartbeat" -args 3 \
  -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 alice

sync_clock
curl -s "http://localhost:8888${PKG#gno.land}:3" | grep -o "Status:[^<]*\|Deadline:[^<]*\|Grace period ends:[^<]*"
```

Live output (`OK!`, `GAS USED: 5,505,891`):

```text
Status: active
Deadline: 2026-11-26T08:46:27Z
Grace period ends: 2026-11-26T08:47:27Z (60 seconds)
```

The vault returns to `active` and its deadline resets to `now + 60s` (`08:46:27Z`), with a fresh 60-second grace window (`08:47:27Z`).

---

## Part B — Post-grace expiry & keeper 98/2 release

### 1. Create a second vault (60s interval + 60s grace, 1,000 ugnot) and wait ~125s (`deadline + grace`)

```sh
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "$PKG" -func "CreateVault" \
  -args "$BOB_ADDR" -args 60 \
  -send 1000ugnot -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 alice
# Initial Deadline: 2026-11-26T08:34:54Z
# Grace period ends: 2026-11-26T08:35:54Z (60 seconds)
```

Wait >120 seconds so both the 60-second check-in window and the 60-second grace period expire, then sync the devnet clock:

```sh
sync_clock && sync_clock
curl -s "http://localhost:8888${PKG#gno.land}" | grep -o "Vault #[^<]*"
# Vault #1 — expired — awaiting keeper — balance 1000 ugnot — deadline 2026-11-26T08:34:54Z
```

### 2. Keeper Carol triggers the release — 98% to Bob, 2% to Carol

```sh
printf 'testpass123\n' | gnokey maketx call -insecure-password-stdin \
  -pkgpath "$PKG" -func "TriggerRelease" -args 1 \
  -gas-fee 8000ugnot -gas-wanted 8000000 \
  -chainid dev -remote 127.0.0.1:26657 carol
```

Live output (`OK!`, `GAS USED: 5,285,754`):
- Return values: `(980 int64)` and `(20 int64)`
- Events: `20ugnot` (2%) to `carol`, `980ugnot` (98%) to `bob`

### 3. Verify `gnoweb` and on-chain bank balances

```sh
sync_clock
curl -s "http://localhost:8888${PKG#gno.land}" | grep -o "Vault #[^<]*"
# Vault #1 — released — balance 1000 ugnot — deadline 2026-11-26T08:34:54Z

gnokey query "bank/balances/$BOB_ADDR" -remote 127.0.0.1:26657
# data: "10000000000980ugnot"     <- bob: prefunded 10^13 + 980 ugnot (98%)

gnokey query "bank/balances/$CAROL_ADDR" -remote 127.0.0.1:26657
# data: "9999999971620ugnot"      <- carol: prefunded 10^13 + 20 ugnot (2% fee) - 28,400 tx cost
```

---

## What the demo proves

| Claim | Evidence |
|---|---|
| Vaults hold real funds | `1,000 ugnot` moves from `alice` into the realm on `CreateVault` |
| Grace period protects against missed check-ins | After `Deadline`, status enters `in grace period — awaiting heartbeat`; `TriggerRelease` aborts with `vault is in grace period, cannot release before deadline + grace` |
| Owner `Heartbeat` revives during grace | `Heartbeat` resets `Deadline` to `now + interval` (`08:44:56Z` → `08:46:27Z`) and restores status to `active` |
| `Heartbeat` guards are enforced | Fails before `Deadline`, after `Deadline + GracePeriod`, or from any non-owner caller |
| Post-grace split is strictly 98/2 | After `Deadline + GracePeriod`, `TriggerRelease` pays `980 ugnot` (98%) to `bob` and `20 ugnot` (2%) to keeper `carol` |

---

## Running the unit tests

```sh
cd r/heirrealm
gno test -v ./...
```

Expected output — 15 tests, all PASS (verified 2026-11-26, `gno v1.8.0`):

```text
=== RUN   TestCreateVault
--- PASS: TestCreateVault (0.01s)
--- GAS:  4442559
=== RUN   TestCreateVaultGuards
--- PASS: TestCreateVaultGuards (0.00s)
--- GAS:  4960832
=== RUN   TestDeposit
--- PASS: TestDeposit (0.01s)
--- GAS:  6963118
=== RUN   TestCheckInResetsTimer
--- PASS: TestCheckInResetsTimer (0.01s)
--- GAS:  6750448
=== RUN   TestEarlyReleaseFails
--- PASS: TestEarlyReleaseFails (0.00s)
--- GAS:  6111719
=== RUN   TestExpiredReleaseSplits
--- PASS: TestExpiredReleaseSplits (0.01s)
--- GAS:  6857050
=== RUN   TestKeeperCannotBeOwnerOrBeneficiary
--- PASS: TestKeeperCannotBeOwnerOrBeneficiary (0.00s)
--- GAS:  4669541
=== RUN   TestCancelRefunds
--- PASS: TestCancelRefunds (0.00s)
--- GAS:  7705899
=== RUN   TestRender
--- PASS: TestRender (0.01s)
--- GAS:  14487689
=== RUN   TestTriggerReleaseDuringGraceFails
--- PASS: TestTriggerReleaseDuringGraceFails (0.00s)
--- GAS:  6217302
=== RUN   TestHeartbeatDuringGraceRevivesVault
--- PASS: TestHeartbeatDuringGraceRevivesVault (0.00s)
--- GAS:  4501656
=== RUN   TestHeartbeatBeforeDeadlineFails
--- PASS: TestHeartbeatBeforeDeadlineFails (0.00s)
--- GAS:  4307304
=== RUN   TestHeartbeatAfterGraceEndsFails
--- PASS: TestHeartbeatAfterGraceEndsFails (0.00s)
--- GAS:  4443912
=== RUN   TestHeartbeatNonOwnerFails
--- PASS: TestHeartbeatNonOwnerFails (0.01s)
--- GAS:  6307194
=== RUN   TestTriggerReleaseAfterGraceSplits
--- PASS: TestTriggerReleaseAfterGraceSplits (0.00s)
--- GAS:  6337012
ok      . 	3.01s
```
