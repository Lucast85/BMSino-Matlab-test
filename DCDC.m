classdef DCDC < handle % handle class
   properties (Constant)

   end
   
   properties 
       DCDCName             = 'Unnamed DC-DC converter'
       setpointVoltage      = NaN
       setpointCurrent      = NaN
       setpointOutput       = NaN
       DCDCoutputCurrent    
       DCDCoutputVoltage 	 
       DCDCinputVoltage     
       DCDCoutputEnabled    
       DCDCoutputStatus      
   end
   
   properties (Access = private)
       SerialObj
   end
   
   methods
       % Constructor
       function obj = DCDC(name)
           if (nargin > 0 && ischar(name))
                obj.DCDCName = name;
           else
               error('DC-DC converter wants a name. Name must be a string.');
           end
       end
       % Destructor
       function delete(obj)
           fclose(obj.SerialObj);
       end
       
       % Initialize serial communication
       function COMinit(obj, baudrate, COMport)
           if (nargin == 3 && ischar(COMport) && isnumeric(baudrate))
                obj.SerialObj = serial(COMport);
                set(obj.SerialObj, 'BaudRate',baudrate);
                fopen(obj.SerialObj);
                disp('waiting for serial communication...');
                pause(2);
                % ask for instrument name and check if it responds
                % correctly
%                 obj.BatteryName = namefprintf(obj.SerialObj, 'ask for name'); %change code here
%                 if obj.DCDCName == 'Nome previsto'
                    disp('DC-DC converter serial communication initializated');
%                 else 
%                     disp('DC-DC converter name is not correct: Serial communication issues?');
%                 end
           else
               error('Inputs arguments are wrong');
           end
           flushinput(obj.SerialObj);
       end
       % Close serial communication
       function result = COMclose(obj)
           fclose(obj.SerialObj);
       end
       
       % Set Voltage
       function setVoltage(obj, voltage)
            string = strcat('VOLTAGE',32, int2str(voltage));
            fprintf(obj.SerialObj, string);
            disp('Voltage set')
            flushinput(obj.SerialObj);
       end
       % Set Current
       function setCurrent(obj, current)
            string = strcat('CURRENT',32, int2str(current));
            fprintf(obj.SerialObj, string);
            disp('Current set')
            flushinput(obj.SerialObj);
       end
       % Set Output (0=off, 1=on)
       function setOutput(obj, sts)
            string = strcat('OUTPUT',32, int2str(sts));
            fprintf(obj.SerialObj, string);
            disp('Output set')
            flushinput(obj.SerialObj);
       end
       % Set Autocommit
       function setAutocommit(obj)
            fprintf(obj.SerialObj, 'AUTOCOMMIT');
            disp('autocommit set')
            flushinput(obj.SerialObj);
       end
       % Set DC-DC converter Name
       function setName(obj, name)
            string = strcat('SNAME',32, name);
            fprintf(obj.SerialObj, string);
            disp('DCDC name set')
            flushinput(obj.SerialObj);
       end
       
       % Get DC-DC Status, output current and voltgage, input voltage
       function status = getStatus(obj)
            flushinput(obj.SerialObj);
            fprintf(obj.SerialObj, 'STATUS\n');
            if (fscanf((obj.SerialObj),'%s') =='STATUS:') 
                disp('Status received from DCDC');
                %fscanf((obj.SerialObj),'%s');
                obj.DCDCoutputEnabled = fscanf((obj.SerialObj),'OUTPUT: %s');
                obj.DCDCinputVoltage = fscanf((obj.SerialObj), 'VIN: %f');
                obj.DCDCoutputVoltage = fscanf((obj.SerialObj), 'VOUT: %f');
                obj.DCDCoutputCurrent = fscanf((obj.SerialObj), 'COUT: %f');
                obj.DCDCoutputStatus = fscanf((obj.SerialObj), 'CONSTANT: %s');
                fscanf((obj.SerialObj), '%s');      %read out last line from the buffer ("DONE")
                status = 1;
                return
            else
                disp('ERROR: Status not received from DCDC')
                status = 0;
                return
            end
            flushinput(obj.SerialObj);
       end

   end
   
end