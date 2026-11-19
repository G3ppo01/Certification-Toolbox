# Scripts

This directory contains PowerShell utilities for the Certification Toolbox.

## Markdown note aggregator

`noteAggregator.ps1` combines Markdown notes from a directory into one structured Markdown document. The output is designed to be clear and usable as a single Google NotebookLM source.

### Run with defaults

From the repository root:

```powershell
.\scripts\noteAggregator.ps1
```

By default, the script:

- scans the repository root recursively;
- finds `.md` and `.markdown` files;
- sorts sources by relative path;
- writes `AggregatedNotes.md` in the repository root;
- excludes the output file if it is already inside the source directory.

### Aggregate a specific directory

```powershell
.\scripts\noteAggregator.ps1 `
    -SourceDirectory ".\AZ-104" `
    -OutputFile ".\AZ-104\AZ-104-Aggregated.md"
```

### Aggregate only the immediate directory

Use `-NoRecurse` to omit subdirectories:

```powershell
.\scripts\noteAggregator.ps1 `
    -SourceDirectory ".\AZ-104\Notes" `
    -OutputFile ".\AZ-104\Notes\AggregatedNotes.md" `
    -NoRecurse
```

### Parameters

| Parameter | Aliases | Default | Description |
|---|---|---|---|
| `SourceDirectory` | `InputDirectory`, `Directory` | Repository root | Directory containing Markdown source files |
| `OutputFile` | `OutputPath` | `AggregatedNotes.md` in the repository root | Full or relative output path |
| `NoRecurse` | — | Disabled | Searches only the source directory's immediate level |

### Output format

The generated document contains:

- generation date and time;
- source directory and source count;
- an indexed source list;
- one clearly labeled section per Markdown file;
- the original relative path for each section.
