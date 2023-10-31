echo off

Set dir=%~dp0

set vswhere=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe
if exist "%vswhere%" for /f "tokens=*" %%i in ('"%vswhere%" -latest -find VC') do (
	set vcvars=%%i\Auxiliary\Build\vcvarsall.bat
)

if "%vcvars%"=="" (
 echo:
 echo:
 echo ***FAILURE***  ***FAILURE***  ***FAILURE***  ***FAILURE***  ***FAILURE***
 echo:
 echo     Visual Studio not found in the system.
 echo:
 goto :EOF
)

call "%vcvars%" x86_amd64

:MSBUILD
msbuild.exe "%dir%netuio\netuio.sln" /t:rebuild /p:Configuration="release" /p:Platform="x64" /p:signmode="off" /p:TrackFileAccess="false"

:BUILD_CHECK
set build_status=%ERRORLEVEL%

if not %build_status%==0 (

 echo:
 echo:
 echo ***FAILURE***  ***FAILURE***  ***FAILURE***  ***FAILURE***  ***FAILURE***
 echo:
 echo     Failed to build netuio Solution. Check specific log more info.
 echo:
 goto :EOF

 )
 
:MSBUILD
msbuild.exe "%dir%virt2phys\virt2phys.sln" /t:rebuild /p:Configuration="release" /p:Platform="x64" /p:signmode="off" /p:TrackFileAccess="false"

:BUILD_CHECK
set build_status=%ERRORLEVEL%

if not %build_status%==0 (

 echo:
 echo:
 echo ***FAILURE***  ***FAILURE***  ***FAILURE***  ***FAILURE***  ***FAILURE***
 echo:
 echo     Failed to build virt2phys Solution. Check specific log more info.
 echo:
 goto :EOF

 ) 