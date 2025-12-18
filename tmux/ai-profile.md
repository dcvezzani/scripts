# AI Profile for tmux Session Management Scripts

## Project Overview
Creating bash scripts to automate tmux session, window, and pane configurations with custom directory contexts and command execution capabilities.

## Required Expertise

### tmux (Terminal Multiplexer)
- **Session Management**: Creating, attaching, detaching, and managing tmux sessions
- **Window Operations**: Creating, naming, switching, and organizing windows within sessions
- **Pane Management**: Splitting windows horizontally and vertically, resizing, and navigating panes
- **Command Execution**: Using `send-keys` to execute commands or pre-populate input in panes
- **Directory Control**: Setting working directories per pane using `-c` flag
- **Target Specifications**: Understanding tmux target notation (session:window.pane)
- **Configuration**: Knowledge of `.tmux.conf` and runtime configuration options
- **Scripting Patterns**: Best practices for tmux automation scripts including:
  - Checking if sessions already exist
  - Conditional session creation vs. attachment
  - Proper window/pane indexing
  - Timing considerations for command execution

### Bash Scripting
- **Script Structure**: Proper shebang, error handling, and exit codes
- **Control Flow**: Conditionals, loops, and function definitions
- **Variables and Arguments**: Parameter handling and variable expansion
- **String Manipulation**: Path handling, string parsing, and text processing
- **Process Management**: Background processes, job control, and command chaining
- **Error Handling**: Set flags (`set -e`, `set -u`), trap statements, and validation
- **Portability**: Writing scripts compatible with bash on macOS

### iTerm2 (macOS Terminal Emulator)
- **Integration with tmux**: Understanding iTerm2's tmux integration mode and native behavior
- **Profile Management**: Knowledge of iTerm2 profiles and preferences
- **Session Restoration**: How iTerm2 handles tmux session persistence
- **Keyboard Shortcuts**: Common key bindings and potential conflicts with tmux
- **Command Line Integration**: iTerm2 shell integration features and compatibility

## Key Capabilities

### Script Design Patterns
- Idempotent session creation (safe to run multiple times)
- Parameterized scripts for flexible session configurations
- Clear naming conventions for sessions, windows, and panes
- Modular design for reusable components

### Command Execution Strategies
- **Immediate Execution**: Commands that run automatically on pane creation
- **Prepared Commands**: Commands entered but not executed (waiting for user confirmation)
- **Interactive Shells**: Panes that simply open to a directory with active shell

### Workflow Automation
- Development environment setup (editor, terminal, logs, services)
- Project-specific layouts (web development, data science, system administration)
- Multi-repository workflows
- Testing and debugging environments

## Technical Considerations

### macOS-Specific Knowledge
- Default shell environments (bash, zsh)
- Homebrew package management (tmux installation/updates)
- File system paths and conventions
- Terminal.app vs iTerm2 differences

### Best Practices
- Avoid hardcoded paths (use variables and configuration)
- Include helpful comments and documentation
- Handle edge cases (session already exists, tmux not running, etc.)
- Provide clear user feedback during execution
- Support cleanup and session destruction scripts

### Common Patterns to Implement
```bash
# Check if session exists
tmux has-session -t session_name 2>/dev/null

# Create session with specific window
tmux new-session -d -s session_name -n window_name

# Split pane and set directory
tmux split-window -h -t session_name -c /path/to/dir

# Send keys with or without execution
tmux send-keys -t session_name:window.pane "command" C-m  # Execute
tmux send-keys -t session_name:window.pane "command"      # Don't execute

# Attach to session
tmux attach-session -t session_name
```

## Expected Deliverables
- Reusable, well-documented bash scripts
- Clear instructions for customization
- Example configurations for common workflows
- Error handling and user-friendly feedback
- Consistent coding style and formatting
