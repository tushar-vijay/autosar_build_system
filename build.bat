@echo off
echo Select build type:
echo 1. Full build (delete build folder, reconfigure, rebuild everything)
echo 2. Clean build (clean outputs, do not reconfigure)
echo 3. Incremental build (build changed files only)
set /p option=Choose (1-3):

REM Helper: Configure if build folder doesn't exist
set need_config=false
IF NOT EXIST build (
    set need_config=true
)

REM FULL BUILD: delete build folder, reconfigure, build all
if "%option%"=="1" (
    echo Performing FULL build...
    IF EXIST build (
        rmdir /s /q build
    )
    cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_C_COMPILER=C:/MinGW/bin/gcc.exe
    IF ERRORLEVEL 1 (
        echo CMake configuration failed!
        exit /b 1
    )
    cmake --build build
    IF ERRORLEVEL 1 (
        echo Build failed!
        exit /b 1
    )
    echo Running executable...
    build\main_exec.exe
    pause
    exit /b
)

REM CLEAN BUILD: configure if needed, clean/rebuild
if "%option%"=="2" (
    echo Performing CLEAN build...
    IF "%need_config%"=="true" (
        echo Build directory not found, configuring project...
        cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_C_COMPILER=C:/MinGW/bin/gcc.exe
        IF ERRORLEVEL 1 (
            echo CMake configuration failed!
            exit /b 1
        )
    )
    cmake --build build --target clean
    IF ERRORLEVEL 1 (
        echo Clean failed!
        exit /b 1
    )
    cmake --build build
    IF ERRORLEVEL 1 (
        echo Build failed!
        exit /b 1
    )
    echo Running executable...
    build\main_exec.exe
    pause
    exit /b
)

REM INCREMENTAL BUILD: configure if needed, build only changed
if "%option%"=="3" (
    echo Performing INCREMENTAL build...
    IF "%need_config%"=="true" (
        echo Build directory not found, configuring project...
        cmake -S . -B build -G "MinGW Makefiles" -DCMAKE_C_COMPILER=C:/MinGW/bin/gcc.exe
        IF ERRORLEVEL 1 (
            echo CMake configuration failed!
            exit /b 1
        )
    )
    cmake --build build
    IF ERRORLEVEL 1 (
        echo Build failed!
        exit /b 1
    )
    echo Running executable...
    build\main_exec.exe
    pause
    exit /b
)

echo Invalid option!
pause