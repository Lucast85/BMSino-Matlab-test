classdef DCDC < handle % handle class
   properties (Constant)
       MAX_DCDC_VOLTAGE = 27.2;       %4.2*6 (cells) + 2 

   end
   
   properties 
       DCDCName             = 'Unnamed DC-DC converter'
       setpointVoltage      = NaN
       setpointCurrent      = NaN
       setpointOutput       = NaN
       DCDCoutputCurrent    = 10
       DCDCoutputVoltage 	= 10 
       DCDCinputVoltage     = 1.2
       DCDCoutputEnabled    = 'OFF'
       DCDCoutputStatus     = 'CURRENT'
       
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

                string = strcat('OUTPUT',32, int2str(0));
                fprintf(obj.SerialObj, string);
                disp('Output set')
                pause(0.01);
                flushinput(obj.SerialObj);
                string = strcat('VOLTAGE',32, num2str(obj.MAX_DCDC_VOLTAGE,'%1.3f\n'));
                fprintf(obj.SerialObj, string);
                disp('Max DCDC Voltage set');
               
                

                
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
            string = strcat('VOLTAGE',32, num2str(voltage,'%1.3f\n'));
            fprintf(obj.SerialObj, string);
            disp('Voltage set')
            flushinput(obj.SerialObj);
       end
       % Set Current
       function setCurrent(obj, current)
            if current <0.001
                string = strcat('CURRENT',32,'0.001\n');
                fprintf(obj.SerialObj, string);
                pause(0.01)
                string = strcat('OUTPUT',32, '0');
                fprintf(obj.SerialObj, string);
                pause(0.01)
                flushinput(obj.SerialObj);
                flushoutput(obj.SerialObj);
            else
                string = strcat('CURRENT',32, num2str(current,'%1.3f\n'));
                fprintf(obj.SerialObj, string);
            end
            disp('Current set')
            flushinput(obj.SerialObj);
       end
       % Set Output (0=off, 1=on)
       function setOutput(obj, sts)
            string = strcat('OUTPUT',32, int2str(sts));
            fprintf(obj.SerialObj, string);
            disp('Output set')
            flushinput(obj.SerialObj);
            flushoutput(obj.SerialObj);
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
%             if (fscanf((obj.SerialObj),'%s') =='STATUS:') 
                disp('Status received from DCDC');
                %fscanf((obj.SerialObj),'%s');
                fscanf((obj.SerialObj), 'STATUS:%s');
                obj.DCDCoutputEnabled = fscanf((obj.SerialObj),'OUTPUT: %s');
                obj.DCDCinputVoltage = fscanf((obj.SerialObj), 'VIN: %f');
                obj.DCDCoutputVoltage = fscanf((obj.SerialObj), 'VOUT: %f');
                %obj.DCDCoutputVoltage = fscanf((obj.SerialObj), 'COUT: %f');
                % read COUT: we use a workaround to read the real current
                COUT_str = fscanf((obj.SerialObj), 'COUT: %s');
                if contains(COUT_str, '.') % the output current string contains the dot
                    obj.DCDCoutputCurrent = sscanf(COUT_str, '%f');
                else % then the output current is given in Ampere
                    obj.DCDCoutputCurrent = sscanf(COUT_str, '%f')*0.001;
                end
                
                obj.DCDCoutputStatus = fscanf((obj.SerialObj), 'CONSTANT: %s');
                flushinput(obj.SerialObj);
                %fscanf((obj.SerialObj), 'DONE%s');      %read out last line from the buffer ("DONE")
                status = 1;
                
%             else
%                 disp('ERROR: Status not received from DCDC')
%                 status = 0;
%                 
%             end
            flushinput(obj.SerialObj);
       end

   end
   
end