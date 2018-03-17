close all
clear all
clc


%% Define BMSino and DC/DC objects
delete(instrfindall);
global test_info
global mv_CELLS_SETPOINT;
mv_CELLS_SETPOINT = [4200 4200 4200 4200 3600 4200];
% [3915 3810 3900 3826 3820 3815];
test_info = test_setup();

%% Figure, axes and animated lines

% line colors
C1col=[0.6 0.3 0];
C2col=[0.6 0.6 0];
C3col=[0 0.6 0];
C4col=[0 0.6 0.6];
C5col=[0 0 0.6];
C6col=[0.6 0 0.6];
% line markers
C1mrk='none';
C2mrk='none';
C3mrk='none';
C4mrk='none';
C5mrk='none';
C6mrk='none';
% line styles
C1ls='-';
C2ls='-';
C3ls='-';
C4ls='-';
C5ls='-';
C6ls='-';

% Figure 1: Cell voltages vs. Battery current
hfig_CV = figure('Name','Cell voltages' );
ax_CV = gca;
title('Cell voltages vs. Battery current');
ax_CV.YGrid = 'on';
ax_CV.XGrid = 'on';
ax_CV.XLabel.String = 'Time [s]';
yyaxis left
ax_CV.YColor = 'black';
ax_CV.YLabel.String = 'Cell voltage [V]';
yyaxis right
ax_CV.YColor = 'red';
ax_CV.YLabel.String = 'Battery current [A]';

% define the handles of the animated lines to plot data in real time
hAnimLinesCV.BatteryCurrent = animatedline('Color','red');
legend('Battery Current')
yyaxis left
hAnimLinesCV.CellVoltage1 = animatedline('Color',C1col,'Marker',C1mrk,'LineStyle',C1ls);
hAnimLinesCV.CellVoltage2 = animatedline('Color',C2col,'Marker',C2mrk,'LineStyle',C2ls);
hAnimLinesCV.CellVoltage3 = animatedline('Color',C3col,'Marker',C3mrk,'LineStyle',C3ls);
hAnimLinesCV.CellVoltage4 = animatedline('Color',C4col,'Marker',C4mrk,'LineStyle',C4ls);
hAnimLinesCV.CellVoltage5 = animatedline('Color',C5col,'Marker',C5mrk,'LineStyle',C5ls);
hAnimLinesCV.CellVoltage6 = animatedline('Color',C6col,'Marker',C6mrk,'LineStyle',C6ls);
hAnimLinesCV.CellVoltage_h_limit = animatedline('Color',[0.5 0.5 0.5],'LineStyle',':');
hAnimLinesCV.CellVoltage_l_limit = animatedline('Color',[0.5 0.5 0.5],'LineStyle',':');
legend('Cell 1','Cell 2','Cell 3',...
    'Cell 4','Cell 5','Cell 6','Location', 'southwest');

% % plot the limits
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MAX_CH_CURRENT test_info.BMSino.MAX_CH_CURRENT],... % y
%     'r--','LineWidth',1.4); % properties 
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MAX_CELL_VOLTAGE test_info.BMSino.MAX_CELL_VOLTAGE],... % y
%     'b--'); % properties 
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MIN_CELL_VOLTAGE test_info.BMSino.MIN_CELL_VOLTAGE],... % y
%     'b--'); % properties 
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MAX_SECURITY_CELL_VOLTAGE test_info.BMSino.MAX_SECURITY_CELL_VOLTAGE],... % y
%     'b-.','LineWidth',1.4); % properties
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.CELL_VOLTAGE_START_BALANCING test_info.BMSino.CELL_VOLTAGE_START_BALANCING],... % y
%     'b-.','LineWidth',1.4); % properties

% % Figure 2: Cell temperatures vs. Battery current
% hfig_CT = figure('Name','Cell temperatures' );
% ax_CT = gca;
% title('Cell temperatures vs. Battery current');
% ax_CT.YGrid = 'on';
% ax_CT.XGrid = 'on';
% ax_CT.XLabel.String = 'Time [s]';
% yyaxis left
% ax_CT.YLabel.String = 'Cell temperature [°C]';
% ax_CT.YColor = 'blue';
% yyaxis right
% ax_CT.YLabel.String = 'Battery current [A]';
% ax_CT.YColor = 'red';
% 
% % define the handles of the animated lines to plot data in real time
% hAnimLinesCT.BatteryCurrent = animatedline('Color','r');
% yyaxis left
% hAnimLinesCT.CellTemperature1 = animatedline('Color','b');
% hAnimLinesCT.CellTemperature2 = animatedline('Color','b');
% hAnimLinesCT.CellTemperature3 = animatedline('Color','b');
% hAnimLinesCT.CellTemperature4 = animatedline('Color','b');
% hAnimLinesCT.CellTemperature5 = animatedline('Color','b');
% hAnimLinesCT.CellTemperature6 = animatedline('Color','b');

