# HeirRealm — DoraHacks submission checklist

Hackathon: **Gnome Tavern** (Gno.land) — https://dorahacks.io/hackathon/gnome-tavern/detail
Submissions close: **December 18, 2026, 01:00 UTC**. Judging Dec 18–21, winners announced Dec 21.

## Copy-ready short description (paste into DoraHacks)

> **HeirRealm is a dead-man's switch for Gno.** Name a beneficiary, fund a vault, and check in regularly — if you stop, any keeper can trigger the release and your GNOT goes to the person you chose, minus a 2% keeper fee. No custodian, no trusted third party: the release is maintained by incentives, not by trust. Crypto holders lose assets forever when keys are lost or owners die; HeirRealm makes inheritance a first-class feature of the chain.

## Submission checklist

| Requirement | Status | Evidence / link |
|---|---|---|
| Live working deployment on the Onyx testnet, with link | ✅ Deployed on `onyx-1` (block `1,400,742`, TX `hXNZA1U7AhfUOLoxv6/qv3iaPmLR63gQawWkUFD4s5o=`) | Pkgpath: `gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm` · Gnoweb: `https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm` (check GPAO activation via `gnokey query vm/qpkgmeta_json -data gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm -remote https://rpc.onyx.testnets.gno.land:443`) |
| Public repo | ✅ Done | https://github.com/Emmanuel-webDev/HeirRealm |
| Genuine Gno component (realm/package) | ✅ Done | `r/heirrealm/` — realm `gno.land/r/dev/heirrealm`, Gno 0.9 |
| README | ✅ Done | `README.md` — what it is, how it works, keeper fee, local test + Onyx deploy steps |
| Demo video | ⬜ TODO — record it | Script: `demo-video-script.md` (60–90 seconds) |
| Short description | ✅ Done | Above — paste into DoraHacks |
| Project name does NOT use a 'Gno' prefix | ✅ Done | "HeirRealm" — no 'Gno' prefix, implies no official status |
| No mockups/slides/concepts only | ✅ Done | Working realm + 9 passing tests + live local-chain demo (see DEMO.md) |

## Judging criteria — where HeirRealm scores

| Criterion (weight) | How HeirRealm meets it |
|---|---|
| Technical quality (40%) | Real realm with storage (avl tree), banker payouts, caller auth, time-based logic; 9 unit tests covering every guard; verified end-to-end on a live chain with real transactions and exact 98/2 split. |
| User appeal (20%) | Solves a problem everyone understands in one sentence: "if I die, my crypto is gone." One flow, three actors, no jargon. |
| Creativity (20%) | A dead-man's switch maintained by an incentivised keeper, not a custodian — a new primitive on Gno. No inheritance project was among the 12 builds submitted as of Nov 25, 2026. |
| Docs and demo (20%) | README, DEMO.md with exact commands and real outputs, static demo page, deploy script, video script, this checklist. |

## After submitting — the retention match (optional, worth up to 2× the prize)

Winners can double their prize (50% at month 3, 50% at month 6) if the project is still live on mainnet at each checkpoint, ships at least one release/deployment per month, is submitted via the checkpoint form with deployment link, demo, and usage numbers, reaches 50 unique addresses by month 3 and 100 by month 6 (team-funded and newly created wallets don't count), is adopted by at least one other project that imports or uses it, and has an active outside community on X, Telegram, or Discord.

HeirRealm's honest retention angle: inheritance is low-frequency by nature, so usage numbers need a plan, not hope. Ideas for the retention period: a keeper-bot service that watches deadlines and triggers releases (it imports the realm), a "vault health" dashboard other wallets can embed, and a monthly release cadence (multi-beneficiary splits → social/voice recovery → mainnet deployment). Note this in the submission if asked about long-term plans — do not overpromise it.
