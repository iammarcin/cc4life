---
name: spec-driven-planning
description: "Creates gap-free specifications through structured user interviews. Use when starting research projects, planning complex tasks, or preparing specs for autonomous agent execution. Triggers on: plan, spec, research plan, project planning."
---

# Spec-Driven Planning

Most AI research fails not during execution, but before it starts. Someone says "research X" and the agent charges off, produces 10 pages of surface-level findings, and misses the actual question. The user reads it, sighs, and starts over with more instructions. Repeat until exhaustion.

The fix is embarrassingly simple: **don't start until you know exactly what "done" looks like.** Interview the user. Surface the hidden requirements. Write a specification so precise that an agent can execute it autonomously at 3am and produce exactly what was needed.

This skill exists because of a hard-won lesson: the teams that sleep well during overnight research are the ones who did the most work *before* pressing go.

---

## Why the Default Approach Fails

When you hand Claude a research task, it defaults to:

- **The eager start** -- begins researching immediately, filling gaps with assumptions instead of questions.
- **The shallow spread** -- covers everything at surface level, nothing at useful depth.
- **The missing "why"** -- produces facts without knowing what decision they inform.
- **The ambiguity cascade** -- one vague requirement produces five vague phases, each producing vague deliverables that nobody can evaluate.

The result: work that technically "answers the question" but doesn't actually help. The user ends up doing the thinking themselves anyway.

**Spec-driven planning inverts this.** Front-load all the thinking. Interview ruthlessly. Write the spec. Then -- and only then -- execute.

---

## Core Principles

### 1. Interview Before You Plan

The user knows what they want but not always how to articulate it. Your job is to pull it out of them -- like a consultant in a discovery session, not a form-filling exercise.

**Why:** Every question you don't ask becomes an assumption. Every assumption becomes a gap. Every gap becomes a follow-up conversation at 9am that could have been avoided.

**How:** Ask questions that surface the *decision* behind the research, not just the topic. "What will you do differently when you have this research?" reveals more than "What do you want to know?"

### 2. Specs Are for Machines, Not Humans

A good spec reads like a contract between the user and the executing agent. No ambiguity. No "explore further if needed." Every phase has explicit inputs, outputs, and completion criteria.

**Why:** The spec might be executed by a different agent, in a different session, hours later. That agent has zero context beyond what's written. If the spec says "research competitors," it will produce something generic. If it says "identify the 3 closest competitors by pricing model, compare their onboarding flow to ours, and flag which features they offer that we don't," it will produce something useful.

### 3. Surface the Hidden Requirements

Users rarely state their actual requirements upfront. They say "research morning exercise" when they mean "find evidence I can cite in a presentation to our wellness committee about restructuring the workday." The context around the request changes everything about the research design.

**Why:** Without the context, you'll produce a general-purpose article summary. With it, you'll produce citation-ready evidence organized by committee objection.

### 4. Scope Kills More Projects Than Complexity

A tight scope with clear boundaries beats an ambitious scope with vague ones. The skill's job is to help the user decide what's OUT as much as what's IN.

**Why:** Research without boundaries expands until it consumes all available time and tokens. "Analyze the competitive landscape" is a 3-day project or a 30-minute project depending on scope. The spec must make that explicit.

### 5. Phases Must Chain, Not Float

Each phase should produce something the next phase consumes. If you can rearrange phases randomly and nothing breaks, your phases are just a list pretending to be a plan.

**Why:** Independent phases mean the agent can't verify its own progress. Chained phases create natural checkpoints: "Phase 2 needs the company list from Phase 1. If Phase 1 produced no companies, stop."

### 6. Write to Disk, Not to Memory

Store the spec as a file. Reference it before major decisions. Update it as gaps surface during execution.

**Why:** After 30+ tool calls, the agent's original understanding drifts. The spec file acts as a persistent north star. Re-reading it before each phase brings the goals back into the attention window. This is the single most effective trick for long-running autonomous tasks.

---

## The Process

### Phase 1: Interview

Start with discovery, not planning. Your goal is to understand three things:

1. **What decision does this research inform?** (The "so what?")
2. **Who consumes the output and what format do they need?** (The audience)
3. **What would make this research worthless?** (The anti-requirements)

Ask 3-5 questions per round. Don't dump 20 questions at once -- that's a survey, not a conversation. Listen to the answers. Let them reshape your next questions.

**Interview flow:**
- Round 1: Understand the problem and context
- Round 2: Clarify scope and constraints
- Round 3: Define success criteria and deliverables
- Round 4 (if needed): Fill specific gaps

Stop interviewing when you can write the problem statement and success criteria without guessing. If you're still guessing, ask another question.

See `templates/interview-checklist.md` for domain-specific question banks.

