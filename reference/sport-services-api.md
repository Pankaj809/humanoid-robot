# Sport services interface — English reference (R1 and G1)

**Source of truth:** `unitreerobotics/unitree_sdk2_python`, read 2025-10-25 —
`unitree_sdk2py/r1/loco/{r1_loco_api.py, r1_loco_client.py}` and
`unitree_sdk2py/g1/loco/{g1_loco_api.py, g1_loco_client.py}`.
The Chinese docs page `support.unitree.com/home/zh/G1_developer/sport_services_interface`
is the lab's stated reference, but it renders client-side and could not be read directly, so
**everything below was read from the SDK source instead.** Where the docs and the source
disagree, trust the source — it is what actually runs.

This covers **both robots**, because `03-equipment-audit.md` has not yet established which one
the lab owns. That turned out to matter far more than expected — see §2.

---

## 1. How the interface works

`LocoClient` is a thin JSON-RPC wrapper. It talks over DDS to a service named **`"sport"`**,
API version **`"1.0.0.0"`**, and every operation is a numeric **api_id** with a JSON payload.

```python
from unitree_sdk2py.core.channel import ChannelFactoryInitialize
from unitree_sdk2py.r1.loco.r1_loco_client import LocoClient   # or .g1.loco.g1_loco_client

ChannelFactoryInitialize(0, "eth0")   # network interface facing the robot
client = LocoClient()
client.SetTimeout(10.0)
client.Init()                         # registers the api_ids — required before any call
client.Damp()
```

`Init()` must be called first; it sets the API version and registers each api_id at
priority `0`. Calls return an integer error code — **`0` means the request was accepted**,
which is not the same as the robot having moved (see §6).

**"Deploying a predefined motion" means selecting an FSM id or a task id and sending it.**
That is the whole mechanism. Every named helper below is one line wrapping `SetFsmId`,
`SetVelocity` or `SetTaskId`. There is no separate "motion library" to install.

---

## 2. The R1 and G1 APIs are **not** the same size

This is the headline finding, and it changes the plan if the lab turns out to have an R1.

| api_id | Name | R1 | G1 |
|---|---|:--:|:--:|
| 7001 | `GET_FSM_ID` | ✅ | ✅ |
| 7002 | `GET_FSM_MODE` | ❌ | ✅ |
| 7003 | `GET_BALANCE_MODE` | ❌ | ✅ |
| 7004 | `GET_SWING_HEIGHT` | ❌ | ✅ |
| 7005 | `GET_STAND_HEIGHT` | ❌ | ✅ |
| 7006 | `GET_PHASE` | ❌ | ✅ *(deprecated)* |
| 7101 | `SET_FSM_ID` | ✅ | ✅ |
| 7102 | `SET_BALANCE_MODE` | ❌ | ✅ |
| 7103 | `SET_SWING_HEIGHT` | ❌ | ✅ |
| 7104 | `SET_STAND_HEIGHT` | ❌ | ✅ |
| 7105 | `SET_VELOCITY` | ✅ | ✅ |
| 7106 | `SET_ARM_TASK` | ✅ | ✅ |
| 7107 | `SET_SPEED_MODE` | ❌ | ✅ |
| 7110 | `SWITCH_TO_USER_CTRL` | ❌ | ✅ |
| 7111 | `SWITCH_TO_INTERNAL_CTRL` | ❌ | ✅ |

**R1 registers four api_ids. G1 registers fifteen.**

So on R1 the following simply **do not exist**: `BalanceStand`, `HighStand`, `LowStand`,
`SetStandHeight`, `SetSwingHeight`, `SetSpeedMode`, `SwitchToUserCtrl`,
`SwitchToInternalCtrl`, and every getter except `GetFsmId`.

Practical consequence: **do not write code against G1 tutorials and expect it to run on an
R1.** Most online examples, and the docs link the lab supplied, are G1. This is the concrete
reason the model question in `03-equipment-audit.md` is worth asking before building anything.

---

## 3. R1 — complete command set

Everything the R1 `LocoClient` can do.

### Raw calls

| Method | api_id | Payload |
|---|---|---|
| `GetFsmId()` | 7001 | — |
| `SetFsmId(fsm_id: int)` | 7101 | `{"data": fsm_id}` |
| `SetVelocity(vx, vy, omega, duration=1.0)` | 7105 | `{"velocity": [vx, vy, omega], "duration": duration}` |
| `SetTaskId(task_id)` | 7106 | `{"data": task_id}` |

### Predefined motions (FSM ids)

| Method | FSM id | What it does |
|---|---|---|
| `ZeroTorque()` | **0** | All joints to zero torque. Robot goes limp — **only safe on the hoist or already lying down.** |
| `Damp()` | **1** | Damping mode. The standard safe resting state and the usual recovery action. |
| `Stance()` | **4** | Stance / standing posture hold. |
| `Lie2StandUp()` | **701** | Transition from lying to standing. |
| `StandUp2Lie()` | **702** | Transition from standing to lying down. |
| `Start()` | **811** | Start / enable locomotion. |

### Velocity control

| Method | Effect |
|---|---|
| `Move(vx, vy, vyaw, continous_move=False)` | `SetVelocity` with `duration=1` s, or `864000.0` s (10 days) when `continous_move=True` |
| `StopMove()` | `SetVelocity(0, 0, 0)` |

