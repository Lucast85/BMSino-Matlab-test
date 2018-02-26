clear all
clc

%% Define constant dependent on setup.m classdef
% setup.BMSino_SerialPort = 'COM1';
% setup.DCDC_SerialPort = 'COM3';

%% Define the timer object

% specifies the properties of the timer object
t = timer('StartDelay', 10, 'Period', 2, 'TasksToExecute', inf, ...
          'ExecutionMode', 'fixedRate',...
          'StartFcn', @T1_Start_Fcn,...
          'TimerFcn',@T1_trig_Fcn,...
          'StopFcn',@T1_Stop_Fcn,...
          'ErrorFcn',@T1_Err_Fcn);
%% Timer trigger
function T1_trig_Fcn(obj, event, text_arg)
% T1_trig_Fcn
    disp('in T1_trig_Fcn function')
    disp(round(toc,1))
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
    % initialize serial port of BMSino and DCDC
    
    delete(instrfindall);
    BMSino=serial(setup.BMSino_SerialPort);
    set(BMSino, 'BaudRate',115200);
    fopen(BMSino);
    disp('BMSino serial communication initializated...')
    pause(0.5)
%     DCDC=serial(setup.DCDC_SerialPort);
%     set(DCDC, 'BaudRate',38400);
%     fopen(DCDC);
%     disp('DC-DC converter serial communication initializated...')
end
%% Timer Stop
function T1_Stop_Fcn(obj, event, text_arg)
% T1_Stop_Fcn
    disp('in T1_Stop_Fcn function')
    disp('Total running time is: ')
    disp(round(toc,1))
end

%% STATO 1
% disattiva bilanciamenti per poter effettuare le misure
% plotta in real time tutti i valori su 2/3 grafici 
% leggi T, Itotale, Vtotale, TBMS
% wait 50ms
% leggi V.

%% STATO 2
% Stima stepoint carica

%% STATO 3
% Attua bilanciamenti

%% STATO 4
% Controlla che siano stati attuati i bilanciamenti
%% STATO 5
% Imposta il setpoint di carica stimato precedentemente al caricabatterie

