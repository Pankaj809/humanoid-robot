# Humanoid robot research — Master's thesis workspace

Research workspace for a Master's thesis on **Vision-Language-Action (VLA) policies on a Unitree
G1 humanoid**, in a robotics lab at Nankai University. Lab source material is in Chinese;
everything produced here is in English.

---

## What is happening

The project started from a Chinese sales brochure and an assumption that the work would be
control and perception engineering on a Unitree **R1**. Both turned out to be wrong:

- The lab's robot is a **G1 EDU**, not an R1. The brochure describes a *workbench* from a
  different product line and names G1 zero times.
- Day-to-day supervision covers the **VLA / decision-making layer** only. Control algorithms and
  simulation cannot be supported in-group.

So the direction moved from "learn the motion stack" to a question that is both supervisable and
runnable on the hardware that is actually confirmed present:

> **A VLA policy that is accurate offline is not necessarily usable on a robot, because the robot
> keeps moving while the policy thinks. Where does the latency budget go, and what does spending
> it differently cost in task success?**

Full reasoning, including the two directions that were considered and deferred, is in
[`01-thesis-proposal.md`](01-thesis-proposal.md).

## What needs to be done

**Blocked on the lab** — five questions, best sent as one numbered message. The most important is
*which VLA stack the group actually uses*, because the thesis should target their stack.

**Not blocked — start now.** Three pieces of work need no hardware, no permissions and no
answers: build the latency timestamping harness, write the task-suite specification, and draft
the related-work section. Together they de-risk everything that follows.

Both lists, with the reasoning and the order to do them in, are in
[`02-open-questions.md`](02-open-questions.md).

## Documents

| File | What it is |
|---|---|
| [`00-research-context.md`](00-research-context.md) | Established facts — hardware, supervision, constraints. Every claim labelled `[CONFIRMED]` / `[VENDOR]` / `[UNVERIFIED]` |
| [`01-thesis-proposal.md`](01-thesis-proposal.md) | The proposed thesis: question, why this and not the alternatives, method, risks, PhD arc |
| [`02-open-questions.md`](02-open-questions.md) | Decision gates and the work that can start immediately |
| [`reference/bench-brochure-translation.md`](reference/bench-brochure-translation.md) | Full English rendering of the bench brochure. Background only |
| [`reference/sport-services-api.md`](reference/sport-services-api.md) | Motion API reference (`sport` service, `LocoClient`), read from SDK source |
| [`docs/`](docs/) | Generated PDF and DOCX of the proposal, for sharing with the lab |

## Generating the shareable documents

The PDF and DOCX in `docs/` are built from the Markdown — edit the Markdown, never the generated
files:

```sh
./build-docs.sh
```

Requires `pandoc`; the PDF step additionally requires a LaTeX engine (`xelatex`).

## Conventions

- **Claims are labelled.** Nothing moves from `[UNVERIFIED]` to `[CONFIRMED]` without a source or
  a direct statement from the lab. Literature numbers are not cited until checked against the
  papers.
- **Hardware is never assumed.** No plan depends on hardware not confirmed present. This is why
  the task suite is tiered.
- **Safety.** The humanoid is never operated alone — two people present, e-stop within reach.

## A note on sources

The vendor brochure underlying the translation is Unitree Robotics material and is **not
redistributed here**; it is kept locally and excluded from version control. Personal notes,
supervision notes and lab machine configuration are likewise local-only.
