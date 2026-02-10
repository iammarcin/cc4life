# Examples: Before and After

Real examples showing the difference between a vague request and a spec-driven approach. Every "Before" is something that actually happens. Every "After" is what the interview process produces.

---

## Example 1: Prospect Research

### Before (What the User Says)

> "I need to research Personio before a sales call."

An agent receiving this will Google "Personio," produce a Wikipedia-style company overview, and call it done. The user gets founding year, employee count, funding rounds -- data they could have found in 2 minutes themselves.

### After (What the Interview Surfaces)

**Round 1:**
- "What are you selling them?" -- White-glove AI agent setup service for European executives.
- "Who's the meeting with?" -- Haven't booked it yet. This research is to figure out WHO to approach and HOW.
- "What makes Personio a good prospect?" -- They're a European HR tech unicorn, probably dealing with the exact problems we solve.

**Round 2:**
- "Do you need competitive intelligence on Personio, or intelligence ABOUT Personio for your pitch?" -- About them. I want to know their pain points, who to talk to, and what angle would resonate.
- "What's the deal size?" -- $5-10K initial engagement.
- "Any specific concerns about the approach?" -- They might build internally rather than buy. I need to know if they already have AI capabilities.

**Round 3:**
- "What format works for you?" -- A structured dossier I can skim in 10 minutes before writing the outreach email.
- "What's the single most important output?" -- Personalized approach angles. Not generic -- something that references their specific situation.

### The Spec That Results

```markdown
## Problem Statement
Research Personio to identify the right decision-makers and craft
personalized outreach angles for a $5-10K white-glove AI agent
setup service. The research must surface whether they're building
AI capabilities internally (build vs. buy risk) and identify
pain points that our service addresses.

## Success Criteria
- Identified 3+ decision-makers with roles, backgrounds, and recent activity
- Assessed internal AI maturity (do they already build this themselves?)
- Produced 3+ personalized approach angles, each referencing
  something specific about the prospect (a quote, a product gap,
  a recent announcement)
- All findings sourced to publicly available data

## Scope
- IN: Company profile, key people, tech stack, product analysis,
  competitive position, customer reviews (pain points), recent press
- OUT: Financial modeling, full competitive landscape of HR tech market,
  product demo analysis

## Phases
### Phase 1: Company Discovery
Research questions: What does Personio do? Size, funding, valuation?
Key leadership? Tech stack? Social presence?
Output: Company profile table + key people table
Completion: Profile table has 8+ fields populated

### Phase 2: Deep Data Collection
Inputs: Company profile from Phase 1
Research questions: Pricing model? Product features? Blog themes?
Recent press (last 12 months)? Customer review sentiment?
Output: Product analysis + press timeline + review summary
Completion: At least 3 review sources checked, press timeline has 5+ entries

### Phase 3: Strategic Analysis
Inputs: Product data from Phase 2, company context from Phase 1
Research questions: Market position vs. direct competitors?
Key strengths and weaknesses? AI capabilities (internal)?
Internal build vs. buy signals?
Output: Competitive positioning + SWOT + AI maturity assessment
Completion: Strengths and weaknesses each have 3+ items with sources

### Phase 4: Decision-Maker Profiling
Inputs: Key people from Phase 1
Research questions: What do they post about? What events do they
speak at? What topics would they respond to? Shared connections?
Output: Decision-maker profiles (3+) with engagement hooks
Completion: Each profile has recent activity (last 6 months) documented

### Phase 5: Executive Summary
Inputs: All previous phases
Output: Key findings summary, 3+ approach angles (each personalized
with specific references), talking points, risk factors
Completion: Each approach angle references a specific, verifiable
piece of information from the research

## Deliverable Format
Structured markdown report:
- Stage 1: Company profile + key people tables
- Stage 2: Product analysis + press timeline + reviews
- Stage 3: Competitive positioning + strengths/weaknesses
- Stage 4: Decision-maker profiles with engagement hooks
- Stage 5: Executive summary + approach angles + talking points + risks
- Footer: Data sources list
```

### What Changed

The vague "research Personio" became a 5-phase spec with explicit outputs. The agent now knows:
- It needs approach angles, not just facts
- It must assess AI maturity (build vs. buy risk)
- Decision-maker profiles need recent activity, not just titles
- Each approach angle must reference something specific and verifiable
- The deliverable format is defined down to section headings

