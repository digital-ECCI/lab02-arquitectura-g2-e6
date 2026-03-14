# Lab02 - Sumador/Restador de 4 bits

## Integrantes
* Juan Daniel Caballero Abril
* Andres Felipe Albarracin Diaz
* Kevin Steven Guzman Samper

## Documentación

### 1. Objetivos
* Diseñar e implementar un circuito capaz de sumar y restar números de 4 bits utilizando el método de complemento a 2.
* Reutilizar (instanciar) el sumador de 4 bits hecho en el laboratorio anterior para no tener que diseñar un restador desde cero, optimizando el uso de hardware.
* Validar el diseño con un *testbench* exhaustivo y visualizar las formas de onda en simulación para comprobar que los acarreos y los resultados negativos funcionen bien.

### 2. Funcionamiento

#### - El "truco" del Sumador/Restador
Básicamente, el circuito aprovecha una propiedad matemática muy útil: hacer una resta es lo mismo que sumar un número negativo. En binario, esto se logra con el complemento a 2: $A - B = A + (\sim B + 1)$.

Para controlar si sumamos o restamos usamos una sola señal llamada `M` (Modo):
* **Si $M = 0$ (Suma):** Las compuertas XOR dejan pasar el vector `B` tal cual. El acarreo de entrada del sumador ($Ci$) es 0. El resultado es $A + B$.
* **Si $M = 1$ (Resta):** Las compuertas XOR actúan como inversores, sacando el complemento a 1 de `B`. Además, como `M` entra directamente al $Ci$ del sumador, le estamos sumando ese $+1$ que nos faltaba. ¡Magia! Tenemos el complemento a 2 y el circuito hace $A - B$.

#### - Análisis del Esquemático RTL
![Esquemático RTL del Sumador/Restador](ruta_a_tu_imagen_esquematico.jpeg)
*Nota: Reemplaza la ruta con el nombre de tu archivo, ej: esquematico.jpeg*

En la imagen superior vemos exactamente cómo se sintetizó nuestro código. Las entradas `B[3..0]` pasan por un banco de 4 compuertas XOR (llamadas `B_mod~0` a `B_mod~3`) que son controladas en paralelo por la señal `M`. Luego, ese vector modificado y el vector `A` entran al bloque `sumador_4b` (la caja verde). Fíjate cómo `M` también se conecta directo al pin `Ci` del sumador. Es un diseño súper limpio.

#### - Código Verilog (`Sumador_Restador.v`)
Este módulo es el top-level. En lugar de hacer lógica combinacional gigante, simplemente creamos un cable intermedio `wire [3:0] B_mod;` donde aplicamos la lógica XOR bit a bit: `assign B_mod[0] = B[0] ^ M;` (y así para los 4 bits). Luego, instanciamos nuestro viejo y confiable `sumador_4b`, le pasamos `A`, `B_mod` y metemos `M` en el acarreo inicial. 

#### - Simulación y Testbench (`SR4b_tb.v`)
Para estar 100% seguros de que esto no va a fallar en la FPGA, hicimos un *testbench* rudo. En lugar de probar 3 o 4 casos a mano, metimos tres ciclos `for` anidados. El bucle externo alterna `M` entre 0 y 1, y los internos recorren todos los valores de `A` (0 a 15) y `B` (0 a 15). Esto significa que simulamos **512 combinaciones** (todas las posibles).

![Ondas de simulación en GTKWave](ruta_a_tu_imagen_gtkwave.jpeg)
*Nota: Reemplaza la ruta con el nombre de tu archivo, ej: ondas.jpeg*

En esta captura de GTKWave podemos comprobar que la lógica funciona.
* Arriba tenemos `A` y `B` en formato hexadecimal cambiando con el tiempo.
* La señal `M` nos divide la simulación: primero está en baja (0) haciendo sumas, y a la mitad pasa a alta (1) para empezar a restar.
* Observamos la salida `So` y el bit de acarreo `Co`. Cuando estamos restando, el bit `Co` es clave: si da `1`, el resultado es positivo (no hay "préstamo" o *borrow* pendiente); si da `0`, el resultado es negativo y está expresado en complemento a 2.

### 3. Casos de Prueba (Tabla de Verdad resumida)

Para ilustrar mejor, sacamos estos casos puntuales de la simulación:

| Operación | M (Modo) | A | B | Resultado (So) | Co | ¿Qué significa? |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Suma** | 0 | 0111 (7) | 0101 (5) | 1100 (12) | 0 | Suma aritmética normal. |
| **Resta** | 1 | 0111 (7) | 0101 (5) | 0010 (2) | 1 | Resta normal. $Co=1$ indica que dio positivo. |
| **Resta** | 1 | 0011 (3) | 0111 (7) | 1100 (-4) | 0 | $3 - 7 = -4$. El resultado está en comp. a 2. $Co=0$ avisa que es negativo. |

---

## Conclusiones

1. **Reutilizar código es la clave:** Este laboratorio nos demostró el poder del diseño jerárquico. Agarrar el `sumador_4b` del lab anterior y meterle solo 4 compuertas XOR nos ahorró tener que diseñar mapas de Karnaugh y ecuaciones gigantes para un restador. Es hardware eficiente.
2. **El complemento a 2 simplifica todo:** A nivel matemático y de compuertas, transformar una resta en una suma conectando el pin `M` al acarreo inicial (`Ci`) es probablemente el truco más elegante de la aritmética digital. 
3. **Las simulaciones masivas salvan vidas:** Correr ciclos `for` en el *testbench* nos dio la tranquilidad de que el circuito funciona para los 512 casos posibles. Tratar de ver el error a mano en la FPGA directamente hubiera sido un dolor de cabeza, por eso GTKWave es una herramienta indispensable en nuestro flujo de trabajo.

## Referencias
* Mano, M. M., & Ciletti, M. D. (2018). *Digital Design: With an Introduction to the Verilog HDL, VHDL, and SystemVerilog* (6th ed.). Pearson.
* Brown, S., & Vranesic, Z. (2014). *Fundamentals of Digital Logic with Verilog Design* (3rd ed.). McGraw-Hill Education.
