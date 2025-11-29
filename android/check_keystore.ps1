# PowerShell script to check keystore SHA1 fingerprint
# Usage: .\check_keystore.ps1 -KeystorePath "path\to\your\keystore.jks" -StorePassword "your_password"

param(
    [Parameter(Mandatory=$true)]
    [string]$KeystorePath,
    
    [Parameter(Mandatory=$true)]
    [string]$StorePassword
)

$expectedSHA1 = "34:9B:35:89:13:05:45:5C:24:5D:A0:ED:46:C4:EC:C4:81:14:30:4C"

Write-Host "Checking keystore: $KeystorePath" -ForegroundColor Cyan
Write-Host ""

# Get the Java keytool path
$javaHome = $env:JAVA_HOME
if (-not $javaHome) {
    # Try to find Java in common locations
    $possibleJavaPaths = @(
        "$env:ProgramFiles\Java",
        "$env:ProgramFiles(x86)\Java",
        "C:\Program Files\Android\Android Studio\jbr"
    )
    
    foreach ($path in $possibleJavaPaths) {
        if (Test-Path "$path\bin\keytool.exe") {
            $javaHome = $path
            break
        }
    }
}

if (-not $javaHome) {
    Write-Host "ERROR: Could not find Java. Please set JAVA_HOME environment variable." -ForegroundColor Red
    exit 1
}

$keytool = "$javaHome\bin\keytool.exe"

if (-not (Test-Path $keytool)) {
    Write-Host "ERROR: keytool not found at $keytool" -ForegroundColor Red
    exit 1
}

# List all aliases in the keystore
Write-Host "Aliases in keystore:" -ForegroundColor Yellow
& $keytool -list -v -keystore $KeystorePath -storepass $StorePassword | Select-String -Pattern "Alias name:" | ForEach-Object {
    $alias = ($_ -split ":")[1].Trim()
    Write-Host "  - $alias" -ForegroundColor White
}

Write-Host ""
Write-Host "Certificate fingerprints:" -ForegroundColor Yellow

# Get the SHA1 fingerprint
$output = & $keytool -list -v -keystore $KeystorePath -storepass $StorePassword 2>&1
$sha1Line = $output | Select-String -Pattern "SHA1:"

if ($sha1Line) {
    $sha1 = ($sha1Line -split "SHA1:")[1].Trim()
    Write-Host "  SHA1: $sha1" -ForegroundColor White
    Write-Host ""
    
    if ($sha1 -eq $expectedSHA1) {
        Write-Host "✓ SUCCESS: This keystore matches the expected SHA1!" -ForegroundColor Green
        Write-Host "  Expected: $expectedSHA1" -ForegroundColor Green
        Write-Host "  Found:    $sha1" -ForegroundColor Green
    } else {
        Write-Host "✗ WARNING: This keystore does NOT match the expected SHA1!" -ForegroundColor Red
        Write-Host "  Expected: $expectedSHA1" -ForegroundColor Yellow
        Write-Host "  Found:    $sha1" -ForegroundColor Red
    }
} else {
    Write-Host "ERROR: Could not extract SHA1 fingerprint from keystore" -ForegroundColor Red
}





