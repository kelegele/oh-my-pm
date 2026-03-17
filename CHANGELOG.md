# Changelog

All notable changes to Oh-My-PM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.1] - 2026-03-13

### Added
- **Commands support** - Registered 3 workflow commands for direct invocation
  - `/quick-prd` - Quick PRD with competitive analysis
  - `/full-pm-cycle` - Complete product management lifecycle
  - `/feature-launch` - Feature launch coordination
  - `/ompm` - Namespace dispatcher for all workflows with help (`/ompm help`)
- **Dual invocation methods** - Both direct (`/workflow-name`) and namespace (`/ompm workflow-name`) calling supported
- `commands/` directory at project root with 4 command files

### Changed
- `plugin.json` - Added `commands` field with command file paths
- README.md - Updated usage section with command examples

## [0.4.0] - 2026-03-13

### Added
- **Figma MCP Integration** - Comprehensive Figma prototype generation from PRD
  - `figma-prototype` skill - Generate Figma prototypes with design reference
  - **Two prototype modes**:
    - **Iteration mode** - Match existing style exactly from UI screenshots/HTML/URL, mark changes (green=new, yellow=modify, red=delete)
    - **New product mode** - Require design reference (component library/style guide/Figma Community)
  - **Token configuration guide** - Step-by-step Figma Personal Access Token setup (90-day expiration)
  - **PRD integration** - Automatically asks user after PRD generation if they need Figma prototype
  - **Workflow integration** - Integrated into `quick-prd`, `prd-gen` with optional Figma step

### Changed
- `prd-gen` (v0.2.1) - Added Figma Integration section with user prompt after PRD generation
- `quick-prd` (v0.2.0) - Added Step 3: Figma Prototype (Optional) to workflow
- `skills.yaml` - Registered `figma-prototype` skill in design layer
- Updated README.md core features table with "Figma 原型集成"

### Design Philosophy
- **No hallucination** - Never generate styles without explicit design reference
- **Style consistency** - Iteration mode strictly follows existing UI patterns
- **Change annotation** - Clear visual marking of modifications (green/yellow/red)

## [Unreleased]

### Fixed
- **Plugin loading issues** - Fixed directory structure and manifest configuration
  - Moved `agents/` from `.claude/agents/` to root directory (plugin resources must be at root)
  - Fixed `plugin.json` author format (changed from string to object)
  - Removed invalid `agents` field from `plugin.json` (agents loaded via agents.yaml, not plugin.json)
  - Added `marketplace.json` for future marketplace distribution
  - Added missing `LICENSE` file

### Lessons Learned

#### Plugin Structure
- **Plugin resource location**: Skills and agents must be in project root, not in `.claude/`
- **plugin.json fields**: `skills` takes directory path, `agents` is not a valid field (use agents.yaml)
- **Author field**: Must be object `{"name": "..."}` not a string

#### Plugin Loading - Critical Discovery
- **`--plugin-dir` does NOT load skills into `/skills` command**:
  - `--plugin-dir` only loads plugin config, NOT skill registration
  - Skills from `--plugin-dir` loaded plugins are NOT callable via `/skill-name`
  - Skills must be in `~/.claude/skills/` to be discovered
- **Solution for local development**: Symlink individual skill directories to `~/.claude/skills/`:
  ```bash
  cd ~/Projects/oh-my-pm/skills
  for dir in */*; do ln -sf "$(pwd)/$dir" ~/.claude/skills/; done
  ```
- **Marketplace vs local plugin**:
  - Marketplace plugins: Skills are automatically registered
  - Local `--plugin-dir` plugins: Skills are NOT automatically registered
  - Symbolic marketplace links: Require registration in `known_marketplaces.json`

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

[Unreleased]: https://github.com/kelegele/oh-my-pm/compare/v0.4.0...HEAD
[0.4.0]: https://github.com/kelegele/oh-my-pm/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/kelegele/oh-my-pm/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/kelegele/oh-my-pm/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/kelegele/oh-my-pm/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/kelegele/oh-my-pm/releases/tag/v0.1.0
## [0.6.0] - 2026-03-17

### Added
- **HTML 原型生成系统** - Three fidelity templates (wireframe/mockup/interactive) with CSS variables
  - `templates/prototype/` directory with template files for different fidelity levels
  - **Enhanced prototype-design skill** (v0.6.0) with HTML generation workflow
  - Format selection and fidelity level support integrated
  - Style configuration system with extracted colors and typography

### Changed
- `prototype-design` (v0.5.0) - Removed Figma references, enhanced with HTML prototype generation
- `quick-prd` (v0.2.0) - Updated to call prototype-design for HTML generation
- `prd-gen` (v0.3.0) - HTML format selection added after PRD generation

### Design Philosophy
- **No external dependencies** - HTML prototypes generated with embedded CSS, no external tool dependencies
- **Template-based generation** - Reusable template system for different fidelity levels
- **Style system** - CSS variable system supports extracted or user-selected styles
- **Progressive fidelity** - Support for wireframe, mockup, and interactive prototypes


## [0.7.0] - 2026-03-17

### Added
- **Pencil MCP 集成** - 专业设计稿生成能力
  - `pencil-design` skill (新增) - 使用 Pencil MCP 生成 .pen 设计文件
  - **关键词更新** - "pencil" 和 "pen" 已添加到 keywords

### Changed
- `prototype-design` (v0.6.0) - 移除 Figma 引用，增强 HTML 生成能力
- `skills.yaml` - 新增 pencil-design skill 注册
- `plugin.json` - 新增 pencil-design skill 到 skills 数组
- `plugin.json` - version 更新到 0.7.0
- `plugin.json` - keywords 添加 pencil/pen

### Design Philosophy
- **专业设计优先** - Pencil 作为可选的高级功能，提供专业级设计能力
- **渐进式集成** - 先实现 HTML 原型（无依赖），再集成 Pencil（需配置）
- **环境检查优先** - Pencil 环境配置作为必需前置，确保可用性

## [0.8.0] - 2026-03-17

### Added
- **Plan-and-Execute 工作流架构** - 统一的工作流架构文档
  - `docs/workflow-architecture.md` - 新增工作流架构规范
  - 定义统一的阶段标识（S0-S5）、状态机和质量门控
  - 五层架构与阶段映射关系
  - 工作流状态追踪字段定义

### Changed
- `quick-prd` (v0.8.0) - 更新为 Plan-and-Execute 模式
  - 添加 5 个阶段定义（S0-S5）
  - 添加阶段门控（Quality Gates）
  - 添加状态追踪字段定义
  - 完善协作模式文档
- `feature-launch` (v0.8.0) - 更新为 Plan-and-Execute 模式
  - 添加 4 个阶段定义（S0-S3）
  - 添加阶段门控和质量标准
  - 添加工作流执行轨迹示例
- `full-pm-cycle` (v0.8.0) - 更新为 Plan-and-Execute 模式
  - 添加 5 个阶段定义（S0-S5）
  - 统一阶段和质量门控格式
  - 添加工作流执行轨迹示例
  - 完善自定义选项（Fast Track/Deep Dive/Parallel）
- `plugin.json` - version 更新到 0.8.0
- `skills.yaml` - 修复文件格式，version 更新到 0.8.0

### Fixed
- `skills.yaml` - 修复损坏的文件格式，重建完整的技能清单

### Design Philosophy
- **统一架构** - 所有工作流采用一致的 Plan-and-Execute 模式
- **阶段化管理** - 每个工作流明确定义阶段、状态和质量门控
- **状态追踪** - 统一的工作流状态字段和执行轨迹记录
- **可扩展性** - 架构支持自定义选项和并行执行

