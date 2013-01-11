@echo off
echo chargement du profile I-TOOLS sur Windows

set SAMPLE=%CD%/t/sample

set TOOLS_HOME=%SAMPLE%
set PATH=%PATH%;%SAMPLE%/bin
set BV_DEFPATH=%SAMPLE%/def
set BV_TABPATH=%SAMPLE%/tab
set BV_PCIPATH=%SAMPLE%/pci


set BV_LOGFILE=%SAMPLE%/log/ITstd.log
set BV_LOGERR=%SAMPLE%/log/ITerr.log

set TESTVAR=variable evaluee

set IT20_COMPLIANT=1
