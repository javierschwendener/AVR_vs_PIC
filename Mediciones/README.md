# Mediciones
En esta carpeta se encuentran todas las mediciones obtenidas por el analizador lógico en el programa Logic 2.3.58, divididas por módulo.
Las mediciones fueron obtenidas según los requisitos de cada módulo, por lo que, a continuación, se explica qué mediciones se obtuvieron en cada módulo:

## EEPROM
Para la evaluación de la memoria EEPROM, las capturas del analizador lógico se obtuvieron en la escritura "write" y en la lectura "read" de una localidad de memoria específica en ambos lenguajes.

## EntradasSalidas
Las capturas obtenidas para las entradas y salidas se obtuvieron midiendo, a la vez, un pin de entrada con un botón y un pin de salida con una LED en ambos lenguajes.

## Interrupciones
La evaluación de las interrupciones se realizó de la misma forma que las entradas y salidas, empleando un botón de interrupción para encender y apagar una luz LED en ambos lenguajes.

## Pila
Para la evaluación del módulo de la pila, se emplearon dos programas diferentes en cada lenguaje. Con el primero se midió el tiempo de ejecución con una única función y en el segundo, con funciones anidadas hasta un máximo de 8.

## Temporizador
En la evaluación del módulo de temporizador se realizaron dos variantes del programa en ambos lenguajes: la primera, sin el uso de interrupciones y la segunda, con el uso de interrupciones. Para cada variante se obtuvo un total de 5 capturas, dando un total de 20 capturas para poder utilizarlas en un análisis estadístico.