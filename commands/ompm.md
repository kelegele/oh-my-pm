---
description: Oh-My-PM product management workflow namespace
category: product-management
argument-hint: "<workflow> [args...] | help | ?"
---

# Oh-My-PM Workflow Dispatcher

Product management workflow namespace for oh-my-pm.

## Your Input

$ARGUMENTS

## Help Detection

**If first argument is "help" or "?", display the following help:**

---

# Oh-My-PM Commands Help

## Available Workflows

| Command | Description | Usage Example |
|:--------|:-------------|:--------------|
| `quick-prd` | PRD with competitive analysis | `/ompm quick-prd "用户改版" 淘宝 京东` |
| `full-pm-cycle` | Complete product lifecycle (0-1) | `/ompm full-pm-cycle "新项目管理工具"` |
| `feature-launch` | Feature launch coordination | `/ompm feature-launch "注册流程"` |

## Direct Commands (without /ompm prefix)

| Command | Description |
|:--------|:-------------|
| `/quick-prd` | Same as `/ompm quick-prd` |
| `/full-pm-cycle` | Same as `/ompm full-pm-cycle` |
| `/feature-launch` | Same as `/ompm feature-launch` |

## Help

- `/ompm help` - Show this help message
- `/ompm ?` - Show this help message

---

## Dispatch (for non-help arguments)

First argument = workflow name, remaining = workflow arguments.
