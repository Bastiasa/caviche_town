
for /f "tokens=*" %%a in ('date /t') do set current_date=%%a

git add .
git commit -m "Commit from command "%current_date%
git push origin main

pause