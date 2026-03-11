# Changelog

All notable changes to Oh-My-PM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Issue templates (Bug Report, Feature Request, Skill Improvement)
- Contributing guidelines (CONTRIBUTING.md)
- Project roadmap document (docs/roadmap.md)
- Project board configuration (.github/project-board.json)

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
