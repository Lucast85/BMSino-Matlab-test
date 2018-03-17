close all
clear all
clc


%% Define BMSino and DC/DC objects
delete(instrfindall);
global test_info
global mv_CELLS_SETPOINT;
mv_CELLS_SETPOINT = [3915 3810 3900 3826 3820 3815];
test_info = test_setup();

%% Define the timer object
% specifies the properties of the timer object
t = timer('StartDelay', 0, 'Period', 1, 'TasksToExecute', inf,...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TimerFcn',@T1_Trig_Fcn,...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);

%% Timer trigger
function T1_Trig_Fcn(obj, event)

% T1_trig_Fcn

    global test_info;
    global mv_CELLS_SETPOINT;

    % static variable. t_idx is the number of times the trigger function is
    % called
    persistent t_idx
    if isempty(t_idx)
        t_idx = 0;
    end
    t_idx = t_idx + 1;
    
    % Initialize errors
    test_error.high_cell_voltage = NaN;
    test_error.low_cell_voltage = NaN;
    test_error.high_battery_current = NaN;
    test_error.high_cell_temperature = NaN;
    test_error.low_cell_temperature = NaN;
    test_error.high_BMS_temperature = NaN;
    
%% STATE 1
    % Save actual time
    test_info.time(t_idx) = round(toc,1);
        
% Disable all balancing mosfets (it's mandatory to accurately measure the
% cell voltages)
    test_info.BMSino.setBalancingStatus([0 0 0 0 0 0]);
    
% Measure cell temperatures
    test_info.BMSino.getTemperatures();
    test_info.CellTemperatures(:,t_idx) = test_info.BMSino.CellsTemperatures(:);
    
% Measure BMS temperature
    test_info.BMSino.getBMSTemperature();	
    test_info.BMSTemperature(t_idx) = test_info.BMSino.BMSTemperature;

% Measure battery current
    %test_info.B3603.getStatus();
%     test_info.BatteryCurrent(t_idx) = test_info.B3603.DCDCoutputCurrent;
%     % test_info.BMSino.getCurrent(); %does not work now!
    
% Finally wait 50 ms, measure cell voltages and compute battery voltage
    pause(0.05);
    test_info.BMSino.getVoltages();
    test_info.CellVoltage(:, t_idx) = test_info.BMSino.CellsVoltages(:);
    test_info.BatteryVoltage(t_idx) = test_info.BMSino.TotalVoltage;
    
   
%% SECURITY CONTROL
    % update error structure
    if(max(test_info.CellVoltage(:, t_idx)) > test_info.BMSino.MAX_SECURITY_CELL_VOLTAGE)
        test_error.high_cell_voltage = max(test_info.CellVoltage(:, t_idx));
    else
        test_error.high_cell_voltage = NaN;
    end
    if(min(test_info.CellVoltage(:, t_idx)) < test_info.BMSino.MIN_CELL_VOLTAGE)
        test_error.low_cell_voltage = min(test_info.CellVoltage(:, t_idx));
    else
        test_error.low_cell_voltage = NaN;
    end
    if(max(test_info.BatteryCurrent(t_idx)) > test_info.BMSino.MAX_CH_CURRENT)
        test_error.high_battery_current = max(test_info.BatteryCurrent(t_idx));
    else
        test_error.high_battery_current = NaN;
    end
    if(max(test_info.BMSTemperature(t_idx)) > test_info.BMSino.MAX_BMS_TEMPERATURE)
        test_error.high_BMS_temperature = max(BMSTemperature(t_idx));
    else
        test_error.high_BMS_temperature = NaN;
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
        toWriteCellBalancingStatus = zeros(1,test_info.CELLS_NUMBER);
        for i=1:test_info.CELLS_NUMBER
            if test_info.CellVoltage(i, t_idx) >= mv_CELLS_SETPOINT(i)
                % it's time to balance the i-th cell!
                toWriteCellBalancingStatus(1,i) = 1;
            else
                % switch off the balancing mosfet on i-th cell
                toWriteCellBalancingStatus(1,i) = 0;
            end
        end

        % write balancing mask to BMSino
        test_info.BMSino.setBalancingStatus(toWriteCellBalancingStatus(1,:));

%     %% STATE 4
%         % check balancing status vector
%         test_info.BMSino.getBalancingStatus;
%         test_info.CellBalancingStatus(:, t_idx) = test_info.BMSino.CellsBalancingStatus;
%         if ~isequal(test_info.CellBalancingStatus(:, t_idx), toWriteCellBalancingStatus)
%              disp('error during writing of balancing status register');
%         end

    
    else %actuate security features: stop all
        % stop charge (open relay)
        test_info.BMSino.setBalancingStatus([0 0 0 0 0 0]);
        % stop balancing
        test_info.B3603.setOutput(0);
        
        
        test_info.B3603.getStatus();
        disp(test_info.B3603.DCDCoutputEnabled)
        if(strcmp(test_info.B3603.DCDCoutputEnabled, 'OFF'))
        fprintf('CHARGING DISABLED\n')
        end
        
        %update Battery Current value
        test_info.time(t_idx) = round(toc,1);
        test_info.BatteryCurrent(t_idx) = test_info.B3603.DCDCoutputCurrent;        
        
        
        % Display error message!
        if(isnan(test_error.high_cell_voltage) == 0)
            fprintf('too high cell voltage (%1.3f)\n', test_error.high_cell_voltage)
        end
        if(isnan(test_error.low_cell_voltage) == 0)
            fprintf('too low cell voltage (%1.3f)\n', test_error.low_cell_voltage)
        end
        if(isnan(test_error.high_battery_current) == 0)
            fprintf('too high battery current (%1.3f)\n', test_error.high_battery_current)
        end
        if(isnan(test_error.high_cell_temperature) == 0)
            fprintf('too high cell temperature (%3.1f)\n', test_error.high_cell_temperature)
        end
        if(isnan(test_error.low_cell_temperature) == 0)
            fprintf('too low cell temperature (%3.1f)\n', test_error.low_cell_temperature)
        end
        if(isnan(test_error.high_BMS_temperature) == 0)
            fprintf('too high BMS temperature (%3.1f)\n', test_error.high_BMS_temperature)
        end 
    end

end
%% Timer Error
function T1_Err_Fcn(obj, event, text_arg)
% T1_Err_Fcn
    delete(instrfindall);
    disp('in T1_Err_Fcn function')
end
%% Timer Start
function T1_Start_Fcn(obj, event, text_arg)
% T1_Start_Fcn
    disp('Initialization of instruments');
    tic % start stopwatch timer
end
%% Timer Stop
function T1_Stop_Fcn(obj, event, text_arg)
% T1_Stop_Fcn
    global test_info
    test_info.B3603.setOutput(0);
    pause(0.01);
    test_info.BMSino.setBalancingStatus([0 0 0 0 0 0]);
    
    delete(instrfindall);
    disp('in T1_Stop_Fcn function')
    disp('Total running time is: ')
    disp(round(toc,1))
end

