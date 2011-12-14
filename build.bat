@echo off
rem ---------------------------------------------------------------------------
rem build.bat - Win32 Build Script for the NISP
rem
rem ---------------------------------------------------------------------------

rem ----- Verify and Set Required Environment Variables -----------------------

if not "%NISP_HOME%" == "" goto gotAntHome
set NISP_HOME=.

:gotAntHome
@cd %NISP_HOME%

set FIRSTJAR=%NISP_HOME%\lib\xercesImpl-2.11.0.jar

call %NISP_HOME%\bin\ant -lib %FIRSTJAR% %1 %2 %3 %4 %5 %6 %7 %8 %9

