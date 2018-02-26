test_info=test_setup();
delete(instrfindall);
myDCDC=DCDC('B3603');
myDCDC.COMinit(test_info.DCDC_BaudRate, test_info.DCDC_SerialPort);

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

myDCDC.getStatus