---

## Example 2: Marketing Research

### Before (What the User Says)

> "Create a marketing playbook for my AI setup service."

This produces a generic "Content Marketing 101" guide with social media tips, blog post ideas, and vague advice about SEO. Nothing actionable. Nothing specific to the actual service.

### After (What the Interview Surfaces)

**Round 1:**
- "What's the service?" -- White-glove AI agent setup for European executives. $5-10K. We deploy autonomous workflows (prospect research, competitive intelligence, content automation) on managed infrastructure.
- "What marketing have you tried?" -- Nothing systematic. Some BMS community posts. Want to start properly.
- "Who's the customer?" -- European executives at SMBs (50-500 people). Not technical. They want outcomes, not tools.

**Round 2:**
- "Do you need strategy or execution? (A plan, or actual copy to publish?)" -- Both. Strategy first, then concrete assets.
- "What's the competitive landscape for this service?" -- Unknown. That's part of what I need researched.
- "What's the biggest obstacle right now?" -- Nobody knows this service exists. No brand awareness. Zero inbound.

**Round 3:**
- "What channels do you have access to right now?" -- LinkedIn, BMS community, personal network. No ad budget yet (testing $100 on Facebook).
- "What's the first piece of content you'd publish from this research?" -- A LinkedIn post that positions us clearly.
- "Is there a brand voice?" -- Confident authority. European sophistication. Not Silicon Valley hype.

### The Spec That Results

```markdown
## Problem Statement
Research and design a marketing playbook for a white-glove AI agent
setup service targeting European SMB executives ($5-10K engagements).
Must include competitive landscape analysis, customer language
extraction, positioning strategy, content pillars, and concrete
first-week actions.

## Success Criteria
- Competitive landscape mapped with at least 5 competitors,
  their positioning, pricing, and gap analysis
- Customer language captured verbatim from forums, reviews,
  and social media (minimum 8 real quotes)
- 3+ positioning angles developed with anti-positioning statements
- Content strategy with keyword clusters (high-intent, mid-funnel,
  top-funnel) and content pillars
- Actionable first-week recommendations (specific, executable)

## Scope
- IN: Competitor analysis, customer language, positioning, content
  strategy, keyword clusters, copy concepts, landing page headlines
- OUT: Full SEO audit, brand identity design, social media calendar,
  paid advertising strategy (beyond the $100 test)
- DEFERRED: Email nurture sequences, case study production, video scripts

## Phases
### Phase 1: Market Landscape
Research questions: Who else offers "white-glove AI setup"?
What do they charge? What's their positioning? What market gaps
exist in Europe specifically?
Output: Competitor table (5+) with pricing, positioning, gap analysis
Completion: 3 competitive tiers identified with representative players

### Phase 2: Customer Language
Research questions: What do target customers say about AI tools
in forums (Reddit, Twitter, communities)? What frustrations do
they express? What exact phrases do they use?
Output: Pain points list with verbatim quotes and sources
Completion: 8+ real quotes captured with attribution

### Phase 3: Positioning & Voice
Inputs: Gaps from Phase 1, language from Phase 2
Research questions: What positioning angles leverage identified gaps?
What's the anti-positioning? What voice profile matches the
"European sophistication" brand direction?
Output: Positioning angles, anti-positioning statements, voice guide
Completion: 3+ angles developed, each connecting gap to customer pain

### Phase 4: Content Strategy
Inputs: Customer language from Phase 2, positioning from Phase 3
Research questions: What keywords would this audience search?
What content formats work for European executives? What content
pillars create sustained authority?
Output: Keyword clusters, content pillars, quick-win topics
Completion: Keywords organized by funnel stage, pillars connected to positioning

### Phase 5: Expert Assessment
Inputs: All previous phases
Output: Strengths/risks analysis of the overall strategy,
recommended first 3 actions (this week), copy concepts for
LinkedIn post and landing page
Completion: Each recommendation is specific and executable
within 7 days without additional research
```

### What Changed

