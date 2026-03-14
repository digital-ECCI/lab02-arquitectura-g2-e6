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

#### - Código Sumador_Restador.v
Un sumador/restador de 4 bits es un circuito digital combinacional que puede realizar tanto la operación de suma como la de resta entre dos números binarios de 4 bits. Para evitar diseñar un circuito restador desde cero, este módulo reutiliza la arquitectura del sumador de 4 bits previamente creado, aplicando el principio matemático del **complemento a 2** ($A - B = A + (\sim B + 1)$). La operación (suma o resta) se decide mediante una única señal de control.

* **Inclusión del módulo base (`include):** Permite importar el archivo "Sumador_4b.v", el cual contiene la lógica de la suma en cascada (Ripple Carry Adder) que será el núcleo de esta nueva operación.
* **Declaración de señales de entrada y salida:** Se definen los vectores de entrada `A` y `B` de 4 bits, así como las salidas `So` (resultado) y `Co` (acarreo final). Se introduce una nueva entrada llamada `M` (Modo), que actuará como el selector de la operación: 0 para sumar, 1 para restar.
* **Generación del complemento a 1 (assign B_mod):** Se declara un cable intermedio `B_mod` de 4 bits. Usando compuertas lógicas XOR (`^`), se opera cada bit de `B` con la señal `M`. Si `M=0`, las compuertas XOR dejan pasar el valor original de `B`. Si `M=1`, las compuertas XOR invierten cada bit de `B`, generando así el **complemento a 1** necesario para la resta.
* **Instanciación del sumador y generación del complemento a 2:** Se instancia el módulo `sumador_4b`. Las entradas son `A` y el nuevo vector modificado `B_mod`. El paso clave aquí es conectar la señal de control `M` al acarreo de entrada (`Ci`). De este modo, cuando `M=1` (modo resta), el circuito automáticamente suma un 1 inicial al complemento a 1 de `B`, obteniendo instantáneamente el **complemento a 2**. Si `M=0` (modo suma), simplemente se suma $A + B + 0$.

#### - Código SR4b_tb.v
El testbench del sumador/restador automatiza la verificación del circuito. Dado que este circuito es más complejo y maneja dos modos de operación, el banco de pruebas está diseñado para recorrer exhaustivamente todas las combinaciones numéricas posibles tanto para suma como para resta, garantizando la fiabilidad del diseño.

* **Directiva de simulación y llamado al módulo:** Al igual que en los ejemplos anteriores, se define la escala de tiempo en `1ns/1ps` y se incluye el archivo del sumador/restador. Se declara el módulo `SR4b_tb` sin puertos.
* **Declaración de señales y variables de iteración:** Las entradas al circuito (`A`, `B`, `M`) se declaran como tipo `reg` para poder inyectarles valores. Las respuestas del circuito (`So`, `Co`) son tipo `wire`. Se declaran tres variables enteras (`i`, `j`, `k`) que servirán como contadores para los bucles de prueba.
* **Instanciación del módulo (DUT):** Se conecta el circuito bajo prueba (`Sumador_Restador`) mapeando los puertos del módulo a las señales del testbench.
* **Generación de archivos de ondas ($dumpfile y $dumpvars):** Se configuran las directivas para guardar el historial de la simulación en el archivo "SR4b_tb.vcd", permitiendo su posterior análisis gráfico en herramientas como GTKWave.
* **Bloque initial y generación de estímulos anidados:** A diferencia de pruebas manuales, aquí se utilizan tres bucles `for` anidados. El bucle externo `k` alterna el modo de operación `M` (0 y 1). Los bucles internos `i` y `j` recorren todos los valores posibles (del 0 al 15) para los vectores `A` y `B` respectivamente. Esto somete al circuito a una prueba exhaustiva de 512 combinaciones posibles.
* **Visualización de resultados ($display):** Se imprime una cabecera para organizar los datos como una tabla en la consola de simulación. Por cada iteración del bucle, se espera un retardo de `#10` unidades de tiempo y luego se imprimen los valores actuales del tiempo, la operación, los operandos, el resultado y el acarreo final, permitiendo verificar rápidamente si la aritmética del complemento a 2 funciona.

### Conclusiones
* **Eficiencia mediante la reutilización de hardware:** El diseño del sumador/restador demostró cómo la arquitectura de un circuito existente (el sumador de 4 bits en cascada o *Ripple Carry Adder*) puede reutilizarse para crear un sistema más complejo. Esto reduce el tiempo de desarrollo y minimiza la cantidad de hardware necesario, evidenciando las ventajas del diseño modular y jerárquico en Verilog.
* **Optimización matemática con complemento a 2:** Se comprobó empíricamente que la resta binaria puede transformarse en una suma mediante el uso del complemento a 2. La integración de compuertas XOR controladas por la señal `M` (para hallar el complemento a 1) junto con la inyección de esta misma señal en el acarreo de entrada `Ci` (sumando el $+1$ faltante), resulta en una solución elegante y de muy bajo costo computacional para resolver la operación $A - B = A + (\sim B + 1)$.
* **Importancia de la simulación exhaustiva:** A diferencia de las pruebas manuales de un solo bit, el uso de bucles `for` anidados en el *testbench* (`SR4b_tb`) permitió evaluar automáticamente las 512 combinaciones posibles de los operandos de entrada. Esta práctica es fundamental en el flujo de diseño digital, ya que garantiza que el circuito se comporte correctamente bajo cualquier escenario antes de su síntesis e implementación física en una FPGA.

### Referencias
* Mano, M. M., & Ciletti, M. D. (2018). *Digital Design: With an Introduction to the Verilog HDL, VHDL, and SystemVerilog* (6th ed.). Pearson.
* Brown, S., & Vranesic, Z. (2014). *Fundamentals of Digital Logic with Verilog Design* (3rd ed.). McGraw-Hill Education.
* Palnitkar, S. (2003). *Verilog HDL: A Guide to Digital Design and Synthesis* (2nd ed.). Prentice Hall.
* Wakerly, J. F. (2006). *Digital Design: Principles and Practices* (4th ed.). Pearson.

---

### Diagramas
*(Inserta aquí la imagen del circuito esquemático del sumador/restador)*

### Simulación
*(Inserta aquí las capturas de pantalla de la simulación arrojadas por GTKWave)*
