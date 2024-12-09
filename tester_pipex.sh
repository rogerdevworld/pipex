#!/bin/bash
clear
make re
# Ruta al ejecutable pipex
PIPEX="./pipex"

# Definir colores
GREEN='\033[0;32m'  # Color verde
RED='\033[0;31m'    # Color rojo
NC='\033[0m'        # Sin color (rese

echo "Mandatory o casos de solo 2 comandos"

# Prueba 1: Listar archivos y ver los saltos de línea con cat
$PIPEX infile "ls" "cat" .tester/outfile1.txt
< infile ls | cat > .tester/outfile1_sys.txt
if diff .tester/outfile1.txt .tester/outfile1_sys.txt > /dev/null; then
    echo -n "${GREEN} 01. [OK]${NC}"
else
    echo -n "${RED} 01. [KO]${NC}"
fi

# Prueba 2: Ver si pipex maneja comandos de búsqueda con grep
$PIPEX infile "ls" "grep pipex" .tester/outfile2.txt
< infile ls | grep pipex > .tester/outfile2_sys.txt
if diff .tester/outfile2.txt .tester/outfile2_sys.txt > /dev/null; then
    echo -n "${GREEN} 02. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 02. ${RED}[KO]${NC}"
fi

# Prueba 3: Contar el número de líneas con wc -l
$PIPEX infile "ls" "wc -l" .tester/outfile3.txt
< infile ls | wc -l > .tester/outfile3_sys.txt
if diff .tester/outfile3.txt .tester/outfile3_sys.txt > /dev/null; then
    echo -n "${GREEN} 03. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 03. ${RED}[KO]${NC}"
fi

# Prueba 4: Ver el contenido del archivo con cat
$PIPEX infile "cat" "cat" .tester/outfile4.txt
< infile cat | cat > .tester/outfile4_sys.txt
if diff .tester/outfile4.txt .tester/outfile4_sys.txt > /dev/null; then
    echo -n "${GREEN} 04. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 04. ${RED}[KO]${NC}"
fi

# Prueba 5: Buscar el texto 'contenido' en el archivo con grep
$PIPEX infile "cat" "grep contenido" .tester/outfile5.txt
< infile cat | grep contenido > .tester/outfile5_sys.txt
if diff .tester/outfile5.txt .tester/outfile5_sys.txt > /dev/null; then
    echo -n "${GREEN} 05. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 05. ${RED}[KO]${NC}"
fi

# Prueba 6: Pasar la salida de ls a tr para cambiar el formato
$PIPEX infile "ls" "tr a-z A-Z" .tester/outfile6.txt
< infile ls | tr a-z A-Z > .tester/outfile6_sys.txt
if diff .tester/outfile6.txt .tester/outfile6_sys.txt > /dev/null; then
    echo -n "${GREEN} 06. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 06. ${RED}[KO]${NC}"
fi

# Prueba 7: Mostrar el número de palabras con wc -w
$PIPEX infile "ls" "wc -w" .tester/outfile7.txt
< infile ls | wc -w > .tester/outfile7_sys.txt
if diff .tester/outfile7.txt .tester/outfile7_sys.txt > /dev/null; then
    echo -n "${GREEN} 07. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 07. ${RED}[KO]${NC}"
fi

# Prueba 8: Redirigir el archivo a la salida estándar con cat
$PIPEX infile "cat" "cat" .tester/outfile8.txt
< infile cat | cat > .tester/outfile8_sys.txt
if diff .tester/outfile8.txt .tester/outfile8_sys.txt > /dev/null; then
    echo -n "${GREEN} 08. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 08. ${RED}[KO]${NC}"
fi

# Prueba 9: Listar archivos y mostrar solo los archivos ocultos con grep
$PIPEX infile "ls -a" "grep ^\." .tester/outfile9.txt
< infile ls -a | grep ^\. > .tester/outfile9_sys.txt
if diff .tester/outfile9.txt .tester/outfile9_sys.txt > /dev/null; then
    echo -n "${GREEN} 09. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 09. ${RED}[KO]${NC}"
fi

# Prueba 10: Buscar la palabra 'pipex' en el contenido con grep
$PIPEX infile "cat" "grep pipex" .tester/outfile10.txt
< infile cat | grep pipex > .tester/outfile10_sys.txt
if diff .tester/outfile10.txt .tester/outfile10_sys.txt > /dev/null; then
    echo "${GREEN} 10. ${GREEN}[OK]${NC}"
else
    echo "${RED} 10. ${RED}[KO]${NC}"
fi

# Prueba 11: Aplicar el comando sort a la salida de ls
$PIPEX infile "ls" "sort" .tester/outfile11.txt
< infile ls | sort > .tester/outfile11_sys.txt
if diff .tester/outfile11.txt .tester/outfile11_sys.txt > /dev/null; then
    echo -n "${GREEN} 11. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 11. ${RED}[KO]${NC}"
fi

# Prueba 12: Ver las primeras 5 líneas de un archivo con head
$PIPEX infile "ls" "head -n 5" .tester/outfile12.txt
< infile ls | head -n 5 > .tester/outfile12_sys.txt
if diff .tester/outfile12.txt .tester/outfile12_sys.txt > /dev/null; then
    echo -n "${GREEN} 12. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 12. ${RED}[KO]${NC}"
fi

# Prueba 13: Ver los últimos 5 archivos con tail
$PIPEX infile "ls" "tail -n 5" .tester/outfile13.txt
< infile ls | tail -n 5 > .tester/outfile13_sys.txt
if diff .tester/outfile13.txt .tester/outfile13_sys.txt > /dev/null; then
    echo -n "${GREEN} 13. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 13. ${RED}[KO]${NC}"
fi

# Prueba 14: Mostrar los archivos con extensión '.txt' con grep
$PIPEX infile "ls" "grep \.txt" .tester/outfile14.txt
< infile ls | grep \.txt > .tester/outfile14_sys.txt
if diff .tester/outfile14.txt .tester/outfile14_sys.txt > /dev/null; then
    echo -n "${GREEN} 14. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 14. ${RED}[KO]${NC}"
fi

# Prueba 15: Mostrar las primeras 3 líneas de un archivo con head
$PIPEX infile "cat" "head -n 3" .tester/outfile15.txt
< infile cat | head -n 3 > .tester/outfile15_sys.txt
if diff .tester/outfile15.txt .tester/outfile15_sys.txt > /dev/null; then
    echo -n "${GREEN} 15. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 15. ${RED}[KO]${NC}"
fi

# Prueba 16: Buscar archivos con la palabra 'txt' con grep
$PIPEX infile "ls" "grep txt" .tester/outfile16.txt
< infile ls | grep txt > .tester/outfile16_sys.txt
if diff .tester/outfile16.txt .tester/outfile16_sys.txt > /dev/null; then
    echo -n "${GREEN} 16. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 16. ${RED}[KO]${NC}"
fi

# Prueba 17: Mostrar la salida del comando 'df' con grep
$PIPEX infile "df" "grep /dev/sda" .tester/outfile17.txt
< infile df | grep /dev/sda > .tester/outfile17_sys.txt
if diff .tester/outfile17.txt .tester/outfile17_sys.txt > /dev/null; then
    echo -n "${GREEN} 17. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 17. ${RED}[KO]${NC}"
fi

# Prueba 18: Contar líneas con wc -l
$PIPEX infile "cat" "wc -l" .tester/outfile18.txt
< infile cat | wc -l > .tester/outfile18_sys.txt
if diff .tester/outfile18.txt .tester/outfile18_sys.txt > /dev/null; then
    echo -n "${GREEN} 18. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 18. ${RED}[KO]${NC}"
fi

# Prueba 19: Mostrar los archivos con 'txt' con grep
$PIPEX infile "ls" "grep txt" .tester/outfile19.txt
< infile ls | grep txt > .tester/outfile19_sys.txt
if diff .tester/outfile19.txt .tester/outfile19_sys.txt > /dev/null; then
    echo -n "${GREEN} 19. ${GREEN}[OK]${NC}"
else
    echo -n "${RED} 19. ${RED}[KO]${NC}"
fi

# Prueba 20: Ver las últimas líneas con tail
$PIPEX infile "cat" "tail -n 5" .tester/outfile20.txt
< infile cat | tail -n 5 > .tester/outfile20_sys.txt
if diff .tester/outfile20.txt .tester/outfile20_sys.txt > /dev/null; then
    echo "${GREEN} 20. ${GREEN}[OK]${NC}"
else
    echo "${RED} 20. ${RED}[KO]${NC}"
fi

# Prueba 21: Redirigir la salida a un archivo nuevo con "echo"
$PIPEX infile "echo Hello" "cat" .tester/outfile21.txt
< infile echo Hello | cat > .tester/outfile21_sys.txt
if diff .tester/outfile21.txt .tester/outfile21_sys.txt > /dev/null; then
    echo -n "${GREEN} 21. [OK]${NC}"
