# Thesis proposal

**Status:** recommended direction, ready to take to the supervisor. Not yet agreed with the lab.
Baseline facts in [`00-research-context.md`](00-research-context.md); everything still to be
confirmed is in [`02-open-questions.md`](02-open-questions.md).

---

## 1. The decision, and why

### Working title

> **Latency-Bounded Deployment of Vision-Language-Action Policies on a Humanoid Robot:
> action representation, compute placement, and closed-loop task success on the Unitree G1 EDU**

Short form: *How fast must a humanoid think?*

### The one-sentence question

**A VLA policy that is accurate offline is not necessarily usable on a robot, because the robot
keeps moving while the policy thinks — so where is the latency budget, and what does spending it
differently cost in task success?**

### Why this question and not another

Three candidate directions were on the table. All three sit inside the supervisor's VLA /
decision-making layer, so all three are supervisable. They differ almost entirely in **how many
unconfirmed things they depend on**, and that is what decides it.

| | **A. Latency & action representation** *(recommended)* | B. Object-state divergence | C. Data curation for post-training |
|---|---|---|---|
| Inside supervisor's area | Yes | Yes | Yes |
| Needs working hands | **No** (see §3) | Partly — push tasks only | **Yes** |
| Needs demonstration data | **No** | No | **Yes**, must be collected |
| Needs post-training compute | **No** | No | **Yes**, unconfirmed |
| Needs RGB-D perception pipeline | No | **Yes** | Partly |
| Needs simulation | No | No | No |
| Fails outright if a dependency is missing | **No** — see §6 | Possibly | **Yes** |
| Plays to a non-robotics student's strengths | **Strongly** | Partly | Partly |

**The deciding argument.** Every one of the three options needs the same thing first: *a VLA
policy actually running on this robot.* Nobody in the lab has confirmed that exists yet. Options
B and C treat that bring-up as unpaid setup work before the real thesis begins. Option A **makes
the bring-up itself the object of study** — the measurement *is* the contribution. That is the
difference between a thesis that starts producing results in month two and one that is still
setting up in month six.

**The second argument is about who is writing it.** This is not a control-engineering thesis and
should not pretend to be. Its contribution is an evaluation protocol, a measurement harness, a
failure taxonomy and a deployment guideline — methodology and systematic characterisation. That
is squarely what this student is good at, and it is a recognised class of contribution in
robotics rather than a consolation prize.

**Why B and C are not discarded.** They are the natural follow-ons. Option A produces the
instrumented platform and the failure taxonomy that B needs, and the latency/representation
baseline that C needs. Sequenced as A → B → C, this is a Master's thesis with a PhD programme
behind it rather than three competing ideas. See §8.

---

## 2. Research questions

- **RQ1 — Where does the time actually go?** How does end-to-end closed-loop latency decompose
  across image capture, preprocessing, policy inference, action decoding, and command
  transmission on the G1 EDU, and which stage dominates?
- **RQ2 — What does the action representation cost?** How do discrete action tokens versus a
  continuous action head, and different action-chunk lengths, trade inference latency against
  closed-loop task success?
- **RQ3 — Is there a latency cliff?** As control latency is increased in controlled steps, does
  task success degrade smoothly or collapse past a threshold — and does that threshold move with
  task speed and with compute placement (onboard Orin NX vs off-board workstation over the lab's
  100 Mbps link)?

RQ1 is descriptive and essentially cannot fail. RQ2 is the main experiment. RQ3 is the one most
likely to produce a result worth publishing on its own, because a measured latency threshold is
exactly the kind of number practitioners need and rarely have.

## 3. Task suite — designed around the hands problem

The G1 in daily use has **non-functional hands**. Rather than make the thesis wait on an
unconfirmed hand, the task suite is **tiered**, and the thesis is complete at Tier 1.

| Tier | Tasks | Needs | Status |
|---|---|---|---|
| **1 — non-prehensile** | reach-to-target, point-at-named-object, push-object-to-goal, nudge-without-toppling | Arms and vision only | **Runnable on confirmed hardware** |
| 2 — simple grasp | pick-and-place of a graspable object | Three-finger hand attached, or access to the 17-joint G1 | Gated on Q1/Q2 |
| 3 — dexterous | in-hand reorientation, multi-object sequencing | 17-joint hand, sustained access | Unlikely; out of scope |

**Why tiering rather than picking one.** It removes the project's single largest dependency
without giving up ambition. Tier 1 answers all three research questions on its own — latency and
action representation are not properties of the gripper. If a hand becomes available, Tier 2 adds
a generalisation result; if it never does, nothing is lost. This is the main reason this proposal
is low-risk, and it is why the recommendation is Option A *as refined here* rather than Option A
as originally framed, which assumed manipulation.

**Why non-prehensile tasks are scientifically adequate.** Pushing is a genuine closed-loop
control problem with contact dynamics and continuous visual feedback — the object keeps moving
after contact, so stale actions have visible consequences. That is precisely the regime where
latency should matter, which makes Tier 1 arguably a *better* probe for RQ3 than slow pick-and-place.

## 4. Method

