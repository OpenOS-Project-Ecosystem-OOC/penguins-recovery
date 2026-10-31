[update-readmes]   Mode: rewrite — migrating to template structure...
# penguins-recovery

[![AI agent ready](https://img.shields.io/badge/AI_agent-ready-2ea44f?style=flat-square)](https://github.com/Interested-Deving-1896/fork-sync-all/blob/main/DOCS/ai-agent-badges.md)
[![Open in Codex](https://img.shields.io/badge/Open_in-Codex-000000?style=flat-square&logo=openai&logoColor=white)](https://chatgpt.com/codex)
[![Open in Claude Code](https://img.shields.io/badge/Open_in-Claude_Code-d97757?style=flat-square&logo=anthropic&logoColor=white)](https://claude.ai/code)
[![Open in GitHub Copilot](https://img.shields.io/badge/Open_in-GitHub_Copilot-181717?style=flat-square&logo=githubcopilot&logoColor=white)](https://github.com/copilot)
[![Open in Cursor](https://img.shields.io/badge/Open_in-Cursor-111111?style=flat-square)](https://cursor.com/agents)
[![Use with Gemini CLI](https://img.shields.io/badge/Use_with-Gemini_CLI-4285f4?style=flat-square&logo=googlegemini&logoColor=white)](https://github.com/google-gemini/gemini-cli)
[![KDE Eco](https://img.shields.io/badge/KDE%20Eco-certified-brightgreen?logo=kde&logoColor=white&style=flat-square)](https://eco.kde.org/) [![Blue Angel](https://img.shields.io/badge/Blue%20Angel-DE--UZ%20215-0055a4?style=flat-square)](https://www.blauer-engel.de/en/certification/criteria)




<!-- AI:start:what-it-does -->
This project provides a unified Linux system recovery toolkit designed for system administrators and advanced users. It addresses the need for creating modular, customizable recovery environments by supporting pluggable builders for Debian, Arch, and Unified Kernel Images (UKI). The toolkit integrates with penguins-eggs and includes utilities for bootloader packaging, secure boot signing, and filesystem recovery.
<!-- AI:end:what-it-does -->

## Architecture

<!-- AI:start:architecture -->
The project uses a modular architecture to build Linux system recovery toolkits. Key components include pluggable builders for Debian, Arch, and Unified Kernel Images (UKI), as well as integration with penguins-eggs for system recovery. Builders are standalone scripts or tools located in the `builders/` directory, each responsible for creating specific recovery artifacts. The `Makefile` orchestrates these builders and provides targets for building, packaging, and verifying recovery images. The `gui/` directory contains the QML-based graphical interface, while `common/` and `tools/` house shared utilities and scripts. Integration tasks and workflows are managed via GitHub Actions in the `.github/` directory.

Directory structure:
```plaintext
.
├── .github/               # CI/CD workflows
├── adapters/              # System-specific adapters
├── bin/                   # Executable scripts
├── bootloaders/           # Bootloader packaging and source
├── builders/              # Pluggable recovery builders
│   ├── debian/            # Debian-based ISO builder
│   ├── arch/              # Arch-based ISO builder
│   ├── uki/               # UKI builder
│   ├── uki-lite/          # Lightweight UKI builder
│   ├── verity-uki/        # Verified UKI builder
├── common/                # Shared utilities
├── gui/                   # QML-based graphical interface
├── recovery-manager/      # Recovery management tools
├── scripts/               # Helper scripts
├── tests/                 # Test cases
├── tools/                 # Additional tools
├── LICENSE                # License file
├── Makefile               # Build orchestration
└── README.md              # Project documentation
```
<!-- AI:end:architecture -->

## Install

<!-- Add installation instructions here. This section is yours — the AI will not modify it. -->

```bash
git clone https://github.com/Interested-Deving-1896/penguins-recovery.git
cd penguins-recovery
```

## Usage

<!-- Add usage examples here. This section is yours — the AI will not modify it. -->

## Configuration

<!-- Document configuration options here. This section is yours — the AI will not modify it. -->

## CI

<!-- AI:start:ci -->
The repository uses GitHub Actions for continuous integration and automation. Below are the workflows and their functions:

- **bootloaders-upstream-sync.yaml**: Synchronizes bootloader sources from upstream repositories. No secrets required.
- **mirror-osp-to-ooc.yaml**: Mirrors the repository from the open-source platform (OSP) to an organizational open-source copy (OOC). Requires `OOC_REPO_TOKEN` secret for authentication.
- **trigger-artifact-mirror.yml**: Triggers artifact mirroring to external storage or repositories. Requires `ARTIFACT_STORAGE_KEY` and `ARTIFACT_STORAGE_SECRET` secrets for access.

All workflows are located in the `.github/workflows` directory. Ensure required secrets are configured in the repository settings for workflows to function correctly.
<!-- AI:end:ci -->

## Mirror chain

<!-- AI:start:mirror-chain -->
This repo is maintained in [`Interested-Deving-1896/penguins-recovery`](https://github.com/Interested-Deving-1896/penguins-recovery) and mirrored through:

```
Interested-Deving-1896/penguins-recovery  ──►  OpenOS-Project-OSP/penguins-recovery  ──►  OpenOS-Project-Ecosystem-OOC/penguins-recovery
```

Changes flow downstream automatically via the hourly mirror chain in
[`fork-sync-all`](https://github.com/Interested-Deving-1896/fork-sync-all).
Direct commits to OSP or OOC are detected and opened as PRs back to `Interested-Deving-1896`.
<!-- AI:end:mirror-chain -->

## Contributors

<!-- AI:start:contributors -->
| Contributor | Commits |
|---|---|
| [@Interested-Deving-1896](https://github.com/Interested-Deving-1896) | 224 |
| [@github-actions[bot]](https://github.com/apps/github-actions) | 8 |
| [@ona-agent](https://github.com/ona-agent) | 1 |
<!-- AI:end:contributors -->

## Origins

<!-- AI:start:origins -->
_Original project — no upstream influences recorded._
<!-- AI:end:origins -->

## Resources

<!-- AI:start:resources -->
_No additional resource files found._
<!-- AI:end:resources -->

## Accessibility

<!-- AI:start:accessibility -->
This repo uses automated accessibility auditing via `check-accessibility.yml`.

Checks include: CODEOWNERS ownership coverage, README screen-reader compatibility,
WCAG 2.1 AA HTML compliance, audio overview (espeak-ng), and Braille output (liblouis).




Run the [Check Accessibility](https://github.com/Interested-Deving-1896/penguins-recovery/actions/workflows/check-accessibility.yml)
workflow to generate the first report and accessibility artifacts.
See the [W3C Web Content Accessibility Guidelines (WCAG)](https://www.w3.org/WAI/standards-guidelines/wcag/)
for the underlying accessibility reference.
<!-- AI:end:accessibility -->

## License

<!-- AI:start:license -->
<!-- License not detected — add a LICENSE file to this repo. -->
<!-- AI:end:license -->
