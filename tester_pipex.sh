#!/bin/bash
clear
make re
# Ruta al ejecutable pipex
PIPEX="./pipex"

# Definir colores
GREEN='\033[0;32m'  # Color verde
RED='\033[0;31m'    # Color rojo
NC='\033[0m'        # Sin color (rese

echo "Mandatory casos normales"

# Limpiar archivos anteriores si existen
rm -f .tester/outfile*.txt .tester/outfile*.sys.txt

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
# Limpiar archivos anteriores si existen
rm -f .tester/outfile*.txt .tester/outfile*.sys.txt