1. **Instrument before changing anything.** Build a timestamping harness that tags each stage of
   the loop and logs to a single clock. Nothing else in the thesis is trustworthy without this,
   and it is buildable before any hardware access.
2. **Establish a safe, repeatable motion substrate** using the documented `sport` service and
   `LocoClient` (see [`reference/sport-services-api.md`](reference/sport-services-api.md)), with
   e-stop procedure and a fixed reset routine between trials.
3. **Bring up one VLA policy** on the model stack the group already uses — this is gate G1 in
   `02-open-questions.md`, and the choice of model follows the group, not the other way round.
4. **Measure RQ1** — latency decomposition over repeated trials, per task, per tier.
5. **Measure RQ2** — hold task, scene and policy weights fixed; vary action representation and
   chunk length; record latency and success.
6. **Measure RQ3** — inject controlled additional latency in steps and locate the degradation
   curve; repeat with compute placed onboard and off-board.
7. **Build the failure taxonomy** from logged trials — including whether a failure was a *policy*
   error or a *timing* error. This distinction is the thesis's conceptual contribution and the
   bridge to Option B.

**Metrics:** per-stage latency distributions (not just means — tails are what break control),
end-to-end loop rate, task success rate, and time-to-completion on successful trials. Every
reported number tied to a logged trial id.

## 5. Contributions claimed

1. A reproducible **evaluation protocol and open harness** for latency-resolved VLA evaluation on
   a commercial humanoid.
2. An **empirical characterisation** of the latency/success frontier on real hardware.
3. A **deployment guideline**: which action representation and chunk length under which compute
   budget and placement.
4. A **failure taxonomy** separating policy error from timing error.

These are deliberately modest and checkable. A Master's thesis is judged on whether the claim is
defended, not on how large the claim is.

## 6. Why this cannot fail outright

The largest technical risk is that onboard inference on the Orin NX proves impractical — too
slow, or the module is not accessible.

**That outcome is itself RQ3's result.** If inference will not run usefully onboard, the thesis
reports the measured reason and moves the policy off-board over the 100 Mbps link, where the
added network latency becomes a second experimental condition rather than a dead end. The
comparison was always part of the design, so the failure mode is already a chapter.

This is the main structural reason to prefer this direction. Options B and C have failure modes
that produce no result.

## 7. Risks, honestly

| Risk | Severity | Mitigation |
|---|---|---|
| No VLA stack exists in the group yet | **High** | Gate G1. If none, adopt a published open model with documented Jetson deployment; budget bring-up as thesis work, not overhead |
| Orin NX not accessible / not installed | High | Gate G2. Off-board condition (§6) |
| Robot time scarce (two-person rule) | Medium | Short scripted runs; harness developed and dry-run off-robot; batch trials per session |
| Non-robotics background slows bring-up | Medium | Thesis contribution is methodology, not control; keep the motion substrate to documented high-level API only |
| Hands never become available | Low | Tier 1 is sufficient (§3) |
| Evaluation framed as "merely engineering" | Medium | Lead with the RQ3 threshold result, which is a scientific claim, not an engineering report |
| Unverified literature numbers propagate | Low | Task V1; proposal does not rest on them |

## 8. Why this is a good base for a PhD

- **The problem is live.** Real-time, reliable embodied decision-making is a central open problem
  in deployed VLA, not a niche. Efficiency and latency are where the field is actively moving.
- **It transfers.** A measurement-and-evaluation skill set for VLA systems is portable to any
  group working on embodied foundation models — it does not lock the student to this lab, this
  robot, or this model.
- **It has a natural three-chapter arc.** A (this thesis: measure the frontier) → B (act on it:
  detect object-state divergence and recover within the latency budget) → C (reduce the cost:
  data-efficient post-training against the measured baseline).
- **It produces artefacts.** An open harness, a protocol and a task suite are citable and
  reusable, which is disproportionately valuable in a PhD application.
- **Honest counterweight:** benchmark and evaluation papers are sometimes read as lower-novelty
  than new-architecture papers. The defence is RQ3 — a measured latency threshold with a causal
  story is a finding, not a report. Keep that result in front.

## 9. Indicative sequence

Deliberately expressed as phases, not dates, because the gates in `02-open-questions.md` control
the pace and several are outside the student's control.

| Phase | Work | Depends on |
|---|---|---|
| 0 | Agree direction with supervisor; verify literature (V1); draft related-work section | Nothing — **startable now** |
| 1 | Build timestamping harness and task-suite spec; dry-run off-robot | Nothing — **startable now** |
| 2 | Robot access, safety induction, motion substrate, first teleoperated/ scripted runs | G3, G4 |
| 3 | VLA bring-up on the group's stack | G1, G2 |
| 4 | RQ1 and RQ2 experiments | Phase 3 |
| 5 | RQ3 latency sweep, onboard vs off-board | Phase 4 |
| 6 | Failure taxonomy, writing, (optional) Tier 2 extension | Phase 5 |

**Phases 0 and 1 need no hardware, no answers and no permissions.** That is where to start today;
it is the fastest available path and it de-risks everything after it.
