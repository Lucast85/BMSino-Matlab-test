classdef Battery < handle % handle class
   properties (Constant)
      S = 6
      P = 1
      RATED_CAPACITY                        = 3200  % mAh
      NOMINAL_VOLTAGE                       = 3600  % mV
      STD_CH_CURRENT                        = 1.625  % A
      MAX_CH_CURRENT                        = 1700  % A
      MAX_DS_CURRENT                        = 3200  % mA       
      CUTOFF_CURRENT                        = 65    % mA
      MAX_SECURITY_CELL_VOLTAGE             = 4150  % mV  used for security check
      MAX_CELL_VOLTAGE                      = 4110 % mV  used for SetPoint Estimation alghoritm
      MIN_CELL_VOLTAGE                      = 2500  % mV  
      CELL_VOLTAGE_START_SP_CH_REDUCTION    = 4000  % mV
      CELL_VOLTAGE_START_BALANCING          = 4000  % mV
      DELTA_VOLTAGE_END_OF_BALANCING        = 30    % mV
      MAX_CELL_TEMPERATURE                  = 40    % °C
      MIN_CELL_TEMPERATURE                  = 0     % °C
      MAX_BMS_TEMPERATURE                   = 75    % °C
      MANUFACTURER                          = 'Panasonic'
      PART_NUMBER                           = 'NCR18650B'
      DELTA_VOLTAGE_EOC                     = 5      % mV
      NOTE = '6s1p battery made with 18650 lithium cells. This battery is used to test BMSino'
   end
   
   properties 
      BatteryName                   = 'Unnamed Battery'
      CellsVoltages                 = NaN*zeros(6,1)
      CellsTemperatures             = NaN*zeros(6,1)
      CellsBalancingStatus          = NaN*zeros(6,1) %left justified
      % e.g. cell 1 and 2 on balancing: 110000
      BMSTemperature                = NaN
      TotalCurrent                  = NaN
      TotalVoltage                  = NaN
      BatteryFullyCharged           = NaN
      StateOfCharge                 = NaN   % not yet implemented
      StateOfHealth                 = NaN   % not yet implemented
      SerialObj
   end
   
%    properties (Access = private)
%        SerialObj
%    end
   
   methods
       % Constructor
       function obj = Battery(name)
           if (nargin > 0 && ischar(name))
                obj.BatteryName = name;
           else
               error('Battery wants a name. Name must be a string.');
           end
       end
       % Destructor
%        function delete(obj)
%            fclose(obj.SerialObj);
%        end
       
       % Initialize serial communication
       function COMinit(obj, baudrate, COMport)
           if (nargin == 3 && ischar(COMport) && isnumeric(baudrate))
                obj.SerialObj = serial(COMport);
                set(obj.SerialObj, 'BaudRate',baudrate);
                fopen(obj.SerialObj);
                disp('waiting for serial communication...');
                pause(2);
%                 ask for instrument name and check if it responds
%                 correctly
%                 obj.BatteryName = namefprintf(obj.SerialObj, 'ask for name'); %change code here
%                  if obj.BatteryName == 'Nome previsto'
                      disp('Battery serial communication initializated');
%                  else 
%                      disp('Battery name is not correct: Serial communication issues?');
%                  end
           else
               error('Inputs arguments are wrong');
           end
       end
       
       % Close serial communication
       function COMclose(obj)
           fclose(obj.SerialObj);
       end
       
       % Get Voltages
       function getVoltages(obj)
            fprintf(obj.SerialObj, 'mVCELL A');
            obj.CellsVoltages = cell2mat(textscan(fscanf(obj.SerialObj),'%f'));
			obj.TotalVoltage = sum(obj.CellsVoltages);
            flushinput(obj.SerialObj);
       end
       % Get Temperatures
       function getTemperatures(obj)
           fprintf(obj.SerialObj, 'TCELL A');
           obj.CellsTemperatures = cell2mat(textscan(fscanf(obj.SerialObj),'%f'));
           flushinput(obj.SerialObj);
       end
       % Get Temperature of BMS
       function getBMSTemperature(obj)
           fprintf(obj.SerialObj, 'TBMS');
           obj.BMSTemperature = cell2mat(textscan(fscanf(obj.SerialObj),'%f'));
           flushinput(obj.SerialObj);
       end
       % Get Balancing Status
       function getBalancingStatus(obj)
           fprintf(obj.SerialObj, 'RBCELL');
           obj.CellsBalancingStatus = string2binarray(fscanf((obj.SerialObj),'%s'));
           flushinput(obj.SerialObj);
       end
       % Set Balancing Status
       function setBalancingStatus(obj, bitmask_binarray)
           bitmask_string = binarray2string(bitmask_binarray);
           string = strcat('SBCELL' ,32, bitmask_string);
           fprintf(obj.SerialObj, string);
%            pause(0.3);
%            fprintf(obj.SerialObj, 'RBCELL ');
%            obj.CellsBalancingStatus = string2binarray(fscanf((obj.SerialObj),'%s'));
%            if obj.CellsBalancingStatus == bitmask_binarray
%                disp('CellsBalancingStatus wrote!')
%                status =  1;
%                return 
%            else 
%                disp('CellsBalancingStatus Error!')
%                status =  0;
%                return 
%            end
           flushinput(obj.SerialObj);
           flushoutput(obj.SerialObj);
       end
   end
   
end