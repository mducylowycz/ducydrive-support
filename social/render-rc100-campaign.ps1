param(
    [string]$InputPath = (Join-Path $PSScriptRoot '..\assets\duchydrive-rc100-campaign-base.png'),
    [string]$OutputPath = (Join-Path $PSScriptRoot '..\assets\duchydrive-rc100-campaign.png')
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

$source = [System.Drawing.Image]::FromFile((Resolve-Path $InputPath))
$canvas = New-Object System.Drawing.Bitmap 1254, 1254
$graphics = [System.Drawing.Graphics]::FromImage($canvas)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$graphics.DrawImage($source, 0, 0, 1254, 1254)

for ($x = 0; $x -lt 730; $x += 2) {
    $opacity = [Math]::Max(0, [Math]::Min(225, [int](225 * (1 - ($x / 730.0)))))
    $brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($opacity, 3, 11, 25))
    $graphics.FillRectangle($brush, $x, 0, 3, 1254)
    $brush.Dispose()
}

$white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(247, 250, 255))
$blue = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(128, 209, 255))
$yellow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(224, 255, 65))
$muted = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(183, 199, 222))
$linePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(85, 128, 209, 255)), 2
$headline = New-Object System.Drawing.Font 'Segoe UI', 64, ([System.Drawing.FontStyle]::Bold)
$subhead = New-Object System.Drawing.Font 'Segoe UI', 25, ([System.Drawing.FontStyle]::Bold)
$label = New-Object System.Drawing.Font 'Segoe UI', 20, ([System.Drawing.FontStyle]::Regular)
$small = New-Object System.Drawing.Font 'Segoe UI', 16, ([System.Drawing.FontStyle]::Regular)

$graphics.FillEllipse($yellow, 72, 72, 28, 28)
$graphics.DrawString('MJD SOLUTIONS  /  CLOSED TEST', $subhead, $blue, 116, 67)
$graphics.DrawString('DucyDrive', $headline, $white, 66, 145)
$graphics.DrawString('2.2 RC100', $headline, $yellow, 66, 220)
$graphics.DrawLine($linePen, 72, 327, 592, 327)
$graphics.DrawString('Your Android phone. A practical USB workspace.', $label, $white, 72, 356)

$items = @(
    'Inspect a connected USB drive',
    'Choose a guided format',
    'Write supported images',
    'Verify what was written'
)
$y = 446
foreach ($item in $items) {
    $graphics.FillEllipse($yellow, 76, $y + 8, 12, 12)
    $graphics.DrawString($item, $label, $muted, 108, $y)
    $y += 66
}

$graphics.DrawString('Clearer navigation  •  Local-first processing', $subhead, $white, 72, 750)
$graphics.DrawString('Use spare media. Destructive USB operations replace data.', $small, $muted, 72, 805)
$graphics.DrawString('JOIN THE GOOGLE PLAY CLOSED TEST', $subhead, $yellow, 72, 1090)

$outputDirectory = Split-Path -Parent $OutputPath
if (-not (Test-Path $outputDirectory)) { New-Item -ItemType Directory -Path $outputDirectory | Out-Null }
$canvas.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)

$headline.Dispose(); $subhead.Dispose(); $label.Dispose(); $small.Dispose()
$white.Dispose(); $blue.Dispose(); $yellow.Dispose(); $muted.Dispose(); $linePen.Dispose()
$graphics.Dispose(); $canvas.Dispose(); $source.Dispose()

Write-Output $OutputPath
