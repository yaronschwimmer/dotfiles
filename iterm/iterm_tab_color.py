#!/usr/bin/env python3.7

import asyncio
import iterm2
import random


def rand_color():
    return random.randint(0,255)

async def main(connection):
    app = await iterm2.async_get_app(connection)

    async def monitor(session_id):
        session = app.current_terminal_window.current_tab.current_session
        change = iterm2.LocalWriteOnlyProfile()
        color = iterm2.Color(rand_color(),rand_color(),rand_color())

        change.set_tab_color(color)
        change.set_use_tab_color(True)
        await session.async_set_profile_properties(change)

    await (iterm2.EachSessionOnceMonitor.async_foreach_session_create_task(app, monitor))

# This instructs the script to run the "main" coroutine and to keep running even after it returns.
iterm2.run_forever(main)