else
    echo -n "${RED} 21. [KO]${NC}"
fi

# Prueba 22: Verificar el conteo de líneas con "wc -l"
$PIPEX infile "cat" "wc -l" .tester/outfile22.txt
< infile cat | wc -l > .tester/outfile22_sys.txt
if diff .tester/outfile22.txt .tester/outfile22_sys.txt > /dev/null; then
    echo -n "${GREEN} 22. [OK]${NC}"
else
    echo -n "${RED} 22. [KO]${NC}"
fi

# Prueba 23: Mostrar un archivo y contar las palabras con "wc -w"
$PIPEX infile "cat" "wc -w" .tester/outfile23.txt
< infile cat | wc -w > .tester/outfile23_sys.txt
if diff .tester/outfile23.txt .tester/outfile23_sys.txt > /dev/null; then
    echo -n "${GREEN} 23. [OK]${NC}"
else
    echo -n "${RED} 23. [KO]${NC}"
fi

# Prueba 24: Filtrar palabras con "grep" y contar con "wc -l"
$PIPEX infile "grep test" "wc -l" .tester/outfile24.txt
< infile grep test | wc -l > .tester/outfile24_sys.txt
if diff .tester/outfile24.txt .tester/outfile24_sys.txt > /dev/null; then
    echo -n "${GREEN} 24. [OK]${NC}"
else
    echo -n "${RED} 24. [KO]${NC}"
fi

# Prueba 25: Ordenar las líneas con "sort" y luego contar con "wc -w"
$PIPEX infile "sort" "wc -w" .tester/outfile25.txt
< infile sort | wc -w > .tester/outfile25_sys.txt
if diff .tester/outfile25.txt .tester/outfile25_sys.txt > /dev/null; then
    echo -n "${GREEN} 25. [OK]${NC}"
else
    echo -n "${RED} 25. [KO]${NC}"
fi

# Prueba 26: Buscar una palabra y luego ordenarla
$PIPEX infile "grep test" "sort" .tester/outfile26.txt
< infile grep test | sort > .tester/outfile26_sys.txt
if diff .tester/outfile26.txt .tester/outfile26_sys.txt > /dev/null; then
    echo -n "${GREEN} 26. [OK]${NC}"
else
    echo -n "${RED} 26. [KO]${NC}"
fi

# Prueba 27: Redirigir la salida de "cat" a "grep"
$PIPEX infile "cat" "grep test" .tester/outfile27.txt
< infile cat | grep test > .tester/outfile27_sys.txt
if diff .tester/outfile27.txt .tester/outfile27_sys.txt > /dev/null; then
    echo -n "${GREEN} 27. [OK]${NC}"
else
    echo -n "${RED} 27. [KO]${NC}"
fi

# Prueba 28: Usar "head -n 10" para mostrar las primeras 10 líneas
$PIPEX infile "cat" "head -n 10" .tester/outfile28.txt
< infile cat | head -n 10 > .tester/outfile28_sys.txt
if diff .tester/outfile28.txt .tester/outfile28_sys.txt > /dev/null; then
    echo -n "${GREEN} 28. [OK]${NC}"
else
    echo -n "${RED} 28. [KO]${NC}"
fi

# Prueba 29: Contar las líneas con "wc -l" y luego filtrar con "grep"
$PIPEX infile "wc -l" "grep 3" .tester/outfile29.txt
< infile wc -l | grep 3 > .tester/outfile29_sys.txt
if diff .tester/outfile29.txt .tester/outfile29_sys.txt > /dev/null; then
    echo -n "${GREEN} 29. [OK]${NC}"
else
    echo -n "${RED} 29. [KO]${NC}"
fi

# Prueba 30: Filtrar líneas con "grep" y luego ordenar con "sort"
$PIPEX infile "grep test" "sort" .tester/outfile30.txt
< infile grep test | sort > .tester/outfile30_sys.txt
if diff .tester/outfile30.txt .tester/outfile30_sys.txt > /dev/null; then
    echo -n "${GREEN} 30. [OK]${NC}"
else
    echo -n "${RED} 30. [KO]${NC}"
fi

# Prueba 31: Filtrar líneas con "grep" y mostrar las primeras 10 con "head"
$PIPEX infile "grep test" "head -n 10" .tester/outfile31.txt
< infile grep test | head -n 10 > .tester/outfile31_sys.txt
if diff .tester/outfile31.txt .tester/outfile31_sys.txt > /dev/null; then
    echo -n "${GREEN} 31. [OK]${NC}"
else
    echo -n "${RED} 31. [KO]${NC}"
fi

# Prueba 32: Usar "tail" para mostrar las últimas 5 líneas
$PIPEX infile "cat" "tail -n 5" .tester/outfile32.txt
< infile cat | tail -n 5 > .tester/outfile32_sys.txt
if diff .tester/outfile32.txt .tester/outfile32_sys.txt > /dev/null; then
    echo -n "${GREEN} 32. [OK]${NC}"
else
    echo -n "${RED} 32. [KO]${NC}"
fi

# Prueba 33: Usar "sort" y luego contar las palabras con "wc -w"
$PIPEX infile "sort" "wc -w" .tester/outfile33.txt
< infile sort | wc -w > .tester/outfile33_sys.txt
if diff .tester/outfile33.txt .tester/outfile33_sys.txt > /dev/null; then
    echo -n "${GREEN} 33. [OK]${NC}"
else
    echo -n "${RED} 33. [KO]${NC}"
fi

# Prueba 34: Mostrar el contenido de un archivo con "cat" y luego buscar con "grep"
$PIPEX infile "cat" "grep test" .tester/outfile34.txt
< infile cat | grep test > .tester/outfile34_sys.txt
if diff .tester/outfile34.txt .tester/outfile34_sys.txt > /dev/null; then
    echo -n "${GREEN} 34. [OK]${NC}"
else
    echo -n "${RED} 34. [KO]${NC}"
fi

# Prueba 35: Contar las palabras con "wc -w" y luego filtrar con "grep"
$PIPEX infile "wc -w" "grep 3" .tester/outfile35.txt
< infile wc -w | grep 3 > .tester/outfile35_sys.txt
if diff .tester/outfile35.txt .tester/outfile35_sys.txt > /dev/null; then
    echo -n "${GREEN} 35. [OK]${NC}"
else
    echo -n "${RED} 35. [KO]${NC}"
fi

# Prueba 36: Filtrar líneas con "grep" y luego ordenar con "sort"
$PIPEX infile "grep test" "sort" .tester/outfile36.txt
< infile grep test | sort > .tester/outfile36_sys.txt
if diff .tester/outfile36.txt .tester/outfile36_sys.txt > /dev/null; then
    echo -n "${GREEN} 36. [OK]${NC}"
else
    echo -n "${RED} 36. [KO]${NC}"
fi

# Prueba 37: Redirigir la salida de "echo" y luego filtrar con "grep"
$PIPEX infile "echo Hello" "grep Hello" .tester/outfile37.txt
< infile echo Hello | grep Hello > .tester/outfile37_sys.txt
if diff .tester/outfile37.txt .tester/outfile37_sys.txt > /dev/null; then
    echo -n "${GREEN} 37. [OK]${NC}"
else
    echo -n "${RED} 37. [KO]${NC}"
fi

# Prueba 38: Filtrar palabras con "grep" y mostrar las primeras 5 con "head"
$PIPEX infile "grep test" "head -n 5" .tester/outfile38.txt
< infile grep test | head -n 5 > .tester/outfile38_sys.txt
if diff .tester/outfile38.txt .tester/outfile38_sys.txt > /dev/null; then
    echo -n "${GREEN} 38. [OK]${NC}"
else
    echo -n "${RED} 38. [KO]${NC}"
fi

# Prueba 39: Filtrar líneas con "grep" y mostrar las últimas 5 con "tail"
$PIPEX infile "grep test" "tail -n 5" .tester/outfile39.txt
< infile grep test | tail -n 5 > .tester/outfile39_sys.txt
if diff .tester/outfile39.txt .tester/outfile39_sys.txt > /dev/null; then
    echo -n "${GREEN} 39. [OK]${NC}"
else
    echo -n "${RED} 39. [KO]${NC}"
fi

# Prueba 40: Buscar en un archivo y luego contar líneas con "wc -l"
$PIPEX infile "grep test" "wc -l" .tester/outfile40.txt
< infile grep test | wc -l > .tester/outfile40_sys.txt
if diff .tester/outfile40.txt .tester/outfile40_sys.txt > /dev/null; then
    echo -n "${GREEN} 40. [OK]${NC}"
else
    echo -n "${RED} 40. [KO]${NC}"
fi

