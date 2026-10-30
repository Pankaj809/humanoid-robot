# Robot-Lab-Nankai

Working notes for humanoid robot software work in a Nankai University robotics lab, built
around a Unitree humanoid and the `unitree_sdk2` stack. Source material from the lab is in
Chinese; everything produced here is in English.

| File | What it is |
|---|---|
| [`01-spec-translation.md`](01-spec-translation.md) | English rendering of the Unitree bench brochure |
| [`02-onboarding-plan.md`](02-onboarding-plan.md) | Stepwise plan — motions → perception → manipulation |
| [`03-equipment-audit.md`](03-equipment-audit.md) | What the lab actually has. **Unfilled**, pending confirmation |
| [`04-sport-services-api.md`](04-sport-services-api.md) | English reference for the motion API, covering **both** R1 and G1, read from SDK source |

## Current state

Documentation only — no code yet.

**Blocked on one question:** the brochure describes an **R1**-based bench (model SXT-LK-R1-1)
but the documentation link supplied by the lab points at **G1** docs. This matters more than
it first appeared — the R1 motion API registers **4** api_ids where G1 registers **15**, so
`BalanceStand`, `HighStand`, `LowStand`, `SetSpeedMode` and most getters do not exist on R1
at all (details in [`04-sport-services-api.md`](04-sport-services-api.md) §2). On top of that,
only **R1-EDU** supports secondary development; R1 Air and R1 Basic ship locked with no SDK or
ROS 2 access. Model and variant need confirming before any model-specific code.

See [`03-equipment-audit.md`](03-equipment-audit.md) for the full list of open questions.

## A note on sources

The vendor brochure this translation is based on is Unitree Robotics material and is **not
redistributed here** — it is kept locally and excluded from version control. `01-spec-translation.md`
is an independent English summary written for internal lab use.
