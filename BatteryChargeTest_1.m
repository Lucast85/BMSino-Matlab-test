clear all
clc
%% Figure, axes and animated lines
figure
ax = gca;
ax.YGrid = 'on';
ax.XGrid = 'on';
ax.XLabel.String = 'Time';
yyaxis left
ax.YLabel.String = 'YLabel left';
yyaxis right
ax.YLabel.String = 'ylabel right';

% define the handles of the animated lines to plot data in real time
hAnimLinesV.CellVoltage1 = animatedline;
hAnimLinesV.CellVoltage2 = animatedline;
hAnimLinesV.CellVoltage3 = animatedline;
hAnimLinesV.CellVoltage4 = animatedline;
hAnimLinesV.CellVoltage5 = animatedline;
hAnimLinesV.CellVoltage6 = animatedline;

hAnimLinesBS.CellBalSts1 = animatedline;
hAnimLinesBS.CellBalSts2 = animatedline;
hAnimLinesBS.CellBalSts3 = animatedline;
hAnimLinesBS.CellBalSts4 = animatedline;
hAnimLinesBS.CellBalSts5 = animatedline;
hAnimLinesBS.CellBalSts6 = animatedline;

hAnimLinesT.CellTemperature1 = animatedline;
hAnimLinesT.CellTemperature2 = animatedline;
hAnimLinesT.CellTemperature3 = animatedline;
hAnimLinesT.CellTemperature4 = animatedline;
hAnimLinesT.CellTemperature5 = animatedline;
hAnimLinesT.CellTemperature6 = animatedline;
hAnimLinesT.BMSTemperature = animatedline;

hAnimLinesC.BatteryCurrent = animatedline;

%% Define BMSino and DC/DC objects
delete(instrfindall);
test_info=test_setup();

%% Define the timer object

