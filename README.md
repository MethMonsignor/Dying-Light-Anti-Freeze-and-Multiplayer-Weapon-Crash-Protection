# Dying-Light-Anti-Freeze-and-Multiplayer-Weapon-Crash-Protection
#  Anti-Freeze + Multiplayer Weapon Crash Guard

**Author:** MethMonsignor  
**Purpose:** Detect runtime freezes and sanitize crash-inducing weapons in multiplayer environments for *Dying Light*.

## Features

- Runtime freeze detection and recovery
- Deep weapon validation (damage, mesh, effects, nested fields)
- Executable field stripping (`onUse`, `callback`, `script`, etc.)
- Obfuscated string decoding (hex/base64)
- Remote origin tracing
- Quarantine vault for suspicious weapons
- Lore-integrated alerts and contributor-safe logging

## Usage

Drop the contents of data4 into *DW Folder*.

## Quarantine Vault

Suspicious weapons are isolated in `logs/quarantine_log.txt` for contributor review. This ensures immersive governance without compromising.

## License

This repository is licensed under [MIT License]. All lore, logic, and contributor scaffolds are traceable and ethically governed.

## Credits

Built by MethMonsignor. Every line is legacy-grade.