# Prueba 41: Filtrar texto con "grep" y mostrar las primeras 10 líneas
$PIPEX infile "grep test" "head -n 10" .tester/outfile41.txt
< infile grep test | head -n 10 > .tester/outfile41_sys.txt
if diff .tester/outfile41.txt .tester/outfile41_sys.txt > /dev/null; then
    echo -n "${GREEN} 41. [OK]${NC}"
else
    echo -n "${RED} 41. [KO]${NC}"
fi

# Prueba 42: Usar "cut" para obtener la primera columna y luego contar las palabras
$PIPEX infile "cut -d ' ' -f1" "wc -w" .tester/outfile42.txt
< infile cut -d ' ' -f1 | wc -w > .tester/outfile42_sys.txt
if diff .tester/outfile42.txt .tester/outfile42_sys.txt > /dev/null; then
    echo -n "${GREEN} 42. [OK]${NC}"
else
    echo -n "${RED} 42. [KO]${NC}"
fi

# Prueba 43: Buscar una palabra con "grep" y contar el número de coincidencias
$PIPEX infile "grep test" "wc -l" .tester/outfile43.txt
< infile grep test | wc -l > .tester/outfile43_sys.txt
if diff .tester/outfile43.txt .tester/outfile43_sys.txt > /dev/null; then
    echo -n "${GREEN} 43. [OK]${NC}"
else
    echo -n "${RED} 43. [KO]${NC}"
fi

# Prueba 44: Ordenar el archivo y mostrar las primeras 5 líneas
$PIPEX infile "sort" "head -n 5" .tester/outfile44.txt
< infile sort | head -n 5 > .tester/outfile44_sys.txt
if diff .tester/outfile44.txt .tester/outfile44_sys.txt > /dev/null; then
    echo -n "${GREEN} 44. [OK]${NC}"
else
    echo -n "${RED} 44. [KO]${NC}"
fi

# Prueba 45: Redirigir la salida de "cat" a "grep" y luego contar líneas
$PIPEX infile "cat" "grep test" .tester/outfile45.txt
< infile cat | grep test > .tester/outfile45_sys.txt
if diff .tester/outfile45.txt .tester/outfile45_sys.txt > /dev/null; then
    echo -n "${GREEN} 45. [OK]${NC}"
else
    echo -n "${RED} 45. [KO]${NC}"
fi

# Prueba 46: Usar "sort" y luego eliminar duplicados con "uniq"
$PIPEX infile "sort" "uniq" .tester/outfile46.txt
< infile sort | uniq > .tester/outfile46_sys.txt
if diff .tester/outfile46.txt .tester/outfile46_sys.txt > /dev/null; then
    echo -n "${GREEN} 46. [OK]${NC}"
else
    echo -n "${RED} 46. [KO]${NC}"
fi

# Prueba 47: Buscar un patrón con "grep" y luego contar las palabras
$PIPEX infile "grep test" "wc -w" .tester/outfile47.txt
< infile grep test | wc -w > .tester/outfile47_sys.txt
if diff .tester/outfile47.txt .tester/outfile47_sys.txt > /dev/null; then
    echo -n "${GREEN} 47. [OK]${NC}"
else
    echo -n "${RED} 47. [KO]${NC}"
fi

# Prueba 48: Filtrar con "grep" y ordenar el resultado con "sort"
$PIPEX infile "grep test" "sort" .tester/outfile48.txt
< infile grep test | sort > .tester/outfile48_sys.txt
if diff .tester/outfile48.txt .tester/outfile48_sys.txt > /dev/null; then
    echo -n "${GREEN} 48. [OK]${NC}"
else
    echo -n "${RED} 48. [KO]${NC}"
fi

# Prueba 49: Buscar y mostrar solo la primera línea con "head -n 1"
$PIPEX infile "grep test" "head -n 1" .tester/outfile49.txt
< infile grep test | head -n 1 > .tester/outfile49_sys.txt
if diff .tester/outfile49.txt .tester/outfile49_sys.txt > /dev/null; then
    echo -n "${GREEN} 49. [OK]${NC}"
else
    echo -n "${RED} 49. [KO]${NC}"
fi

# Prueba 50: Mostrar el contenido de un archivo con "cat" y luego contar las palabras con "wc -w"
$PIPEX infile "cat" "wc -w" .tester/outfile50.txt
< infile cat | wc -w > .tester/outfile50_sys.txt
if diff .tester/outfile50.txt .tester/outfile50_sys.txt > /dev/null; then
    echo -n "${GREEN} 50. [OK]${NC}"
else
    echo -n "${RED} 50. [KO]${NC}"
fi

echo "\n"
echo "Bonus casos normales 3 comandos"
echo "\n"

# Prueba 51: Tres comandos con pipe
$PIPEX infile "ls" "grep test" "cat" .tester/outfile51.txt
< infile ls | grep test | cat > .tester/outfile51_sys.txt
if diff .tester/outfile51.txt .tester/outfile51_sys.txt > /dev/null; then
    echo -n "${GREEN} 51. [OK]${NC}"
else
    echo -n "${RED} 51. [KO]${NC}"
fi

# Prueba 52: Tres comandos con redirección de entrada y salida
$PIPEX infile "cat" "grep test" "sort" .tester/outfile52.txt
< infile cat | grep test | sort > .tester/outfile52_sys.txt
if diff .tester/outfile52.txt .tester/outfile52_sys.txt > /dev/null; then
    echo -n "${GREEN} 52. [OK]${NC}"
else
    echo -n "${RED} 52. [KO]${NC}"
fi

# Prueba 53: Tres comandos con diferentes opciones de filtrado
$PIPEX infile "cat" "grep '2024'" "head -n 10" .tester/outfile53.txt
< infile cat | grep '2024' | head -n 10 > .tester/outfile53_sys.txt
if diff .tester/outfile53.txt .tester/outfile53_sys.txt > /dev/null; then
    echo -n "${GREEN} 53. [OK]${NC}"
else
    echo -n "${RED} 53. [KO]${NC}"
fi

# Prueba 54: Tres comandos con una combinación de diferentes filtros
$PIPEX infile "cat" "grep 'hello'" "sort -r" .tester/outfile54.txt
< infile cat | grep 'hello' | sort -r > .tester/outfile54_sys.txt
if diff .tester/outfile54.txt .tester/outfile54_sys.txt > /dev/null; then
    echo -n "${GREEN} 54. [OK]${NC}"
else
    echo -n "${RED} 54. [KO]${NC}"
fi

# Prueba 55: Tres comandos con salida a un archivo
$PIPEX infile "ls" "grep 'doc'" "wc -l" .tester/outfile55.txt
< infile ls | grep 'doc' | wc -l > .tester/outfile55_sys.txt
if diff .tester/outfile55.txt .tester/outfile55_sys.txt > /dev/null; then
    echo -n "${GREEN} 55. [OK]${NC}"
else
    echo -n "${RED} 55. [KO]${NC}"
fi
# Prueba 56: Tres comandos, redirigir salida a un archivo
$PIPEX infile "cat" "grep 'error'" "wc -l" .tester/outfile56.txt
< infile cat | grep 'error' | wc -l > .tester/outfile56_sys.txt
if diff .tester/outfile56.txt .tester/outfile56_sys.txt > /dev/null; then
    echo -n "${GREEN} 56. [OK]${NC}"
else
    echo -n "${RED} 56. [KO]${NC}"
fi

# Prueba 57: Tres comandos, filtrar y ordenar
$PIPEX infile "ls" "grep 'txt'" "sort" .tester/outfile57.txt
< infile ls | grep 'txt' | sort > .tester/outfile57_sys.txt
if diff .tester/outfile57.txt .tester/outfile57_sys.txt > /dev/null; then
    echo -n "${GREEN} 57. [OK]${NC}"
else
    echo -n "${RED} 57. [KO]${NC}"
fi

# Prueba 58: Comandos con varias combinaciones de filtrado
$PIPEX infile "cat" "grep 'warning'" "grep -v 'critical'" .tester/outfile58.txt
< infile cat | grep 'warning' | grep -v 'critical' > .tester/outfile58_sys.txt
if diff .tester/outfile58.txt .tester/outfile58_sys.txt > /dev/null; then
    echo -n "${GREEN} 58. [OK]${NC}"
else
    echo -n "${RED} 58. [KO]${NC}"
fi

# Prueba 59: Comandos con salida formateada
$PIPEX infile "cat" "cut -d ' ' -f 1" "sort" .tester/outfile59.txt
< infile cat | cut -d ' ' -f 1 | sort > .tester/outfile59_sys.txt
if diff .tester/outfile59.txt .tester/outfile59_sys.txt > /dev/null; then
    echo -n "${GREEN} 59. [OK]${NC}"
else
    echo -n "${RED} 59. [KO]${NC}"
fi

# Prueba 60: Tres comandos, mostrar el final de los archivos
$PIPEX infile "cat" "tail -n 10" "sort" .tester/outfile60.txt
< infile cat | tail -n 10 | sort > .tester/outfile60_sys.txt
if diff .tester/outfile60.txt .tester/outfile60_sys.txt > /dev/null; then
    echo -n "${GREEN} 60. [OK]${NC}"
