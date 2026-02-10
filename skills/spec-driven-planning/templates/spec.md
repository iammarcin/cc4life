# Specification: [Project Name]

*Created: [DATE]*
*Status: Draft | Confirmed | In Progress | Complete*

---

## Problem Statement

[One paragraph. What problem does this research solve, and why does it matter now? Not the topic -- the decision it informs.]

## Success Criteria

[Each criterion is binary -- met or not met. No "explore" or "consider."]

- [ ] [Specific, measurable outcome]
- [ ] [Specific, measurable outcome]
- [ ] [Specific, measurable outcome]
- [ ] [Specific, measurable outcome]

## Scope

### In Scope
- [Specific area of research]
- [Specific area of research]
- [Specific area of research]

### Out of Scope
- [Explicitly excluded -- and why]
- [Explicitly excluded -- and why]

### Deferred
- [Could do later, not now -- and what would trigger it]

## Context

[Background the executing agent needs. Who is the user? What's the business? What's already known? What failed before? This section prevents the agent from re-discovering information the user already has.]

---

## Phases

### Phase 1: [Name]

**Objective:** [One sentence -- what this phase accomplishes]

**Inputs:** [What this phase needs. For Phase 1, usually just the problem statement. For later phases, outputs from earlier phases.]

**Research Questions:**
1. [Specific question to answer]
2. [Specific question to answer]
3. [Specific question to answer]

**Expected Output:** [What gets written at the end of this phase -- be specific about format]

**Completion Criteria:** [How the agent knows this phase is done. Binary.]

---

### Phase 2: [Name]

**Objective:** [One sentence]

**Inputs:** [Explicitly reference Phase 1 outputs needed]

**Research Questions:**
1. [Specific question]
2. [Specific question]
3. [Specific question]

**Expected Output:** [Format description]

**Completion Criteria:** [Binary check]

---

### Phase 3: [Name]

**Objective:** [One sentence]

**Inputs:** [Explicitly reference previous phase outputs needed]

**Research Questions:**
1. [Specific question]
2. [Specific question]
3. [Specific question]

**Expected Output:** [Format description]

**Completion Criteria:** [Binary check]

---

### Phase 4: [Name] (Synthesis)

**Objective:** [One sentence -- typically "synthesize findings into deliverable"]

**Inputs:** [All previous phase outputs]

**Research Questions:**
1. [Synthesis question -- what patterns emerge?]
2. [Recommendation question -- what should the user do?]
3. [Gap question -- where is the data thin?]

**Expected Output:** [Final deliverable format -- specify section headings]

**Completion Criteria:** [Binary check -- typically "all success criteria met"]

---

## Deliverable Format

[Describe the final output structure. Include section headings, table formats, expected length. The executing agent should be able to create the output file structure from this section alone.]

```
## Executive Summary
- Key findings (3-5 bullets)
- Recommended action
- Confidence assessment

## [Section matching Phase 1 output]

## [Section matching Phase 2 output]

## [Section matching Phase 3 output]

## Recommended Actions
- Top 3 specific, executable actions

## Sources
- [All sources cited]
```

---

## Error Handling

**Source unavailable:** [What to do -- fallback sources, or mark as unavailable with sources checked]

**Insufficient data:** [Minimum acceptable threshold for each phase]

**Scope creep:** [Boundary check -- what to do when research surfaces something interesting but out of scope]

---

## Execution Notes

- **Re-read this spec before starting each phase.** Goals drift after many tool calls.
- **Write findings to the deliverable file after every 2-3 searches.** Don't accumulate in context.
- **Update phase status here as you progress.** Mark complete, log blockers.
- **Log errors here.** Failed sources, dead ends, access-denied pages. This prevents retrying the same thing.

### Phase Status Tracker

| Phase | Status | Notes |
|-------|--------|-------|
| Phase 1 | pending | |
| Phase 2 | pending | |
| Phase 3 | pending | |
| Phase 4 | pending | |

### Error Log

| Phase | Error | Resolution |
|-------|-------|------------|
| | | |
