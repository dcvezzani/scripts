import iterm2

WINDOW_NAME = "[[PERSONAL-BOOKMARKS]]"

async def set_window_dimensions(window, columns=175, rows=50):
    session = window.current_tab.current_session
    newDimensions = iterm2.util.Size(int(columns), int(rows))
    session.preferred_size = newDimensions
    await window.current_tab.async_update_layout()

async def main(connection):
    app = await iterm2.async_get_app(connection)
    await app.async_activate()

    main = app.current_terminal_window

    if main is not None:
        # Create a new window
        window = await main.async_create(connection)
        await window.async_activate()
        session = window.current_tab.current_session

        # Set window dimensions
        await set_window_dimensions(window, 175, 50)

        # Set window title
        await window.async_set_title(WINDOW_NAME)

        # Tab 1
        tab1 = window.current_tab
        await tab1.async_set_title("bookmarks")
        await session.async_send_text("cd /Users/dcvezzani/Library/CloudStorage/OneDrive-ChurchofJesusChrist/Documents/journal/current/20250206-dcvezzani-home\n")
        await session.async_set_variable("user.windowName", WINDOW_NAME)

        # Tab 2 with 3 panes
        tab2 = await window.async_create_tab()
        await tab2.async_set_title("api")
        session1 = tab2.current_session
        await session1.async_send_text("cd /Users/dcvezzani/Library/CloudStorage/OneDrive-ChurchofJesusChrist/Documents/journal/current/20250206-dcvezzani-home/api && yarn dev\n")
        await session1.async_set_variable("user.windowName", WINDOW_NAME)

        # Split horizontally
        session2 = await session1.async_split_pane(vertical=False)
        await session2.async_set_variable("user.windowName", WINDOW_NAME)

        # # Split horizontally again from session2
        # session3 = await session2.async_split_pane(vertical=False)
        # await session3.async_set_variable("user.windowName", WINDOW_NAME)

        # # Tab 3
        # tab3 = await window.async_create_tab()
        # await tab3.async_set_title("comp")
        # await tab3.current_session.async_send_text("cd /Users/dcvezzani/projects/md-notes-03/md-components\n")
        # await tab3.current_session.async_set_variable("user.windowName", WINDOW_NAME)

        # Return to Tab 1 and run `yarn status`
        await window.tabs[0].async_activate()
        await window.tabs[0].current_session.async_send_text("git status\n")

iterm2.run_until_complete(main)


