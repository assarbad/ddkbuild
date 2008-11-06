@echo off
echo ================ Build warnings =======================
if exist "fstrtest.txt" for /f "tokens=*" %%x in ('findstr "warning[^.][CDMRU][0-9][0-9]* warning[^.][BRP][KCWG][0-9][0-9]* warning[^.][ACLPS][DNRTVX][JKLTX][0-9][0-9]* error[^.][CDMRU][0-9][0-9]* error[^.][BRP][KCWG][0-9][0-9]* error[^.][ACLPS][DNRTVX][JKLTX][0-9][0-9]*" "fstrtest.txt"') do @(
  @echo %%x
)

goto :EOF

BK0000
C000
C0000
CXX0000
D0000
M0000
U0000
R0000
CRT0000
RC0000
RW0000
CVT0000
LNK0000
PG0000
PRJ0000
ATL0000
SDL0000
