#!/usr/bin/env python3
"""
Generates ~/.dotfiles/claude/settings.json with paths resolved for the current machine.

Usage:
    python3 ~/.dotfiles/claude/install-settings.py

Machine-specific overrides (e.g. mcpServers, extra plugins) go in
~/.claude-accounts/settings-local.json — they are deep-merged into the
base settings and that file is never tracked.
"""

import json
import os


def deep_merge(base: dict, override: dict) -> dict:
    result = dict(base)
    for k, v in override.items():
        if k in result and isinstance(result[k], dict) and isinstance(v, dict):
            result[k] = deep_merge(result[k], v)
        else:
            result[k] = v
    return result


def main() -> None:
    home = os.path.expanduser("~")
    dotfiles = os.environ.get("DOTFILES", f"{home}/.dotfiles")
    launcher = f"{dotfiles}/bin/claude-launcher"
    notify   = f"{home}/.claude/telegram-notify.py"
    statusline = f"{home}/.claude/statusline-command.sh"

    settings: dict = {
        "hooks": {
            "Stop": [{
                "hooks": [
                    {
                        "type": "command",
                        "command": f"cat | {launcher} hi-cleanup-hook",
                        "async": False,
                    },
                    {
                        "type": "command",
                        "command": f"cat | python3 {notify} stop 2>/dev/null || true",
                        "async": True,
                    },
                ],
            }],
            "Notification": [{
                "hooks": [
                    {
                        "type": "command",
                        "command": f"cat | python3 {notify} notification 2>/dev/null || true",
                        "async": True,
                    },
                ],
            }],
        },
        "statusLine": {
            "type": "command",
            "command": f"bash {statusline}",
        },
        "enabledPlugins": {
            "gopls-lsp@claude-plugins-official": True,
        },
        "effortLevel": "xhigh",
        "tui": "fullscreen",
        "skipDangerousModePermissionPrompt": True,
        "theme": "dark",
        "agentPushNotifEnabled": True,
        "skipAutoPermissionPrompt": True,
        "inputNeededNotifEnabled": True,
    }

    local_path = os.path.join(home, ".claude-accounts", "settings-local.json")
    if os.path.exists(local_path):
        with open(local_path) as f:
            settings = deep_merge(settings, json.load(f))
        print(f"Merged {local_path}")

    out = os.path.join(dotfiles, "claude", "settings.json")
    with open(out, "w") as f:
        json.dump(settings, f, indent=2)
        f.write("\n")
    print(f"Wrote {out}")


if __name__ == "__main__":
    main()
