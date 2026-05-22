#!/usr/bin/env python3

import json
import os
import re
import socket
import sys
import urllib.request

BOT_TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN", "")
CHAT_ID = os.environ.get("TELEGRAM_CHAT_ID", "")

# python-telegram-bot/src/telegram/helpers.py
def escape_markdown(
    text: str, version: int = 1, entity_type: str | None = None
) -> str:
    """Helper function to escape telegram markup symbols.

    .. versionchanged:: 20.3
        Custom emoji entity escaping is now supported.

    Args:
        text (:obj:`str`): The text.
        version (:obj:`int` | :obj:`str`): Use to specify the version of telegrams Markdown.
            Either ``1`` or ``2``. Defaults to ``1``.
        entity_type (:obj:`str`, optional): For the entity types
            :tg-const:`telegram.MessageEntity.PRE`, :tg-const:`telegram.MessageEntity.CODE` and
            the link part of :tg-const:`telegram.MessageEntity.TEXT_LINK` and
            :tg-const:`telegram.MessageEntity.CUSTOM_EMOJI`, only certain characters need to be
            escaped in :tg-const:`telegram.constants.ParseMode.MARKDOWN_V2`. See the `official API
            documentation <https://core.telegram.org/bots/api#formatting-options>`_ for details.
            Only valid in combination with ``version=2``, will be ignored else.
    """
    if int(version) == 1:
        escape_chars = r"_*`["
    elif int(version) == 2:
        if entity_type in ["pre", "code"]:
            escape_chars = r"\`"
        elif entity_type in ["text_link", "custom_emoji"]:
            escape_chars = r"\)"
        else:
            escape_chars = r"\_*[]()~`>#+-=|{}.!"
    else:
        raise ValueError("Markdown version must be either 1 or 2!")

    return re.sub(f"([{re.escape(escape_chars)}])", r"\\\1", text)

def md(text: str) -> str:
    return escape_markdown(text, 2)

def code(text: str) -> str:
    return '`' + escape_markdown(text, 2, 'pre') + '`'

def send(text: str) -> None:
    if not BOT_TOKEN or not CHAT_ID:
        return
    data = json.dumps({
        "chat_id": CHAT_ID,
        "text": text,
        "parse_mode": "MarkdownV2",
    }).encode()

    req = urllib.request.Request(
        f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage",
        data=data,
        headers = {"Content-Type": "application/json"},
    )
    try:
        urllib.request.urlopen(req, timeout=10)
    except Exception as e:
        print(f"Telegram error: {e}", file=sys.stderr)

def fmt_cwd(cwd: str) -> str:
    home = os.path.expanduser("~")
    if cwd.startswith(home + "/"):
        cwd = "~/" + cwd[len(home) + 1:]
    elif cwd == home:
        cwd = "~"
    return cwd

def main() -> None:
    try:
        payload = json.load(sys.stdin)
    except Exception:
        payload = {}

    with open('/tmp/cchook.jsonl', 'a') as fp:
        json.dump(payload, fp)
        print(file=fp)

    if os.environ.get("CC_HI_SESSION") == "1":
        return

    event   = payload.get("hook_event_name", sys.argv[1] if len(sys.argv) > 1 else "Stop")
    hostname = socket.gethostname()
    cwd     = fmt_cwd(payload.get("cwd") or os.getcwd())
    session = str(payload.get("session_id", ""))[:8]

    common = [
        f"🖥  *Host:* {code(hostname)}",
        f"📁 *Project:* {code(cwd)}",
    ]
    if session:
        common.append(f"🔑 *Session:* {code(session)}")

    if event == "Stop":
        perm = payload.get("permission_mode", "")
        last = payload.get("last_assistant_message", "")
        lines = ["✅ *Claude finished*", *common]
        if perm:
            lines.append(f"🔐 *Mode:* {code(perm)}")
        if last:
            lines.append(f"💬 {md(last[:300])}")

    elif event == "Notification":
        msg  = payload.get("message", "needs your attention")
        ntype = payload.get("notification_type", "")
        lines = ["⚠️ *Claude needs input*", *common, f"💬 {md(msg)}"]
        if ntype:
            lines.append(f"🔔 *Type:* {code(ntype)}")

    else:
        lines = [md(event)]

    send("\n".join(lines))

if __name__ == "__main__":
    main()
