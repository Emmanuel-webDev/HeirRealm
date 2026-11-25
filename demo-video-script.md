# HeirRealm demo video script (60–90 seconds)

**Format:** screen recording of the local demo (gnodev + terminal + gnoweb), male American voiceover, normal pace, burned-in captions. No face cam needed. Target: 75 seconds.

---

**[0:00–0:08] HOOK — the problem, on screen: a wallet balance that can never move again.**

> "Every year, crypto holders die — or lose their keys — and their assets are locked forever. Billions of dollars, gone, because nobody else can move them."

**[0:08–0:20] THE IDEA — gnoweb page, empty vault list.**

> "HeirRealm is a dead-man's switch for Gno. You name a beneficiary, fund a vault, and check in regularly. If you stop checking in, anyone can trigger the release — and your GNOT goes to the person you chose. No custodian. No trusted third party."

**[0:20–0:35] CREATE — terminal: CreateVault command runs, vault #1 appears on the page.**

> "Here's a vault. Alice creates it for Bob: a 60-second check-in window, one thousand ugnot. The realm holds the funds — Alice can't spend them, and neither can anyone else."

**[0:35–0:48] CHECK IN — terminal: CheckIn runs, deadline moves on the page.**

> "Alice checks in, and the deadline moves forward. As long as she keeps checking in, nothing happens. The funds just sit there, safe."

**[0:48–1:05] EXPIRE + TRIGGER — terminal: wait, then Carol triggers; events show the split.**

> "Now Alice disappears. The deadline passes — and Carol, a complete stranger, triggers the release. Bob gets 98 percent: one thousand seventy-eight ugnot. Carol, the keeper, gets 2 percent for doing the work: twenty-two ugnot. She can't release early, she can't redirect the funds, and she can't be the owner or the beneficiary. The incentive is the whole mechanism."

**[1:05–1:15] CLOSE — gnoweb page showing "released".**

> "HeirRealm. If you stop checking in, your crypto still reaches the people you chose. Built for the Gnome Tavern Hackathon on Gno."

---

## Shot list (what to record, in order)

1. gnoweb page at `http://localhost:8888/r/dev/heirrealm` — "No vaults yet".
2. Terminal: `gnokey maketx call ... CreateVault` — show `OK!` and `(1 int)`.
3. Refresh gnoweb — vault #1, active, 1,000 ugnot, deadline visible.
4. Terminal: `CheckIn` — show `OK!`; refresh page — deadline moved.
5. Terminal: `Deposit` 100 ugnot (advances the local chain — see DEMO.md) — balance 1,100.
6. Terminal: `TriggerRelease` as carol — show `(1078 int64)` `(22 int64)` and the two transfer events.
7. Refresh gnoweb — vault #1, **released**.
8. Terminal: `gnokey query bank/balances` for bob — `10000000001078ugnot`.

## Recording notes

- Use the exact commands from DEMO.md — they are verified, including the gas flags (`-gas-wanted 8000000 -gas-fee 8000ugnot`).
- Start `gnodev` *after* creating the alice/bob/carol keys, so they are funded at startup.
- The 60-second wait is real time — record it, then cut it to a 2-second "time passing" title card in editing; do not fake the deadline.
- Keep the terminal font large (16pt+) so the amounts are readable at 1080p.