### Phase 2: Draft the Spec

Write the specification using `templates/spec.md` as the structure. Every section must be concrete:

- **Problem statement:** One paragraph. What and why. No filler.
- **Success criteria:** Bullet list. Each item is binary (met or not met). No "explore" or "consider."
- **Scope:** What's IN. What's OUT. What's explicitly deferred.
- **Phases:** Each with inputs, research questions, expected outputs, and completion criteria.
- **Deliverable format:** What the final output looks like, down to section headings.

Save the spec as a file in the project directory. This is the contract.

### Phase 3: Gap Check

Read the spec back to the user. Ask them:
- "Is there anything here that would surprise you in the output?"
- "What's the most important section? What could we cut?"
- "If the agent produced exactly this, would you be satisfied?"

Update the spec based on their answers. Repeat until they confirm.

### Phase 4: Handoff

The spec is now ready for execution. It can be:
- Executed immediately in the current session
- Handed to a cron job for overnight execution
- Assigned to a different agent or session

The spec file is the single source of truth. The executing agent reads it, follows it, and writes findings to the deliverable format specified within it.

---

## The Spec as Persistent Memory

This is the idea worth stealing from the original Manus approach: **the filesystem is your working memory.**

```
Context window = RAM (volatile, limited)
Spec file on disk = persistent, unlimited, re-readable
```

During execution:
- **Re-read the spec before starting each phase.** This keeps goals in the agent's recent attention window, preventing drift after many tool calls.
- **Write findings immediately.** Don't accumulate discoveries in context -- write them to the findings file after every 2-3 search operations.
- **Update phase status in the spec.** Mark phases complete. Log blockers. This lets any agent (or human) pick up where execution left off.
- **Log errors in the spec.** Failed searches, dead-end sources, access-denied pages. This prevents the agent from retrying the same thing and builds institutional knowledge for the next run.

---

## Anti-Patterns

### The Premature Start
**Wrong:** User says "research X." Agent immediately starts searching.
**Right:** "Before I research X, let me understand what you need. What decision will this research inform?"

### The Question Dump
**Wrong:** 15 questions in a wall of text. User answers 3, ignores 12.
**Right:** 3-5 targeted questions. Wait. Adjust. Ask more based on answers.

### The Vague Phase
**Wrong:** "Phase 2: Analyze competitors."
**Right:** "Phase 2: For each of the 5 competitors identified in Phase 1, extract pricing tiers, free trial availability, and onboarding time from their websites. Output: comparison table with source URLs."

### The Missing "Done"
**Wrong:** Phases with no completion criteria. How does the agent know when to stop researching?
**Right:** "Phase complete when: company profile table has all 8 fields populated with sourced data, or fields are marked 'not publicly available' after checking 3+ sources."

### The Floating Phase
**Wrong:** Phases that can execute in any order.
**Right:** Each phase explicitly states what it needs from previous phases. "Phase 3 requires the competitor list from Phase 2 and the feature matrix from Phase 1."

### The Infinite Scope
**Wrong:** "Research everything about the AI agent market."
**Right:** "Research the pricing models and target customers of the 5 closest competitors to our white-glove AI setup service in the European market."

### The Solo Interview
**Wrong:** Ask one round of questions, assume you understand, write the spec.
**Right:** Minimum 2 rounds. Often 3. The best insights come from follow-up questions to unexpected answers.

---

## When to Use This Skill

**Use for:**
- Research projects that will run autonomously (overnight cron, background agent)
- Multi-phase work where execution order matters
- Tasks where the user won't be available to answer questions during execution
- Any project where "I'll know it when I see it" needs to become "here's exactly what done looks like"

**Skip for:**
- Simple lookups ("What's Personio's valuation?")
- Single-step tasks that fit in one tool call
- Tasks where the user will be hands-on throughout

---

## Quality Checklist

Before marking the spec complete:

- [ ] **The outsider test:** Could a different agent, with no prior context, execute this spec and produce the right output?
- [ ] **The binary test:** Is every success criterion pass/fail? No "explore" or "consider."
- [ ] **The scope test:** Can you name 3 things explicitly excluded? If not, scope is too vague.
- [ ] **The chain test:** Does each phase consume output from the previous one? Can you trace the data flow?
- [ ] **The format test:** Is the final deliverable format specified down to section headings?
- [ ] **The failure test:** Does the spec say what to do when a source is unavailable or a search returns nothing?
- [ ] **The user test:** Did the user confirm the spec? Not just read it -- confirmed it.

---

## Reference Materials

- **Interview question banks by domain:** `reference.md`
- **Real before/after examples:** `examples.md`
- **Spec template:** `templates/spec.md`
- **Interview checklist:** `templates/interview-checklist.md`
