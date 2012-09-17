@echo off
echo Installing Arduino v0.23 drivers...
set DPINST=DPInst.exe
IF "%PROCESSOR_ARCHITECTURE%"=="" set PROCESSOR_ARCHITECTURE=x86
pushd "%~dp0"
IF not exist %DPINST% set DPINST=DPInst_%PROCESSOR_ARCHITECTURE%.exe
.\%DPINST% /LM /SA /SW %*
popd