else
    echo -n "${RED} 60. [KO]${NC}"
fi

# Prueba 61: Filtrar logs de un archivo
$PIPEX infile "grep 'ERROR'" "grep 'Database'" "cat" .tester/outfile61.txt
< infile grep 'ERROR' | grep 'Database' | cat > .tester/outfile61_sys.txt
if diff .tester/outfile61.txt .tester/outfile61_sys.txt > /dev/null; then
    echo -n "${GREEN} 61. [OK]${NC}"
else
    echo -n "${RED} 61. [KO]${NC}"
fi

# Prueba 62: Mostrar las primeras líneas
$PIPEX infile "head -n 20" "grep 'success'" "sort" .tester/outfile62.txt
< infile head -n 20 | grep 'success' | sort > .tester/outfile62_sys.txt
if diff .tester/outfile62.txt .tester/outfile62_sys.txt > /dev/null; then
    echo -n "${GREEN} 62. [OK]${NC}"
else
    echo -n "${RED} 62. [KO]${NC}"
fi

# Prueba 63: Combina comandos para contar palabras
$PIPEX infile "cat" "grep 'word'" "wc -w" .tester/outfile63.txt
< infile cat | grep 'word' | wc -w > .tester/outfile63_sys.txt
if diff .tester/outfile63.txt .tester/outfile63_sys.txt > /dev/null; then
    echo -n "${GREEN} 63. [OK]${NC}"
else
    echo -n "${RED} 63. [KO]${NC}"
fi

# Prueba 64: Tres comandos, mostrar logs
$PIPEX infile "cat" "grep 'INFO'" "tail -n 5" .tester/outfile64.txt
< infile cat | grep 'INFO' | tail -n 5 > .tester/outfile64_sys.txt
if diff .tester/outfile64.txt .tester/outfile64_sys.txt > /dev/null; then
    echo -n "${GREEN} 64. [OK]${NC}"
else
    echo -n "${RED} 64. [KO]${NC}"
fi

# Prueba 65: Procesamiento de texto con reemplazo
$PIPEX infile "cat" "sed 's/error/warning/g'" "sort" .tester/outfile65.txt
< infile cat | sed 's/error/warning/g' | sort > .tester/outfile65_sys.txt
if diff .tester/outfile65.txt .tester/outfile65_sys.txt > /dev/null; then
    echo -n "${GREEN} 65. [OK]${NC}"
else
    echo -n "${RED} 65. [KO]${NC}"
fi

# Prueba 66: Filtrar solo las líneas que contienen un número
$PIPEX infile "cat" "grep -E '\d+'" "sort -n" .tester/outfile66.txt
< infile cat | grep -E '\d+' | sort -n > .tester/outfile66_sys.txt
if diff .tester/outfile66.txt .tester/outfile66_sys.txt > /dev/null; then
    echo -n "${GREEN} 66. [OK]${NC}"
else
    echo -n "${RED} 66. [KO]${NC}"
fi

# Prueba 67: Encontrar y contar líneas que contienen 'error'
$PIPEX infile "grep 'error'" "wc -l" .tester/outfile67.txt
< infile grep 'error' | wc -l > .tester/outfile67_sys.txt
if diff .tester/outfile67.txt .tester/outfile67_sys.txt > /dev/null; then
    echo -n "${GREEN} 67. [OK]${NC}"
else
    echo -n "${RED} 67. [KO]${NC}"
fi

# Prueba 68: Mostrar últimas líneas después de aplicar un filtro
$PIPEX infile "cat" "grep 'pass'" "tail -n 5" .tester/outfile68.txt
< infile cat | grep 'pass' | tail -n 5 > .tester/outfile68_sys.txt
if diff .tester/outfile68.txt .tester/outfile68_sys.txt > /dev/null; then
    echo -n "${GREEN} 68. [OK]${NC}"
else
    echo -n "${RED} 68. [KO]${NC}"
fi

# Prueba 69: Filtrar y hacer un conteo de líneas
$PIPEX infile "cat" "grep 'server'" "wc -l" .tester/outfile69.txt
< infile cat | grep 'server' | wc -l > .tester/outfile69_sys.txt
if diff .tester/outfile69.txt .tester/outfile69_sys.txt > /dev/null; then
    echo -n "${GREEN} 69. [OK]${NC}"
else
    echo -n "${RED} 69. [KO]${NC}"
fi

# Prueba 70: Comandos con procesado de texto y formato
$PIPEX infile "cat" "sed 's/^/Prefix: /'" "sort" .tester/outfile70.txt
< infile cat | sed 's/^/Prefix: /' | sort > .tester/outfile70_sys.txt
if diff .tester/outfile70.txt .tester/outfile70_sys.txt > /dev/null; then
    echo -n "${GREEN} 70. [OK]${NC}"
else
    echo -n "${RED} 70. [KO]${NC}"
fi

# Prueba 71: Mostrar el contenido de un archivo y ordenar por tamaño
$PIPEX infile "ls -lh" "sort -k 5" "head -n 10" .tester/outfile71.txt
< infile ls -lh | sort -k 5 | head -n 10 > .tester/outfile71_sys.txt
if diff .tester/outfile71.txt .tester/outfile71_sys.txt > /dev/null; then
    echo -n "${GREEN} 71. [OK]${NC}"
else
    echo -n "${RED} 71. [KO]${NC}"
fi

# Prueba 72: Combina comandos para filtrar y mostrar el contenido
$PIPEX infile "cat" "grep 'success'" "tail -n 3" .tester/outfile72.txt
< infile cat | grep 'success' | tail -n 3 > .tester/outfile72_sys.txt
if diff .tester/outfile72.txt .tester/outfile72_sys.txt > /dev/null; then
    echo -n "${GREEN} 72. [OK]${NC}"
else
    echo -n "${RED} 72. [KO]${NC}"
fi

# Prueba 73: Buscar un patrón en un archivo
$PIPEX infile "grep 'pattern'" "sort" "uniq" .tester/outfile73.txt
< infile grep 'pattern' | sort | uniq > .tester/outfile73_sys.txt
if diff .tester/outfile73.txt .tester/outfile73_sys.txt > /dev/null; then
    echo -n "${GREEN} 73. [OK]${NC}"
else
    echo -n "${RED} 73. [KO]${NC}"
fi

# Prueba 74: Combinación de cat, grep, y tail
$PIPEX infile "cat" "grep '2024'" "tail -n 15" .tester/outfile74.txt
< infile cat | grep '2024' | tail -n 15 > .tester/outfile74_sys.txt
if diff .tester/outfile74.txt .tester/outfile74_sys.txt > /dev/null; then
    echo -n "${GREEN} 74. [OK]${NC}"
else
    echo -n "${RED} 74. [KO]${NC}"
fi

# Prueba 75: Mostrar el contenido y hacer un orden inverso
$PIPEX infile "cat" "sort -r" "head -n 5" .tester/outfile75.txt
< infile cat | sort -r | head -n 5 > .tester/outfile75_sys.txt
if diff .tester/outfile75.txt .tester/outfile75_sys.txt > /dev/null; then
    echo -n "${GREEN} 75. [OK]${NC}"
else
    echo -n "${RED} 75. [KO]${NC}"
fi

# Prueba 76: Procesar logs con múltiples comandos de filtrado
$PIPEX infile "cat" "grep 'error'" "grep 'critical'" "sort" .tester/outfile76.txt
< infile cat | grep 'error' | grep 'critical' | sort > .tester/outfile76_sys.txt
if diff .tester/outfile76.txt .tester/outfile76_sys.txt > /dev/null; then
    echo -n "${GREEN} 76. [OK]${NC}"
else
    echo -n "${RED} 76. [KO]${NC}"
fi

# Prueba 77: Combina comandos para mostrar y ordenar
$PIPEX infile "cat" "sort" "uniq" .tester/outfile77.txt
< infile cat | sort | uniq > .tester/outfile77_sys.txt
if diff .tester/outfile77.txt .tester/outfile77_sys.txt > /dev/null; then
    echo -n "${GREEN} 77. [OK]${NC}"
else
    echo -n "${RED} 77. [KO]${NC}"
fi

# Prueba 78: Comando con búsqueda de una palabra específica
$PIPEX infile "grep 'search'" "cat" "head -n 10" .tester/outfile78.txt
< infile grep 'search' | cat | head -n 10 > .tester/outfile78_sys.txt
if diff .tester/outfile78.txt .tester/outfile78_sys.txt > /dev/null; then
    echo -n "${GREEN} 78. [OK]${NC}"
else
    echo -n "${RED} 78. [KO]${NC}"
fi

