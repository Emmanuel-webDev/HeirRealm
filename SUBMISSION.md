# HeirRealm — DoraHacks submission checklist

Hackathon: **Gnome Tavern** (Gno.land) — https://dorahacks.io/hackathon/gnome-tavern/detail
Submissions close: **December 18, 2026, 01:00 UTC**. Judging Dec 18–21, winners announced Dec 21.

## Copy-ready short description (paste into DoraHacks)

> HeirRealm is inactivity-triggered release for Gno. Lock funds, name who should receive them, and check in regularly — if you miss a window, a post-deadline grace period lets you revive the vault with an owner-only Heartbeat; stay quiet past the grace period and any keeper can trigger the release: 98% to the recipient, 2% to the keeper. No custodian, no trusted third party. Inheritance is the first use case, but the same primitive covers DAO treasury succession, freelancer escrow when a client disappears, time-locked gifts, and dormant funds. Crypto has no password reset — when a holder dies, loses their keys, or disappears, assets are locked forever. HeirRealm makes "what happens if I go quiet" a first-class feature of the chain.
>
> Live on Onyx (GnoWeb): https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm/v2
> Adena Web App: https://emmanuel-webdev.github.io/HeirRealm/demo/

## Submission checklist

| Requirement | Status | Evidence / link |
|---|---|---|
| Live working deployment on the Onyx testnet, with link | ✅ Live on `onyx-1` (`heirrealm/v2` at block `1,423,166`, TX `euaCtNf9SfTPYrEpoMsMWBR9rWiBeDwjOSJkyLxi/Ac=`; initial v1 at `/heirrealm`, block `1,400,742`) | https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm/v2 |
| Public repo | ✅ Done | https://github.com/Emmanuel-webDev/HeirRealm |
| Genuine Gno component (realm/package) | ✅ Done | `r/heirrealm/` — realm `gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm/v2`, Gno 0.9 |
| README | ✅ Done | `README.md` — inactivity-triggered release positioning, 5 use cases, grace-period Heartbeat, keeper fee, guards, local test + live Onyx links |
| Demo video | ⬜ TODO — record it | Script: `demo-video-script.md` (60–90 seconds, Adena UI + GnoWeb proof) |
| Short description | ✅ Done | Above — paste into DoraHacks |
| Project name does NOT use a 'Gno' prefix | ✅ Done | "HeirRealm" — no 'Gno' prefix, implies no official status |
| No mockups/slides/concepts only | ✅ Done | Live Onyx realm + single-page Adena dApp + 15 passing unit tests + verified 98/2 split (see DEMO.md) |

## Judging criteria — where HeirRealm scores

| Criterion (weight) | How HeirRealm meets it |
|---|---|
| Technical quality (40%) | Real realm with storage (`avl.Tree`), banker payouts, caller auth (`IsUserCall` + `OriginSend`), time-based check-in + post-deadline grace period (`Heartbeat`); 15 unit tests covering every guard; verified end-to-end on local chain and deployed live on Onyx (`onyx-1`). |
| User appeal (20%) | One-click Adena Web App with use-case presets, My Vaults, Keeper Bounties, live grace countdowns, and one sentence anyone understands: *"Lock funds + name a recipient + set a check-in window. Check in and nothing happens. Go inactive and the funds move, no custodian needed."* |
| Creativity (20%) | Inactivity-triggered release with a trustless post-deadline Heartbeat grace buffer and 2% keeper incentive — a reusable on-chain primitive on Gno. |
| Docs and demo (20%) | README with 5 concrete use cases and explicit scope bounds, DEMO.md with exact commands and real outputs, Framer-styled Adena dApp, Onyx deploy script, video script, and this checklist. |

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
> Live on Onyx (GnoWeb): https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm/v2
> Adena Web App: https://emmanuel-webdev.github.io/HeirRealm/demo/

## After submitting — the retention match (roadmap, do not overpromise)

Winners can double their prize (50% at month 3, 50% at month 6) if the project is live on mainnet at each checkpoint, ships monthly releases, reaches 50 unique addresses by month 3 and 100 by month 6, is imported/adopted by another project, and maintains an active community.

Why **inactivity-triggered release** gives HeirRealm a realistic retention path beyond one-off inheritance:
- **Project adoption:** DAOs and Gno projects can import HeirRealm directly for maintainer/treasury succession — directly addressing the "adopted by another project" criterion.
- **Recurring usage:** Freelancer/bounty escrow (where a client disappearing still pays the contributor) creates repeatable monthly usage rather than once-in-a-lifetime events.
- **Monthly release roadmap:** Keeper-bot service watching deadlines and calling `TriggerRelease` → multi-beneficiary splits → optional social/voice recovery → mainnet deployment. Present these strictly as the post-hackathon roadmap, with single-recipient inactivity-triggered release live today.
