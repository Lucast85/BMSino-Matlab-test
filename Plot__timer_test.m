clear all
clc
% FIgure code
% h = animatedline;

figure
ax = gca;
ax.YLim = [-1.2 +1.2];
ax.YGrid = 'on';
hfigure = animatedline;

%% Define the timer object

% specifies the properties of the timer object
t = timer('StartDelay', 1, 'Period', 0.1, 'TasksToExecute', inf, ...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TimerFcn',{@T1_trig_Fcn, hfigure},...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);
%% Timer trigger
function T1_trig_Fcn(obj, event, hfigure)
% T1_trig_Fcn
    disp('in T1_trig_Fcn function')
    disp(round(toc,1))


    % Get current time
    t =  toc;
    y = sin(t);
    % Add points to animation
    addpoints(hfigure,t,y)
    % Update axes
    ax.XLim = t+2;
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





	  