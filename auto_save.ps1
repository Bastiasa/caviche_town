Set-Location "b:\projects\gamemaker\caviche_town\"
git add .
git commit -m "Auto commit $(Get-Date)"
git push origin main

Write-Host "Presione cualquier tecla para continuar..."
Read-Host