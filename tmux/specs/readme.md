Here is a project for "bsp-dev"
- A: create one window with 2 panes horizontally
- B: in the first pane (A[0]), create 2 more panes vertically (3 panes total)
- C: in the second pane (A[1]), create 1 more pane vertically (2 panes total)
- D: create another window with 2 panes vertically

### A[0].B[0]
```
cd /Users/dcvezzani/projects/bsp-dev-tools
NODE_ENV=local yarn dev
```

### A[0].B[1]
```
cd /Users/dcvezzani/projects/markdown-renderer
nvm use 22 > /dev/null 2>&1; nvm use 22; NODE_ENV=local yarn dev
```

### A[0].B[2]
```
cd /Users/dcvezzani/projects/markdown-renderer/shared/api
yarn dev
```

### A[1].C[0]
```
cd /Users/dcvezzani/projects/markdown-renderer
```

### A[1].C[0]
```
cd /Users/dcvezzani/projects/markdown
```

### D[0].panes[0]
```
cd /Users/dcvezzani/Library/CloudStorage/OneDrive-ChurchofJesusChrist/Documents/journal/current/20250206-dcvezzani-home/api
yarn dev
```

### D[0].panes[1]
```
cd /Users/dcvezzani/Library/CloudStorage/OneDrive-ChurchofJesusChrist/Documents/journal/current/20250206-dcvezzani-home/api
```

