@ECHO off
GOTO start
:find_dp0
SET dp0=%~dp0
EXIT /b
:start
SETLOCAL
CALL :find_dp0

endLocal & goto #_undefined_# 2>NUL || title %COMSPEC% & "C:\Users\ASUS\AppData\Local\nvim-data\mason\packages\rust_hdl\vhdl_ls-x86_64-pc-windows-msvc/bin/vhdl_ls.exe" %*