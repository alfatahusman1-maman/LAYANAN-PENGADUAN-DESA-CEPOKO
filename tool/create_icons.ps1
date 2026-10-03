Add-Type -AssemblyName System.Drawing

$base = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$assetDir = Join-Path $base 'assets\branding'
New-Item -ItemType Directory -Force -Path $assetDir | Out-Null

function New-Brush([int]$red, [int]$green, [int]$blue) {
    [System.Drawing.SolidBrush]::new([System.Drawing.Color]::FromArgb(255, $red, $green, $blue))
}

function Draw-Mark([System.Drawing.Graphics]$graphics, [single]$scale, [single]$originX, [single]$originY) {
    $shell = New-Brush 255 253 245
    $roof = New-Brush 126 83 61
    $door = New-Brush 127 98 68
    $window = New-Brush 168 201 121
    $points = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($originX + (512 * $scale), $originY + (236 * $scale)),
        [System.Drawing.PointF]::new($originX + (810 * $scale), $originY + (486 * $scale)),
        [System.Drawing.PointF]::new($originX + (770 * $scale), $originY + (530 * $scale)),
        [System.Drawing.PointF]::new($originX + (512 * $scale), $originY + (319 * $scale)),
        [System.Drawing.PointF]::new($originX + (254 * $scale), $originY + (530 * $scale)),
        [System.Drawing.PointF]::new($originX + (214 * $scale), $originY + (486 * $scale))
    )
    $graphics.FillPolygon($roof, $points)
    $graphics.FillRectangle($shell, $originX + (272 * $scale), $originY + (464 * $scale), 480 * $scale, 268 * $scale)
    $graphics.FillRectangle($door, $originX + (446 * $scale), $originY + (552 * $scale), 132 * $scale, 180 * $scale)
    $graphics.FillRectangle($window, $originX + (635 * $scale), $originY + (514 * $scale), 70 * $scale, 75 * $scale)
    $treePoints = [System.Drawing.PointF[]]@(
        [System.Drawing.PointF]::new($originX + (862 * $scale), $originY + (409 * $scale)),
        [System.Drawing.PointF]::new($originX + (817 * $scale), $originY + (472 * $scale)),
        [System.Drawing.PointF]::new($originX + (840 * $scale), $originY + (472 * $scale)),
        [System.Drawing.PointF]::new($originX + (796 * $scale), $originY + (529 * $scale)),
        [System.Drawing.PointF]::new($originX + (838 * $scale), $originY + (529 * $scale)),
        [System.Drawing.PointF]::new($originX + (823 * $scale), $originY + (579 * $scale)),
        [System.Drawing.PointF]::new($originX + (902 * $scale), $originY + (579 * $scale)),
        [System.Drawing.PointF]::new($originX + (887 * $scale), $originY + (529 * $scale)),
        [System.Drawing.PointF]::new($originX + (929 * $scale), $originY + (529 * $scale)),
        [System.Drawing.PointF]::new($originX + (885 * $scale), $originY + (472 * $scale)),
        [System.Drawing.PointF]::new($originX + (907 * $scale), $originY + (472 * $scale))
    )
    $graphics.FillPolygon($window, $treePoints)
    $graphics.FillRectangle($window, $originX + (858 * $scale), $originY + (574 * $scale), 9 * $scale, 74 * $scale)
    $shell.Dispose(); $roof.Dispose(); $door.Dispose(); $window.Dispose()
}

$launcher = [System.Drawing.Bitmap]::new(1024, 1024, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($launcher)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::FromArgb(30, 86, 49))
Draw-Mark $graphics 1 0 0
$launcher.Save((Join-Path $assetDir 'launcher.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose(); $launcher.Dispose()

$foreground = [System.Drawing.Bitmap]::new(1024, 1024, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$graphics = [System.Drawing.Graphics]::FromImage($foreground)
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$graphics.Clear([System.Drawing.Color]::Transparent)
Draw-Mark $graphics 0.62 0 0
$foreground.Save((Join-Path $assetDir 'foreground.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose(); $foreground.Dispose()

$webDir = Join-Path $base 'web\icons'
New-Item -ItemType Directory -Force -Path $webDir | Out-Null
$sourceImage = [System.Drawing.Image]::FromFile((Join-Path $assetDir 'launcher.png'))
foreach ($dimension in @(192, 512)) {
    $webIcon = [System.Drawing.Bitmap]::new($dimension, $dimension, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $webGraphics = [System.Drawing.Graphics]::FromImage($webIcon)
    $webGraphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $webGraphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $webGraphics.DrawImage($sourceImage, 0, 0, $dimension, $dimension)
    $webIcon.Save((Join-Path $webDir "Icon-$dimension.png"), [System.Drawing.Imaging.ImageFormat]::Png)
    $webGraphics.Dispose(); $webIcon.Dispose()
}
$sourceImage.Dispose()

Write-Output 'Generated Android launcher and adaptive foreground PNGs.'
