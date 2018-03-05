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

% PRIME2018_Battery=Battery('BMSino');
% PRIME2018_Battery.COMinit(test_info.BMSino_BaudRate, test_info.BMSino_SerialPort);
% 
% PRIME2018_DCDC=DCDC('B3603');
% PRIME2018_DCDC.COMinit(test_info.DCDC_BaudRate, test_info.DCDC_SerialPort);


%% Define the timer object

% specifies the properties of the timer object
t = timer('StartDelay', 5, 'Period', 1, 'TasksToExecute', inf, ...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TimerFcn',{@T1_trig_Fcn, hAnimLinesV, hAnimLinesT, hAnimLinesC, test_info },...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);
%% Timer trigger
function T1_trig_Fcn(obj, event, hAnimLinesV, hAnimLinesT, hAnimLinesC, hAnimLinesBS, test_info)
% T1_trig_Fcn
%     disp('in T1_trig_Fcn function')
%     disp(round(toc,1))
   
    % static variable. idx is the number of times the trigger function is
    % called
    persistent idx
    if isempty(idx)
        idx = 0;
    end 
    idx = idx + 1;
    
%% STATE 1
% Disable all balancing mosfets. 

    persistent OldBalSts
    if isempty(OldBalSts)
        OldBalSts = 0;
    end 
    test_info.BMSino.setBalancingStatus(00000000);
    
% Measure cell temperatures
    test_info.BMSino.getTemperatures();

%, battery current, BMS temperature and 
% compute battery voltage.
% Finally wait 50 ms and measure cell voltages.
        

    % read data from BMSino & DC/DC and save it into test vectors
    
    test_info.time(idx) = toc;  % save actual time
     
    test_info.CellVoltage(1,idx) = 
    
    test_info.CellBalancingStatus(1,idx) = 
    
    test_info.CellTemperatures = 
    
    test_info.BMSTemperature =
    
    test_info.BatteryCurrent =
   


%% STATE 2
% Stima stepoint carica
%% STATE 3
% Attua bilanciamenti
%% STATE 4
% Controlla che siano stati attuati i bilanciamenti
%% STATE 5
% Imposta il setpoint di carica stimato precedentemente al caricabatterie
% plotta in real time tutti i valori su 2/3 grafici
    
    % Plot in real time the cells values
    addpoints(hAnimLinesV.CellVoltage1, test_info.time(idx), test_info.CellVoltage(1,idx))
    addpoints(hAnimLinesV.CellVoltage2, test_info.time(idx), test_info.CellVoltage(2,idx))
    addpoints(hAnimLinesV.CellVoltage3, test_info.time(idx), test_info.CellVoltage(3,idx))
    addpoints(hAnimLinesV.CellVoltage4, test_info.time(idx), test_info.CellVoltage(4,idx))
    addpoints(hAnimLinesV.CellVoltage5, test_info.time(idx), test_info.CellVoltage(5,idx))
    addpoints(hAnimLinesV.CellVoltage6, test_info.time(idx), test_info.CellVoltage(6,idx))
    
    addpoints(hAnimLinesBS.CellBalSts1, test_info.time(idx), test_info.CellBalancingStatus(1,idx))
    addpoints(hAnimLinesBS.CellBalSts2, test_info.time(idx), test_info.CellBalancingStatus(2,idx))
    addpoints(hAnimLinesBS.CellBalSts3, test_info.time(idx), test_info.CellBalancingStatus(3,idx))
    addpoints(hAnimLinesBS.CellBalSts4, test_info.time(idx), test_info.CellBalancingStatus(4,idx))
    addpoints(hAnimLinesBS.CellBalSts5, test_info.time(idx), test_info.CellBalancingStatus(5,idx))
    addpoints(hAnimLinesBS.CellBalSts6, test_info.time(idx), test_info.CellBalancingStatus(6,idx))
    
    addpoints(hAnimLinesT.CellTemperature1, test_info.time(idx), test_info.CellTemperature(1,idx))
    addpoints(hAnimLinesT.CellTemperature2, test_info.time(idx), test_info.CellTemperature(2,idx))
    addpoints(hAnimLinesT.CellTemperature3, test_info.time(idx), test_info.CellTemperature(3,idx))
    addpoints(hAnimLinesT.CellTemperature4, test_info.time(idx), test_info.CellTemperature(4,idx))
    addpoints(hAnimLinesT.CellTemperature5, test_info.time(idx), test_info.CellTemperature(5,idx))
    addpoints(hAnimLinesT.CellTemperature6, test_info.time(idx), test_info.CellTemperature(6,idx))
    
    addpoints(hAnimLinesT.BMSTemperature, test_info.time(idx), test_info.BMSTemperature)
    
    addpoints(hAnimLinesC.BatteryCurrent, test_info.time(idx), test_info.BatteryCurrent)
    
    % Update axes
    ax.XLim = time-50; % sembra non funzionare
    drawnow
end
%% Timer Error
function T1_Err_Fcn(obj, event, text_arg)
% T1_Err_Fcn
    disp('in T1_Err_Fcn function')
end
%% Timer Start
function T1_Start_Fcn(obj, event, text_arg)
% T1_Start_Fcn
    disp('Initialization of instruments');
    tic % start stopwatch timer
    
    test_info=test_setup();
end
%% Timer Stop
function T1_Stop_Fcn(obj, event, text_arg)
% T1_Stop_Fcn
    disp('in T1_Stop_Fcn function')
    disp('Total running time is: ')
    disp(round(toc,1))
end

