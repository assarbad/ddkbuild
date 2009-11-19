@echo off
set DDK_DIRBASE=C:\WINDDK
set DDK_CONFIGS=checked chk free fre
set ADDITIONAL_PARAMS=-cZ
set TEMPDIRBASE=.\loctmp
set DDKBUILD_CMD=ddkbuild.cmd
set TESTSOURCES=.\testsrc\*

:: Calls the tests for each base directory variable
for %%i in (WXPBASE XPBASE WNETBASE WLHBASE W7BASE WIN7BASE) do @(
  call :SET_TESTCASES %%i
)
:: We're done here, below are subroutines only
goto :EOF

:: Sets the variables that control what to run
:SET_TESTCASES
setlocal ENABLEEXTENSIONS
set BASEDIRVAR=%~1
:: Unlike call, this goto will fail if the label can't be found
goto :%BASEDIRVAR%
:WXPBASE
:XPBASE
set TEST_TARGETS=WXP XP WXP64 WXPI64 XP64 WXP2K XPW2K
set TEST_DIRS=2600 2600.1106
goto :ENDOF_SET_TESTCASES
:WNETBASE
set TEST_TARGETS=WNET WNET64 WNETI64 WNETXP WNETXP64 WNETAMD64 WNETX64 WNETA64 WNET2K WNETW2K
set TEST_DIRS=3790 3790.1830
goto :ENDOF_SET_TESTCASES
:WLHBASE
set TEST_TARGETS=WLH WLH2K WLHXP WLHXP64 WLHNET WLHNETI64 WLHNET64 WLHNETX64 WLHNETA64 WLHI64 WLH64 WLHX64 WLHA64
set TEST_DIRS=6000 6001.18000 6001.18001 6001.18002
goto :ENDOF_SET_TESTCASES
:W7BASE
:WIN7BASE
set TEST_TARGETS=W7 WIN7 W7I64 WIN764 W7X64 WIN7A64 W7LH WIN7WLH W7LHI64 WIN7WLH64 W7LHX64 WIN7WLHA64 W7NET WIN7NET W7NETI64 WIN7NET64 W7NETX64 WIN7NETA64 W7XP WIN7XP
set TEST_DIRS=7600.16385.0
:ENDOF_SET_TESTCASES
call :RUN_TEST_BY_DDKDIR "%BASEDIRVAR%" "%TEST_TARGETS%" "%TEST_DIRS%"
endlocal & goto :EOF

:: Calls the function with configuration for each individual test
:: RUN_TEST_BY_DDKDIR <BASEDIRVAR> <TARGET+> <DDKDIR+>
:RUN_TEST_BY_DDKDIR
setlocal ENABLEEXTENSIONS
set BASEDIRVAR=%~1
set TEST_TARGETS=%~2
set TEST_DIRS=%~3
for %%j in (%TEST_DIRS%) do @(
  for %%k in (%TEST_TARGETS%) do @(
    for %%l in (%DDK_CONFIGS%) do @(
      call :RUN_ONE_TEST "%BASEDIRVAR%" "%DDK_DIRBASE%\%%j" "%%k" "%%l"
    )
  )
)
endlocal & goto :EOF

:: Calls an actual build with the properly assembled parameters
:: RUN_ONE_TEST <%BASEDIRVAR%> <DDKDIR> <TARGET> <CONFIG>
:RUN_ONE_TEST
setlocal ENABLEEXTENSIONS
:: Set base directory for the DDK
set %~1=%~2
set TEMPDIR=%TEMPDIRBASE%\%~1_%~3
:: Create and fill temporary directory with local DDKBUILD and the sources to compile
md "%TEMPDIR%" > NUL 2>&1
xcopy /y ".\%DDKBUILD_CMD%" "%TEMPDIR%\" > NUL 2>&1
xcopy /y "%TESTSOURCES%" "%TEMPDIR%\" > NUL 2>&1
:: Switch to the folder, call local DDKBUILD copy, switch back
pushd "%TEMPDIR%" > NUL 2>&1
echo call .\%DDKBUILD_CMD% -%~3 %~4 . %ADDITIONAL_PARAMS% > NUL 2>&1
if not (%ERRORLEVEL%) == (0) @(
  echo SUCCESS: %~1=%~2 for %~3
) else @(
  echo ERROR: %~1=%~2 for %~3
)
popd > NUL 2>&1
endlocal & goto :EOF
