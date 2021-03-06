clear all
clc

%% Figure
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

hAnimLinesC.BatteryCurrent = animatedline;

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

%% Define the timer object

% specifies the properties of the timer object
t = timer('StartDelay', 1, 'Period', 0.1, 'TasksToExecute', inf, ...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TimerFcn',{@T1_trig_Fcn, hAnimLinesV, hAnimLinesT, hAnimLinesC },...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);
%% Timer trigger
function T1_trig_Fcn(obj, event, hAnimLinesV, hAnimLinesT, hAnimLinesC )
% T1_trig_Fcn
    disp('in T1_trig_Fcn function')
    disp(round(toc,1))


    % Get current time
    time =  toc;
    y1 = sin(time);
    y2 = sin(time+pi/2);
    y3 = sin(time+pi);
    y4 = sin(time+pi*3/2);
    % Add points to animation
    addpoints(hAnimLinesV.CellVoltage1,time,y1)
    addpoints(hAnimLinesV.CellVoltage2,time,y2)
    addpoints(hAnimLinesT.CellTemperature1,time,y3)
    addpoints(hAnimLinesC.BatteryCurrent,time,y4)
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
    disp('in T1_Start_Fcn function');
    tic
end
%% Timer Stop
function T1_Stop_Fcn(obj, event, text_arg)
% T1_Stop_Fcn
    disp('in T1_Stop_Fcn function')
    disp('Total running time is: ')
    disp(round(toc,1))
end





	  