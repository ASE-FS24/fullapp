@echo off

rem Args
set BRANCH=%1%
if "%BRANCH%"=="" set BRANCH=main

rem Variables - Color
set "RED=\033[1;31m"
set "GREEN=\033[1;32m"
set "NOCOLOR=\033[0m"

echo.

echo Step 1: %GREEN%checking dependencies%NOCOLOR%

rem List of executables to check
set "executables=docker mvn git"

rem Checks if every executable is installed
for %%i in (%executables%) do (
    where %%i >nul 2>nul
    if errorlevel 1 (
        echo %%i could not be found
        exit /b 1
    )
)

echo All executables are installed

echo.

echo Step 2: %GREEN%cloning repositories%NOCOLOR%

set "repos=https://github.com/ASE-FS24/user-manager https://github.com/ASE-FS24/post-manager https://github.com/ASE-FS24/frontend"

for %%r in (%repos%) do (
    git clone -b %BRANCH% "%%r"
)

echo All repositories cloned

echo.

echo Step 3: %GREEN%compiling user-manager%NOCOLOR%

cd user-manager
mvn -B package -DfinalName=usermanager -DskipTests --file pom.xml

cd ..

echo Compiled user-manager

echo.

echo Step 4: %GREEN%compiling post-manager%NOCOLOR%

cd post-manager
mvn -B package -DfinalName=postmanager -DskipTests --file pom.xml
cd ..

echo Compiled post-manager

echo Step 5: %GREEN%copying scripts%NOCOLOR%

mkdir scripts

for /r frontend %%f in (*.sh) do (
    copy "%%f" scripts\frontend-"%%~nxf"
)
for /r user-manager %%f in (*.sh) do (
    copy "%%f" scripts\user-manager-"%%~nxf"
)
for /r post-manager %%f in (*.sh) do (
    copy "%%f" scripts\post-manager-"%%~nxf"
)

echo.

echo %GREEN%Done.%NOCOLOR% You can now run the docker-compose file to start the application.
