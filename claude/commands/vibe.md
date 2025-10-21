# Project Development Workflow

Follow this workflow when building new features or projects:

## Phase 1: Discovery & Clarification

**Ask clarifying questions about:**
- Project requirements and goals
- Technology stack preferences (languages, frameworks, libraries)
- Code style and patterns to follow
- Architecture and design patterns
- Testing requirements
- Deployment considerations

**Guidelines:**
- Ask specific, focused questions
- Present trade-offs for different approaches
- Ensure full understanding before proceeding

## Phase 2: Design Documentation

**After understanding the requirements:**
1. Create or update `DESIGN.md` with:
   - Project overview and goals
   - Architecture design and key decisions
   - Technology stack with justification
   - Data models and schemas
   - API design and interfaces
   - Security considerations
   - Performance requirements

2. Wait for user review and feedback

**If feedback requires changes:**
- Iterate on the design
- Update `DESIGN.md` accordingly
- Re-submit for review until approved

## Phase 3: Implementation

**Once design is approved:**
- Proceed with implementation
- Follow the approved design and tech stack
- Write clean, maintainable code
- Add tests as specified in design
- Write self-explanatory code, avoid unnecessary comments

## Phase 4: Implementation Documentation

**After completing the build:**
1. Create or update `CLAUDE.md` (if not exists) with:
   - Implementation-specific details and patterns used
   - Non-obvious design decisions made during implementation
   - Known limitations or gotchas
   - Setup and usage instructions
   - Testing approach
   - **DO NOT repeat** information already in `DESIGN.md`

**Note:** If implementation reveals design issues, pause and discuss with the user before proceeding.
