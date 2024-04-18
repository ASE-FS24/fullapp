@echo off

rem Args
set BRANCH=%1%
if "%BRANCH%"=="" set BRANCH=main

echo.

echo Step 1: checking dependencies

rem List of executables to check
set "executables=docker git mvn"

rem Checks if every executable is installed
for %%i in (%executables%) do (
    where %%i | findstr . >nul || (
        echo %%i could not be found
        exit /b 1
    )
)

echo All executables are installed

echo.

echo Step 2: cloning repositories

set "repos=https://github.com/ASE-FS24/user-manager https://github.com/ASE-FS24/post-manager https://github.com/ASE-FS24/frontend"

for %%r in (%repos%) do (
    git clone -b %BRANCH% "%%r"
)

echo All repositories cloned

echo.

echo Step 3: compiling user-manager

cd user-manager
mvn -B package -DfinalName=usermanager -DskipTests --file pom.xml

cd ..

echo Compiled user-manager

echo.

echo Step 4: compiling post-manager

cd post-manager
mvn -B package -DfinalName=postmanager -DskipTests --file pom.xml
cd ..

echo Compiled post-manager

echo Step 5: copying scripts

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

echo Done. You can now run the docker-compose file to start the application.
