# Reference: Interview Patterns and Spec Design

Deep reference for designing interviews and structuring specifications. Read this when you need guidance beyond what SKILL.md covers.

---

## The Interview Framework

### The Three Questions That Matter Most

Every interview, regardless of domain, must answer:

1. **"What decision does this inform?"** -- Research without a decision context produces encyclopedia entries. Research with a decision context produces actionable intelligence.

2. **"What would make this worthless?"** -- The anti-requirements reveal more than the requirements. "Don't give me a 50-page literature review" tells you more about the desired output than "I want research on X."

3. **"Who reads this besides you?"** -- A spec for the user's eyes only is different from one shared with a board, a team, or a client. The audience shapes the depth, format, and language.

### Interview Dynamics

**Pacing:** 3-5 questions per round. More than 5 overwhelms. Fewer than 3 wastes a round.

**Sequencing:** Start broad (problem, context, decision), narrow down (scope, constraints, format), then fill gaps (specific data needs, sources, edge cases).

**Listening signals:** When the user gives a long, detailed answer, they care deeply about that aspect -- probe further. When they give a terse answer, they either don't care or haven't thought about it. Ask which.

**The redirect:** If the user starts describing the solution ("I need 5 phases, each covering..."), gently redirect to the problem. "That's a good structure. Before we lock it in, what problem are we solving? The right structure falls out of the problem definition."

**Knowing when to stop:** You're done interviewing when you can write the problem statement, success criteria, and scope boundaries without guessing. If you catch yourself writing "probably" or "likely" in the spec, you need another question.

---

## Question Banks by Domain

### Prospect Research / Sales Intelligence

**Context questions:**
- What's the sales motion? (Outbound cold, warm referral, inbound qualification, strategic account?)
- What stage is this prospect in your pipeline? (Brand new, had one call, near close?)
- What's your product/service, in one sentence?
- What's the typical deal size? (This determines research depth)

