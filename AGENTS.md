# Repository Guidelines

## Project Structure & Module Organization

This repository manages Apple Silicon macOS with Nix flakes, nix-darwin, and Home Manager.

- `flake.nix`: declares inputs, system packages, macOS defaults, Homebrew packages, and the `MacBook` and `Mo` outputs.
- `flake.lock`: pins dependency revisions; update it intentionally and commit it with related input changes.
- `home-manager/home.nix`: defines user packages, shell tools, and Home Manager programs.
- `home-manager/config.cloud.fish`: Fish configuration installed through Home Manager.
- `Makefile`: provides update, validation, build, and activation commands.
- `readme.md`: installation notes and operational troubleshooting.

Keep machine-wide settings in `flake.nix` and user settings under `home-manager/`. Split large configurations into clearly named `.nix` modules.

## Build, Test, and Development Commands

- `make check`: evaluate and check the `MacBook` nix-darwin configuration without activating it.
- `make build`: build the system configuration for review.
- `make rebuild`: build and activate `.#MacBook`; this uses `sudo` and changes the local system.
- `make Mo`: activate the `.#Mo` Home Manager configuration, preserving conflicts with a `backup` suffix.
- `make update`: update flake inputs and regenerate `flake.lock`.
- `nix flake check`: run general flake evaluation checks when changing outputs or inputs.

Run `make check` before activation. Review `git diff -- flake.lock` after updates.

## Coding Style & Naming Conventions

Use two-space indentation for Nix expressions and format attribute sets consistently. Keep upstream option names; use lowercase, hyphenated filenames for new modules. Group related packages and options, and comment only where a setting's purpose is unclear. Run `nix fmt` if the flake gains a formatter; otherwise preserve surrounding style.

## Testing Guidelines

There is no separate unit-test framework or coverage target. Configuration evaluation is the test boundary. At minimum, run `make check`; for larger changes, also run `make build`. Activate only after both succeed, then manually verify affected applications, shell startup, or macOS defaults.

## Commit & Pull Request Guidelines

Existing history uses short, imperative summaries such as `add pnpm` and `update nix`. Follow that pattern, but make the subject specific, for example `add fish completion plugin`. Keep commits focused and include lockfile changes with the configuration change that caused them.

Pull requests should explain the intended system change, list validation commands run, and call out activation side effects. Include screenshots only for visible macOS or application-setting changes. Never commit credentials, private certificates, or host-specific secrets.
