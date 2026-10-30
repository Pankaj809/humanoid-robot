# Research context — established facts

Everything in this file is treated as settled. It is the shared baseline for
[`01-thesis-proposal.md`](01-thesis-proposal.md) and [`02-open-questions.md`](02-open-questions.md).
Each claim is labelled so that nothing unverified is silently promoted to fact:

- **[CONFIRMED]** — stated directly by the lab, or read off the hardware.
- **[VENDOR]** — from Unitree product documentation or the bench brochure.
- **[UNVERIFIED]** — working belief from prior reading. **Must be checked before citing.**

---

## 1. The correction that reframes the project

The project began from a 6-page Chinese sales brochure, translated in full in
[`reference/bench-brochure-translation.md`](reference/bench-brochure-translation.md).

Two things about that brochure matter, and both are easy to get wrong:

1. **It describes a workbench, not a robot.** The product is model SXT-LK-R1-1: a
   1450 × 800 × 1300 mm bench with a protective gantry, AC power and e-stop panel, a cut-away
   motor display, a host PC, and a microphone/speaker array. The humanoid itself never appears
   in any equipment list in the document. **[VENDOR]**
2. **It describes the wrong robot line.** The brochure names **R1** five times and **G1** zero
   times. **[VENDOR]**

The lab's actual robot is a **G1**. **[CONFIRMED]** So the brochure is background material about
a product line the thesis does not use. It is kept in `reference/` for traceability and is not
the basis for anything.

**Why this matters:** an entire earlier plan — motor fundamentals → motion control → LiDAR/SLAM
→ gripper/ACT capstone — was derived from this brochure. It was built on the wrong robot *and*
at the wrong layer (see §3). That plan is superseded.

## 2. Hardware actually in the lab **[CONFIRMED]**

| Item | Status | Note |
|---|---|---|
| Unitree **G1** humanoid | Present, **EDU** | The machine currently in use |
| — its hands | **Fake / decorative** | Non-functional end effectors. Drives the task design in §5 of the proposal |
| A **second G1** with 17-joint hands | Present | Availability to this project **not yet confirmed** |
| **Three-finger movable hand** | Present, **detached** | Permitted in principle to attach to the fake-hand G1; not yet done |
| Robot dogs (quadrupeds) | Present | All EDU **except** the smallest, which is not EDU |

**EDU is the decisive label.** Only EDU editions support secondary development — own code, own
algorithms, SDK and ROS 2 access. Basic and Air editions ship locked and are demonstration-only.
**[VENDOR]** The lab being almost entirely EDU is what makes research possible here at all.

**G1 EDU configuration [VENDOR]:** NVIDIA Jetson **Orin NX** high-compute module as standard,
3D LiDAR and depth camera included, optional Dex3-1 three-finger dexterous hand (7 DoF per hand),
knee torque to 120 N·m, arm payload 3 kg. Non-EDU G1 drops the Orin module and rates lower
(90 N·m, 2 kg).

### Network **[CONFIRMED]**

The host machine sits on Unitree's standard `192.168.123.x` robot subnet with a manual/static
address, `255.255.255.0` mask and a `.1` gateway — a conventional bring-up. The number that
matters for this thesis is the link speed: **100 / 100 Mbps**.

**Why it matters:** 100 Mbps is comfortable for control messages and marginal for streaming
camera frames off-robot. It is a real argument for keeping policy inference **onboard**, and it
makes "onboard vs off-board" a measurable question rather than a preference. This is used
directly in the proposal.

### Safety rules **[CONFIRMED]**

- Robot dog: may be worked on alone.
- **Humanoid: two people must be present.** E-stop within reach.
- Extra caution on the dexterous-hand G1, which is rarely used by anyone in the lab.

**Why it matters beyond safety:** the two-person rule makes robot time a *scheduled, scarce
resource*. Any plan that needs long unsupervised sessions is not executable here, which is a
further argument for short, scripted, instrumented runs.

## 3. Supervision — what can and cannot be guided **[CONFIRMED]**

Day-to-day guidance is available for the **decision-making layer**: large-model agents
integrated with robots, i.e. **Vision-Language-Action (VLA)**.

Guidance is **not** available for:

- low-level control algorithms,
- simulation engineering (MuJoCo / Isaac Gym),
- Action Grid, which is outside the group's work.

**Why this is the single most important constraint in the project.** A thesis is defensible
largely because a supervisor can judge it. Work that sits outside the supervisor's area has to
be carried alone, and a non-robotics student carrying a control or simulation thesis alone is
the main foreseeable way this fails. The thesis therefore lives in the VLA / decision /
evaluation layer, and treats any simulation or control work as optional and self-supported.

## 4. Technical reference carried forward

The motion API is documented in
[`reference/sport-services-api.md`](reference/sport-services-api.md): DDS service `sport`,
client class `LocoClient`, getters in 7001–7006, setters in 7101–7107, control switching at
7110/7111, plus friendly wrappers (`Damp`, `StandUp`, `Move`, `WaveHand`, …). "Deploying a
predefined motion" means selecting an FSM or task id and sending it.

**Why it is kept but demoted:** the thesis needs a way to make the robot move safely and
repeatably, and this is it. But the API surface is genuinely small, so *using* it is a means,
not a contribution. Treating it as the thesis was the earlier mistake.

R1 and G1 share `unitree_sdk2` / `unitree_sdk2_python`, CycloneDDS and the `192.168.123.x`
layout, but differ in joint count, URDF and partly in API — so R1 examples are a guide, not a
drop-in. **[VENDOR]**

## 5. Literature figures — **[UNVERIFIED]**, do not cite yet

Carried from earlier reading, recorded so they are not lost, flagged so they are not misused:

- ~50 Hz onboard closed-loop VLA demonstrated on G1 with Orin NX.
- **POT-VLA** formalised "object-state divergence" and reported 39/80 → 71/80 success.
- **DEED** reported data-efficient post-training taking a task 0% → 32%, framing it as a
  systems-integration problem rather than an architecture problem.

**None of these has been checked against the source papers.** They are not load-bearing: the
proposal in `01-thesis-proposal.md` is written so that its motivation stands without them.
Verifying them is task V1 in `02-open-questions.md`.

## 6. Standing rules

- Never run the humanoid alone; two people, e-stop in reach.
- Never propose work that depends on hardware not confirmed present.
- Never assume in-group support for control or simulation.
- The thesis must answer a question with a measurable result. A learning log is not a thesis.
- All repository documents in English.
- Verify literature numbers before citing.
