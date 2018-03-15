function [ChSetPoint] = SetPoint_Estimation(Battery, HighestCellVoltage)
%SetPoint_Estimation Estimate the charge setpoint in terms of current by
%reading the highest cell voltage of the battery pack.
%   Estimate the current setpoint from the highest cell votlage of the
%   battery pack and from some useful information about the cells used.
%   Returns value in A, not in mA!!!


%% TODO 
% implementa il seguente filtro:
%   #if LPF
%   // Simple LPF to soil moisture sensor: more informations in http://www.edn.com/design/systems-design/4320010/A-simple-software-lowpass-filter-suits-embedded-system-applications
%   static int32_t filter_reg;  // delay element
%   int16_t filter_input;       // filter_input
%   int16_t soilMoistureValue;  // filter output
%   
%   filter_input = analogRead(SOIL_MOISTURE_PIN);  //read input
%   filter_reg = filter_reg - (filter_reg >> FILTER_SHIFT) + filter_input;  //update filter with current sample
%   soilMoistureValue = filter_reg >> FILTER_SHIFT;  //scale output for unity gain
%   #else
%   uint16_t soilMoistureValue = analogRead(SOIL_MOISTURE_PIN);  //read input
%   #endif

%% codice originale
    DeltaVoltage = 0;
    DeltaVoltageMax = 0;
    ChSetPoint=0;
    % Con la tensione di cella scalo il SetPoint di carica (corrente)
    DeltaVoltage = (HighestCellVoltage - Battery.CELL_VOLTAGE_START_SP_CH_REDUCTION);
    DeltaVoltageMax = (Battery.MAX_CELL_VOLTAGE - Battery.CELL_VOLTAGE_START_SP_CH_REDUCTION);
    if (DeltaVoltage > 0)
        if (DeltaVoltage <= DeltaVoltageMax)
            ChSetPoint = (1 - (DeltaVoltage / DeltaVoltageMax)) * Battery.STD_CH_CURRENT;
            if ChSetPoint < (Battery.CUTOFF_CURRENT / 1000)
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

