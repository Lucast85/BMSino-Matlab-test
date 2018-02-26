test_info=test_setup();
delete(instrfindall);
myBattery=Battery('BMSino');
myBattery.COMinit(test_info.BMSino_BaudRate, test_info.BMSino_SerialPort);

myBattery.getVoltages

myBattery.getTemperatures

%myBattery.setBalancingStatus([1 0 0 0 0 0 0 0])

myBattery.getBalancingStatus

%myBattery.setBalancingStatus([1 0 0 0 0 0 0 0])

myBattery.getBMSTemperature
