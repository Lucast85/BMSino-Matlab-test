function [ChSetPoint] = SetPoint_Estimation(Battery, HighestCellVoltage)
%SetPoint_Estimation Estimate the charge setpoint in terms of current by
%reading the highest cell voltage of the battery pack.
%   Estimate the current setpoint from the highest cell votlage of the
%   battery pack and from some useful information about the cells used.
    DeltaVoltage = 0;
    DeltaVoltageMax = 0;
    ChSetPoint=0;
    % Con la tensione di cella scalo il SetPoint di carica (corrente)
    DeltaVoltage = (HighestCellVoltage - Battery.CELL_VOLTAGE_START_SP_CH_REDUCTION);
    DeltaVoltageMax = (Battery.MAX_CELL_VOLTAGE - Battery.CELL_VOLTAGE_START_SP_CH_REDUCTION);
    if (DeltaVoltage > 0)
        if (DeltaVoltage <= DeltaVoltageMax)
            ChSetPoint = (100 - (100*DeltaVoltage / DeltaVoltageMax)) * Battery.STD_CH_CURRENT;
            if ChSetPoint < Battery.CUTOFF_CURRENT
                ChSetPoint = 0;
                Battery.BatteryFullyCharged = 1;
            end
        else
            ChSetPoint = 0;
        end
    else
        ChSetPoint = Battery.STD_CH_CURRENT;
    end
end