**Scope questions:**
- Which decision-makers do you need profiles on? (C-suite only? VP-level? Technical buyers?)
- Do you need competitive positioning? (How your prospect's alternatives compare to you)
- Is there a specific objection you're trying to pre-empt?
- What's the timeline? (Call tomorrow? Prep for a conference next month?)

**Output questions:**
- What format works? (Structured report, talking points, email draft, executive briefing?)
- What's the single most important thing to know before the call?
- Do you need approach angles or just raw intelligence?

### Market Research / Competitive Analysis

**Context questions:**
- What market are you in or entering? (Define the boundaries)
- Are you evaluating whether to enter, or already in and optimizing?
- What's your current position? (Leader, challenger, new entrant, niche?)
- Is this for a specific decision? (Pricing change, new feature, market expansion, fundraising deck?)

**Scope questions:**
- How many competitors should we analyze? (Top 3? All known? Only direct?)
- What dimensions matter? (Pricing, features, positioning, team, funding, tech stack?)
- Geography? (Global, European, specific country?)
- Time horizon? (Current snapshot or trend over 12 months?)

**Output questions:**
- Do you need a recommendation or just the data?
- Will this be presented to anyone? (Shapes the format)
- What existing competitive knowledge do you already have? (Avoid duplicating)

### Content Strategy / Marketing Research

**Context questions:**
- What are you marketing? (Product, service, personal brand, company?)
- Who's the target audience? (Be specific: job titles, company sizes, pain points)
- What channels are you active on? (LinkedIn, blog, newsletter, Twitter, paid?)
- What content exists already? (We should extend, not duplicate)

**Scope questions:**
- Are we researching what to say or how to say it? (Positioning vs. voice)
- Do you need customer language? (Exact phrases from forums, reviews, social?)
- Competitor content analysis? (What's working for them?)
- Keyword research? (SEO-focused or awareness-focused?)

**Output questions:**
- What's the first piece of content you'll create from this research?
- Do you need copy concepts or just strategic direction?
- Is there a brand voice guide to follow?

### Technical Research / Architecture Decisions

**Context questions:**
- What problem are you solving technically? (Not the tool, the problem)
- What's the current stack? (We need to know constraints)
- What's the team size and skill set? (Shapes what's feasible)
- Is this greenfield or migration? (Changes the risk profile)

**Scope questions:**
- How many options should we evaluate? (2-3 focused or broad survey?)
- What criteria matter? (Performance, cost, learning curve, community, enterprise support?)
- Are there non-negotiables? (Must be open source, must run on ARM, must support X?)
- What's the decision timeline?

**Output questions:**
- Who makes the final decision? (Just you, or a team/committee?)
- Do you need a recommendation with reasoning, or a neutral comparison?
- Will this be a one-time decision or something we revisit?

### General Research / Analysis

**Context questions:**
- What triggered this research? (Something happened -- what?)
- What do you already know about this topic? (Starting point)
- What have you tried before? (Previous approaches, what worked/didn't)

**Scope questions:**
- What's the time boundary? (Last 6 months? Historical? Forward-looking?)
- Geographic scope?
- Depth vs. breadth preference? (One topic deeply or many topics surveyed?)
- Source preferences? (Academic, industry, social media, primary data?)

**Output questions:**
- What format serves you best?
- What's the single question this research must answer?
- When do you need it?

---

## Spec Design Patterns

### Pattern 1: The Funnel

Start broad, narrow each phase. Good for prospect dossiers and market research.

```
Phase 1: Cast a wide net (discover all relevant entities)
Phase 2: Filter to the most relevant (apply criteria)
Phase 3: Deep-dive on the filtered set
Phase 4: Synthesize and recommend
```

**Example:** Prospect Dossier
- Phase 1: Discover company profile, people, tech stack, social presence
- Phase 2: Scrape product details, pricing, blog, press, reviews
- Phase 3: Analyze competitive position, strengths, weaknesses, sentiment
- Phase 4: Profile decision-makers, create approach angles
- Phase 5: Synthesize executive summary with talking points

### Pattern 2: The Parallel Tracks

Multiple independent research threads that converge in a synthesis phase. Good for multi-dimensional analysis.

```
Phase 1: Track A research (market)
Phase 2: Track B research (competitors)
Phase 3: Track C research (customers)
Phase 4: Converge — synthesize across tracks
```

**Example:** Vibe Marketing Playbook
- Phase 1: Market landscape (size, growth, competitive segments, pricing gaps)
- Phase 2: Customer language (forums, reviews, social -- exact phrases)
- Phase 3: Positioning and voice (angles, anti-positioning, differentiation)
- Phase 4: Content strategy (keywords, pillars, quick wins)
- Phase 5: Expert assessment (strengths, risks, recommended first actions)

### Pattern 3: The Iterative Drill

Go deep on one thing, then use findings to direct the next drill. Good for investigative research.

```
Phase 1: Initial exploration (what's out there?)
Phase 2: Follow the strongest lead
Phase 3: Follow the next strongest lead
Phase 4: Connect the threads
```

### Pattern 4: The Comparative

Evaluate N options against fixed criteria. Good for technology evaluations and vendor selection.

```
Phase 1: Define evaluation criteria (from interview)
Phase 2: Research option A against criteria
Phase 3: Research option B against criteria
Phase 4: Research option C against criteria
Phase 5: Comparative matrix + recommendation
```

---

## Phase Design Rules

### Every Phase Needs Five Things

1. **Objective:** One sentence. What this phase accomplishes.
2. **Inputs:** What it needs from previous phases (or from the user).
3. **Research questions:** The specific questions this phase answers (3-7 per phase).
4. **Expected output:** What gets written to the deliverable at the end of this phase.
5. **Completion criteria:** How the agent knows this phase is done. Binary. No "feels complete."

### Phase Sizing

**Too small:** A phase that takes 1-2 tool calls. Combine with adjacent phases.

**Right-sized:** A phase that takes 5-15 tool calls. Meaningful chunk of work with clear output.

**Too large:** A phase that takes 30+ tool calls. Break into sub-phases with intermediate outputs.

**Rule of thumb:** 3-7 phases for most research projects. More than 7 usually means phases need consolidation. Fewer than 3 means the project is simple enough to skip the spec.

### Dependency Declarations

Make dependencies explicit. Don't assume the executing agent will figure out the order.

**Weak:** "Phase 3: Analyze competitors"
**Strong:** "Phase 3: Using the competitor list from Phase 2 (minimum 3, maximum 7 companies), analyze each against the criteria defined in the scope section."

---

## Error Handling in Specs

### Source Failures

Specs should anticipate that sources will be unavailable. Include fallback instructions:

```
Phase 2: Extract pricing from competitor websites.
- Primary: Check pricing page directly
- Fallback: Check G2/Capterra for reported pricing
- Fallback: Check recent articles/reviews mentioning pricing
- If no pricing found: Mark as "Pricing: Not publicly available (checked: website, G2, Capterra, recent press)"
```

### Insufficient Data

Specs should say what "good enough" looks like:

```
Completion criteria: Company profile table has at least 6 of 8 fields populated.
Fields that cannot be found after checking 3 sources should be marked
"Not publicly available" with sources checked listed.
```

### Scope Creep During Execution

Specs should include a scope boundary check:

```
SCOPE BOUNDARY: This research covers only European competitors with
fewer than 500 employees. If execution surfaces a relevant competitor
outside these boundaries, note it in an appendix but do not research
it in depth.
```

---

## Deliverable Format Design

### The Executive Summary Pattern

Every research deliverable should lead with an executive summary. Not a table of contents -- a summary of findings that stands alone.

**Components:**
- Key findings (3-5 bullets, each one sentence)
- Recommended action (what the user should do with this)
- Confidence level (where is the data strong vs. thin?)

### The Evidence Pattern

Every claim links to its source. Not for academic rigor -- for trust. The user needs to know which findings are well-sourced and which are thin.

```
| Finding | Source | Confidence |
|---------|--------|------------|
| Revenue: $435M | Crunchbase, press release | High |
| Employee count: ~2,050 | LinkedIn, company page | Medium |
| Customer satisfaction: 4.3/5 | G2 (200+ reviews) | High |
| Pricing: ~$5-10/employee/mo | Inferred from comparisons | Low |
```

### The Action Items Pattern

Research that doesn't end with "here's what to do" gets filed and forgotten. Every spec should include a deliverable section for recommended next steps.

```
## Recommended Actions (Top 3)
1. [Specific action] -- [Why, based on finding X]
2. [Specific action] -- [Why, based on finding Y]
3. [Specific action] -- [Why, based on finding Z]
```

---

## Common Spec Mistakes

### The Boil-the-Ocean Spec
Tries to answer every possible question. Result: 20 pages of thin research instead of 5 pages of useful research. Fix: force the user to name the top 3 questions. Everything else goes in "explicitly out of scope."

### The Copy-Paste Spec
Uses the template verbatim without adapting to the specific project. The template is a starting point, not a fill-in-the-blanks form. Every spec should feel custom.

### The No-Format Spec
Describes what to research but not what the output looks like. The executing agent invents a format, and it's usually not what the user wanted. Fix: include section headings for the final deliverable directly in the spec.

### The Assumption-Heavy Spec
Contains phrases like "the agent should know to..." or "obviously include..." Nothing is obvious to an agent reading the spec cold. If it matters, write it explicitly.

### The One-Shot Spec
Written after a single round of questions. Almost always missing something. Fix: minimum 2 interview rounds, ideally 3.