# Prueba 79: Verificar si hay alguna coincidencia
$PIPEX infile "cat" "grep 'pattern'" "sort -u" .tester/outfile79.txt
< infile cat | grep 'pattern' | sort -u > .tester/outfile79_sys.txt
if diff .tester/outfile79.txt .tester/outfile79_sys.txt > /dev/null; then
    echo -n "${GREEN} 79. [OK]${NC}"
else
    echo -n "${RED} 79. [KO]${NC}"
fi

# Prueba 80: Combina filtros con reducción de líneas
$PIPEX infile "cat" "grep 'pass'" "tail -n 5" .tester/outfile80.txt
< infile cat | grep 'pass' | tail -n 5 > .tester/outfile80_sys.txt
if diff .tester/outfile80.txt .tester/outfile80_sys.txt > /dev/null; then
    echo "${GREEN} 80. [OK]${NC}"
else
    echo "${RED} 80. [KO]${NC}"
fi

echo "Bonus casos normales 4 comandos"
echo "\n"

# Prueba 81: Cuatro comandos para filtrar, ordenar y contar
$PIPEX infile "cat" "grep 'pattern'" "sort" "wc -l" .tester/outfile81.txt
< infile cat | grep 'pattern' | sort | wc -l > .tester/outfile81_sys.txt
if diff .tester/outfile81.txt .tester/outfile81_sys.txt > /dev/null; then
    echo -n "${GREEN} 81. [OK]${NC}"
else
    echo -n "${RED} 81. [KO]${NC}"
fi

# Prueba 82: Filtrar, ordenar y mostrar las primeras líneas
$PIPEX infile "cat" "grep 'error'" "sort" "head -n 10" .tester/outfile82.txt
< infile cat | grep 'error' | sort | head -n 10 > .tester/outfile82_sys.txt
if diff .tester/outfile82.txt .tester/outfile82_sys.txt > /dev/null; then
    echo -n "${GREEN} 82. [OK]${NC}"
else
    echo -n "${RED} 82. [KO]${NC}"
fi

# Prueba 83: Buscar patrones, ordenar y mostrar las últimas líneas
$PIPEX infile "cat" "grep 'success'" "sort" "tail -n 10" .tester/outfile83.txt
< infile cat | grep 'success' | sort | tail -n 10 > .tester/outfile83_sys.txt
if diff .tester/outfile83.txt .tester/outfile83_sys.txt > /dev/null; then
    echo -n "${GREEN} 83. [OK]${NC}"
else
    echo -n "${RED} 83. [KO]${NC}"
fi

# Prueba 84: Buscar palabras, mostrar las primeras y ordenar
$PIPEX infile "cat" "grep 'log'" "head -n 10" "sort" .tester/outfile84.txt
< infile cat | grep 'log' | head -n 10 | sort > .tester/outfile84_sys.txt
if diff .tester/outfile84.txt .tester/outfile84_sys.txt > /dev/null; then
    echo -n "${GREEN} 84. [OK]${NC}"
else
    echo -n "${RED} 84. [KO]${NC}"
fi

# Prueba 85: Buscar y contar líneas con un patrón específico
$PIPEX infile "cat" "grep 'warning'" "wc -l" "sort" .tester/outfile85.txt
< infile cat | grep 'warning' | wc -l | sort > .tester/outfile85_sys.txt
if diff .tester/outfile85.txt .tester/outfile85_sys.txt > /dev/null; then
    echo -n "${GREEN} 85. [OK]${NC}"
else
    echo -n "${RED} 85. [KO]${NC}"
fi

# Prueba 86: Extraer columnas, buscar, ordenar y mostrar las últimas líneas
$PIPEX infile "cat" "cut -d ' ' -f 2" "grep 'pattern'" "tail -n 5" .tester/outfile86.txt
< infile cat | cut -d ' ' -f 2 | grep 'pattern' | tail -n 5 > .tester/outfile86_sys.txt
if diff .tester/outfile86.txt .tester/outfile86_sys.txt > /dev/null; then
    echo -n "${GREEN} 86. [OK]${NC}"
else
    echo -n "${RED} 86. [KO]${NC}"
fi

# Prueba 87: Filtrar y ordenar logs
$PIPEX infile "cat" "grep 'error'" "sort" "uniq" .tester/outfile87.txt
< infile cat | grep 'error' | sort | uniq > .tester/outfile87_sys.txt
if diff .tester/outfile87.txt .tester/outfile87_sys.txt > /dev/null; then
    echo -n "${GREEN} 87. [OK]${NC}"
else
    echo -n "${RED} 87. [KO]${NC}"
fi

# Prueba 88: Redirigir salida, buscar, ordenar y mostrar las primeras líneas
$PIPEX infile "cat" "grep 'critical'" "sort" "head -n 5" .tester/outfile88.txt
< infile cat | grep 'critical' | sort | head -n 5 > .tester/outfile88_sys.txt
if diff .tester/outfile88.txt .tester/outfile88_sys.txt > /dev/null; then
    echo -n "${GREEN} 88. [OK]${NC}"
else
    echo -n "${RED} 88. [KO]${NC}"
fi

# Prueba 89: Buscar, filtrar, ordenar y mostrar las últimas líneas
$PIPEX infile "cat" "grep 'debug'" "sort" "tail -n 5" .tester/outfile89.txt
< infile cat | grep 'debug' | sort | tail -n 5 > .tester/outfile89_sys.txt
if diff .tester/outfile89.txt .tester/outfile89_sys.txt > /dev/null; then
    echo -n "${GREEN} 89. [OK]${NC}"
else
    echo -n "${RED} 89. [KO]${NC}"
fi

# Prueba 90: Buscar, ordenar y contar líneas
$PIPEX infile "cat" "grep 'status'" "sort" "wc -l" .tester/outfile90.txt
< infile cat | grep 'status' | sort | wc -l > .tester/outfile90_sys.txt
if diff .tester/outfile90.txt .tester/outfile90_sys.txt > /dev/null; then
    echo -n "${GREEN} 90. [OK]${NC}"
else
    echo -n "${RED} 90. [KO]${NC}"
fi

# Prueba 91: Redirigir y procesar con `cut`, `grep`, `sort` y `uniq`
$PIPEX infile "cat" "cut -d ' ' -f 3" "grep 'pattern'" "uniq" .tester/outfile91.txt
< infile cat | cut -d ' ' -f 3 | grep 'pattern' | uniq > .tester/outfile91_sys.txt
if diff .tester/outfile91.txt .tester/outfile91_sys.txt > /dev/null; then
    echo -n "${GREEN} 91. [OK]${NC}"
else
    echo -n "${RED} 91. [KO]${NC}"
fi

# Prueba 92: Filtrar, ordenar y hacer un corte en columnas
$PIPEX infile "cat" "grep '2024'" "sort" "cut -d ' ' -f 2" .tester/outfile92.txt
< infile cat | grep '2024' | sort | cut -d ' ' -f 2 > .tester/outfile92_sys.txt
if diff .tester/outfile92.txt .tester/outfile92_sys.txt > /dev/null; then
    echo -n "${GREEN} 92. [OK]${NC}"
else
    echo -n "${RED} 92. [KO]${NC}"
fi

# Prueba 93: Filtrar líneas, ordenar y obtener el recuento
$PIPEX infile "cat" "grep 'pass'" "sort" "wc -l" .tester/outfile93.txt
< infile cat | grep 'pass' | sort | wc -l > .tester/outfile93_sys.txt
if diff .tester/outfile93.txt .tester/outfile93_sys.txt > /dev/null; then
    echo -n "${GREEN} 93. [OK]${NC}"
else
    echo -n "${RED} 93. [KO]${NC}"
fi

# Prueba 94: Cortar columnas, filtrar y ordenar
$PIPEX infile "cat" "cut -d ' ' -f 1" "grep 'server'" "sort" .tester/outfile94.txt
< infile cat | cut -d ' ' -f 1 | grep 'server' | sort > .tester/outfile94_sys.txt
if diff .tester/outfile94.txt .tester/outfile94_sys.txt > /dev/null; then
    echo -n "${GREEN} 94. [OK]${NC}"
else
    echo -n "${RED} 94. [KO]${NC}"
fi

# Prueba 95: Buscar, ordenar y mostrar las últimas líneas
$PIPEX infile "cat" "grep 'data'" "sort" "tail -n 3" .tester/outfile95.txt
< infile cat | grep 'data' | sort | tail -n 3 > .tester/outfile95_sys.txt
if diff .tester/outfile95.txt .tester/outfile95_sys.txt > /dev/null; then
    echo -n "${GREEN} 95. [OK]${NC}"
else
    echo -n "${RED} 95. [KO]${NC}"
fi

# Prueba 96: Mostrar las líneas y contar palabras
$PIPEX infile "cat" "grep 'info'" "wc -w" "sort" .tester/outfile96.txt
< infile cat | grep 'info' | wc -w | sort > .tester/outfile96_sys.txt
if diff .tester/outfile96.txt .tester/outfile96_sys.txt > /dev/null; then
    echo -n "${GREEN} 96. [OK]${NC}"
