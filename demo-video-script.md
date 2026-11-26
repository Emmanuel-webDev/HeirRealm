# HeirRealm demo video script (75–90 seconds)

**Format:** screen recording of the **Adena Web App** + **Onyx GnoWeb** tab side-by-side, clear voiceover, burned-in captions. No face cam needed. Target: ~80 seconds.

---

**[0:00–0:14] HOOK — on screen: HeirRealm Adena Web App hero (`If you go quiet, your funds still reach who should have them`).**

> "What happens to your crypto if you just... go quiet? Die, lose your keys, disappear — on most chains, it's locked forever. HeirRealm fixes that on Gno. And it's not just for inheritance."

**[0:14–0:26] THE PRIMITIVE — scroll briefly across the 5 use-case presets, then click `60s Live Demo`.**

> "HeirRealm is inactivity-triggered release. Lock GNOT, name a recipient, and pick a check-in window — for family inheritance, DAO treasury succession, or freelancer escrow. Check in and nothing happens. Go quiet past the grace period, and any stranger earns 2 percent to deliver 98 percent to your recipient. No custodian needed."

**[0:26–0:40] CREATE ON ONYX — fill recipient, `0.01 GNOT`, click `Lock Funds & Create Vault`, sign in Adena.**

> "Let's run it live on Gno Onyx. I connect Adena, pick the 60-second demo window with `0.01 GNOT`, and create a vault in one click. Instantly, Vault #1 appears in My Vaults — and right here on Onyx GnoWeb."

**[0:40–0:56] GRACE PERIOD + HEARTBEAT REVIVAL — cut to countdown hitting `0s` → `Grace Period · Heartbeat Open` → click `Send Heartbeat · Revive Vault`.**

> "When the check-in deadline passes, funds don't release immediately — the vault enters a grace period first. Keepers are still locked out, and as the owner I click Send Heartbeat to revive the vault and reset the timer."

**[0:56–1:12] POST-GRACE EXPIRY + KEEPER 98/2 RELEASE — cut to grace ending → switch to Keeper wallet → open `Keeper Bounties` → click `Trigger Release · Earn 200 ugnot (2%)`.**

> "Now suppose I truly go quiet and both the deadline and grace period expire. Any stranger opens Keeper Bounties and clicks Trigger Release — sending `9,800 ugnot` — 98 percent — to the recipient, and earning `200 ugnot` — 2 percent — atomically."

**[1:12–1:22] CLOSE — flip to Onyx GnoWeb showing `Status: released` + GitHub & DoraHacks links.**

> "15 passing Gno unit tests, live on Onyx, zero custodians. HeirRealm — if you go quiet, your funds still move."

---

## Shot list (in order)

1. Open **Adena Web App** (`https://emmanuel-webdev.github.io/HeirRealm/demo/` or `http://localhost:8080/demo/`) set to **`Onyx (onyx-1)`**, plus **Onyx GnoWeb** (`https://onyx.testnets.gno.land/r/g1pzw2mc795ahjumtmkxjyxhz0awklc3apyfpw9e/heirrealm/v2`) in a second tab.
2. Connect **Owner** wallet in Adena → click **`60s Live Demo`** → enter Recipient `g1...` and `0.01 GNOT` → click **`Lock Funds & Create Vault`** → approve in Adena.
3. Show the new **`Active`** vault card ticking down (and refresh GnoWeb tab to prove on-chain state).
4. Let the 60s timer hit `00m 00s` *(trim the wait in editing with a 1.5s `"60 seconds later..."` caption)* → show **`Grace Period · Heartbeat Open`** → click **`Send Heartbeat · Revive Vault`** → approve in Adena → show timer reset back to **`Active`**.
5. Let both windows expire (`60s + 60s`, trimmed in editing with `"After deadline + grace..."`) → switch Adena to a **Keeper** wallet (not Owner or Recipient) → click **`Keeper Bounties`** → click **`Trigger Release · Earn 200 ugnot (2%)`** → approve in Adena.
6. Refresh Onyx GnoWeb vault detail page showing **`Status: released`**, **`98%`** recipient share, and **`2%`** keeper fee.
