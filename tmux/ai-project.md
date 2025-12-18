# tmux Session Management Scripts - Project Overview

## Objective
Create a collection of bash scripts to automate tmux session setup for various development workflows and projects. Each script will establish a tmux session with predefined window and pane layouts, directory contexts, and command preparation.

## Core Requirements

### Multi-Script Architecture
- Individual scripts for different project types or workflows
- Each script creates a complete session with custom configuration
- Reusable patterns across different project scripts

### Pane Configuration
- Each pane operates in a different working directory
- Commands can be either:
  - **Executed automatically** - Run immediately when pane is created
  - **Pre-populated** - Typed into the terminal, waiting for manual execution/modification

### Session Management
- Idempotent design (safe to run multiple times)
- Ability to attach to existing sessions or create new ones
- Clean naming conventions for sessions and windows

## Use Cases
- Development environments with editor, terminal, test runner, and log viewer
- Multi-repository workflows with different project directories
- Service orchestration (database, API server, frontend dev server)
- System administration tasks with multiple SSH sessions
- Project-specific debugging and monitoring setups

## Project Specifications

### Technology Stack
- Web development (Node.js, Java, Java Spring Boot, XQuery)
- Separate repositories per project
- 3-tier architecture: Frontend, Web Service/API, CMS tier

### Layout Preferences
- Typically 1 window with 3 vertical panes
- Vertical split layout (top to bottom):
  - Pane 1 (top): Frontend development server
  - Pane 2 (middle): Web service/API server
  - Pane 3 (bottom): CMS tier - **default focus**
- Variations as needed per project

### Command Execution
- **Default**: Commands executed automatically
- **Optional**: Pre-populated commands for manual execution (project-specific)
- Common commands: Starting dev servers, opening editors, tailing logs

### Session Management
- Sessions named by project name
- Individual scripts per project for maintainability
- Utility scripts for session operations (list, kill, switch)

### Configuration
- Central tmux configuration file for key bindings and preferences
- Reusable patterns across project scripts

## Expected Outcomes
- A library of ready-to-use tmux session scripts
- Consistent, efficient workspace setup
- Reduced manual configuration when starting work
- Easy customization for new projects or workflows
- Utility tools for session lifecycle management
