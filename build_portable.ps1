$ErrorActionPreference = "Stop"

python -m PyInstaller `
    --noconfirm `
    --clean `
    --onefile `
    --console `
    --name EngineeringCalculator `
    calculator.py

Write-Host "Portable file created: dist\EngineeringCalculator.exe"
