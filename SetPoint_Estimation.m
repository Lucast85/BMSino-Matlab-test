function [ChSetPoint] = SetPoint_Estimation(Battery, HighestCellVoltage)
%SetPoint_Estimation Estimate the charge setpoint in terms of current by
%reading the highest cell voltage of the battery pack.
%   Estimate the current setpoint from the highest cell votlage of the
%   battery pack and from some useful information about the cells used.
    DeltaVoltage = 0;
    DeltaVoltageMax = 0;
    ChSetPoint=0;
    % Con la tensione di cella scalo il SetPoint di carica (corrente)
    DeltaVoltage = (HighestCellVoltage - Battery.CellVoltageStartSPChReduction);
    DeltaVoltageMax = (Battery.MaxCellVoltage - Battery.CellVoltageStartSPChReduction);
    if (DeltaVoltage > 0)
        if (DeltaVoltage <= DeltaVoltageMax)
            ChSetPoint = (100 - (100*DeltaVoltage / DeltaVoltageMax)) * Battery.StdChCurrent;
        else
            ChSetPoint = 0;
        end
    else
        ChSetPoint = Battery.StdChCurrent;
    end
end