else
    echo -n "${RED} 96. [KO]${NC}"
fi

# Prueba 97: Buscar en líneas y realizar un corte específico
$PIPEX infile "cat" "grep 'error'" "cut -d ' ' -f 4" "sort" .tester/outfile97.txt
< infile cat | grep 'error' | cut -d ' ' -f 4 | sort > .tester/outfile97_sys.txt
if diff .tester/outfile97.txt .tester/outfile97_sys.txt > /dev/null; then
    echo -n "${GREEN} 97. [OK]${NC}"
else
    echo -n "${RED} 97. [KO]${NC}"
fi

# Prueba 98: Realizar un corte, ordenar y contar
$PIPEX infile "cat" "cut -d ' ' -f 3" "sort" "wc -l" .tester/outfile98.txt
< infile cat | cut -d ' ' -f 3 | sort | wc -l > .tester/outfile98_sys.txt
if diff .tester/outfile98.txt .tester/outfile98_sys.txt > /dev/null; then
    echo -n "${GREEN} 98. [OK]${NC}"
else
    echo -n "${RED} 98. [KO]${NC}"
fi

# Prueba 99: Buscar por fecha, ordenar y contar
$PIPEX infile "cat" "grep '2024'" "sort" "wc -l" .tester/outfile99.txt
< infile cat | grep '2024' | sort | wc -l > .tester/outfile99_sys.txt
if diff .tester/outfile99.txt .tester/outfile99_sys.txt > /dev/null; then
    echo -n "${GREEN} 99. [OK]${NC}"
else
    echo -n "${RED} 99. [KO]${NC}"
fi

# Prueba 100: Buscar por patrón y ordenar por fecha
$PIPEX infile "cat" "grep 'pattern'" "sort" "uniq" .tester/outfile100.txt
< infile cat | grep 'pattern' | sort | uniq > .tester/outfile100_sys.txt
if diff .tester/outfile100.txt .tester/outfile100_sys.txt > /dev/null; then
    echo -n "${GREEN} 100. [OK]${NC}"
else
    echo -n "${RED} 100. [KO]${NC}"
fi

echo "bonus 5 comandos "
echo "\n"
# Prueba 101: Filtrar, ordenar, contar y cortar columnas
$PIPEX infile "cat" "grep 'pattern'" "sort" "cut -d ' ' -f 2" "wc -l" .tester/outfile101.txt
< infile cat | grep 'pattern' | sort | cut -d ' ' -f 2 | wc -l > .tester/outfile101_sys.txt
if diff .tester/outfile101.txt .tester/outfile101_sys.txt > /dev/null; then
    echo -n "${GREEN} 101. [OK]${NC}"
else
    echo -n "${RED} 101. [KO]${NC}"
fi

# Prueba 102: Cortar columnas, buscar, ordenar y contar palabras
$PIPEX infile "cat" "cut -d ' ' -f 2" "grep 'data'" "sort" "wc -w" .tester/outfile102.txt
< infile cat | cut -d ' ' -f 2 | grep 'data' | sort | wc -w > .tester/outfile102_sys.txt
if diff .tester/outfile102.txt .tester/outfile102_sys.txt > /dev/null; then
    echo -n "${GREEN} 102. [OK]${NC}"
else
    echo -n "${RED} 102. [KO]${NC}"
fi

# Prueba 103: Buscar, ordenar, mostrar las primeras líneas y contar palabras
$PIPEX infile "cat" "grep 'error'" "sort" "head -n 5" "wc -w" .tester/outfile103.txt
< infile cat | grep 'error' | sort | head -n 5 | wc -w > .tester/outfile103_sys.txt
if diff .tester/outfile103.txt .tester/outfile103_sys.txt > /dev/null; then
    echo -n "${GREEN} 103. [OK]${NC}"
else
    echo -n "${RED} 103. [KO]${NC}"
fi

# Prueba 104: Buscar y ordenar, mostrar las últimas líneas y contar
$PIPEX infile "cat" "grep 'log'" "sort" "tail -n 10" "wc -l" .tester/outfile104.txt
< infile cat | grep 'log' | sort | tail -n 10 | wc -l > .tester/outfile104_sys.txt
if diff .tester/outfile104.txt .tester/outfile104_sys.txt > /dev/null; then
    echo -n "${GREEN} 104. [OK]${NC}"
else
    echo -n "${RED} 104. [KO]${NC}"
fi

# Prueba 105: Filtrar, ordenar y contar líneas, mostrar las primeras y últimas
$PIPEX infile "cat" "grep 'success'" "sort" "head -n 5" "tail -n 5" .tester/outfile105.txt
< infile cat | grep 'success' | sort | head -n 5 | tail -n 5 > .tester/outfile105_sys.txt
if diff .tester/outfile105.txt .tester/outfile105_sys.txt > /dev/null; then
    echo -n "${GREEN} 105. [OK]${NC}"
else
    echo -n "${RED} 105. [KO]${NC}"
fi

# Prueba 106: Buscar por fecha, ordenar, contar y cortar
$PIPEX infile "cat" "grep '2024'" "sort" "wc -l" "cut -d ' ' -f 3" .tester/outfile106.txt
< infile cat | grep '2024' | sort | wc -l | cut -d ' ' -f 3 > .tester/outfile106_sys.txt
if diff .tester/outfile106.txt .tester/outfile106_sys.txt > /dev/null; then
    echo -n "${GREEN} 106. [OK]${NC}"
else
    echo -n "${RED} 106. [KO]${NC}"
fi

# Prueba 107: Buscar, ordenar, cortar y contar
$PIPEX infile "cat" "grep 'error'" "sort" "cut -d ' ' -f 2" "wc -l" .tester/outfile107.txt
< infile cat | grep 'error' | sort | cut -d ' ' -f 2 | wc -l > .tester/outfile107_sys.txt
if diff .tester/outfile107.txt .tester/outfile107_sys.txt > /dev/null; then
    echo -n "${GREEN} 107. [OK]${NC}"
else
    echo -n "${RED} 107. [KO]${NC}"
fi

# Prueba 108: Cortar, buscar, ordenar y mostrar las primeras líneas
$PIPEX infile "cat" "cut -d ' ' -f 1" "grep 'warning'" "sort" "head -n 10" .tester/outfile108.txt
< infile cat | cut -d ' ' -f 1 | grep 'warning' | sort | head -n 10 > .tester/outfile108_sys.txt
if diff .tester/outfile108.txt .tester/outfile108_sys.txt > /dev/null; then
    echo -n "${GREEN} 108. [OK]${NC}"
else
    echo -n "${RED} 108. [KO]${NC}"
fi

# Prueba 109: Buscar, ordenar, mostrar las últimas líneas y cortar columnas
$PIPEX infile "cat" "grep 'debug'" "sort" "tail -n 10" "cut -d ' ' -f 3" .tester/outfile109.txt
< infile cat | grep 'debug' | sort | tail -n 10 | cut -d ' ' -f 3 > .tester/outfile109_sys.txt
if diff .tester/outfile109.txt .tester/outfile109_sys.txt > /dev/null; then
    echo -n "${GREEN} 109. [OK]${NC}"
else
    echo -n "${RED} 109. [KO]${NC}"
fi

# Prueba 110: Filtrar, ordenar, contar y mostrar las primeras líneas
$PIPEX infile "cat" "grep 'test'" "sort" "wc -l" "head -n 5" .tester/outfile110.txt
< infile cat | grep 'test' | sort | wc -l | head -n 5 > .tester/outfile110_sys.txt
if diff .tester/outfile110.txt .tester/outfile110_sys.txt > /dev/null; then
    echo -n "${GREEN} 110. [OK]${NC}"
else
    echo -n "${RED} 110. [KO]${NC}"
fi

# Prueba 111: Buscar, ordenar, mostrar las últimas líneas y cortar
$PIPEX infile "cat" "grep 'info'" "sort" "tail -n 10" "cut -d ' ' -f 1" .tester/outfile111.txt
< infile cat | grep 'info' | sort | tail -n 10 | cut -d ' ' -f 1 > .tester/outfile111_sys.txt
if diff .tester/outfile111.txt .tester/outfile111_sys.txt > /dev/null; then
    echo -n "${GREEN} 111. [OK]${NC}"
else
    echo -n "${RED} 111. [KO]${NC}"
fi

# Prueba 112: Buscar por patrón, ordenar y contar palabras
$PIPEX infile "cat" "grep 'success'" "sort" "wc -w" "uniq" .tester/outfile112.txt
< infile cat | grep 'success' | sort | wc -w | uniq > .tester/outfile112_sys.txt
if diff .tester/outfile112.txt .tester/outfile112_sys.txt > /dev/null; then
    echo -n "${GREEN} 112. [OK]${NC}"
