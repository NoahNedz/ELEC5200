@echo off
set bin_path=C:\Aldec\Active-HDL-10.5a\bin
call "%bin_path%/avhdl" -do "do -tcl {main_compile.do}"
set error=%errorlevel%
copy /Y "H:\Documents\5200Projects\project_1\project_1.sim\sim_1\behav\activehdl\project_1\log\console.log" "compile.log"
set errorlevel=%error%
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
