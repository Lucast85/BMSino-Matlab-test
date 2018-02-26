classdef DCDC < handle % handle class
   properties (Constant)

   end
   
   properties 
       DCDCName             = 'Unnamed DC-DC converter'
       OutputVoltage
       OutputCurrent
       OutputStatus
       WorkingStatus        = ''; % CC or CV
       InputVoltage
   end
   
   properties (Access = private)
       SerialObj
   end
   
   methods (Access = private)
       
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
                delete(instrfindall);
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
       end
       % Close serial communication
       function result = COMclose(obj)
           fclose(obj.SerialObj);
       end
       % Get Status
       function obj = getStatus(obj)
           flushinput(obj.SerialObj);
           fprintf(obj.SerialObj, 'STATUS');
           fscanf(obj.SerialObj) % dummy read the first row (status)
           str_splitted = fscanf(obj.SerialObj);
           % OUTPUT STATUS PARSING
           if contains(str_splitted, 'OFF')
               obj.OutputStatus = 'OFF'
           else
                if contains(str_splitted, 'ON')
                    obj.OutputStatus = 'ON'
                else
                    error('OUTPUT STATUS of DC/DC not defined!');     
                end
           end

           % VIN parsing
           str_splitted = strsplit(fscanf(obj.SerialObj));
           obj.InputVoltage = cell2mat(textscan(cell2str(str_splitted(2)),'%f'));
           if isempty(obj.InputVoltage)
               error('VIN not defined!');     
           end
           
           % VOUT parsing
           str_splitted = fscanf(obj.SerialObj);
           obj.OutputVoltage = cell2mat(textscan(str_splitted,'%f'));
           if isempty(obj.OutputVoltage)
               error('VOUT not defined!');     
           end      
           %COUT parsing
           str_splitted = fscanf(obj.SerialObj);
           obj.OutputCurrent = cell2mat(textscan(str_splitted,'%f'));
           if isempty(obj.OutputCurrent)
               error('COUT not defined!');     
           end  
           % CONSTANT VOLTAGE or CONSTANT CURRENT parsing
           str_splitted = fscanf(obj.SerialObj);
           if contains(str_splitted,'VOLTAGE')
               obj.WorkingStatus = 'CV';
           else
                if contains(str_splitted,'CURRENT')
                    obj.WorkingStatus = 'CC';
                else
                    error('WorkingStatus of DC/DC not defined!');     
                end
           end    
% esempio di messaggio ricevuto dal DC/DC una volta inviato "STATUS"           
%Status Report
% 
%     Send: "STATUS"
%     Receive: esempio: "STATUS:\r\nOUTPUT: OFF\r\nVIN: 32.201\r\nVOUT: .108\r\nCOUT: 16\r\nCONSTANT: VOLTAGE\r\n"
%
% Codice C del main del DC/DC:
%
% 	} else if (strcmp(uart_read_buf, "STATUS") == 0) {
% 		uart_write_str("STATUS:\r\n");
% 		write_onoff("OUTPUT: ", cfg_system.output);
% 		write_millivolt("VIN: ", state.vin);
% 		write_millivolt("VOUT: ", state.vout);
% 		write_milliamp("COUT: ", state.cout);
% 		write_str("CONSTANT: ", state.constant_current ? "CURRENT" : "VOLTAGE");
       end
       
       % Set Voltage
       function setVoltage(obj, voltage)
            flushinput(obj.SerialObj);
            string = strcat('VOLTAGE',32, int2str(voltage));
            fprintf(obj.SerialObj, string);
            % parse response data to ckeck if the write operation is done
       end
       % Set Current
       function setCurrent(obj, current)
            flushinput(obj.SerialObj);
            string = strcat('CURRENT',32, int2str(current));
            fprintf(obj.SerialObj, string);
            % parse response data to ckeck if the write operation is done
       end
       % Set Output (0=off, 1=on)
       function setOutput(obj, sts)
            flushinput(obj.SerialObj);
            string = strcat('OUTPUT',32, int2str(sts));
            fprintf(obj.SerialObj, string);
            % parse response data to ckeck if the write operation is done
       end
       % Set Autocommit
       function setAutocommit(obj)
            flushinput(obj.SerialObj);
            fprintf(obj.SerialObj, 'AUTOCOMMIT');
            % parse response data to ckeck if the write operation is done
       end
       % Set DC-DC converter Name
       function setName(obj, name)
            flushinput(obj.SerialObj);
            fprintf(obj.SerialObj, name);
            % parse response data to ckeck if the write operation is done
       end
   end
   
end