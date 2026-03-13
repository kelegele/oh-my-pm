---
description: 编排从 PRD 到上线后分析的完整功能发布工作流
category: product-management
argument-hint: "<feature name> [launch-date]"
---

# Feature Launch Workflow

Ship features successfully from PRD to post-launch analysis.

## What This Does

Orchestrates the end-to-end feature launch:
- **Stage 1 (Design)**: PRD finalization, prototype validation
- **Stage 2 (Prepare)**: Requirement review, project planning
- **Stage 3 (Release)**: Release management and deployment
- **Stage 4 (Validate)**: Impact analysis, feedback synthesis

## Usage

- `/feature-launch "user onboarding flow"`
- `/ompm feature-launch "checkout redesign" 2024-04-15`

## Execution

This command activates the `feature-launch` workflow skill.

Your input: $ARGUMENTS
