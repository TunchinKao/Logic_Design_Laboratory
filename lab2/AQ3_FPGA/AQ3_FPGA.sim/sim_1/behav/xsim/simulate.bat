@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1.1 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Mon Oct 05 19:36:10 +0800 2020
REM SW Build 2960000 on Wed Aug  5 22:57:20 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
echo "xsim Lab2_TeamX_Carry_Look_Ahead_t_behav -key {Behavioral:sim_1:Functional:Lab2_TeamX_Carry_Look_Ahead_t} -tclbatch Lab2_TeamX_Carry_Look_Ahead_t.tcl -log simulate.log"
call xsim  Lab2_TeamX_Carry_Look_Ahead_t_behav -key {Behavioral:sim_1:Functional:Lab2_TeamX_Carry_Look_Ahead_t} -tclbatch Lab2_TeamX_Carry_Look_Ahead_t.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
