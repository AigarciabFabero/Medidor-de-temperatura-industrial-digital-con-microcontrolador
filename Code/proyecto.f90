#include "mbed.h"
#include "DebounceIn.h"
#include "DS1820.h"
//#include "TextLCD.h"  // LCD control remoto.
#include "C12832.h"
#define calmax 40
#define calmin 2
//TextLCD lcd(p12,p9,p17,p18,p19,p20);
C12832 lcd(p5, p7, p6, p8, p11);
DS1820 termoref(p9); //p9 13
AnalogIn termov(p18); //p18 p16
//AnalogIn  // Temperatura de referencia del sensor
DebounceIn btn1(p15); //boton up //p 21 //b1 izquierda, b2 derecha(usb hacia arriba)
DebounceIn btn2(p12); //Para decir no  //p 22

bool oldbtn1;
bool oldbtn2;
bool bt1;
bool bt2;

float tvector[7];
float voltaje;
float temp;
float Tmax;
float Tmin;
float termor;
int i;
int j;
int x;
float a;
float b;
float paso;
float Vmax;
float Vmin;
float T;
int estado;
float c;
float d;
Ticker ticc;
Ticker tomart;
Ticker tic2;

void temperaturaref ()
{
    termor=termoref.temperature();
}

void temperatura ()
{
// Continua toma de datos con desplazamiento

    tvector[6]=3.3*termov.read(); // en el lab quitar el 3.3, esto solo para pract remota.
// printf("Tmovin=%.2f \n",tvector[6]);
    for (i=1; i<7; i++) {
        j=i-1;
        tvector[j]=tvector[i];
    }
// Ordenamos el vector
    for (i = 0; i < (6); i++) {
        for (j = i + 1; j < 7; j++) {
            if (tvector[j] < tvector[i]) {
                paso = tvector[j];
                tvector[j] = tvector[i];
                tvector[i] = paso;
            }
        }
    }
    voltaje = tvector[3];
    temp=((voltaje-b)/a)+termor;
    T=voltaje*c+d+termor;
//TEMPERATURA MÁXIMA Y MÍNIMA
    if (temp>Tmax) {
        Tmax=temp;
    } else if (-19<temp && temp<Tmin) {
        Tmin=temp;
    }//if
}//void
int main ()
{
    ticc.attach(&temperaturaref,2);  //ticker para tomar la temperatura de referencia.
    // En el lab btn1y btn2 poner a 1, de forma remota = 0 porque las entradas estan negadas.
    tomart.attach(&temperatura,1);  //poner a 0.2, lo subo para que me tomen los datos mas despacio.
    //printf("volint=%.2f \n",voltaje);
    a=0.0214422840268792;
    b=0.968772722;
    c=1;
    d=1;
    bt1=false;
    bt2=false;
    estado=1;
    Tmax=-20.0;
    Tmin=120.0;
    //printf("a=%.3f \n", a);
    //printf("b=%.3f \n", b);
    while (1) {
        //printf("Estado=%d \n",estado);
        //Damos a elegir si queremos calibrar
        int ret=termoref.convertTemperature(true);
        //printf("ret=%d  Tref=%.1f \n",ret,termor);
        //printf("volwhile=%.2f \n",voltaje);
        //printf("Tmov=%.2f \n",termov.read());
        if (btn1==1 && oldbtn1==false) { //Me lee solo el flanco de subida, no lee de forma continuada
            bt1=true;//arriba
        } else {
            bt1=false;
        }
        oldbtn1=btn1;
        if (btn2==1 && oldbtn2==false) { //Me lee solo el flanco de subida, no lee de forma continuada
            bt2=true;
        } else {
            bt2=false;
        }
        oldbtn2=btn2;

        switch (estado) {
            case 1:
                //Toma de datos del voltaje
                if (btn2==1) { //volver a calibrar
                    estado=2;
                }
                if (btn1==1) { //para borrar tmax y tmin
                    estado=4;
                }
                lcd.cls();
                lcd.locate(0,0);
                lcd.printf("T=%.2f\n",temp);
                lcd.locate(0,9);
                //lcd.printf("TC=%.2f\n",T );
                //lcd.locate(0,18);
                lcd.printf("Tref=%.2f\n",termor);
                printf("Tref=%.2f \n",termor);
                printf("volt=%.2f \n",voltaje);
                // printf("T=%.f \n",temp);
                break;
            //CALIBRACION
            case 2: //CALIBRAR a T=2
                lcd.cls();
                lcd.locate(0,0);
                lcd.printf("T=2 V=%.2f\n",voltaje);
                //Creamos V=aT+b
                if (btn2==1 ) {
                    Vmin=voltaje;
                    estado=3;
                }
                break;
            case 3: //CALIBRAR A T=80
                //Leer voltaje a 80º
                lcd.cls();
                lcd.locate(0,0);
                lcd.printf("T=40 V=%.2f\n",voltaje );
                if (btn2==1 ) {
                    Vmax=voltaje;
                    //calcular a y b
                    //b=termor*(Vmax+(((calmax-calmin)/termor)-1)*Vmin)/(calmax-calmin);
                    //a=Vmax/(calmax-calmin)-Vmin/(calmax-calmin);
                    a=Vmax/(calmax-calmin)-Vmin/(calmax-calmin);
                    b=Vmax-a*(calmax-termor);
                    c=(calmax-calmin)/(Vmax-Vmin);
                    d=calmax-termor-c*Vmax;
                    estado=1;
                }
                break;
            case 4: //Borramos datos de t max
                //Tmax=0;
                //Tmin=0;
                //for (i=0; i<(7); i++) {
                //    tvector[i]=0;
                // }
                lcd.cls();
                lcd.locate(0,0);
                lcd.printf("M=%.1f,m=%.1f\n",Tmax,Tmin);
                if (btn1==1 ) {
                    estado=1;
                }
                break;
        }//switch
        wait(0.5);
    }//while
}//int