`vx` forward, `vy` lateral, `vyaw` yaw rate. Note the default duration is **1 second** — a
single `Move()` call decays after a second. For continuous walking either call it in a loop or
pass `continous_move=True`.

(The parameter really is spelled `continous_move` in the SDK, missing the second "u". Also
note `SetVelocity`'s third argument is named `omega` on R1 and `vyaw` on G1 — same thing.)

### Arm tasks (task ids via 7106)

| Method | task_id | Notes |
|---|---|---|
| `WaveHand(turn_flag=False)` | **0** / **1** | `1` when `turn_flag=True` (wave with a turn) |
| `ShakeHand(stage=-1)` | **2** / **3** | `stage=0` → 2; `stage=1` → 3; default `-1` toggles between 3 and 2 on each call, so repeated calls advance the handshake |

---

## 4. G1 — additional commands

G1 has everything in §3 (with `Squat`-style transitions instead of lie/stand) plus:

| Method | FSM id / mechanism |
|---|---|
| `Damp()` | 1 |
| `ZeroTorque()` | 0 |
| `Sit()` | 3 |
| `Start()` | 500 |
| `Lie2StandUp()` | 702 |
| `StandUp2Squat()` | 706 |
| `Squat2StandUp()` | **706** — see the warning below |
| `HighStand()` | `SetStandHeight(UINT32_MAX)` |
| `LowStand()` | `SetStandHeight(0)` |
| `BalanceStand(balance_mode)` | `SetBalanceMode(mode)` |
| `SwitchToInternalCtrl(mode)` | `LAST`=0, `PASSIVE`=1, `WALKRUN`=2; anything else raises `ValueError` |

> **Upstream bug worth knowing.** In `g1_loco_client.py`, **`Squat2StandUp()` and
> `StandUp2Squat()` both send FSM id 706.** One of them is almost certainly wrong. If you are
> on a G1 and a squat/stand transition goes the wrong direction, this is why — it is not your
> code. Verify against the robot's own documentation for your software version before relying
> on either.

---

## 5. Suggested first hardware sequence

Matches `02-onboarding-plan.md` §5. Read-only first, so you confirm the service is reachable
before commanding any motion.

```python
ChannelFactoryInitialize(0, "eth0")
c = LocoClient(); c.SetTimeout(10.0); c.Init()

print(c.GetFsmId())        # 1. read-only — does the service answer at all?
c.Damp()                   # 2. known-safe state
c.Lie2StandUp()            # 3. R1; on G1 use the squat/stand transition
c.Move(0.1, 0.0, 0.0)      # 4. one small step, decays after 1 s
c.StopMove()
c.Damp()                   # 5. back to safe
```

**If step 1 does not return a sensible value, stop.** Do not proceed to step 2.

Robot on the hoist, e-stop in hand, another person present. `ZeroTorque()` is the one call to
treat with real caution — it drops all joint torque, and a standing robot will fall.

---

## 6. Known failure modes

These are documented upstream and are **software-version dependent**, which is why
`03-equipment-audit.md` asks for the version.

| Symptom | Cause |
|---|---|
| Call returns `0` (success) but the robot does not move | Reported on G1 EDU+ sw 1.5.3: `SetVelocity` / `SetFsmId` accepted but not executed. A `0` return means *the request was accepted*, not *the motion happened*. |
| Error **`3203`** | "API not implemented on server" — the robot's firmware does not have that api_id. Reported specifically for **7106** (`SetArmTask`, i.e. `WaveHand` / `ShakeHand`). |
| Error **`3102`** (`RPC_ERR_CLIENT_SEND`) | Lease acquisition on `sport_lease` failing, even with client and server API versions both at `1.0.0.0`. |
| Nothing responds at all | Wrong network interface passed to `ChannelFactoryInitialize`, or no route to the `192.168.123.x` subnet. |

Because a `0` return does not prove execution, **verify motions by watching the robot and by
polling `GetFsmId()`** — not by checking return codes alone.

---

## 7. Network and environment

| Thing | Value |
|---|---|
| Robot subnet | `192.168.123.x`, gigabit Ethernet, CycloneDDS |
| Development Computing Unit (Jetson Orin NX) | `192.168.123.164`, login `unitree` / `123` |
| Motion control stack | `192.168.123.161` — **not user-accessible** |
| SDK requirements | Ubuntu 20.04 LTS, GCC 9.4.0 (C++17), CMake ≥ 3.10, Python ≥ 3.8 |

Two environment mismatches already identified, neither resolved:

- The bench PC in the brochure spec ships **Ubuntu 22.04**; the SDK documents **20.04**.
- **`unitree_sdk2_python` is Linux-only.** It will not run on macOS, so the simulation step
  in `02-onboarding-plan.md` §3 needs a Linux machine, a VM, or the bench PC itself.

---

## 8. Open questions

1. **R1 or G1, and which variant?** §2 is the reason this is not a cosmetic question. Only
   R1-EDU supports secondary development at all.
2. **Software version** — determines whether 7106 works (§6).
3. **FSM transition legality.** The SDK exposes the ids but documents no state machine. It is
   not yet known which transitions are legal from which state — e.g. whether `Start()` (811 on
   R1) requires `Stance()` first. This is what the Chinese docs page most likely covers and is
   the main gap in this document.
4. **Does R1 expose balance/stand-height control by another route?** It is absent from the loco
   API, but may exist in the low-level joint interface.
