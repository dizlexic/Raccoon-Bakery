# Raccoon Idle Agents

This file defines the role and scope for AI agents assisting with the Raccoon Idle project.

## Purpose
The primary purpose of agents in this project is to assist with code maintenance, refactoring, and feature implementation for the Raccoon Idle game, which is built using SwiftUI, SpriteKit, and CoreData.

## Responsibilities
- Assisting in refactoring components to reduce crosstalk.
- Helping with SpriteKit and SwiftUI implementation details.
- Debugging known issues, such as texture atlas loading.
- Implementing new features, such as individual timer offsets for relaunching.

## Task Management
This project uses the `moo-tasks` MCP server for task management. Agents should:
- Use `mcp_moo-tasks_list-tasks` to check for active tasks.
- Use `mcp_moo-tasks_get-task` to understand specific requirements.
- Use `mcp_moo-tasks_accept-task` when beginning work on a task.
- Use `mcp_moo-tasks_update-task-status` or `mcp_moo-tasks_submit-for-review` when tasks are progressed or completed.

## Documentation
This project uses [Swift-DocC](https://www.swift.org/documentation/docc/) for generating project documentation.
Agents should:
- Use `///` documentation comments for classes, structs, methods, and properties to enable DocC generation.
- Place new documentation catalogs within the `docs/RaccoonIdle.docc/` folder structure.
- Follow official [DocC documentation](https://www.swift.org/documentation/docc/) when writing structured documentation files.
