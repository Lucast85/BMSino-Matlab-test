clear all
clc
delete(instrfindall);

test_info=test_setup();


test_info.B3603.setCurrent(245);
test_info.B3603.setOutput(1);

test_info.BatteryCurrent = test_info.B3603.DCDCoutputCurrent;


% myDCDC.getVoltage
% myDCDC.getCurrent
% 
% myDCDC.setVoltage(7.58);
% myDCDC.setOutput(1);
pause(2)
% myDCDC.setOutput(0);
% myDCDC.setCurrent
% myDCDC.setOutput
% myDCDC.setName
% myDCDC.setAutocommit