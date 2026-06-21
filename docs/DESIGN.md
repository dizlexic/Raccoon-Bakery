# Raccoon Idle Design Guidelines

## Purpose
Bridge design and development to reduce hardcoding, improve UI consistency, and streamline implementation.

## 1. Centralized Design Tokens
- Create `DesignTokens.swift` to house all visual constants (colors, fonts, sizes).
- NEVER hardcode UI values in views.

## 2. Standardized Asset Naming
- Use `lowercase_snake_case`.
- Prefixes: `ui_`, `char_`, `icon_`, `bg_`.

## 3. Component-Based UI Structure
- Inherit from `UIComponent` (standardized init, z-positioning).
- Use configuration objects, not individual parameters.

## 4. Layout & Scaling
- Use `safeAreaLayoutGuide`.
- Relative positioning only; no absolute coordinates.
- Consistent aspect-ratio-aware scaling.

## 5. Data-Driven UI
- Decouple design from game logic using JSON/Swift `Codable` structs.
- Factories should fetch config from centralized repositories.

---
## Tasks to implement these guidelines:
- Create `DesignTokens` configuration file
- Refactor `UpgradeDetails` to use centralized `DesignTokens`
- Standardize asset naming and update project texture loading
