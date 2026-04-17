# Anti-Hallucination Constraints for Perception Layer

## Problem

Perception layer skills (market-intelligence, competitive-analysis, user-research, data-monitoring) and subagents (market-researcher, competitive-analyst) produce hallucinated data — fake market sizes, non-existent competitor features, fabricated user quotes — because they have no factuality constraints.

## Root Causes (analyzed)

1. **No mandatory search requirement**: Subagents have WebSearch/webReader tools but no instruction to use them before outputting data
2. **No source citation fields**: Output JSON structures have no `sources` or `citations` fields
3. **No "unknown is OK" constraint**: Quality standards demand specific outputs (e.g., "cover market size TAM/SAM/SOM") without allowing "Unknown" when real data isn't found
4. **No confidence ratings**: All data presented as fact with no uncertainty markers
5. **Quality standards lack factuality checks**: Only check output structure, not truthfulness

## Solution: 3-Layer Fix

### Layer 1: Shared Rules File (NEW)

Create `skills/shared/anti-hallucination-rules.md` with 6 core rules:

1. **Mandatory search first**: Must use WebSearch/WebReader before outputting any specific data point
2. **Source required for every claim**: Every number, feature, quote, trend must have a URL source
3. **Unknown is acceptable**: When data cannot be found, output "Unknown" or "Need further research" — never fabricate
4. **Confidence rating per data point**: high/medium/low, with high requiring authoritative source
5. **Timestamp each data point**: Record when data was fetched for freshness tracking
6. **Distinguish fact vs inference**: Clearly label analysis/opinion separate from sourced facts

### Layer 2: Update 4 SKILL.md files

Files: `skills/perception/market-intelligence/SKILL.md`, `skills/perception/competitive-analysis/SKILL.md`, `skills/perception/user-research/SKILL.md`, `skills/perception/data-monitoring/SKILL.md`

Changes per file:
- Add reference to `skills/shared/anti-hallucination-rules.md`
- Add `sources` array to JSON output format
- Add "factuality" to Quality Standards section
- Add confidence + timestamp fields to data structures
- Remove rigid numeric requirements that encourage fabrication (e.g., "5+ key trends" → "Identify real trends found through search")

### Layer 3: Update 2 Subagent Definitions

Files: `agents/perception/market-researcher.md`, `agents/perception/competitive-analyst.md`

Changes per file:
- Add reference to `skills/shared/anti-hallucination-rules.md`
- Insert mandatory search step at top of research/analysis process
- Update output format to include sources, confidence, timestamps
- Update Quality Standards with factuality requirement

## Files to Modify

| File | Action |
|:---|:---|
| `skills/shared/anti-hallucination-rules.md` | CREATE |
| `skills/perception/market-intelligence/SKILL.md` | EDIT |
| `skills/perception/competitive-analysis/SKILL.md` | EDIT |
| `skills/perception/user-research/SKILL.md` | EDIT |
| `skills/perception/data-monitoring/SKILL.md` | EDIT |
| `agents/perception/market-researcher.md` | EDIT |
| `agents/perception/competitive-analyst.md` | EDIT |

## Dependencies

Layer 1 must be created first (shared file). Layers 2-3 can proceed after.
