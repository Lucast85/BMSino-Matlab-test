classdef test_setup
    %setup initialize test parameters
    %   ...
    
    properties( Constant = true )
        DCDC_SerialPort = 'COM3'
        BMSino_SerialPort = 'COM8'
        BMSino_BaudRate = 115200
        DCDC_BaudRate = 38400
    end
    
    properties 
        BMSino
        B3603
    end
    
    methods
        function obj = test_setup()
            %test_setup Build the objects to run the test
            % Create BMSino and DCDC objects
            obj.BMSino = Battery('Batteria_6s1p_test'); % BMSino with Garbuglia-Unterhost FW
            obj.B3603 = DCDC('B3603');                  % Calibrated B3603 with custom FW (Luca Buccolini)
        end
    end
end

