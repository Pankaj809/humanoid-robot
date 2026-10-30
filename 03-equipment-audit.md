# Equipment audit — what the lab actually has

**Status: UNFILLED.** Every row below is `unknown` until the lab confirms it. This file exists so that the answers land somewhere permanent instead of in a
chat log.

Derived from `01-spec-translation.md` §8. The brochure marks each `[*]` item
*"本产品不包含该设备（需额外购买）"* — **not included, must be purchased separately.**

> **Why this matters.** "Purchased separately" tells us the bench did not ship with the item.
> It does **not** tell us whether the lab bought it afterwards. Both answers are entirely
> plausible and they lead to very different work plans, so each row has to be confirmed by
> somebody physically looking at the lab — not inferred from the brochure.

---

## A. The robot itself

| Item | Status | Confirmed by | Date | Notes |
|---|---|---|---|---|
| Humanoid robot — **model** (R1 / G1 / other) | `unknown` | | | Brochure implies R1 (model SXT-LK-R1-1); the docs link supplied points at **G1**. Contradictory. |
| Humanoid robot — **variant** (EDU / Air / Basic) | `unknown` | | | **Decisive.** Only R1-EDU supports secondary development; R1 Air and R1 Basic ship locked, no SDK, no ROS 2. |
| Robot **software version** | `unknown` | | | Needed to predict the api_id `7106` / `3203` and `sport_lease` `3102` failure modes (see `02-onboarding-plan.md` §4). |

The robot appears **nowhere** in the brochure's Equipment Composition, Module Composition or
Specification Parameters sections — only as the "supporting hardware platform" (配套硬件平台)
line against the two not-included courses. The brochure's product is the bench alone.

## B. `[*]` items — not included with the bench

| Item | Chinese | Status | Blocks | Notes |
|---|---|---|---|---|
| **LiDAR kit ×1** | 激光雷达套装*1 | `unknown` | Category 03 LiDAR acquisition; category 05 LiDAR mapping; Platform Course modules 6–7 | The stated stretch goal. Believed to be a Livox **Mid-360** — confirm. Marked `[*]` in *both* brochure lists. |
| **Robot grippers ×2** | 机器人夹爪*2 | `unknown` | Category 02 gripper control; Platform Course module 5 (**Dex1-1**); ACT capstone (module 8); category 05 visual recognition | Deferred for now, so a `no` here costs nothing near-term. |
| **Humanoid robot remote controller ×1** | 人形机器人遥控器*1 | `unknown` | Manual driving; **safe recovery of the robot** | The most important row in this table — see the safety note below. |
| **VR goggles set ×1** | VR眼镜套装*1 | `unknown` | Category 04 whole-body teleoperation — the entire category | Not on the near-term path. |

> **Safety note on the remote controller.** This is the only listed means of taking manual
> control of the robot, and it is marked not included. Before the first hardware session
> (`02-onboarding-plan.md` §5) establish *how the robot is stopped and recovered* if an SDK
> command misbehaves. The bench does provide an **emergency-stop button** and the
> **protective frame (hoist)** as standard, and those may be sufficient — but that should be
> a confirmed answer, not an assumption.

## C. Items never listed as supplied at all

| Item | Chinese | Status | Notes |
|---|---|---|---|
| **Depth camera** | 深度相机 | `unknown` | Mentioned exactly once in the whole brochure — in the safety course's sensor fault-diagnosis module. Never listed as equipment. |
| Gripper camera interfaces ×2 | 夹爪相机接口*2 | listed in spec table | *Interfaces*, not cameras. Implies wrist/gripper cameras arrive as part of the gripper purchase. |

## D. Curricula — both `[*]` not included

| Course | Chinese | Status | Content |
|---|---|---|---|
| *Humanoid Robot System Safety and Operations & Maintenance* | 《人形机器人系统安全与运维》 | `unknown` | 64 h / 4 credits — safety architecture, sensor fault diagnosis, DDS comms, anomaly detection, logging, monitoring, OTA |
| *Humanoid Robot Experimental Platform Course* | 《人形机器人实验台课程》 | `unknown` | 64 h / 4 credits — kinematics, FOC, R1 SDK high/low level, custom motions, Dex1-1, IMU + LiDAR, Mid-360 SLAM, ACT capstone |

Lower priority than the hardware rows, but worth asking: if the lab bought either course, that
is a ready-made syllabus covering most of `02-onboarding-plan.md`, and there is no sense
rebuilding it from scratch.

## E. Confirmed included (per the brochure spec table)

No action needed; recorded for completeness.

- Bench, 1450 × 800 × 1300 mm, aluminium extrusion + steel/wood, fire/water/wear-resistant top
- **Protective frame (hoist)** — 保护支架（吊架）, *included by default*
- AC power module: 2P earth-leakage breaker, run lamp, start, stop, **emergency-stop**
- Host PC: i5-class, 32 GB RAM, 512 GB storage, 16 GB VRAM GPU, dual NIC, **Ubuntu 22.04**
- Monitor ×1, USB ×3 + Type-C ×1, external 220 V ×2, Ethernet ×2
- Microphone/speaker array ×1
- Motor display module (cut-away rotor, flange, gear disc, cover plates)
- LiDAR **storage** module ×1 — a compartment. Not the sensor.
- VR goggles **storage** module ×1 — likewise a compartment.

> Note the **Ubuntu 22.04** entry. Unitree's SDK documentation states Ubuntu **20.04 LTS** with
> GCC 9.4.0. Worth verifying rather than assuming it is fine.


