# Onboarding plan — Unitree humanoid software work

**Written:** 2025-10-25. Nankai University robotics lab.

Scope direction supplied by the lab:

> Start through the basic development documentation. The sport services interface
> documentation covers some of the robot's existing motions — you can also look into how to
> deploy predefined motions on the robot. For now you don't need to focus too much on
> dexterous hands. If you'd like to explore further, you could look into LiDAR point cloud
> mapping (our model is believed to be a MID-360).

So the ordering is: **predefined motions first, perception second, manipulation last.**

Reference links supplied:

- `https://support.unitree.com/home/zh/G1_developer/sport_services_interface` — the motion API
- `https://unistore.unitree.com/` — Unitree's official store (for identifying and pricing the
  items the brochure marks as not included; see `01-spec-translation.md` §8)

---

## 0. Starting position

What exists in this repo as of writing:

| File | Status |
|---|---|
| `source/robot.pdf`, `source/robot_pdf_extracted_zh.txt` | The source brochure + extracted text (local only, not committed) |
| `01-spec-translation.md` | Complete English rendering of the brochure — **done** |
| `02-onboarding-plan.md` | This file |
| `03-equipment-audit.md` | Checklist of what the lab has — **unfilled**, awaiting Step 0 answers |

No code yet. No SDK installed. No hardware access confirmed.

Worth keeping in mind: **`source/robot.pdf` is a sales
brochure for a lab bench, not a robot manual.** The product is model SXT-LK-R1-1, a
1450×800×1300 mm workbench with a protective gantry, AC power/e-stop panel, a cut-away motor
display, a host PC and a mic/speaker array. It is not the robot.

---

## ⚠️ Unresolved: R1 or G1?

**The brochure describes an R1-based bench. The documentation link points at G1 docs.** These
are different robots.

They share a lot — `unitree_sdk2` / `unitree_sdk2_python`, CycloneDDS, the `192.168.123.x`
network layout — but they differ in joint count, URDF, and parts of the high-level API.

And the variant matters even more than the model: **only R1-EDU supports secondary
development. R1 Air and R1 Basic ship locked, with no SDK or ROS 2 access at all.** If the lab
owns a locked variant, steps 3 onward need rethinking. This has to be established in week one,
not week six.

Until it is answered, confine work to what is identical across both: DDS setup,
`ChannelFactoryInitialize`, and simulation.

---

## Step 0 — Confirm with the lab (highest priority)

Everything below branches on these answers. Ask in one numbered message, citing
`01-spec-translation.md` §8 as the reason.

1. Which robot does the lab physically have — **R1 or G1**? Which **variant**
   (EDU / Air / Basic)? What **software version** is on it?
2. Do we have the **LiDAR kit**? Is it a Livox **Mid-360**?
3. Do we have the **grippers**, the **VR goggles**, the **remote controller**?
4. Is the **bench PC** set up? Can I get an account on it, plus the robot's network details?
5. Can I work in **simulation** on my own laptop before touching hardware?

The brochure marks items 2 and 3 as "purchase separately", and **the robot itself never
appears in any of the brochure's equipment lists** — it shows up only as a "supporting
hardware platform" line against the two (also not-included) curricula. So none of this is
safe to assume.

---

## Step 1 — Commit the repo

The repo had no commits at all. Done as part of this step: `01-spec-translation.md` represents
real finished work and should not sit untracked.

---

## Step 2 — `03-equipment-audit.md`

Turn §8 of the translation into a live checklist, one row per item, with a status column:
`confirmed present` / `confirmed absent` / `unknown`. Fill it in from the Step 0 answers.

This becomes the single document to point at when scoping what is actually achievable. If an
experiment is impossible because the hardware was never bought, that should be visible early
rather than discovered late.

---

## Step 3 — Simulation first, no hardware

Install on your own machine:

- `unitree_sdk2_python` (Python bindings; `unitree_sdk2` is the C++ original)
- `unitree_mujoco` — ships an `r1/` MJCF model; the C++ SDK has an `example/r1` tree
  (`r1_ankle_swing_example.cpp`, `r1_A5_wrist_swing_example.cpp`, and similar)

Environment per Unitree's requirements: Ubuntu 20.04 LTS, GCC 9.4.0 (C++17), CMake ≥ 3.10,
Python ≥ 3.8. Note the bench PC in the brochure spec ships **Ubuntu 22.04**, which does not
match the SDK's stated 20.04 — worth checking rather than assuming it is fine.

Goal for this step: `ChannelFactoryInitialize` → `LocoClient` → `Init()` → `Move()` working
against the simulator. Make mistakes where nothing falls over.

---

## Step 4 — Read the sport-service API properly, and write it up

Produce `04-sport-services-api.md` in English. This is the first piece of **original** work
for the lab — an English reference to this API that does not currently exist.

The mechanism is small. `LocoClient` talks to a DDS service named `"sport"` (API version
`1.0.0.0`), and every call is an api_id with a payload:

| Range | Purpose | Members |
|---|---|---|
| 7001–7006 | getters | `GetFsmId` 7001, `GetFsmMode` 7002, `GetBalanceMode` 7003, `GetSwingHeight` 7004, `GetStandHeight` 7005, `GetPhase` 7006 *(deprecated)* |
| 7101–7107 | setters | `SetFsmId` 7101, `SetBalanceMode` 7102, `SetSwingHeight` 7103, `SetStandHeight` 7104, `SetVelocity` 7105, `SetArmTask` 7106, `SetSpeedMode` 7107 |
| 7110–7111 | control switching | `SwitchToUserCtrl` 7110, `SwitchToInternalCtrl` 7111 |

The named helpers are thin wrappers over those: `Damp()`, `StandUp()`, `ZeroTorque()`,
`Squat()`, `StandUp2Squat()`, `HighStand()`, `LowStand()`, `Move(vx, vy, vyaw)`, `StopMove()`,
`BalanceStand(mode)`, `WaveHand(turn_flag)`, `ShakeHand(stage)`.

**"Deploying a predefined motion" means selecting an FSM id or a task id and sending it.**
`WaveHand()` is `SetTaskId(1)`. `ZeroTorque()` is `SetFsmId(0)`. `StandUp2Squat()` is
`SetFsmId(706)`. `StopMove()` is `SetVelocity` with zeros. `HighStand()`/`LowStand()` set
stand height to max-uint32 / 0. `Move()` sets a duration of 1 s, or 864000 s when called with
`continous_move=True`. That is the entire pattern.

What to document, beyond the id list: the **legal state transitions** between FSM ids, and
**which calls require which balance mode**. Those are the parts that cause real-world
failures, and they are exactly what the Chinese docs page covers.

Sources: the docs page is the stated source, but the SDK headers are ground truth —
`unitree_sdk2py/g1/loco/g1_loco_api.py` and `g1_loco_client.py`, or the C++
`include/unitree/robot/g1/loco/g1_loco_api.hpp`. **Read the headers for the model you actually
have** once Step 0 resolves which that is; the values above were read from the G1 Python SDK.

### Known failure modes, so you recognise them rather than debug them blind

- `SetVelocity` / `SetFsmId` returning success code `0` while the robot does nothing — reported
  on G1 EDU+ software 1.5.3, alongside lease acquisition on `sport_lease` failing with `3102`
  (`RPC_ERR_CLIENT_SEND`) despite matching API versions.
- Error `3203` = "API not implemented on server". Reported for api_id `7106` (`SetArmTask`,
  i.e. `WaveHand` / `ShakeHand`) on some builds.

Both are software-version-dependent, which is why Step 0 asks for the version.

---

## Step 5 — First hardware session (supervised)

**Never alone.** Robot on the gantry, e-stop within reach, another person present. The
brochure's bench includes the protective frame (hoist) by default and an emergency-stop
button — use them.

Sequence, and stop at the end of it:

1. Connect over Ethernet; confirm the `192.168.123.x` link
2. Verify DDS traffic is flowing
3. `GetFsmId()` — read-only, confirms the service is reachable before you command anything
4. `Damp()`
5. `StandUp()`
6. One small `Move()`

Log everything. If step 3 does not work, do not proceed to step 4.

---

## Step 6 — Deploy predefined motions

The deliverable the lab asked for. Work through `WaveHand`, `ShakeHand`,
squat/stand, posture adjustment. Then chain them into a sequence script with waits and
state checks between calls.

Clean, demonstrable, and a reasonable first result to present.

---

## Step 7 — IMU / DDS subscription

Subscribe to the IMU topic, parse it, plot it. Low risk, and it teaches you the subscriber
side of DDS rather than just the service-call side. Prerequisite understanding for anything
perception-related.

---

## Step 8 — LiDAR mapping *(only if the Mid-360 is confirmed present)*

Livox-SDK2 → point-cloud capture → noise filtering → ROS 2 → visualisation → SLAM mapping →
pose initialisation and navigation.

This is the stretch goal and a substantial step up in scope. Do not start it until 5–7 are
solid. Note the brochure lists a "LiDAR **storage** module" as included — that is a
compartment, not a sensor. The sensor itself is marked not included.

Also relevant: `unitree_ros2` was found to have **no R1-specific example tree**, so ROS 2
integration on R1 may need more work than the G1 path suggests.

---

## Step 9 — Grippers / ACT capstone

Explicitly deferred by the lab, and the hardware is marked not included. Leave it.

For the record, if it ever comes back into scope: brochure module 5 names the **Dex1-1**
gripper over DDS (position / velocity / torque control), and module 8 is a vision → **ACT
imitation learning** → gripper manipulation pipeline.

---

## Sequencing notes

Two things are worth being deliberate about.

**Step 0 blocks Steps 3–8.** A week spent on R1 material when the lab owns a G1 is a week
gone. Ask before building.

**Step 4 is a real deliverable, not personal notes.** The lab's documentation is in Chinese,
so an English reference for this API does not yet exist; writing one is a contribution in its
own right and worth treating as such.
