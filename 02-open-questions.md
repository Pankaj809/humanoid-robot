# Open questions and decision gates

What is still unknown, what each answer changes, and what can proceed regardless. Ordered by how
much they block, not by how interesting they are.

A **gate** blocks work until answered. A **task** can be done by the student alone, now.

---

## Gates — ask the lab

### G1. Which VLA stack does the group actually use?
GR00T, OpenVLA, π0, or something in-house?

**Why it is first.** The thesis targets the group's stack, not a stack chosen in isolation —
that is what makes it supervisable and what makes the result useful to the lab. It also decides
whether action representation is even a free variable: some stacks fix it, which would reshape
RQ2.

**If there is no stack yet:** that is not a blocker but it is a scope change. Bring-up of a
published open model with documented Jetson deployment then becomes legitimate thesis work
rather than unpaid overhead, and the timeline in §9 of the proposal shifts by roughly a phase.

### G2. Is the Orin NX physically installed and accessible?
Not "standard on EDU in principle" — actually present, with an account, SSH, and a working
ROS 2 / SDK environment.

**Why it matters.** It decides whether the headline condition is onboard or off-board inference.
**It does not block the thesis** — §6 of the proposal turns a negative answer into an
experimental condition — but it changes which result leads.

### G3. Which G1 is available to this project, and is a hand available?
Is the 17-joint-hand unit the same machine or a separate one, and can this student use it? Is
the three-finger hand cleared for attachment *in practice*, and who supervises that?

**Why it matters.** It selects the task tier (proposal §3). **Tier 1 proceeds regardless**, so
this gate controls ambition, not viability. Worth asking early anyway, because attaching a
rarely-used dexterous hand will need scheduling and a second person.

### G4. What does robot access look like in practice?
Account on the bench PC, robot network details, and — given the two-person rule — how sessions
are booked and who the second person is.

**Why it matters.** The two-person rule makes robot time the scarcest resource in the project.
The experimental design (short, scripted, batched runs) depends on knowing the real shape of it.

### G5. What are the formal thesis requirements?
Novelty bar, timeline, credit structure, and whether a publication is expected.

**Why it matters.** Whether a publication is expected changes how hard to push RQ3 and whether
to target a venue. Asking it early is normal and avoids a late surprise.

### G6. What compute is available for training, if any?
Workstation GPU, cluster access, or none.

**Why it matters.** Only lightly for this thesis, which is inference-side. It matters a lot for
the Option C follow-on, so it is worth knowing now rather than later.

---

## Tasks — no permission needed, start now

### V1. Verify the three literature figures
The ~50 Hz onboard figure, POT-VLA's 39/80 → 71/80, and DEED's 0% → 32% are all recorded as
**[UNVERIFIED]** in `00-research-context.md`. Find the papers, confirm or correct the numbers and
the exact hardware each used.

**Why now.** They shape how the related-work section is argued, and an uncorrected number in a
thesis draft is far more expensive to remove later. The proposal is deliberately written not to
depend on them, so this is cleanup, not a blocker.

### T1. Build the timestamping harness
Stage-tagged logging to a single clock, dry-run against recorded data or a stub policy.

**Why now.** It needs no robot, and nothing measured later is trustworthy without it. This is the
single highest-value thing available today.

### T2. Write the task-suite specification
Tier 1 tasks from proposal §3: initial conditions, success criteria, reset procedure, trial count.

**Why now.** Success criteria written *before* seeing results is what separates an experiment
from a demo, and it is the part a supervisor can review without any hardware.

### T3. Draft the related-work section
Latency and real-time constraints in VLA; action tokenisation versus continuous heads; action
chunking; onboard inference on edge accelerators.

**Why now.** It is the largest piece of writing that depends on nothing, and it will expose
whether RQ2 and RQ3 are genuinely open — which is worth discovering before committing.

---

## Recommended order

1. **Send G1–G5 as one short numbered message** to the lab. One message, numbered, easy to reply
   to. Lead with G1: it is the question whose answer changes the most.
2. **Start T1 and T3 the same day**, without waiting for replies.
3. Fold answers into `00-research-context.md` as they arrive, re-labelling
   **[UNVERIFIED]** → **[CONFIRMED]**.
4. Revisit the proposal only if G1 or G2 comes back in a way that changes the lead result.

A draft of the message to the lab is kept locally and is not committed to this repository.
