<#
.SYNOPSIS
Combines Markdown notes into one readable source file.

.DESCRIPTION
Scans a directory recursively for .md and .markdown files, sorts them by
relative path and file name, and writes a clearly separated Markdown document.
The generated file is excluded if it is located inside the source directory.

.PARAMETER SourceDirectory
Directory containing the notes. Defaults to the repository root (the parent of
the scripts directory).

.PARAMETER OutputFile
Destination for the aggregated file. Defaults to AggregatedNotes.md in the
repository root.

.PARAMETER NoRecurse
Search only the top level of SourceDirectory instead of its subdirectories.

.EXAMPLE
.\scripts\noteAggregator.ps1

.EXAMPLE
.\scripts\noteAggregator.ps1 -SourceDirectory ".\AZ-104\Notes" -OutputFile ".\AZ-104\Notes\AZ-104-Aggregated.md"
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [Alias("InputDirectory", "Directory")]
    [string]$SourceDirectory,

    [Parameter(Position = 1)]
    [Alias("OutputPath")]
    [string]$OutputFile,

    [switch]$NoRecurse
)

$ErrorActionPreference = "Stop"

$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$repositoryRoot = Split-Path -Parent $scriptDirectory

if ([string]::IsNullOrWhiteSpace($SourceDirectory)) {
    $SourceDirectory = $repositoryRoot
}

if ([string]::IsNullOrWhiteSpace($OutputFile)) {
    $OutputFile = Join-Path $repositoryRoot "AggregatedNotes.md"
}

function Resolve-FullPath {
    param([Parameter(Mandatory)][string]$Path)

    if ([System.IO.Path]::IsPathRooted($Path)) {
        return [System.IO.Path]::GetFullPath($Path)
    }

    return [System.IO.Path]::GetFullPath((Join-Path (Get-Location).Path $Path))
}

function Get-RelativePath {
    param(
        [Parameter(Mandatory)][string]$BaseDirectory,
        [Parameter(Mandatory)][string]$FilePath
    )

    $basePrefix = $BaseDirectory.TrimEnd('\', '/') + [System.IO.Path]::DirectorySeparatorChar
    if ($FilePath.StartsWith($basePrefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        return $FilePath.Substring($basePrefix.Length).Replace('\', '/')
    }

    return [System.IO.Path]::GetFileName($FilePath)
}

$sourceFullPath = Resolve-FullPath $SourceDirectory
$outputFullPath = Resolve-FullPath $OutputFile

if (-not (Test-Path -LiteralPath $sourceFullPath -PathType Container)) {
    throw "Source directory does not exist: $sourceFullPath"
}

$sourceFullPath = [System.IO.Path]::GetFullPath($sourceFullPath)
$outputDirectory = Split-Path -Parent $outputFullPath
if (-not (Test-Path -LiteralPath $outputDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

$getChildItemParameters = @{
    LiteralPath = $sourceFullPath
    File        = $true
    Force       = $true
}

if (-not $NoRecurse) {
    $getChildItemParameters.Recurse = $true
}

$markdownFiles = Get-ChildItem @getChildItemParameters |
    Where-Object {
        $_.Extension -in ".md", ".markdown" -and
        $_.FullName -ine $outputFullPath
    } |
    Sort-Object @{
        Expression = {
            Get-RelativePath -BaseDirectory $sourceFullPath -FilePath $_.FullName
        }
    }, Name

$separator = "`n`n" + ("-" * 72) + "`n`n"
$lines = [System.Collections.Generic.List[string]]::new()

[void]$lines.Add("# Aggregated Certification Notes")
[void]$lines.Add("")
[void]$lines.Add("**Generated:** $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))")
[void]$lines.Add("**Source directory:** ``$sourceFullPath``")
[void]$lines.Add("**Number of sources:** $($markdownFiles.Count)")
[void]$lines.Add("")
[void]$lines.Add("## How to use this document")
[void]$lines.Add("")
[void]$lines.Add("This document combines multiple Markdown note files into one source.")
[void]$lines.Add("Each section is labeled with its original relative path. Treat each source")
[void]$lines.Add("section as one study note and preserve the source label when citing information.")
[void]$lines.Add("")
[void]$lines.Add("## Source index")
[void]$lines.Add("")

$sourceNumber = 0
foreach ($file in $markdownFiles) {
    $sourceNumber++
    $relativePath = Get-RelativePath -BaseDirectory $sourceFullPath -FilePath $file.FullName
    [void]$lines.Add("$sourceNumber. ``$relativePath``")
}

if ($markdownFiles.Count -eq 0) {
    [void]$lines.Add("")
    [void]$lines.Add("_No Markdown source files were found._")
}

for ($sourceIndex = 0; $sourceIndex -lt $markdownFiles.Count; $sourceIndex++) {
    $file = $markdownFiles[$sourceIndex]
    $relativePath = Get-RelativePath -BaseDirectory $sourceFullPath -FilePath $file.FullName

    [void]$lines.Add("")
    [void]$lines.Add($separator)
    [void]$lines.Add("## Source $($sourceIndex + 1): $relativePath")
    [void]$lines.Add("")
    [void]$lines.Add("> Original file: ``$relativePath``")
    [void]$lines.Add("")

    $content = [System.IO.File]::ReadAllText($file.FullName)
    [void]$lines.Add($content.Trim())
}

$aggregatedContent = ($lines -join "`n").TrimEnd() + "`n"
$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($outputFullPath, $aggregatedContent, $utf8NoBom)

Write-Host "Aggregated $($markdownFiles.Count) Markdown file(s)."
Write-Host "Output: $outputFullPath"