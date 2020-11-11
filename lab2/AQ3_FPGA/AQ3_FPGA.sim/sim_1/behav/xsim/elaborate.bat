@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Mon Oct 05 19:36:08 +0800 2020
REM SW Build 2960000 on Wed Aug  5 22:57:20 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 98c81cfe24b046a7a9eba4ca109400d4 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot Lab2_TeamX_Carry_Look_Ahead_t_behav xil_defaultlib.Lab2_TeamX_Carry_Look_Ahead_t xil_defaultlib.glbl -log elaborate.log"
call xelab  -wto 98c81cfe24b046a7a9eba4ca109400d4 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot Lab2_TeamX_Carry_Look_Ahead_t_behav xil_defaultlib.Lab2_TeamX_Carry_Look_Ahead_t xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
