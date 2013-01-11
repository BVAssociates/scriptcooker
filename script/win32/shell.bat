@echo off
cd ..\..

echo Modification du PATH
set PATH=%PATH%;public\bin
set PERL5LIB=%PERL5LIB%;public\lib

cmd.exe /K t\sample\profile.RT.minimal.bat