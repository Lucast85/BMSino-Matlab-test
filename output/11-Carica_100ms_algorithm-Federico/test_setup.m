classdef test_setup < handle % handle class
    %setup initialize test parameters
    %   ...
    
    properties( Constant = true )
        DCDC_SERIALPORT = 'COM5'    % COM port 
        BMSINO_SERIALPORT = 'COM7'  % COM port 
        BMSINO_BAUDRATE = 115200    % bps
        DCDC_BAUDRATE = 38400       % bps
        MAX_TEST_TIME = 7200;       % seconds
        CELLS_NUMBER = 6;           % possible only 4, 5 or 6 cells each BMSino
        
    end
    
    properties 
        BMSino;
        B3603;
        time = NaN * ones(1, test_setup.MAX_TEST_TIME);
        BatteryCurrent = NaN * ones(1, test_setup.MAX_TEST_TIME);
        CellVoltage = NaN * ones(test_setup.CELLS_NUMBER, test_setup.MAX_TEST_TIME);
        CellVoltage_filtered = NaN * ones(test_setup.CELLS_NUMBER, test_setup.MAX_TEST_TIME);
        BatteryVoltage=NaN * ones(1, test_setup.MAX_TEST_TIME);
        CellTemperatures = NaN * ones(test_setup.CELLS_NUMBER, test_setup.MAX_TEST_TIME);
        CellBalancingStatus = NaN * ones(test_setup.CELLS_NUMBER, test_setup.MAX_TEST_TIME);
        BMSTemperature = NaN * ones(1, test_setup.MAX_TEST_TIME);
        
        test_balance_window = 100;
        
        
        StoredCharge = NaN * ones(1, test_setup.MAX_TEST_TIME);
        prev_voltages_value = NaN * ones(test_setup.CELLS_NUMBER, 1);
        cell_lost_current = NaN * ones(test_setup.CELLS_NUMBER,1);
        prev_current_SetPoint;
        prev_current_time = 0;
        start_current_time = 0;
        start_current_SetPoint = 0;
        start_bal_time = 0;
        prev_bal_time = 0;
        
    end
    
    methods
        function obj = test_setup()
            %test_setup Build the objects to run the test
            % clear all intruments objects connected on serial port
            delete(instrfindall);
            % Create BMSino and DCDC objects
            obj.BMSino = Battery('Batteria_6s1p_test_NCR18650'); % BMSino with Garbuglia-Unterhost FW
            obj.BMSino.COMinit(obj.BMSINO_BAUDRATE, obj.BMSINO_SERIALPORT);
            %pause(0.1);
            
            obj.B3603 = DCDC('B3603');                  % Calibrated B3603 with custom FW (Luca Buccolini)
            obj.B3603.COMinit(obj.DCDC_BAUDRATE, obj.DCDC_SERIALPORT);
            %pause(0.1);
        end
    end
end

