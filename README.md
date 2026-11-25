# HeirRealm — inactivity-triggered release for Gno

**If you go quiet, your funds move to who should have them — not to a custodian, not into the void.**

HeirRealm is a Gno realm that holds funds under a check-in timer. Name a recipient, fund a vault, and check in regularly. Miss the window and *any* stranger (a "keeper") can trigger the release. The keeper earns 2% for doing the work, but can never touch the funds early, never redirect them, and never be the owner or the recipient.

Inheritance is the first use case: a holder dies or loses their keys and their family still receives the funds. The same primitive also covers DAO treasury succession, freelancer escrow when a client disappears, time-locked gifts, and dormant funds.

No custodian. No trusted third party. No social recovery committee. **Lock funds + name a recipient + set a check-in window. Check in and nothing happens. Go inactive and the funds move, no custodian needed.**

- **Live on Onyx (`gnoweb` — code & on-chain state):** https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm
- **Adena Web App (zero-CLI Vault & Keeper UI):** https://emmanuel-webdev.github.io/HeirRealm/demo/ *(or open `demo/index.html` via local HTTP server)*

## Why this wins

- **One general primitive, five real problems.** Crypto has no password reset — when a holder, maintainer, or client goes quiet, funds sit locked forever.
- **A new primitive, not a dashboard.** Inactivity-triggered release maintained by an incentivised stranger (2% keeper fee, 98% to recipient) is genuinely new on Gno and importable by other realms.
- **No custodian.** The keeper mechanism is the whole point: execution is maintained by incentives, not by trusting someone.
- **Working, tested, deployed live.** 9/9 Gno unit tests pass, verified end-to-end on local `gnodev` (create → check in → expire → keeper triggers → 98/2 split; see [DEMO.md](DEMO.md)), and deployed live on Onyx (`onyx-1`).

## The 5 use cases

All five run on the exact same realm flow (`CreateVault` → `CheckIn` → miss window → keeper calls `TriggerRelease` → 98% to recipient, 2% to keeper):

1. **Inheritance (the original):** A holder names a family member as beneficiary. If they die or lose their keys, the funds go to the family after the check-in window passes — no will, no lawyer, no sharing a seed phrase.
2. **DAO / project treasury succession:** A maintainer holds a project treasury and names a successor or community wallet as beneficiary. If the maintainer disappears, the treasury moves to the successor instead of dying with them. Other Gno projects can import HeirRealm directly for this.
3. **Freelancer / bounty escrow (the client disappears):** A client funds a vault naming the freelancer as beneficiary with a 30-day check-in window, checking in while work is ongoing. If the client vanishes, the freelancer does not have to chase them — after expiry a keeper triggers the release and the freelancer gets paid 98%.
4. **Time-locked gift / trust:** A parent locks funds naming their child as beneficiary and checks in while active. Not a lump sum handed over today, and not a seed phrase on paper — a vault that moves only when the parent goes quiet.
5. **Dormant / unclaimed funds:** A project, community, or team locks funds naming a community wallet as beneficiary. If the owner goes inactive for a year, the funds return to the community instead of sitting locked forever in a dead wallet.

> **Scope clarity (what this MVP deliberately does NOT do):**
> - **Not a self-savings vault:** `beneficiary != owner` is enforced on-chain, so an owner cannot release funds back to themselves via expiry (use `Cancel` before expiry for a full owner refund).
> - **Single beneficiary, one-shot release:** Recurring payments, multi-beneficiary splits, and social/voice recovery are planned future extensions, not in this MVP.

## How it works

```
Owner creates vault ──► funds locked in the realm
        │                (beneficiary + check-in window set at creation)
        ▼
Owner checks in regularly ──► deadline moves forward, nothing happens
        │
        ▼  (owner stops checking in, deadline passes)
Any keeper calls TriggerRelease ──► 98% to beneficiary, 2% to the keeper
```

### The vault

| Field | Meaning |
|---|---|
| `Owner` | The address that created the vault. Only the owner can check in, deposit, or cancel. |
| `Beneficiary` | Who receives the funds if the owner stops checking in. Cannot be the owner. |
| `Balance` | ugnot held in the vault. Topped up with `Deposit`. |
| `Interval` | The check-in window, in seconds. **Minimum 60 seconds, maximum 365 days.** |
| `Deadline` | `last check-in + interval`. Check-ins reset it. |
| `Status` | `active`, `released`, or `cancelled`. |

### Functions

