test_info=test_setup();
delete(instrfindall);
myBattery=Battery('BMSino');
myBattery.COMinit(test_info.BMSino_BaudRate, test_info.BMSino_SerialPort);

figure
h = animatedline;
ax = gca;
ax.YGrid = 'on';
ax.YLim = [65 85];

stop = false;
startTime = datetime('now');
while ~stop
    % Read current voltages value
    myBattery.getVoltages
    myBattery.getTemperatures
    temp = max(myBattery.CellsTemperatures);
    
    % Get current time
    t =  datetime('now') - startTime;
    
    % Add points to animation
    addpoints(h,datenum(t),myBattery.TotalVoltage)
    % Update axes
    ax.XLim = datenum([t-seconds(15) t]);
    datetick('x','keeplimits')
    drawnow
    % Check stop condition
    if input('\n')== 1
        stop = 1;
    end
end	  
myBattery.getVoltages

myBattery.getTemperatures

%myBattery.setBalancingStatus([1 0 0 0 0 0 0 0])

myBattery.getBalancingStatus

%myBattery.setBalancingStatus([1 0 0 0 0 0 0 0])

myBattery.getBMSTemperature
