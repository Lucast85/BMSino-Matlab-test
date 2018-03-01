classdef Battery < handle % handle class
   properties (Constant)
      S = 6
      P = 1
      RatedCapacity                 = 3200  % mAh
      NominalVoltage                = 3600  % mV
      StdChCurrent                  = 1625  % mA
      MaxDsCurrent                  = 3200  % mA       
      CutOffCurrent                 = 65    % mA
      MaxCellVoltage                = 4200  % mV
      MinCellVoltage                = 2500  % mV
      CellVoltageStartSPChReduction = 4000  % mV
      DeltaVoltageEndOfBalancing    = 20    % mV
      Manufacturer                  = 'Panasonic'
      PartNumber                    = 'NCR18650B'
      Note = '6s1p battery made with 18650 lithium cells. This battery is used to test BMSino'
   end
   
   properties 
      BatteryName                   = 'Unnamed Battery'
      CellsVoltages                 = zeros(6,1)
      CellsTemperatures             = zeros(6,1)
      CellsBalancingStatus          = zeros(6,1)
      BMSTemperature                = 0
      TotalCurrent                  = 0
      TotalVoltage                  = 0
 
   end
   
   properties (Access = private)
       SerialObj
   end
   
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
                delete(instrfindall);
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
       function result = COMclose(obj)
           fclose(obj.SerialObj);
       end
       
       % Get Voltages
       function getVoltages(obj)
            fprintf(obj.SerialObj, 'mVCELL A');
            obj.CellsVoltages = cell2mat(textscan(fscanf(obj.SerialObj),'%f'));
			obj.TotalVoltage = sum(obj.CellsVoltages);										  
       end
       % Get Temperatures
       function getTemperatures(obj)
           fprintf(obj.SerialObj, 'TCELL A');
           obj.CellsTemperatures = cell2mat(textscan(fscanf(obj.SerialObj),'%f'));
       end
       % Get Temperature of BMS
       function getBMSTemperature(obj)
           fprintf(obj.SerialObj, 'TBMS');
           obj.BMSTemperature = cell2mat(textscan(fscanf(obj.SerialObj),'%f'));
       end
       % Get Balancing Status
       function getBalancingStatus(obj)
           fprintf(obj.SerialObj, 'RBCELL');
           obj.CellsBalancingStatus = string2binarray(fscanf((obj.SerialObj),'%s'));
       end
       % Set Balancing Status
       function status = setBalancingStatus(obj, bitmask_binarray)
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
       end
   end
   
end