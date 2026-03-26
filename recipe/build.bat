@echo off
REM Windows build script for rnnoise using autotools_clang_conda

REM Model files are now extracted directly to src/ directory
REM (no need to copy since target_directory was removed from recipe.yaml)

REM Set environment variables for Windows library naming
set REMOVE_LIB_PREFIX=1

REM Ensure host environment directories exist to prevent find command errors
if not exist "%PREFIX%\Library\lib" mkdir "%PREFIX%\Library\lib"
if not exist "%PREFIX%\Library\include" mkdir "%PREFIX%\Library\include"
if not exist "%PREFIX%\Library\bin" mkdir "%PREFIX%\Library\bin"

REM Call the autotools clang conda build wrapper
call "%BUILD_PREFIX%\Library\bin\run_autotools_clang_conda_build.bat" build.sh
if %ERRORLEVEL% neq 0 exit 1

REM Install renamenoise.pc alias for mumble-voip compatibility.
REM mumble's CMake calls find_pkg(renamenoise) which falls back to
REM pkg_search_module for a module named "renamenoise", not "rnnoise".
if not exist "%PREFIX%\Library\lib\pkgconfig" mkdir "%PREFIX%\Library\lib\pkgconfig"
powershell -Command "(Get-Content '%RECIPE_DIR%\renamenoise.pc') -replace '@VERSION@', '%PKG_VERSION%' | Set-Content '%PREFIX%\Library\lib\pkgconfig\renamenoise.pc'"
if %ERRORLEVEL% neq 0 exit 1