else
    echo -n "${RED} 112. [KO]${NC}"
fi

# Prueba 113: Buscar y ordenar, contar palabras y mostrar las primeras
$PIPEX infile "cat" "grep 'critical'" "sort" "wc -w" "head -n 10" .tester/outfile113.txt
< infile cat | grep 'critical' | sort | wc -w | head -n 10 > .tester/outfile113_sys.txt
if diff .tester/outfile113.txt .tester/outfile113_sys.txt > /dev/null; then
    echo -n "${GREEN} 113. [OK]${NC}"
else
    echo -n "${RED} 113. [KO]${NC}"
fi

# Prueba 114: Cortar, ordenar, contar palabras y mostrar las últimas líneas
$PIPEX infile "cat" "cut -d ' ' -f 2" "grep 'status'" "sort" "tail -n 10" .tester/outfile114.txt
< infile cat | cut -d ' ' -f 2 | grep 'status' | sort | tail -n 10 > .tester/outfile114_sys.txt
if diff .tester/outfile114.txt .tester/outfile114_sys.txt > /dev/null; then
    echo -n "${GREEN} 114. [OK]${NC}"
else
    echo -n "${RED} 114. [KO]${NC}"
fi

# Prueba 115: Buscar, ordenar, cortar y mostrar las primeras líneas
$PIPEX infile "cat" "grep 'pattern'" "sort" "cut -d ' ' -f 1" "head -n 5" .tester/outfile115.txt
< infile cat | grep 'pattern' | sort | cut -d ' ' -f 1 | head -n 5 > .tester/outfile115_sys.txt
if diff .tester/outfile115.txt .tester/outfile115_sys.txt > /dev/null; then
    echo -n "${GREEN} 115. [OK]${NC}"
else
    echo -n "${RED} 115. [KO]${NC}"
fi

# Prueba 116: Buscar, ordenar y filtrar por palabra, contar y mostrar
$PIPEX infile "cat" "grep 'error'" "sort" "wc -l" "head -n 10" .tester/outfile116.txt
< infile cat | grep 'error' | sort | wc -l | head -n 10 > .tester/outfile116_sys.txt
if diff .tester/outfile116.txt .tester/outfile116_sys.txt > /dev/null; then
    echo -n "${GREEN} 116. [OK]${NC}"
else
    echo -n "${RED} 116. [KO]${NC}"
fi

# Prueba 117: Ordenar, cortar columnas, filtrar y mostrar las últimas líneas
$PIPEX infile "cat" "sort" "cut -d ' ' -f 1" "grep 'log'" "tail -n 5" .tester/outfile117.txt
< infile cat | sort | cut -d ' ' -f 1 | grep 'log' | tail -n 5 > .tester/outfile117_sys.txt
if diff .tester/outfile117.txt .tester/outfile117_sys.txt > /dev/null; then
    echo -n "${GREEN} 117. [OK]${NC}"
else
    echo -n "${RED} 117. [KO]${NC}"
fi

# Prueba 118: Cortar columnas, buscar, ordenar y contar palabras
$PIPEX infile "cat" "cut -d ' ' -f 3" "grep 'pattern'" "sort" "wc -w" .tester/outfile118.txt
< infile cat | cut -d ' ' -f 3 | grep 'pattern' | sort | wc -w > .tester/outfile118_sys.txt
if diff .tester/outfile118.txt .tester/outfile118_sys.txt > /dev/null; then
    echo -n "${GREEN} 118. [OK]${NC}"
else
    echo -n "${RED} 118. [KO]${NC}"
fi

# Prueba 119: Buscar, ordenar, cortar, contar y mostrar las primeras
$PIPEX infile "cat" "grep 'info'" "sort" "cut -d ' ' -f 1" "head -n 5" .tester/outfile119.txt
< infile cat | grep 'info' | sort | cut -d ' ' -f 1 | head -n 5 > .tester/outfile119_sys.txt
if diff .tester/outfile119.txt .tester/outfile119_sys.txt > /dev/null; then
    echo -n "${GREEN} 119. [OK]${NC}"
else
    echo -n "${RED} 119. [KO]${NC}"
fi

# Prueba 120: Filtrar, cortar, ordenar, contar y mostrar las últimas líneas
$PIPEX infile "cat" "grep 'data'" "cut -d ' ' -f 2" "sort" "tail -n 5" .tester/outfile120.txt
< infile cat | grep 'data' | cut -d ' ' -f 2 | sort | tail -n 5 > .tester/outfile120_sys.txt
if diff .tester/outfile120.txt .tester/outfile120_sys.txt > /dev/null; then
    echo -n "${GREEN} 120. [OK]${NC}"
else
    echo -n "${RED} 120. [KO]${NC}"
fi

echo "bonus mas de 8 comandos"
echo "\n"
# Prueba 121: Filtrar, ordenar, cortar, contar y mostrar las primeras líneas
$PIPEX infile "cat" "grep 'error'" "sort" "cut -d ' ' -f 2" "uniq" "wc -l" "head -n 5" .tester/outfile121.txt
< infile cat | grep 'error' | sort | cut -d ' ' -f 2 | uniq | wc -l | head -n 5 > .tester/outfile121_sys.txt
if diff .tester/outfile121.txt .tester/outfile121_sys.txt > /dev/null; then
    echo -n "${GREEN} 121. [OK]${NC}"
else
    echo -n "${RED} 121. [KO]${NC}"
fi

# Prueba 122: Buscar, ordenar, contar, mostrar las últimas líneas y cortar columnas
$PIPEX infile "cat" "grep 'log'" "sort" "wc -l" "tail -n 10" "cut -d ' ' -f 3" "uniq" .tester/outfile122.txt
< infile cat | grep 'log' | sort | wc -l | tail -n 10 | cut -d ' ' -f 3 | uniq > .tester/outfile122_sys.txt
if diff .tester/outfile122.txt .tester/outfile122_sys.txt > /dev/null; then
    echo -n "${GREEN} 122. [OK]${NC}"
else
    echo -n "${RED} 122. [KO]${NC}"
fi

# Prueba 123: Filtrar por palabra, ordenar, mostrar las primeras, cortar y contar
$PIPEX infile "cat" "grep 'debug'" "sort" "head -n 5" "cut -d ' ' -f 1" "wc -w" "uniq" .tester/outfile123.txt
< infile cat | grep 'debug' | sort | head -n 5 | cut -d ' ' -f 1 | wc -w | uniq > .tester/outfile123_sys.txt
if diff .tester/outfile123.txt .tester/outfile123_sys.txt > /dev/null; then
    echo -n "${GREEN} 123. [OK]${NC}"
else
    echo -n "${RED} 123. [KO]${NC}"
fi

# Prueba 124: Filtrar por fecha, ordenar, cortar, mostrar las últimas líneas y contar
$PIPEX infile "cat" "grep '2024'" "sort" "cut -d ' ' -f 2" "tail -n 10" "wc -l" "uniq" .tester/outfile124.txt
< infile cat | grep '2024' | sort | cut -d ' ' -f 2 | tail -n 10 | wc -l | uniq > .tester/outfile124_sys.txt
if diff .tester/outfile124.txt .tester/outfile124_sys.txt > /dev/null; then
    echo -n "${GREEN} 124. [OK]${NC}"
else
    echo -n "${RED} 124. [KO]${NC}"
fi

# Prueba 125: Buscar, ordenar, mostrar las primeras líneas, cortar columnas y contar palabras
$PIPEX infile "cat" "grep 'success'" "sort" "head -n 5" "cut -d ' ' -f 3" "wc -w" "uniq" .tester/outfile125.txt
< infile cat | grep 'success' | sort | head -n 5 | cut -d ' ' -f 3 | wc -w | uniq > .tester/outfile125_sys.txt
if diff .tester/outfile125.txt .tester/outfile125_sys.txt > /dev/null; then
    echo -n "${GREEN} 125. [OK]${NC}"
else
    echo -n "${RED} 125. [KO]${NC}"
fi

# Prueba 126: Cortar columnas, buscar, ordenar y mostrar las últimas líneas
$PIPEX infile "cat" "cut -d ' ' -f 3" "grep 'pattern'" "sort" "tail -n 10" "wc -l" "uniq" .tester/outfile126.txt
< infile cat | cut -d ' ' -f 3 | grep 'pattern' | sort | tail -n 10 | wc -l | uniq > .tester/outfile126_sys.txt
if diff .tester/outfile126.txt .tester/outfile126_sys.txt > /dev/null; then
    echo -n "${GREEN} 126. [OK]${NC}"
else
    echo -n "${RED} 126. [KO]${NC}"
fi