% % plot the limits
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MIN_CELL_TEMPERATURE test_info.BMSino.MIN_CELL_TEMPERATURE],... % y
%     'b--','LineWidth',1.4); % properties 
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MAX_CELL_TEMPERATURE test_info.BMSino.MAX_CELL_TEMPERATURE],... % y
%     'b--','LineWidth',1.4); % properties 


% Figure 3: BMS temperature vs. Battery current
hfig_BMST = figure('Name','BSM temperature' );
ax_BMST = gca;
title('BMS temperature vs. Battery current');
ax_BMST.YGrid = 'on';
ax_BMST.XGrid = 'on';
ax_BMST.XLabel.String = 'Time [s]';
yyaxis left
ax_BMST.YLabel.String = 'BMS temperature [°C]';
ax_BMST.YColor = 'blue';
yyaxis right
ax_BMST.YLabel.String = 'Battery current [A]';
ax_BMST.YColor = 'red';
% define the handles of the animated lines to plot data in real time

hAnimLinesBMST.BatteryCurrent = animatedline('Color','r');
yyaxis left
hAnimLinesBMST.BMSTemperature_h_limit = animatedline('Color','b','LineStyle',':');
hAnimLinesBMST.BMSTemperature = animatedline('Color','b');

% % plot the limits
% plot([1 test_info.MAX_TEST_TIME],... % x
%     [test_info.BMSino.MAX_BMS_TEMPERATURE test_info.BMSino.MAX_BMS_TEMPERATURE],... % y
%     'b--','LineWidth',1.4); % properties 


% Figure 4: Balancing status vs. Battery current
hfig_BS = figure('Name','Balancing status vs. Battery current');
ax_BS = gca;
title('Balancing status vs. Battery current');
ax_BS.YGrid = 'on';
ax_BS.XGrid = 'on';
ax_BS.XLabel.String = 'Time [s]';
yyaxis left
ax_BS.YColor = 'black';
ax_BS.YLabel.String = 'Cell with active balancing sts';
yyaxis right
ax_BS.YColor = 'red';
ax_BS.YLabel.String = 'Battery current [A]';

% define the handles of the animated lines to plot data in real time
hAnimLinesBS.BatteryCurrent = animatedline('Color','r');
yyaxis left
% data
hAnimLinesBS.CellBalSts1 = animatedline('Color',C1col,'Marker',C1mrk,'LineStyle',C1ls);
hAnimLinesBS.CellBalSts2 = animatedline('Color',C2col,'Marker',C2mrk,'LineStyle',C2ls);
hAnimLinesBS.CellBalSts3 = animatedline('Color',C3col,'Marker',C3mrk,'LineStyle',C3ls);
hAnimLinesBS.CellBalSts4 = animatedline('Color',C4col,'Marker',C4mrk,'LineStyle',C4ls);
hAnimLinesBS.CellBalSts5 = animatedline('Color',C5col,'Marker',C5mrk,'LineStyle',C5ls);
hAnimLinesBS.CellBalSts6 = animatedline('Color',C6col,'Marker',C6mrk,'LineStyle',C6ls);
% limits
hAnimLinesBS.CellBalSts1_stby = animatedline('Color',C1col,'LineStyle',':');
hAnimLinesBS.CellBalSts2_stby = animatedline('Color',C2col,'LineStyle',':');
hAnimLinesBS.CellBalSts3_stby = animatedline('Color',C3col,'LineStyle',':');
hAnimLinesBS.CellBalSts4_stby = animatedline('Color',C4col,'LineStyle',':');
hAnimLinesBS.CellBalSts5_stby = animatedline('Color',C5col,'LineStyle',':');
hAnimLinesBS.CellBalSts6_stby = animatedline('Color',C6col,'LineStyle',':');

ylim([0.8 6.99])
legend('Cell 1','Cell 2','Cell 3',...
    'Cell 4','Cell 5','Cell 6','Location', 'southwest');


%% Define the timer object
% specifies the properties of the timer object
t = timer('StartDelay', 0, 'Period', 1, 'TasksToExecute', inf,...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TimerFcn',{@T1_Trig_Fcn,...
                    hAnimLinesCV,...
                 ...%hAnimLinesCT,...
                    hAnimLinesBMST,...
                    hAnimLinesBS},...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);

