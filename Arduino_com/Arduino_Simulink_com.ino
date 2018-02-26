
#include <stdint.h>
#include <Arduino.h>
#include <stdio.h>
#include <math.h>

#ifndef _SS
#define _SS 10

#endif

#define _EN_PIN	5
#define _ONBOARD_NTC_PIN A4
#define _CURRENT_OUT_PIN A0
#define _CURRENT_REF_PIN A1

#define CELLS 6
#define CHANNELS 12
#define SEPARATOR ' '
#define OMEGA 10

long int startup_time;


byte a;

int cell_current;
long int curr_time;
int16_t board_temp;


uint16_t adc_channel[CHANNELS];
uint16_t cell_temperatures[CELLS];
uint16_t cell_voltages[CELLS];
int battery_voltage_mv=0;


char received[50];
char command[25];
char value[25];
int value_int;
byte value_bin;
uint8_t balance_reg;
bool led_sts=0;




void setup() {


        startup_time = millis();
        Serial.begin(115200);

        adc_channel[0]=1000;
        adc_channel[1]=2000;
        adc_channel[2]=3000;
        adc_channel[3]=4000;
        adc_channel[4]=5000;
        adc_channel[5]=6000;

        adc_channel[6]=1111;
        adc_channel[7]=2222;
        adc_channel[8]=3333;
        adc_channel[9]=4444;
        adc_channel[10]=5555;
        adc_channel[11]=6666;
}


void loop() {
	led_sts^=1;
	digitalWrite(LED_BUILTIN,led_sts);

        //Serial.print(Serial.available());
        if (Serial.available() > 0){

                int i = 0;
                a = Serial.read();
                while (a != '\n') {
                        received[i]= a;
                        a = Serial.read();
                        i++;
                }

                received[i] = '\n';



                i = 0;

                while (received[i] != SEPARATOR){
                        command[i] = received[i];
                        i++;
                }

                command[i] = '\0';


                int k =0;
                i++;
                while (received[i] != '\n') {
                        value[k] = received[i];
                        i++;
                        k++;

                }
                value[k]= '\0';


                // Serial.print(command);
                // Serial.print('\t');
                // Serial.print(SEPARATOR);
                // Serial.print('\t');

                // Serial.print('\n');

                sscanf(value, "%d", &value_int);        //convert value string to integer
                //Serial.print(value_int, DEC);



                curr_time = millis()- startup_time;

                //separate voltages from temperatures
                for (i=0;i<CELLS; i++){
                cell_voltages[i]=(adc_channel[i]*0.976)+1000;
                battery_voltage_mv = battery_voltage_mv + cell_voltages[i] ;    //calc total voltage across the battery
                }
                k = 0;
                uint32_t temp;
                for (i=CHANNELS/2; i<CHANNELS/2+CELLS; i++){
                    cell_temperatures[k] = 556;        //INSERTTT   convert cell temperature to degrees
                    k++;
                }



                // TO PRINT VOLTAGES

                if (strcmp(command, "mVCELL") == 0) {
                        if (strcmp(value, "A")==0){
                            for (i=0; i< CHANNELS/2; i++ ) {
								/*
								Serial.print(cell_voltages[i], DEC);
								Serial.print(SEPARATOR);
								*/
                            	Serial.print(sin(OMEGA *millis()/1000 + 30*i), DEC);
                            	Serial.print(SEPARATOR);
                            }
                            Serial.print('\n');
                        }
                        else if ((value_int <= CELLS)&&(value_int > 0)) {
                            Serial.print(cell_voltages[value_int]);
                            Serial.print('\n');
                        }
                        else    Serial.print("ERROR");
                }

                //TO PRINT TEMPERATURES

                else if (strcmp(command, "TCELL") == 0) {

                                if (strcmp(value, "A")==0){
                                        for (i=0; i< CELLS; i++ ) {
											/*
											Serial.print((cell_temperatures[i]), DEC);
											Serial.print(SEPARATOR);
											*/
                                        	Serial.print(5*sin(100*OMEGA *millis()/1000 + 30*i), DEC);
                                        	Serial.print(SEPARATOR);
                                        }
                                        Serial.print('\n');
                                }
                                else if ((value_int <= CELLS)&&(value_int > 0)) {
                                    Serial.println(cell_temperatures[value_int], DEC);
                                }
                        else    Serial.print("ERROR");
                }


                //TO PRINT BALANCING MOSFET STATUS


                else if (strcmp(command, "RBCELL") == 0) {
                        balance_reg = 0b11001100;            //read from balance register
                        Serial.print(balance_reg, BIN);
                        Serial.print(SEPARATOR);
                }






                //TO ENABLE BALANCING FROM CELL BITMASK


                else if (strcmp(command, "SBCELL") == 0) {
                        Serial.println(value);
                        int error=0;
                        value_bin= 0x00;
                        for (int i=0; value[i]!=NULL; i++){
                                if (value[i]== '1') {
                                        value_bin = value_bin | (0b100000 >> i);
                                }
                                else {
                                        if (value[i] != '0') error =1;

                                }
                        }
                        if (error == 1) Serial.println("WRONG CELL BALANCING BITMASK");
                        else Serial.println("RICEVUTO!");

                }


                //TO PRINT PCB TEMPERATURE

                else if (strcmp(command, "TBMS A") == 0) {
                        Serial.println(10*sin(OMEGA *millis()/1000), DEC);

                }

                else

                	Serial.println("UNKNOWN COMMAND");

        }




        delay(2000);
        return;
}
