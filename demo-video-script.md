# HeirRealm demo video script (60–90 seconds)

**Format:** screen recording of the demo (gnoweb + terminal), male American voiceover, normal pace, burned-in captions. No face cam needed. Target: 75 seconds.

---

**[0:00–0:15] HOOK — the problem + broader primitive, on screen: gnoweb page (`No vaults yet`).**

> "What happens to your crypto if you just... go quiet? Die, lose your keys, disappear — on most chains, the answer is: it's locked forever. HeirRealm fixes that. And it's not just for inheritance."

**[0:15–0:25] THE PRIMITIVE — how it works in one sentence.**

> "HeirRealm is inactivity-triggered release for Gno. Lock funds, name who should receive them, and set a check-in window. Check in and nothing happens. Go quiet, and any stranger can trigger the release — earning 2 percent to move 98 percent to your recipient. No custodian needed."

**[0:25–0:38] CREATE — terminal: `CreateVault` command runs, vault #1 appears on gnoweb.**

> "Here's a live vault. Alice locks one thousand ugnot for Bob with a 60-second check-in window. The realm holds the funds — nobody can touch them early."

**[0:38–0:50] CHECK IN — terminal: `CheckIn` runs, deadline moves forward on gnoweb.**

> "Alice checks in, and the deadline moves forward. As long as she stays active, nothing happens. The funds stay put."

**[0:50–1:06] EXPIRE + TRIGGER — terminal: wait, then Carol triggers; events show the 98/2 split.**

> "Now Alice goes quiet. The deadline passes — and Carol, a complete stranger, calls TriggerRelease. Out of eleven hundred ugnot, Bob gets 98 percent: one thousand seventy-eight ugnot. Carol, the keeper, earns 2 percent for doing the work: twenty-two ugnot. She can't release early, can't redirect the funds, and can't be the owner or the recipient."

**[1:06–1:15] CLOSE — gnoweb page showing `released` + live Onyx URL.**

> "Inheritance, DAO treasuries, freelancer escrow — same vault, same timer, same keeper. If you go quiet, the funds move. Built for the Gnome Tavern Hackathon, live on Gno Onyx."

---

## Shot list (what to record, in order)

1. gnoweb page (`/r/.../heirrealm`) — "No vaults yet".
2. Terminal: `gnokey maketx call ... CreateVault` — show `OK!` and `(1 int)`.
3. Refresh gnoweb — Vault #1, `active`, `1000 ugnot`, deadline visible.
4. Terminal: `CheckIn` — show `OK!`; refresh page — deadline moved forward.
5. Terminal: `Deposit` `100 ugnot` (advances local devnet block time — see `DEMO.md`; not needed on live Onyx where blocks advance automatically) — balance `1100 ugnot`.
6. Terminal: `TriggerRelease` as `carol` — show `(1078 int64)` `(22 int64)` and the two transfer events.
7. Refresh gnoweb — Vault #1, **`released`**.
8. Terminal: `gnokey query bank/balances` for Bob — `10000000001078ugnot` (plus flash the live Onyx URL `https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm`).

## Recording notes

- Use the exact commands from `DEMO.md` — including `-gas-wanted 8000000 -gas-fee 8000ugnot`.
- If recording on local `gnodev`, start `gnodev` *after* creating the `alice`/`bob`/`carol` keys so they are prefunded at startup.
- The 60-second wait is real time — record it, then cut it to a 2-second "65 seconds later..." card in editing; do not fake the deadline.
- Keep the terminal font large (16pt+) so the amounts are readable at 1080p.