%% Timer trigger
function T1_Trig_Fcn(obj, event, hAnimLinesCV,...
                ...hAnimLinesCT,...
                hAnimLinesBMST, hAnimLinesBS)
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
%     if(max(test_info.CellTemperatures(:,t_idx)) > test_info.BMSino.MAX_CELL_TEMPERATURE)
%         test_error.high_cell_temperature = max(test_info.CellTemperatures(:,t_idx));
%     else test_error.high_cell_temperature = NaN;
%     end
%     if(min(test_info.CellTemperatures(:,t_idx)) < test_info.BMSino.MIN_CELL_TEMPERATURE)
%         test_error.low_cell_temperature = min(test_info.CellTemperatures(:,t_idx));
%     else test_error.low_cell_temperature = NaN;
%     end
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

    %% STATE 4
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
%% STATE 6
% plot all values in real-time

    % Plot in real time the cells values
    % Cells voltage & limits
    addpoints(hAnimLinesCV.CellVoltage_h_limit, test_info.time(t_idx), test_info.BMSino.MAX_SECURITY_CELL_VOLTAGE)
    addpoints(hAnimLinesCV.CellVoltage_l_limit, test_info.time(t_idx), test_info.BMSino.MIN_CELL_VOLTAGE)
    addpoints(hAnimLinesCV.CellVoltage1, test_info.time(t_idx), test_info.CellVoltage(1,t_idx))
    addpoints(hAnimLinesCV.CellVoltage2, test_info.time(t_idx), test_info.CellVoltage(2,t_idx))
    addpoints(hAnimLinesCV.CellVoltage3, test_info.time(t_idx), test_info.CellVoltage(3,t_idx))
    addpoints(hAnimLinesCV.CellVoltage4, test_info.time(t_idx), test_info.CellVoltage(4,t_idx))
    addpoints(hAnimLinesCV.CellVoltage5, test_info.time(t_idx), test_info.CellVoltage(5,t_idx))
    addpoints(hAnimLinesCV.CellVoltage6, test_info.time(t_idx), test_info.CellVoltage(6,t_idx))
    
    % Cells balancing status & limits
    addpoints(hAnimLinesBS.CellBalSts1, test_info.time(t_idx), test_info.CellBalancingStatus(1,t_idx)*0.8+1)
    addpoints(hAnimLinesBS.CellBalSts1_stby, test_info.time(t_idx), 1);
    addpoints(hAnimLinesBS.CellBalSts2, test_info.time(t_idx), test_info.CellBalancingStatus(2,t_idx)*0.8+2)
    addpoints(hAnimLinesBS.CellBalSts2_stby, test_info.time(t_idx), 2);
    addpoints(hAnimLinesBS.CellBalSts3, test_info.time(t_idx), test_info.CellBalancingStatus(3,t_idx)*0.8+3)
    addpoints(hAnimLinesBS.CellBalSts3_stby, test_info.time(t_idx), 3);
    addpoints(hAnimLinesBS.CellBalSts4, test_info.time(t_idx), test_info.CellBalancingStatus(4,t_idx)*0.8+4)
    addpoints(hAnimLinesBS.CellBalSts4_stby, test_info.time(t_idx), 4);
    addpoints(hAnimLinesBS.CellBalSts5, test_info.time(t_idx), test_info.CellBalancingStatus(5,t_idx)*0.8+5)
    addpoints(hAnimLinesBS.CellBalSts5_stby, test_info.time(t_idx), 5);
    addpoints(hAnimLinesBS.CellBalSts6, test_info.time(t_idx), test_info.CellBalancingStatus(6,t_idx)*0.8+6)
    addpoints(hAnimLinesBS.CellBalSts6_stby, test_info.time(t_idx), 6);
    
    % Cells temperature
%     addpoints(hAnimLinesCT.CellTemperature1, test_info.time(t_idx), test_info.CellTemperatures(1,t_idx))
%     addpoints(hAnimLinesCT.CellTemperature2, test_info.time(t_idx), test_info.CellTemperatures(2,t_idx))
%     addpoints(hAnimLinesCT.CellTemperature3, test_info.time(t_idx), test_info.CellTemperatures(3,t_idx))
%     addpoints(hAnimLinesCT.CellTemperature4, test_info.time(t_idx), test_info.CellTemperatures(4,t_idx))
%     addpoints(hAnimLinesCT.CellTemperature5, test_info.time(t_idx), test_info.CellTemperatures(5,t_idx))
%     addpoints(hAnimLinesCT.CellTemperature6, test_info.time(t_idx), test_info.CellTemperatures(6,t_idx))
    
    % BMS temperature
    addpoints(hAnimLinesBMST.BMSTemperature, test_info.time(t_idx), test_info.BMSTemperature(t_idx))
    addpoints(hAnimLinesBMST.BMSTemperature_h_limit, test_info.time(t_idx), test_info.BMSino.MAX_BMS_TEMPERATURE)
    
    % Battery current
%     addpoints(hAnimLinesCT.BatteryCurrent, test_info.time(t_idx), test_info.BatteryCurrent(t_idx))
    addpoints(hAnimLinesCV.BatteryCurrent, test_info.time(t_idx), test_info.BatteryCurrent(t_idx))
    addpoints(hAnimLinesBMST.BatteryCurrent, test_info.time(t_idx), test_info.BatteryCurrent(t_idx))
    addpoints(hAnimLinesBS.BatteryCurrent, test_info.time(t_idx), test_info.BatteryCurrent(t_idx))
    % Update axes
    drawnow limitrate
    
    %fprintf('STATE 6 %f\n', toc)
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

