clc;
clear all;
close all;


len = 4502;

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

for t_idx=1:len
    %% STATE 6
% plot all values in real-time

    % Plot in real time the cells values
    % Cells voltage & limits
    addpoints(hAnimLinesCV.CellVoltage_h_limit, test_info.time(t_idx), test_info.BMSino.MAX_SECURITY_CELL_VOLTAGE/1000)
    %addpoints(hAnimLinesCV.CellVoltage_l_limit, test_info.time(t_idx), test_info.BMSino.MIN_CELL_VOLTAGE)
    addpoints(hAnimLinesCV.CellVoltage1, test_info.time(t_idx), test_info.CellVoltage(1,t_idx)/1000)
    addpoints(hAnimLinesCV.CellVoltage2, test_info.time(t_idx), test_info.CellVoltage(2,t_idx)/1000)
    addpoints(hAnimLinesCV.CellVoltage3, test_info.time(t_idx), test_info.CellVoltage(3,t_idx)/1000)
    addpoints(hAnimLinesCV.CellVoltage4, test_info.time(t_idx), test_info.CellVoltage(4,t_idx)/1000)
    addpoints(hAnimLinesCV.CellVoltage5, test_info.time(t_idx), test_info.CellVoltage(5,t_idx)/1000)
    addpoints(hAnimLinesCV.CellVoltage6, test_info.time(t_idx), test_info.CellVoltage(6,t_idx)/1000)
    
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
end