| Function | Who | What it does |
|---|---|---|
| `CreateVault(beneficiary std.Address, intervalSeconds int64) int` | anyone (becomes owner) | Creates a vault, attaches the initial deposit with `-send`. Returns the vault ID. |
| `Deposit(vaultID int)` | owner only | Adds funds to a vault. Does **not** reset the timer. |
| `CheckIn(vaultID int) time.Time` | owner only | Resets the deadline to `now + interval`. Only works before the deadline. |
| `TriggerRelease(vaultID int) (int64, int64)` | any keeper — **not** the owner, **not** the beneficiary | After the deadline, sends 98% to the beneficiary and 2% to the caller. Returns `(beneficiaryAmount, keeperFee)`. |
| `Cancel(vaultID int)` | owner only | Before the deadline, refunds the full balance to the owner and closes the vault. |
| `GetVault(id int) Vault` | anyone (read-only) | Returns one vault. |
| `VaultCount() int` | anyone (read-only) | How many vaults exist. |
| `Render(path string) string` | gnoweb | Human-readable page listing every vault, plus a detail page per vault. |

### The keeper fee — 2%

The keeper receives **2% (200 basis points)** of the vault balance at release; the beneficiary receives **98%**. The fee is computed with integer math — `fee = balance * 200 / 10000` — so it rounds *down* and can never exceed 2%. For a balance under 50 ugnot the fee rounds to 0 and the beneficiary gets everything. The keeper is paid in the same transaction as the release, so there is no second step to trust.

### The guards (what cannot happen)

- The beneficiary cannot be the owner.
- The interval must be between 60 seconds and 365 days.
- A vault cannot be created with a zero deposit.
- Nobody can release before the deadline — not the keeper, not the owner, not the beneficiary.
- The keeper cannot be the owner or the beneficiary (that would let the owner "release" to themselves early, or the beneficiary skip the wait).
- No double-release: once released, the vault is closed forever.
- No check-in after release, and no check-in after the deadline has passed — a missed window cannot be rescued.
- No cancel after the deadline: once expired, the funds belong to the beneficiary.
- Only the owner can check in, deposit, or cancel.

## Project layout

```
heirrealm-mvp/
├── README.md                  # this file
├── DEMO.md                    # exact 60-second demo steps + expected outputs
├── SUBMISSION.md              # DoraHacks submission checklist + copy-ready description
├── demo-video-script.md       # 60–90 second demo video script
├── r/
│   └── heirrealm/
│       ├── gnomod.toml        # module gno.land/r/dev/heirrealm, gno 0.9
│       ├── heirrealm.gno      # the realm: vaults, timer, keeper release
│       ├── render.gno         # gnoweb Render page
│       └── heirrealm_test.gno # 9 tests
├── demo/
│   └── index.html             # static demo walkthrough page (open in a browser)
└── scripts/
    └── deploy.sh              # Onyx testnet deploy helper
```

## How to test locally

Prerequisites: Go 1.21+ and the Gno toolchain (v1.8.0 used here). Install both locally, not system-wide:

```sh
# Go (Linux, user-local)
curl -LO https://go.dev/dl/go1.25.4.linux-amd64.tar.gz
mkdir -p ~/.local/go && tar -C ~/.local/go -xzf go1.25.4.linux-amd64.tar.gz --strip-components=1

# Gno toolchain (official installer)
curl -L https://raw.githubusercontent.com/gnolang/gno/master/scripts/install-gno.sh | sh
export PATH="$HOME/.gno/bin:$HOME/.local/go/bin:$PATH"
gno version   # gno v1.8.0
```

### Run the tests

```sh
cd r/heirrealm
gno test -v ./...
```

Expected: **9 tests pass** (`TestCreateVault`, `TestCreateVaultGuards`, `TestDeposit`, `TestCheckInResetsTimer`, `TestEarlyReleaseFails`, `TestExpiredReleaseSplits`, `TestKeeperCannotBeOwnerOrBeneficiary`, `TestCancelRefunds`, `TestRender`). `gno lint ./...` is clean.

> **Note on package resolution.** The realm imports `gno.land/p/nt/avl/v0` (storage), `gno.land/p/nt/ufmt` (formatting), and the test-only `gno.land/p/nt/testutils` / `uassert` packages. `gno test` resolves those from the Gno mainnet RPC by default, so a machine **with internet access** can run the tests directly from this directory. In a sandbox without access to `rpc.gno.land`, copy the realm into a clone of `gnolang/gno` at `examples/gno.land/r/dev/heirrealm` and run `gno test -v ./...` there with `GNOROOT` pointing at the clone — that is how the tests were verified for this build (see DEMO.md).

### Run the live demo locally

```sh
cd r/heirrealm
gnodev .            # serves gnoweb at http://localhost:8888/r/dev/heirrealm
```

