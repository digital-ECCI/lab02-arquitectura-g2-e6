# Lab02 - Sumador/Restador de 4 bits

## Integrantes
* Juan Daniel Caballero Abril
* Andres Felipe Albarracin Diaz
* Kevin Steven Guzman Samper

## Documentación

### Objetivos
* Implementar un circuito restador usando complemento a 2.
* Reutilizar un sumador de 4 bits para operaciones de resta, optimizando el diseño mediante el uso de compuertas XOR y una señal de control.
* Aprender a verificar y validar el funcionamiento del diseño en un entorno de simulación, identificando y corrigiendo errores antes de la implementación física en hardware mediante simulaciones exhaustivas.

### Funcionamiento

#### - Concepto de Sumador/Restador
El circuito sumador/restador de 4 bits utiliza la lógica combinacional y el principio matemático del complemento a 2 para realizar sumas ($A+B$) y restas ($A-B$). La señal de control $M$ (Modo) es crucial para este funcionamiento:
* **Si $M=0$:** El circuito suma $A+B$. Las compuertas XOR dejan pasar a $B$ sin cambios y el acarreo inicial ($C_{in}$) es 0.
* **Si $M=1$:** El circuito resta $A-B$. Las compuertas XOR invierten los bits de $B$ (complemento a 1) y el $C_{in}$ se pone en 1, sumando ese bit faltante para completar el **complemento a 2**.


Este diagrama esquemático ilustra perfectamente cómo se construye el sumador/restador a partir de un sumador de 4 bits (bloque verde) y compuertas XOR. La señal de control $M$ se conecta a un terminal de cada compuerta XOR y también directamente a la entrada de acarreo inicial ($Ci$) del sumador. El bus de entrada $B[3..0]$ se conecta al otro terminal de las compuertas XOR, y la salida de estas compuertas alimenta la entrada $B[3..0]$ del sumador de 4 bits. Cuando $M=1$, las compuertas XOR actúan como inversores, generando el complemento a 1 de $B$, y al mismo tiempo, el sumador recibe un acarreo inicial de 1, completando el complemento a 2 de $B$.

#### - Código Sumador_Restador.v
Este módulo es el corazón del diseño. Instancia el sumador completo de 4 bits y añade la lógica de control.

* **Lógica de inversión (Compuertas XOR):** Como se muestra en el diagrama, se utiliza la operación XOR entre cada bit de `B` y la señal `M`. Esto genera el vector intermedio `B_mod`.
* **Señal interna B_mod:** Es un cable intermedio de 4 bits (`wire [3:0]`) que almacena el valor de `B` ya procesado (sea igual o invertido) para ser entregado al sumador.
* **Implementación del Complemento a 2:** Al instanciar el sumador completo, se conecta la señal `M` directamente al acarreo de entrada (`Ci`). Cuando se está restando (**M = 1**), esto suma automáticamente el **"+1"** necesario al complemento a 1 de `B`, completando la conversión a complemento a 2.


#### - Código SR4b_tb.v (Testbench)
El banco de pruebas genera los estímulos para verificar exhaustivamente el funcionamiento del sumador/restador. Recorre todas las combinaciones numéricas posibles de los operandos $A$ y $B$, tanto para suma ($M=0$) como para resta ($M=1$), permitiendo validar la lógica y el manejo de acarreos.


Esta captura de pantalla de GTKWave muestra la simulación. Se pueden ver las señales $M$, $A$, $B$, $So$ y $Co$ a lo largo del tiempo. Al inicio, la señal $M$ está en 0, indicando suma, y el resultado $So$ sigue la suma de $A$ y $B$. Posteriormente, $M$ cambia a 1, indicando resta. La forma de onda muestra cómo $So$ cambia en respuesta a los operandos y el modo, validando el diseño.

#### - Descripción de los Módulos

