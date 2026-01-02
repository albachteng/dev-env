# .ready-tmux Guide

## Overview

The `.ready-tmux` system automatically sets up your development environment when you start a new tmux session using the `tmux-sessionizer` script.

## How It Works

1. **Press `Ctrl+f`** (or `prefix + f` in tmux) to launch the tmux-sessionizer
2. **Select a directory** from your home, projects, or .config directories
3. **tmux-sessionizer creates a new session** and runs the `ready-tmux` script
4. **ready-tmux looks for** `.ready-tmux` in this order:
   - `./.ready-tmux` (local project script) - **if found, uses this and exits**
   - `~/.ready-tmux` (global default script) - **fallback**

## Default Behavior

The default `~/.ready-tmux` script does the following:

1. **Opens neovim** in the project root with `nvim .`
2. **Opens the terminal panel** in neovim using `<space>st`
3. **Runs git commands** in that terminal:
   - `git status`
   - `git log --oneline -20`
4. **Creates a new tmux window** for additional work
5. **Returns focus** to the first window with neovim

## Customizing Per-Project

To override the default behavior for a specific project, create a `.ready-tmux` script in your project root:

```bash
#!/usr/bin/env bash

# Example: Start a development server instead
cd "$(dirname "$0")"

# Start your dev server in the background
npm run dev &

# Open your preferred editor
exec nvim .
```

**Make it executable:**
```bash
chmod +x .ready-tmux
```

## Example Custom Scripts

### For a Go Project

```bash
#!/usr/bin/env bash

# Run tests on startup
SESSION=$(tmux display-message -p '#S' 2>/dev/null)

if [ -n "$SESSION" ]; then
  (
    sleep 1.5
    # Open terminal in nvim
    tmux send-keys -t "$SESSION" " st"
    sleep 0.5
    # Run go tests
    tmux send-keys -t "$SESSION" "go test ./..." C-m
    # Create new window for running the app
    tmux new-window -t "$SESSION" -c "$PWD"
    tmux send-keys -t "$SESSION" "go run ." C-m
    # Back to first window
    tmux select-window -t "$SESSION:0"
  ) &
fi

exec nvim .
```

### For a Node.js Project

```bash
#!/usr/bin/env bash

SESSION=$(tmux display-message -p '#S' 2>/dev/null)

if [ -n "$SESSION" ]; then
  (
    sleep 1.5
    # Open terminal in nvim
    tmux send-keys -t "$SESSION" " st"
    sleep 0.5
    # Install dependencies and show git status
    tmux send-keys -t "$SESSION" "npm install && git status" C-m
    # Create new window for dev server
    tmux new-window -t "$SESSION" -c "$PWD"
    tmux send-keys -t "$SESSION" "npm run dev" C-m
    # Back to first window
    tmux select-window -t "$SESSION:0"
  ) &
fi

exec nvim .
```

### For a Simple Project (No Automation)

```bash
#!/usr/bin/env bash

# Just open nvim, nothing else
exec nvim .
```

## Tips & Tricks

### Disable for a Specific Project

Create a `.ready-tmux` that does nothing:

```bash
#!/usr/bin/env bash
# No automation for this project
exec $SHELL
```

### Debug Your Script

Add logging to see what's happening:

```bash
#!/usr/bin/env bash

exec 2>> /tmp/ready-tmux-debug.log
set -x  # Enable debug output

# Your script here...
```

Then check the log:
```bash
tail -f /tmp/ready-tmux-debug.log
```

### Template for New Projects

Keep a template in your dev-env:

```bash
cp ~/dev-env/templates/.ready-tmux-template ./my-project/.ready-tmux
chmod +x ./my-project/.ready-tmux
```

## Troubleshooting

### Script doesn't run
- Make sure it's executable: `chmod +x .ready-tmux`
- Check it's in the project root directory
- Verify the shebang is correct: `#!/usr/bin/env bash`

### Neovim terminal doesn't open
- Increase sleep time in the script (try `sleep 2` instead of `sleep 1.5`)
- Check your neovim config has the `<space>st` keybinding

### Commands send to wrong window
- Make sure you're using `$SESSION` variable correctly
- Add more sleep time between commands to ensure they complete

## Related Files

- **`~/dev-env/env/.ready-tmux`**: Default template (source)
- **`~/.ready-tmux`**: Installed default script (deployed by `./dev-env`)
- **`./.ready-tmux`**: Project-specific override
- **`~/dev-env/env/.local/scripts/ready-tmux`**: Wrapper that chooses which script to run
- **`~/dev-env/env/tmux-sessionizer`**: FZF-based session launcher
