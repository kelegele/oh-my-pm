# Changelog

All notable changes to Oh-My-PM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Project README.md with comprehensive documentation
- Scenario-based PRD generation (iteration/new-feature/new-product)
- Industry benchmark checking (user-specified + agent search)
- UI state collection for iteration updates (screenshot/HTML/URL)
- Context requirements per scenario in YAML frontmatter

### Changed
- `prd-gen` skill v0.1.0 → v0.2.0: Added scenario detection and context collection
- `quick-prd` workflow v0.1.0 → v0.2.0: Added scenario detection as Step 0

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
