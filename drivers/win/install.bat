@echo off
echo Installing Arduino v0.23 drivers...
pushd "%~dp0"
IF "%PROCESSOR_ARCHITECTURE%"=="" set PROCESSOR_ARCHITECTURE=x86
.\DPInst_%PROCESSOR_ARCHITECTURE%.exe /LM %*
popd