# Prueba 127: Buscar, ordenar, cortar y contar palabras
$PIPEX infile "cat" "grep 'error'" "sort" "cut -d ' ' -f 1" "wc -w" "uniq" "head -n 10" .tester/outfile127.txt
< infile cat | grep 'error' | sort | cut -d ' ' -f 1 | wc -w | uniq | head -n 10 > .tester/outfile127_sys.txt
if diff .tester/outfile127.txt .tester/outfile127_sys.txt > /dev/null; then
    echo -n "${GREEN} 127. [OK]${NC}"
else
    echo -n "${RED} 127. [KO]${NC}"
fi

# Prueba 128: Filtrar, cortar, ordenar y mostrar las primeras líneas
$PIPEX infile "cat" "grep 'critical'" "cut -d ' ' -f 1" "sort" "head -n 5" "wc -l" "uniq" .tester/outfile128.txt
< infile cat | grep 'critical' | cut -d ' ' -f 1 | sort | head -n 5 | wc -l | uniq > .tester/outfile128_sys.txt
if diff .tester/outfile128.txt .tester/outfile128_sys.txt > /dev/null; then
    echo -n "${GREEN} 128. [OK]${NC}"
else
    echo -n "${RED} 128. [KO]${NC}"
fi

# Prueba 129: Buscar, ordenar, mostrar las últimas líneas, cortar y contar
$PIPEX infile "cat" "grep 'info'" "sort" "tail -n 10" "cut -d ' ' -f 2" "wc -l" "uniq" .tester/outfile129.txt
< infile cat | grep 'info' | sort | tail -n 10 | cut -d ' ' -f 2 | wc -l | uniq > .tester/outfile129_sys.txt
if diff .tester/outfile129.txt .tester/outfile129_sys.txt > /dev/null; then
    echo -n "${GREEN} 129. [OK]${NC}"
else
    echo -n "${RED} 129. [KO]${NC}"
fi

# Prueba 130: Buscar, ordenar, cortar y mostrar las primeras líneas, contar
$PIPEX infile "cat" "grep 'status'" "sort" "cut -d ' ' -f 2" "head -n 5" "wc -l" "uniq" .tester/outfile130.txt
< infile cat | grep 'status' | sort | cut -d ' ' -f 2 | head -n 5 | wc -l | uniq > .tester/outfile130_sys.txt
if diff .tester/outfile130.txt .tester/outfile130_sys.txt > /dev/null; then
    echo -n "${GREEN} 130. [OK]${NC}"
else
    echo -n "${RED} 130. [KO]${NC}"
fi

# Prueba 131: Buscar, ordenar, mostrar las últimas líneas, cortar y mostrar las primeras
$PIPEX infile "cat" "grep 'warning'" "sort" "tail -n 10" "cut -d ' ' -f 1" "head -n 5" "uniq" .tester/outfile131.txt
< infile cat | grep 'warning' | sort | tail -n 10 | cut -d ' ' -f 1 | head -n 5 | uniq > .tester/outfile131_sys.txt
if diff .tester/outfile131.txt .tester/outfile131_sys.txt > /dev/null; then
    echo -n "${GREEN} 131. [OK]${NC}"
else
    echo -n "${RED} 131. [KO]${NC}"
fi

# Prueba 132: Filtrar por patrón, ordenar, cortar y mostrar las últimas líneas
$PIPEX infile "cat" "grep 'data'" "sort" "cut -d ' ' -f 3" "tail -n 5" "wc -l" "uniq" .tester/outfile132.txt
< infile cat | grep 'data' | sort | cut -d ' ' -f 3 | tail -n 5 | wc -l | uniq > .tester/outfile132_sys.txt
if diff .tester/outfile132.txt .tester/outfile132_sys.txt > /dev/null; then
    echo -n "${GREEN} 132. [OK]${NC}"
else
    echo -n "${RED} 132. [KO]${NC}"
fi

# Prueba 133: Ordenar, cortar, filtrar por palabra, contar y mostrar las primeras líneas
$PIPEX infile "cat" "sort" "cut -d ' ' -f 2" "grep 'info'" "wc -w" "head -n 5" "uniq" .tester/outfile133.txt
< infile cat | sort | cut -d ' ' -f 2 | grep 'info' | wc -w | head -n 5 | uniq > .tester/outfile133_sys.txt
if diff .tester/outfile133.txt .tester/outfile133_sys.txt > /dev/null; then
    echo -n "${GREEN} 133. [OK]${NC}"
else
    echo -n "${RED} 133. [KO]${NC}"
fi

# Prueba 134: Filtrar, ordenar, cortar, contar palabras y mostrar las últimas líneas
$PIPEX infile "cat" "grep 'debug'" "sort" "cut -d ' ' -f 2" "tail -n 10" "wc -w" "uniq" .tester/outfile134.txt
< infile cat | grep 'debug' | sort | cut -d ' ' -f 2 | tail -n 10 | wc -w | uniq > .tester/outfile134_sys.txt
if diff .tester/outfile134.txt .tester/outfile134_sys.txt > /dev/null; then
    echo "${GREEN} 134. [OK]${NC}"
else
    echo "${RED} 134. [KO]${NC}"
fi

# Prueba 135: Buscar, ordenar, mostrar las últimas líneas y contar
$PIPEX infile "cat" "grep 'critical'" "sort" "tail -n 5" "wc -l" "uniq" "head -n 5" .tester/outfile135.txt
< infile cat | grep 'critical' | sort | tail -n 5 | wc -l | uniq | head -n 5 > .tester/outfile135_sys.txt
if diff .tester/outfile135.txt .tester/outfile135_sys.txt > /dev/null; then
    echo -n "${GREEN} 135. [OK]${NC}"
else
    echo -n "${RED} 135. [KO]${NC}"
fi

# Prueba 136: Filtrar, cortar, ordenar y contar palabras
$PIPEX infile "cat" "grep 'fail'" "cut -d ' ' -f 1" "sort" "wc -w" "uniq" "head -n 5" .tester/outfile136.txt
< infile cat | grep 'fail' | cut -d ' ' -f 1 | sort | wc -w | uniq | head -n 5 > .tester/outfile136_sys.txt
if diff .tester/outfile136.txt .tester/outfile136_sys.txt > /dev/null; then
    echo -n "${GREEN} 136. [OK]${NC}"
else
    echo -n "${RED} 136. [KO]${NC}"
fi

# Prueba 137: Buscar, ordenar, mostrar las últimas líneas, cortar y contar
$PIPEX infile "cat" "grep 'info'" "sort" "tail -n 10" "cut -d ' ' -f 3" "wc -w" "uniq" .tester/outfile137.txt
< infile cat | grep 'info' | sort | tail -n 10 | cut -d ' ' -f 3 | wc -w | uniq > .tester/outfile137_sys.txt
if diff .tester/outfile137.txt .tester/outfile137_sys.txt > /dev/null; then
    echo -n "${GREEN} 137. [OK]${NC}"
else
    echo -n "${RED} 137. [KO]${NC}"
fi

# Prueba 138: Ordenar, cortar, filtrar y mostrar las primeras líneas
$PIPEX infile "cat" "sort" "cut -d ' ' -f 2" "grep 'pattern'" "head -n 5" "wc -w" "uniq" .tester/outfile138.txt
< infile cat | sort | cut -d ' ' -f 2 | grep 'pattern' | head -n 5 | wc -w | uniq > .tester/outfile138_sys.txt
if diff .tester/outfile138.txt .tester/outfile138_sys.txt > /dev/null; then
    echo -n "${GREEN} 138. [OK]${NC}"
else
    echo -n "${RED} 138. [KO]${NC}"
fi

# Prueba 139: Filtrar, ordenar, cortar y contar palabras
$PIPEX infile "cat" "grep 'log'" "sort" "cut -d ' ' -f 1" "wc -w" "uniq" "head -n 5" .tester/outfile139.txt
< infile cat | grep 'log' | sort | cut -d ' ' -f 1 | wc -w | uniq | head -n 5 > .tester/outfile139_sys.txt
if diff .tester/outfile139.txt .tester/outfile139_sys.txt > /dev/null; then
    echo -n "${GREEN} 139. [OK]${NC}"
else
    echo -n "${RED} 139. [KO]${NC}"
fi

# Prueba 140: Buscar, cortar, ordenar, mostrar las primeras y contar
$PIPEX infile "cat" "grep 'debug'" "cut -d ' ' -f 3" "sort" "head -n 10" "wc -l" "uniq" .tester/outfile140.txt
< infile cat | grep 'debug' | cut -d ' ' -f 3 | sort | head -n 10 | wc -l | uniq > .tester/outfile140_sys.txt
if diff .tester/outfile140.txt .tester/outfile140_sys.txt > /dev/null; then
    echo -n "${GREEN} 140. [OK]${NC}"
else
    echo -n "${RED} 140. [KO]${NC}"
fi

#en caso de error puedes comentar esta parte para ver los txt y comparar los resultados de los comandos
rm -f .tester/*.txt