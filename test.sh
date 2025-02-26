#!/bin/bash

# Colores para la salida
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

# Variables globales
MANDATORY_PASSED=true
BONUS_PASSED=true
MANDATORY_TESTS=0
BONUS_TESTS=0
TIMEOUT=5  # Tiempo máximo de espera para cada comando (en segundos)
TEST_DIR=".tester"  # Carpeta oculta para almacenar archivos de prueba

# Función para imprimir mensajes de éxito
print_success() {
    echo -e "${GREEN}✔ $1${RESET}"
}

# Función para imprimir mensajes de error
print_error() {
    echo -e "${RED}✖ $1${RESET}"
}

# Función para comparar archivos
compare_files() {
    if diff -q "$1" "$2" > /dev/null; then
        print_success "OK: $1 y $2 son iguales."
        return 0
    else
        print_error "ERROR: $1 y $2 son diferentes."
        return 1
    fi
}

# Función para ejecutar un test con timeout
run_test() {
    local description=$1
    local command=$2
    local expected_output=$3
    local test_type=$4

    echo -e "\n=== Ejecutando test: $description ==="
    echo -e "Comando: $command"

    # Ejecutar el comando con timeout
    timeout $TIMEOUT bash -c "$command" > /dev/null 2>&1
    local exit_status=$?

    # Verificar si el comando terminó correctamente
    if [ $exit_status -eq 124 ]; then
        print_error "ERROR: El comando se quedó bloqueado (timeout)."
        if [ "$test_type" == "mandatory" ]; then
            MANDATORY_PASSED=false
        else
            BONUS_PASSED=false
        fi
        return
    elif [ $exit_status -ne 0 ]; then
        print_error "ERROR: El comando falló con código de salida $exit_status."
        if [ "$test_type" == "mandatory" ]; then
            MANDATORY_PASSED=false
        else
            BONUS_PASSED=false
        fi
        return
    fi

    # Comparar archivos de salida
    if [ -f "$expected_output" ] && [ -f "output.txt" ]; then
        if compare_files "$expected_output" "output.txt"; then
            if [ "$test_type" == "mandatory" ]; then
                MANDATORY_TESTS=$((MANDATORY_TESTS + 1))
            else
                BONUS_TESTS=$((BONUS_TESTS + 1))
            fi
        else
            if [ "$test_type" == "mandatory" ]; then
                MANDATORY_PASSED=false
            else
                BONUS_PASSED=false
            fi
            # Guardar el trace en caso de fallo
            mkdir -p "$TEST_DIR"
            cp input.txt "$TEST_DIR/input.txt"
            cp "$expected_output" "$TEST_DIR/expected_output.txt"
            cp output.txt "$TEST_DIR/generated_output.txt"
            print_error "Trace guardado en $TEST_DIR/"
        fi
    else
        print_error "ERROR: No se pudo comparar $expected_output y output.txt (uno de los archivos no existe)."
        if [ "$test_type" == "mandatory" ]; then
            MANDATORY_PASSED=false
        else
            BONUS_PASSED=false
        fi
    fi
}

# Limpiar archivos de prueba anteriores
cleanup() {
    rm -f input.txt output.txt expected.txt here_doc.txt no_escribible.txt error.log
    if [ "$MANDATORY_PASSED" = true ] && [ "$BONUS_PASSED" = true ]; then
        rm -rf "$TEST_DIR"  # Eliminar la carpeta de trace si todo está bien
    fi
}

# Crear archivos de prueba
setup() {
    echo "Este es un archivo de prueba." > input.txt
    echo "Este es otro archivo de prueba." > input2.txt
    echo "Este es un archivo de prueba." > expected.txt
    echo "línea 1" > here_doc.txt
    echo "línea 2" >> here_doc.txt
}

# Ejecutar tests mandatory
run_mandatory_tests() {
    echo -e "\n=== Ejecutando tests mandatory ==="

    # Test 1: Un solo comando (cat)
    run_test "Un solo comando (cat)" "./pipex input.txt \"cat\" \"wc -l\" output.txt" "expected.txt" "mandatory"

    # Test 2: Comando con argumentos (cat -e)
    run_test "Comando con argumentos (cat -e)" "./pipex input.txt \"cat -e\" \"wc -l\" output.txt" "expected.txt" "mandatory"

    # Test 3: Comando inválido
    run_test "Comando inválido" "./pipex input.txt \"comando_invalido\" \"wc -l\" output.txt" "input.txt" "mandatory"

    # Test 4: Archivo de entrada inexistente
    run_test "Archivo de entrada inexistente" "./pipex no_existe.txt \"cat\" \"wc -l\" output.txt" "input.txt" "mandatory"

    # Test 5: Archivo de salida no escribible
    touch no_escribible.txt
    chmod -w no_escribible.txt
    run_test "Archivo de salida no escribible" "./pipex input.txt \"cat\" \"wc -l\" no_escribible.txt" "input.txt" "mandatory"
    chmod +w no_escribible.txt
    rm -f no_escribible.txt
}

# Ejecutar tests bonus
run_bonus_tests() {
    echo -e "\n=== Ejecutando tests bonus ==="

    # Test 6: Múltiples comandos
    run_test "Múltiples comandos" "./pipex input.txt \"cat\" \"grep prueba\" \"wc -l\" output.txt" "expected.txt" "bonus"

    # Test 7: Here Document
    run_test "Here Document" "./pipex here_doc.txt \"cat\" \"wc -l\" output.txt" "expected.txt" "bonus"

    # Test 8: Here Document con múltiples comandos
    run_test "Here Document con múltiples comandos" "./pipex here_doc.txt \"cat\" \"grep línea\" \"wc -l\" output.txt" "here_doc.txt" "bonus"
}

# Mostrar resultados
show_results() {
    echo -e "\n=== Resultados ==="
    if [ "$MANDATORY_PASSED" = true ]; then
        print_success "Todos los tests mandatory pasaron."
        if [ "$BONUS_PASSED" = true ]; then
            print_success "Todos los tests bonus pasaron."
            echo -e "\nNota final: ${GREEN}125/125${RESET}"
        else
            print_error "Algunos tests bonus fallaron."
            echo -e "\nNota final: ${GREEN}100/100${RESET}"
        fi
    else
        print_error "Algunos tests mandatory fallaron."
        echo -e "\nNota final: ${RED}0/100${RESET}"
    fi

    echo -e "\nResumen:"
    echo "Tests mandatory pasados: $MANDATORY_TESTS"
    echo "Tests bonus pasados: $BONUS_TESTS"
}

# Limpiar y ejecutar tests
cleanup
setup
run_mandatory_tests
run_bonus_tests
show_results
cleanup