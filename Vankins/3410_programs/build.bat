@echo off
cls

set EXE_NAME=vankins
del %EXE_NAME%.exe
del %EXE_NAME%.obj
del %EXE_NAME%.lst
del %EXE_NAME%.ilk
del %EXE_NAME%.pdb

set DRIVE_LETTER=%1:
set PATH=%DRIVE_LETTER%\Interpolating\bin;c:\Windows;c:\Windows\system32
set INCLUDE=%DRIVE_LETTER%\Interpolating\include
set LIB_DIRS=%DRIVE_LETTER%\Interpolating\lib
set LIBS=sqrt.obj

ml -Zi -c -coff -Fl %EXE_NAME%.asm
link /libpath:%LIB_DIRS% %EXE_NAME%.obj %LIBS% io.obj kernel32.lib /debug /out:%EXE_NAME%.exe /subsystem:console /entry:start
%EXE_NAME% < vankins_in_6_7.txt