import asyncio
import iterm2

WINDOW_NAME = "[[PERSONAL-BOOKMARKS]]"

async def main(connection):
    app = await iterm2.async_get_app(connection)
    windows = app.windows

    for window in windows:
        try:
            await window.async_activate()
            # title = await window.async_get_title()
            session = window.current_tab.current_session
            title = await session.async_get_variable("user.windowName")
            print(f"Processing window: {title}")

            if title and WINDOW_NAME in title:
                # Found the target window
                if len(window.tabs) >= 2:
                    tab2 = window.tabs[1]
                    for session in tab2.sessions:
                        await session.async_send_text("\x03")  # Ctrl+C
                        await asyncio.sleep(1)  # Give time for processes to stop
                        await session.async_close()

                # Close all tabs in the window
                for tab in reversed(window.tabs):
                    try:
                        if tab.current_session != None:
                            await tab.async_close()
                    except Exception as e:
                        doNothing = 1
        except Exception as e:
            print(f"Error processing window: {e}")

iterm2.run_until_complete(main)


