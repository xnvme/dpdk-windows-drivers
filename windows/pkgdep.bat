@echo off
@setlocal enableextensions enabledelayedexpansion

net session >nul: 2>&1
if errorlevel 1 (
	echo %0 must be run with Administrator privileges
	goto :eof
)

:: Use PowerShell to install Chocolatey
set "PATH=%ALLUSERSPROFILE%\chocolatey\bin;%PATH%"
echo [1/6] Install: Chocolatey Manager
powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
where /q choco
if errorlevel 1 (
	echo [1/6] Install: Chocolatey = FAIL
	goto :eof
)
echo [1/6] Install: Chocolatey = PASS

set VS=
set "vswhere=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if exist "%vswhere%" for /f "tokens=*" %%i in ('"%vswhere%" -latest -find VC') do set "VS=%%i"

if "%VS%"=="" (
	echo Installing Visual Studio ...
	choco install visualstudio2019community -y -r
	if errorlevel 1 goto :eof
	choco install visualstudio2019-workload-nativedesktop -y -r
	if errorlevel 1 goto :eof
	choco install windowsdriverkit10 -y -r
	if errorlevel 1 goto :eof
)