"Create a marketing playbook" became research with teeth. The spec ensures:
- Competitive analysis uses real data, not assumptions
- Customer language is captured verbatim (exact quotes from real forums)
- Positioning connects gaps to customer pain points (not just clever slogans)
- Content strategy is organized by funnel stage with specific keywords
- First actions are executable this week, not "sometime"

---

## Example 3: Technical Research (Short)

### Before

> "Research the best approach for building autonomous cron workflows."

### After (Interview Summary)

The user clarified: they need to evaluate 3 specific architectures for running AI agents on a schedule, compare them against their constraints (ARM64 hardware, Node.js stack, <$50/month budget), and recommend one with implementation guidance.

### Key Spec Differences

```
BEFORE (what the agent would do):
- Search "autonomous cron workflows"
- Produce a general comparison of cron tools
- Maybe mention Kubernetes, Airflow, systemd timers
- No recommendation

AFTER (what the spec mandates):
Phase 1: Document current constraints (hardware, stack, budget, existing infra)
Phase 2: Research option A (systemd timers + Node.js) against criteria
Phase 3: Research option B (custom scheduler in-process) against criteria
Phase 4: Research option C (external orchestrator) against criteria
Phase 5: Comparative matrix + recommendation with reasoning
Completion: Recommendation includes estimated implementation time
           and identifies the top risk for the chosen approach
```

---

## Example 4: The Interview in Action (Transcript)

Showing the actual flow of a discovery interview, not just the result.

### User Opens With

> "I want to research what our competitors are doing with AI."

### Round 1 (Understanding the Problem)

**Agent:** Three questions before we start:

1. What's your product/service? I need to know what "competitor" means in your context.
2. What triggered this research? Something specific happen, or is this proactive?
3. When you say "what they're doing with AI" -- do you mean their products, their internal operations, or their marketing?

**User:** We sell HR software for European SMBs. I saw that HiBob just launched an AI feature and panicked. I want to know what everyone is doing so I'm not caught off guard again. Mainly their products -- what AI features they're shipping.

### Round 2 (Scoping)

**Agent:** Got it -- competitive AI feature tracking, triggered by HiBob. Two more:

1. Who are your top 5 competitors? Or should I identify them as part of the research?
2. How deep do you want this? Surface-level feature list, or including things like how they're positioning AI, pricing changes, customer reception?

**User:** Top competitors: HiBob, BambooHR, Factorial, SAP SuccessFactors, Workday. But honestly, Workday and SAP are enterprise -- maybe focus on the first three plus anyone else I'm missing in the mid-market. Deep enough to understand what's real vs. marketing hype. Customer reception would be great -- what are users actually saying about these features?

### Round 3 (Defining Done)

**Agent:** Clear picture forming. Final round:

1. What will you DO with this research? Internal strategy doc? Board presentation? Product roadmap input?
2. Is this a one-time snapshot, or do you want a repeatable process? (We could set this up as a weekly or monthly monitor.)
3. What would make this research perfect vs. merely adequate?

**User:** Product roadmap input. My CPO needs this for next quarter's planning. One-time for now, but if it's good, we'd want it monthly. Perfect would be: a comparison matrix of AI features across competitors, with customer sentiment for each feature, and a "gaps we should worry about" section.

### What the Agent Now Knows

- **Decision:** Product roadmap planning for next quarter
- **Audience:** User + CPO
- **Competitors:** HiBob, BambooHR, Factorial (primary), plus mid-market discovery
- **Depth:** Feature-level with customer reception data
- **Output:** Comparison matrix + sentiment + gap analysis
- **Format:** Internal strategy document
- **Potential recurring:** Monthly competitive intelligence digest

The spec writes itself from here. Every phase connects to a specific need that was surfaced through the interview.

---

## The Common Pattern

Across all examples, notice what the interview changes:

| Dimension | Before Interview | After Interview |
|-----------|-----------------|-----------------|
| Problem | Vague topic | Specific decision |
| Scope | Everything about X | These 5 things about X |
| Depth | Surface (cover everything) | Deep (cover less, better) |
| Output | "Research findings" | Defined format with sections |
| Done | "When it feels complete" | Binary criteria |
| Audience | Assumed (just the user) | Identified (user + CPO, board, etc.) |
| Action | None specified | Specific next steps |

The interview doesn't just gather requirements. It transforms the project from something vague into something executable.