% specifies the properties of the timer object
t = timer('StartDelay', 5, 'Period', 1, 'TasksToExecute', inf, ...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TickFcn',{@T1_Trig_Fcn, hAnimLinesV, hAnimLinesT, hAnimLinesC, test_info },...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);
      
%% Timer trigger
function T1_Trig_Fcn(hAnimLinesV, hAnimLinesT, hAnimLinesC, hAnimLinesBS, test_info)
% T1_trig_Fcn
%     disp('in T1_Trig_Fcn function')
%     disp(round(toc,1))

    % Initialize errors
    test_error.high_cell_voltage = NaN;
    test_error.low_cell_voltage = NaN;
    test_error.high_battery_current = NaN;
    test_error.high_cell_temperature = NaN;
    test_error.low_cell_temperature = NaN;
    test_error.high_BMS_temperature = NaN;
   
    % static variable. t_idx is the number of times the trigger function is
    % called
    persistent t_idx
    if isempty(t_idx)
        t_idx = 0;
    end 
    t_idx = t_idx + 1;
    
%% STATE 1
% Save actual time
    test_info.time(t_idx) = toc;
        
% Disable all balancing mosfets (it's mandatory to accurately measure the 
    test_info.BMSino.setBalancingStatus(00000000);
    
% Measure cell temperatures
    test_info.BMSino.getTemperatures();
    test_info.Celltemperatures(:,t_idx) = test_info.BMSino.CellsTemperatures(:);
    
% Measure BMS temperature
    test_info.BMSino.getTemperatures();
    test_info.BMSTemperature(t_idx) = test_info.BMSino.BMSTemperature;

% Measure battery current
    test_info.B3606.getStatus();
    test_info.BatteryCurrent(t_idx) = test_info.B3603.DCDCoutputCurrent;
    % test_info.BMSino.getCurrent(); %does not work now!
    
% Finally wait 50 ms, measure cell voltages and compute battery voltage
    pause(0.05);
    test_info.BMSino.getVoltages();
    test_info.CellVoltage(:, t_idx) = test_info.BMSino.CellsVoltages(:);
    test_info.BatteryVoltage(t_idx) = test_info.BMSino.TotalVoltage;
    
%% SECURITY CONTROL
    % update error structure
    if(max(test_info.CellVoltage(:, t_idx)) > test_info.BMSino.MAX_CELL_VOLTAGE)
        test_error.high_cell_voltage = max(test_info.CellVoltage(:, t_idx));
    end
    if(min(test_info.CellVoltage(:, t_idx)) < test_info.BMSino.MIN_CELL_VOLTAGE)
        test_error.low_cell_voltage = min(test_info.CellVoltage(:, t_idx));
    end
    if(max(test_info.BatteryCurrent(t_idx)) > test_info.BMSino.STD_CH_CURRENT)
        test_error.high_battery_current = max(test_info.BatteryCurrent(t_idx));
    end
    if(max(test_info.CellTemperatures(:,t_idx)) > test_info.BMSino.MAX_CELL_TEMPERATURE)
        test_error.high_cell_temperature = max(test_info.CellTemperatures(:,t_idx));
    end
    if(min(test_info.CellTemperatures(:,t_idx)) < test_info.BMSino.MIN_CELL_TEMPERATURE)
        test_error.low_cell_temperature = min(test_info.CellTemperatures(:,t_idx));
    end
    if(max(BMSTemperature(t_idx)) > test_info.BMSino.MAX_BMS_TEMPERATURE)
        test_error.high_BMS_temperature = max(BMSTemperature(t_idx));
    end

    
    % check for errors. If not, execute the test.
    if(isnan(test_error.high_cell_voltage) &&...
        isnan(test_error.low_cell_voltage) &&...
        isnan(test_error.high_battery_current) &&...
        isnan(test_error.high_cell_temperature) &&...
        isnan(test_error.low_cell_temperature) &&...
        isnan(test_error.high_BMS_temperature))
    %% STATE 2
    % Compute & apply balancing mask
        % compute balancing mask
        toWriteCellBalancingStatus = zeros(test_info.CELLS_NUMBER);
        for i=0:test_info.CELLS_NUMBER
            if test_info.CellVoltage(i, t_idx) >= test_info.BMSino.CELL_VOLTAGE_START_BALANCING
                % it's time to balance the i-th cell!
                toWriteCellBalancingStatus(i) = 1;
            else
                % switch off the balancing mosfet on i-th cell
                toWriteCellBalancingStatus(i) = 0;
            end
        end

        % write balancing mask to BMSino
        test_info.BMSino.setBalancingStatus(toWriteCellBalancingStatus(i));

    %% STATE 3
    % Estimate current charge setpoint
        HighestCellVoltage = max(test_info.CellVoltage(:, t_idx));
        ChSetPoint = SetPoint_Estimation(test_info.BMSino, HighestCellVoltage);
        fprintf('esitimated current setpoint is: %1.3f\n', ChSetPoint);
        ChSetPoint = 0;
        
    %% STATE 4
        % check balancing status vector
        test_info.CellBalancingStatus = test_info.BMSino.getBalancingStatus;
        if test_info.CellBalancingStatus ~= toWriteCellBalancingStatus
             disp('error during writing of balancing status register');
        end

    %% STATE 5
    %  Apply the current setpoint already estimated
        test_info.B3606.setCurrent(ChSetPoint);
        if(~test_info.B3603.DCDCoutputEnabled)
            test_info.B3606.setOutput(1);
        end

    else %actuate security features: stop all
        % stop charge (open relay)
        test_info.B3606.setOutput(0);
        test_info.B3603.DCDCoutputEnabled();
        
        % stop balancing
        test_info.BMSino.setBalancingStatus([0 0 0 0 0 0]);
        % Display error message!
        if(test_error.high_cell_voltage)
            fprintf('too high cell voltage (%1.3f)\n', test_error.high_cell_voltage)
        end
        if(test_error.low_cell_voltage)
            fprintf('too low cell voltage (%1.3f)\n', test_error.low_cell_voltage)
        end
        if(test_error.high_battery_current)
            fprintf('too high battery current (%1.3f)\n', test_error.high_battery_current)
        end
        if(test_error.high_cell_temperature)
            fprintf('too high cell temperature (%3.1f)\n', test_error.high_cell_temperature)
        end
        if(test_error.low_cell_temperature)
            fprintf('too low cell temperature (%3.1f)\n', test_error.low_cell_temperature)
        end
        if(test_error.high_BMS_temperature)
            fprintf('too high BMS temperature (%3.1f)\n', test_error.high_BMS_temperature)
        end 
    end
%% STATE 6
% plot all values in real-time
    
    % Plot in real time the cells values
    % Cells voltage
    addpoints(hAnimLinesV.CellVoltage1, test_info.time(t_idx), test_info.CellVoltage(1,t_idx))
    addpoints(hAnimLinesV.CellVoltage2, test_info.time(t_idx), test_info.CellVoltage(2,t_idx))
    addpoints(hAnimLinesV.CellVoltage3, test_info.time(t_idx), test_info.CellVoltage(3,t_idx))
    addpoints(hAnimLinesV.CellVoltage4, test_info.time(t_idx), test_info.CellVoltage(4,t_idx))
    addpoints(hAnimLinesV.CellVoltage5, test_info.time(t_idx), test_info.CellVoltage(5,t_idx))
    addpoints(hAnimLinesV.CellVoltage6, test_info.time(t_idx), test_info.CellVoltage(6,t_idx))
    % Cells balancing status
    addpoints(hAnimLinesBS.CellBalSts1, test_info.time(t_idx), test_info.CellBalancingStatus(1,t_idx))
    addpoints(hAnimLinesBS.CellBalSts2, test_info.time(t_idx), test_info.CellBalancingStatus(2,t_idx))
    addpoints(hAnimLinesBS.CellBalSts3, test_info.time(t_idx), test_info.CellBalancingStatus(3,t_idx))
    addpoints(hAnimLinesBS.CellBalSts4, test_info.time(t_idx), test_info.CellBalancingStatus(4,t_idx))
    addpoints(hAnimLinesBS.CellBalSts5, test_info.time(t_idx), test_info.CellBalancingStatus(5,t_idx))
    addpoints(hAnimLinesBS.CellBalSts6, test_info.time(t_idx), test_info.CellBalancingStatus(6,t_idx))
    % Cells temperature
    addpoints(hAnimLinesT.CellTemperature1, test_info.time(t_idx), test_info.CellTemperature(1,t_idx))
    addpoints(hAnimLinesT.CellTemperature2, test_info.time(t_idx), test_info.CellTemperature(2,t_idx))
    addpoints(hAnimLinesT.CellTemperature3, test_info.time(t_idx), test_info.CellTemperature(3,t_idx))
    addpoints(hAnimLinesT.CellTemperature4, test_info.time(t_idx), test_info.CellTemperature(4,t_idx))
    addpoints(hAnimLinesT.CellTemperature5, test_info.time(t_idx), test_info.CellTemperature(5,t_idx))
    addpoints(hAnimLinesT.CellTemperature6, test_info.time(t_idx), test_info.CellTemperature(6,t_idx))
    % BMS temperature
    addpoints(hAnimLinesT.BMSTemperature, test_info.time(t_idx), test_info.BMSTemperature)
    % Battery current
    addpoints(hAnimLinesC.BatteryCurrent, test_info.time(t_idx), test_info.BatteryCurrent)
    
    % Update axes
    %ax.XLim = time-50; % sembra non funzionare
    drawnow
end
%% Timer Error
function T1_Err_Fcn()
% T1_Err_Fcn
    disp('in T1_Err_Fcn function')
end
%% Timer Start
function T1_Start_Fcn()
% T1_Start_Fcn
    disp('Initialization of instruments');
    tic % start stopwatch timer
end
%% Timer Stop
function T1_Stop_Fcn()
% T1_Stop_Fcn
    disp('in T1_Stop_Fcn function')
    disp('Total running time is: ')
    disp(round(toc,1))
end