Full command-by-command walkthrough with real transactions and real balances: [DEMO.md](DEMO.md). The 60-second flow is: create a vault with a 60-second window → check in → wait for expiry → a keeper triggers → 98/2 split. Verified live on 2026-11-25: a 1,100 ugnot vault released **1,078 ugnot to the beneficiary and 22 ugnot to the keeper**.

Two things the demo taught us, recorded in DEMO.md:
- **Gas:** the first vault creation costs ~4.6M gas (avl tree initialisation), and a release costs ~5.3M gas. Use `-gas-wanted 8000000 -gas-fee 8000ugnot` for every call — the docs' 2M-gas example is too low.
- **Chain time on gnodev:** time only advances when blocks are committed. After waiting for expiry, submit one successful transaction (e.g. a tiny `Deposit`) to advance the chain, then call `TriggerRelease`. On Onyx, blocks are produced continuously, so plain waiting works.

## Onyx testnet deployment (`onyx-1`)

- **Realm path:** `gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm`
- **Deployer:** `g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e`
- **Block height:** `1,400,742` (`TX HASH: hXNZA1U7AhfUOLoxv6/qv3iaPmLR63gQawWkUFD4s5o=`)
- **Onyx gnoweb URL (LIVE):** https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm
- **GPAO Status:** `live` (verified via `vm/qpkgmeta_json` and `gnoweb` HTTP `200`)
- **RPC / Chain ID:** `https://rpc.onyx.testnets.gno.land:443` / `onyx-1`

> **Verify on-chain metadata anytime:**
> ```sh
> gnokey query vm/qpkgmeta_json \
>   -data gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm \
>   -remote https://rpc.onyx.testnets.gno.land:443
> ```

### How to deploy your own instance to Onyx

1. **Get a wallet.** Install [Adena](https://adena.app/) (the Gno wallet) and create or import a wallet. Write down the recovery phrase somewhere safe.
2. **Get testnet GNOT.** Go to **https://faucet.gno.land** (select **Onyx**) and request testnet funds for your `g1...` address.
3. **Add the key to gnokey** (the Gno CLI key manager), using the same mnemonic as your Adena wallet:
   ```sh
   gnokey add <your-key-name> --recover
   # paste the 24-word mnemonic when prompted; set a passphrase
   gnokey list   # confirm your address
   ```
4. **Point the realm at your address.** Update `r/heirrealm/gnomod.toml` so the module line reads `gno.land/r/<your-address>/heirrealm`, and deploy with:
   ```sh
   sh ./scripts/deploy.sh <your-key-name> <your-address>
   ```
5. **Verify.** Once GPAO flips `vm/qpkgmeta_json` `status` to `"live"`, open `https://onyx.testnets.gno.land/r/<your-address>/heirrealm` and confirm the page renders.
6. **Submit on DoraHacks.** Publish this repo to GitHub (public), record a demo video using [demo-video-script.md](demo-video-script.md), and submit at https://dorahacks.io/hackathon/gnome-tavern/detail with the deployment link, repo link, README, demo video, and the short description from [SUBMISSION.md](SUBMISSION.md).

## Future extensions (NOT in this MVP)

- **Social / voice recovery:** an optional path where trusted contacts or a voice check can authorise a release or a deadline extension. Deliberately left out of the MVP to keep the core airtight — see the shortlist entry for the idea.
- **Multiple beneficiaries with shares** (e.g. split 50/30/20).
- **Recurring check-in reminders** via an off-chain keeper bot that watches deadlines and triggers releases automatically (anyone can already run such a bot — it just calls `TriggerRelease`).
- **Time-locked wills / estate documents** stored alongside the vault.

## Sources and conventions followed

- Realm structure, `Render`, and `gnomod.toml`: `gnolang/gno` repo, `examples/gno.land/r/demo/` (esp. `defi/atomicswap`, `boards`, `users`).
- Time-based logic with `time.Now()` / `time.Now().After(...)`: `examples/gno.land/r/demo/defi/atomicswap/swap.gno`.
- Caller authentication (`cur.Previous().IsUserCall()` + `cur.Previous().Address()`), payments (`unsafe.OriginSend()`), and payouts (`banker.NewBanker(banker.BankerTypeRealmSend, cur)` + `SendCoins`): same examples plus https://docs.gno.land.
- Storage (`gno.land/p/nt/avl/v0` `avl.Tree`): `examples/gno.land/p/nt/avl/`.
- Tests (`testing.SetRealm`, `testing.SetOriginSend`, `testing.IssueCoins`, `uassert.AbortsContains`): `examples/gno.land/r/demo/defi/atomicswap/swap_test.gno` and the `uassert` package docs.
- Deploy and gas guidance: https://docs.gno.land (gnokey / gnodev) — gas figures above are measured, not copied.

## Licence

MIT. Build on it, fork it, keep it alive — that is the point of a dead-man's switch.
