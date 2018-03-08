clear all
clc
delete(instrfindall);

test_info=test_setup();
test_info.BMSino.getBalancingStatus
test_info.BMSino.getBMSTemperature	
test_info.BMSino.getTemperatures
test_info.BMSino.getVoltages

% myBattery=Battery('BMSino');
% myBattery.COMinit(test_info.BMSINO_BAUDRATE, test_info.BMSINO_SERIALPORT);

% figure
% h = animatedline;
% ax = gca;
% ax.YGrid = 'on';
% ax.YLim = [65 85];

% stop = false;
% startTime = datetime('now');
% while ~stop
%     % Read current voltages value
%     myBattery.getVoltages
%     myBattery.getTemperatures
%     temp = max(myBattery.CellsTemperatures);
%     
%     % Get current time
%     t =  datetime('now') - startTime;
%     
%     % Add points to animation
%     addpoints(h,datenum(t),myBattery.TotalVoltage)
%     % Update axes
%     ax.XLim = datenum([t-seconds(15) t]);
%     datetick('x','keeplimits')
%     drawnow
%     % Check stop condition
%     if input('\n')== 1
%         stop = 1;
%     end
% end	  
%myBattery.getVoltages
% 
% myBattery.getTemperatures
% 
% %myBattery.setBalancingStatus([1 0 0 0 0 0 0 0])
% 
% myBattery.getBalancingStatus
% 
% %myBattery.setBalancingStatus([1 0 0 0 0 0 0 0])
% 
% myBattery.getBMSTemperature
