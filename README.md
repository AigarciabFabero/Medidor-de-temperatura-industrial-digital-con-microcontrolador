# Medidor-de-temperatura-industrial-digital-con-microcontrolador

Este proyecto documenta el diseño, construcción y calibración de un termómetro digital. El sistema utiliza un termopar tipo K como sensor principal para medir la temperatura. La señal analógica generada por el termopar es acondicionada y procesada por un microcontrolador para mostrar la temperatura final en una pantalla LCD.

El objetivo inicial era cubrir un rango de -10°C a 120°C, pero debido a la no linealidad de la respuesta fuera de un rango específico, el diseño final fue optimizado y calibrado para medir con precisión temperaturas entre 2°C y 40°C.

## Componentes Principales
El proyecto se divide en dos bloques principales:

### Hardware Analógico:

Sensor: Termopar tipo K.

Puente de Wheatstone: Utilizado inicialmente para simular la señal del termopar durante el desarrollo.

Amplificador de Instrumentación: Amplifica la débil señal de tensión del termopar a un nivel adecuado para el microcontrolador.

Filtro Pasa Baja: Reduce el ruido eléctrico de la señal antes de ser procesada digitalmente.

### Hardware y Software Digital:

Microcontrolador (Placa Mbed): Lee la tensión analógica acondicionada, la convierte a un valor de temperatura y gestiona la pantalla.

Sensor de Referencia (DS1820): Mide la temperatura ambiente (junta fría del termopar) para realizar la compensación y asegurar una medida precisa.

Software: El programa del microcontrolador está escrito en C++ para la plataforma Mbed. Incluye funciones para:

Leer y promediar la tensión del sensor.

Calcular la temperatura basándose en una calibración lineal.

Permitir la recalibración del sistema por el usuario.

Mostrar la temperatura actual, la de referencia, y las máximas/mínimas registradas en una pantalla LCD.

## Funcionamiento
El termopar genera una tensión proporcional a la diferencia de temperatura medida.

El amplificador de instrumentación eleva esta señal a un rango de voltios.

El filtro limpia la señal de ruido.

El microcontrolador lee la tensión final, junto con la temperatura de referencia de la junta fría, y aplica la fórmula T = a*V + b + T_ref para calcular la temperatura.

El sistema cuenta con un modo de calibración que permite al usuario ajustar los coeficientes a y b usando dos puntos de referencia (2°C y 40°C) para maximizar la precisión.

La temperatura resultante se muestra en la pantalla LCD.

## Autores
Aitor García Blanco

Inés Rodríguez Barquero

Rocío Díaz Somalo


Fecha del documento: 2 de Febrero de 2021
