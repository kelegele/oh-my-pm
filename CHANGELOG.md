# Changelog

All notable changes to Oh-My-PM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0] - 2026-03-12

### Added
- **Complete 5-layer architecture** with all 16 skills + 3 workflows (19 total)

#### Perception Layer (4 skills)
- `market-intelligence` - Market trend analysis and opportunity identification
- `user-research` - User interviews, personas, and user journey mapping
- `data-monitoring` - Product metrics tracking and anomaly detection

#### Strategy Layer (3 skills)
- `product-positioning` - Positioning statements and differentiation strategy
- `roadmap-planning` - Product roadmaps with milestones and timelines
- `prioritization` - RICE/MoSCoW prioritization frameworks

#### Design Layer (2 new skills)
- `prototype-design` - Interactive prototypes and UI flow design
- `process-optimization` - Business process analysis and optimization

#### Delivery Layer (3 skills)
- `requirement-review` - Requirement review meetings and stakeholder alignment
- `project-coordination` - Project tracking, risk management, and status reporting
- `release-management` - Release planning, checklists, and deployment coordination

#### Validation Layer (2 new skills)
- `impact-analysis` - Post-release impact measurement and goal comparison
- `feedback-synthesis` - User feedback aggregation and analysis

#### Workflow Orchestrators (2 new workflows)
- `full-pm-cycle` - Complete product management cycle from research to post-launch
- `feature-launch` - End-to-end feature launch workflow from PRD to analysis

### Changed
- All skills now include: input-from/output-to metadata, mode-support (autopilot/copilot/manual), quality standards, context integration docs
- Updated README.md with complete skill catalog
- Updated CLAUDE.md with current architecture status

### Project Structure
```
skills/
├── perception/ (4)      # market-intelligence, user-research, competitive-analysis, data-monitoring
├── strategy/ (3)        # product-positioning, roadmap-planning, prioritization
├── design/ (3)          # prd-gen, prototype-design, process-optimization
├── delivery/ (3)        # requirement-review, project-coordination, release-management
├── validation/ (3)      # impact-analysis, feedback-synthesis, iteration-planning
└── workflows/ (3)       # full-pm-cycle, feature-launch, quick-prd
```

## [0.1.0] - 2026-03-11

### Added
- Initial MVP release with 4 core Skills
  - `competitive-analysis` - Analyze competitor products
  - `prd-gen` - Generate PRD documents
  - `iteration-planning` - Plan iterations with RICE prioritization
  - `quick-prd` - Workflow combining competitive analysis + PRD generation
- Context file system for skill data sharing
- Test framework (tests/test-skills.sh)
- Testing guide (docs/testing-guide.md)
- Initial CLAUDE.md with project guidance

### Project Structure
```
skills/
├── perception/
│   └── competitive-analysis/SKILL.md
├── design/
│   └── prd-gen/SKILL.md
├── validation/
│   └── iteration-planning/SKILL.md
└── workflows/
    └── quick-prd/SKILL.md

context/
├── competitive-analysis.json
├── iteration-plan.json
├── prd-draft.md
└── ...
```

[Unreleased]: https://github.com/kelegele/oh-my-pm/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/kelegele/oh-my-pm/releases/tag/v0.1.0