| Módulo | Función |
| :--- | :--- |
| **Sumador_1b** | Unidad básica que suma $A_n, B_n$ y $C_{in}$ para entregar $S_n$ y $C_{out}$. |
| **Sumador_Restador_4b** | Estructura principal que agrupa los 4 bits y las compuertas XOR de control. |
| **SR4b_tb** | Testbench que automatiza las pruebas y genera las señales de tiempo. |

---

## Resultados y Evidencias

### Tabla de Verdad (Casos Clave)
A continuación se muestran ejemplos del comportamiento esperado del circuito:

| Operación | Sel (M) | A | B | Resultado (So) | Co (Acarreo) | Nota |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Suma** | 0 | 0111 (7) | 0101 (5) | 1100 (12) | 0 | Suma normal |
| **Resta** | 1 | 0111 (7) | 0101 (5) | 0010 (2) | 1 | $C_o=1$ indica resultado (+) |
| **Resta** | 1 | 0011 (3) | 0111 (7) | 1100 (-4) | 0 | $C_o=0$ indica resultado (-) |

### Diagramas
Se presenta el diagrama esquemático completo del sumador/restador de 4 bits, que muestra cómo las compuertas XOR controladas por $M$ implementan el complemento a 1 y 2 para la resta, reutilizando el sumador de 4 bits en cascada (Ripple Carry Adder).


### Simulaciones (GTKWave)
La simulación exhaustiva realizada mediante el testbench anidado recorrió las 512 combinaciones posibles de entrada. Los resultados se visualizaron en GTKWave. La siguiente captura muestra las respuestas para varias combinaciones de $A$ y $B$, alternando el modo de operación con $M$.


Se puede observar cómo, cuando $M=0$, la salida $So$ es la suma de $A$ y $B$. Cuando $M=1$, el circuito realiza la resta. Por ejemplo, se puede ver un cambio en So cuando M cambia de 0 a 1 para los mismos operandos. El acarreo final $Co$ también cambia de forma correspondiente, indicando si el resultado de la resta es positivo o negativo.

### Conclusiones
* **Eficiencia mediante la reutilización de hardware:** El diseño del sumador/restador demostró cómo la arquitectura de un circuito existente (el sumador de 4 bits en cascada o *Ripple Carry Adder*) puede reutilizarse para crear un sistema más complejo. Esto reduce el tiempo de desarrollo y minimiza la cantidad de hardware necesario, evidenciando las ventajas del diseño modular y jerárquico en Verilog.
* **Optimización matemática con complemento a 2:** Se comprobó empíricamente que la resta binaria puede transformarse en una suma mediante el uso del complemento a 2. La integración de compuertas XOR controladas por la señal $M$ (para hallar el complemento a 1) junto con la inyección de esta misma señal en el acarreo de entrada $Ci$ (sumando el $+1$ faltante), resulta en una solución elegante y de muy bajo costo computacional para resolver la operación $A - B = A + (\sim B + 1)$.
* **Importancia de la simulación exhaustiva:** A diferencia de las pruebas manuales de un solo bit, el uso de bucles `for` anidados en el *testbench* (`SR4b_tb`) permitió evaluar automáticamente las 512 combinaciones posibles de los operandos de entrada. Esta práctica es fundamental en el flujo de diseño digital, ya que garantiza que el circuito se comporte correctamente bajo cualquier escenario antes de su síntesis e implementación física en una FPGA.

### Referencias
* Mano, M. M., & Ciletti, M. D. (2018). *Digital Design: With an Introduction to the Verilog HDL, VHDL, and SystemVerilog* (6th ed.). Pearson.
* Brown, S., & Vranesic, Z. (2014). *Fundamentals of Digital Logic with Verilog Design* (3rd ed.). McGraw-Hill Education.
* Palnitkar, S. (2003). *Verilog HDL: A Guide to Digital Design and Synthesis* (2nd ed.). Prentice Hall.
* Wakerly, J. F. (2006). *Digital Design: Principles and Practices* (4th ed.). Pearson.
