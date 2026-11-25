# HeirRealm — DoraHacks submission checklist

Hackathon: **Gnome Tavern** (Gno.land) — https://dorahacks.io/hackathon/gnome-tavern/detail
Submissions close: **December 18, 2026, 01:00 UTC**. Judging Dec 18–21, winners announced Dec 21.

## Copy-ready short description (paste into DoraHacks)

> HeirRealm is inactivity-triggered release for Gno. Lock funds, name who should receive them, and check in regularly — if you go quiet, any keeper can trigger the release: 98% to the recipient, 2% to the keeper. No custodian, no trusted third party. Inheritance is the first use case, but the same primitive covers DAO treasury succession, freelancer escrow when a client disappears, time-locked gifts, and dormant funds. Crypto has no password reset — when a holder dies, loses their keys, or disappears, assets are locked forever. HeirRealm makes "what happens if I go quiet" a first-class feature of the chain.
>
> Live on Onyx (GnoWeb): https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm
> Adena Web App: https://emmanuel-webdev.github.io/HeirRealm/demo/

## Submission checklist

| Requirement | Status | Evidence / link |
|---|---|---|
| Live working deployment on the Onyx testnet, with link | ✅ Live on `onyx-1` (GPAO `status: "live"`, block `1,400,742`, TX `hXNZA1U7AhfUOLoxv6/qv3iaPmLR63gQawWkUFD4s5o=`) | https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm (`gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm` — create at least one live test vault on Onyx before submitting) |
| Public repo | ✅ Done | https://github.com/Emmanuel-webDev/HeirRealm |
| Genuine Gno component (realm/package) | ✅ Done | `r/heirrealm/` — realm `gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm`, Gno 0.9 |
| README | ✅ Done | `README.md` — inactivity-triggered release positioning, 5 use cases, keeper fee, guards, local test + live Onyx links |
| Demo video | ⬜ TODO — record it | Script: `demo-video-script.md` (60–90 seconds, updated "go quiet" hook + 5-use-case close) |
| Short description | ✅ Done | Above — paste into DoraHacks |
| Project name does NOT use a 'Gno' prefix | ✅ Done | "HeirRealm" — no 'Gno' prefix, implies no official status |
| No mockups/slides/concepts only | ✅ Done | Live Onyx realm + 9 passing unit tests + verified local-chain 98/2 split (see DEMO.md) |

## Judging criteria — where HeirRealm scores

| Criterion (weight) | How HeirRealm meets it |
|---|---|
| Technical quality (40%) | Real realm with storage (`avl.Tree`), banker payouts, caller auth (`IsUserCall` + `OriginSend`), time-based logic; 9 unit tests covering every guard; verified end-to-end on local chain (`1,100` → `1,078` / `22`) and deployed live on Onyx (`onyx-1`). |
| User appeal (20%) | One sentence anyone understands: *"Lock funds + name a recipient + set a check-in window. Check in and nothing happens. Go inactive and the funds move, no custodian needed."* Covers inheritance, DAO succession, freelancer escrow, gifts, and dormant funds. |
| Creativity (20%) | Inactivity-triggered release maintained by an incentivised stranger (2% keeper fee), not a custodian — a reusable on-chain primitive on Gno. |
| Docs and demo (20%) | README with 5 concrete use cases and explicit scope bounds, DEMO.md with exact commands and real outputs, static demo page, Onyx deploy script, video script, and this checklist. |

## Socials — revised X/Twitter thread opener

**Post 1 (Hook):**
> 1/ What happens to your crypto if you just go quiet?
>
> Die. Lose your keys. Disappear. On most chains, it's locked forever.
>
> I'm building HeirRealm for @gnoland's Gnome Tavern — inactivity-triggered release for Gno. If you go quiet, your funds move to who should have them.

*(Keep posts 2–5 covering how it works, keeper guards, 9/9 tests + 1,100 → 1,078/22 split, and live Onyx link.)*

**Final Post (Close):**
> Inheritance is just the first use case. DAO treasuries, freelancer escrow, time-locked gifts — same vault, same timer.
>
> Live on Onyx (GnoWeb): https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm
> Adena Web App: https://emmanuel-webdev.github.io/HeirRealm/demo/

## After submitting — the retention match (roadmap, do not overpromise)

Winners can double their prize (50% at month 3, 50% at month 6) if the project is live on mainnet at each checkpoint, ships monthly releases, reaches 50 unique addresses by month 3 and 100 by month 6, is imported/adopted by another project, and maintains an active community.

Why **inactivity-triggered release** gives HeirRealm a realistic retention path beyond one-off inheritance:
- **Project adoption:** DAOs and Gno projects can import HeirRealm directly for maintainer/treasury succession — directly addressing the "adopted by another project" criterion.
- **Recurring usage:** Freelancer/bounty escrow (where a client disappearing still pays the contributor) creates repeatable monthly usage rather than once-in-a-lifetime events.
- **Monthly release roadmap:** Keeper-bot service watching deadlines and calling `TriggerRelease` → multi-beneficiary splits → optional social/voice recovery → mainnet deployment. Present these strictly as the post-hackathon roadmap, with single-recipient inactivity-triggered release live today.
