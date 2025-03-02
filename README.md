## Diagrama de Flujo de las Funciones en Pipex

### 1. `int main(int argc, char **argv, char **env)`
- ⬇ Inicio
- ⬇ Verifica número de argumentos
  - ⚠ Si son insuficientes, muestra error y termina ⛔
- ⬇ Inicializa la estructura `pipex` → `initialize_pipex()`
- ⬇ Ejecuta los comandos → `execute_commands()`
- ⬇ Limpia los recursos → `cleanup()`
- ⬇ Si `here_doc` fue utilizado, elimina el archivo temporal 🗑
- ⬇ Fin ✅

### 2. `void initialize_pipex(t_pipex *pipex, int argc, char **argv, char **env)`
- ⬇ Asigna variables de entorno a la estructura
- ⬇ Si `here_doc` está presente:
  - ⬇ Define archivo de salida
  - ⬇ Maneja `here_doc` → `handle_here_doc()`
  - ⬇ Parsea los comandos → `parse_commands()`
- ⬇ Si no:
  - ⬇ Define archivos de entrada y salida
  - ⬇ Parsea los comandos → `parse_commands()`

### 3. `void parse_commands(t_pipex *pipex, int argc, char **argv)`
- ⬇ Determina el índice inicial en `argv`
- ⬇ Itera sobre los comandos
- ⬇ Agrega cada comando a la lista de `pipex` → `add_cmd()`

### 4. `void execute_commands(t_pipex *pipex)`
- ⬇ Inicializa `prev_fd` con `input_fd`
- ⬇ Itera sobre la lista de comandos
  - ⬇ Llama a `create_pipe_and_fork()` para ejecutar cada comando
- ⬇ Espera a que todos los procesos hijos terminen ⏳

### 5. `void create_pipe_and_fork(t_pipex *pipex, t_cmd *commands, int *prev_fd)`
- ⬇ Crea un pipe si es necesario 🔗
- ⬇ Realiza un fork 👶
  - ⬇ Si es el proceso hijo:
    - ⬇ Redirige entrada y salida 🔄
    - ⬇ Ejecuta el comando → `exec_cmd()`
  - ⬇ Si es el proceso padre:
    - ⬇ Cierra descriptores de archivo innecesarios ❌

### 6. `void exec_cmd(char *cmd, t_pipex *pipex)`
- ⬇ Divide el comando en argumentos
- ⬇ Obtiene la ruta del ejecutable → `get_path()`
- ⬇ Llama a `execve()` para ejecutar el comando 🚀
- ⬇ En caso de error, muestra mensaje y termina el proceso ❌

### 7. `void handle_here_doc(t_pipex *pipex, char *limiter)`
- ⬇ Abre un archivo temporal para escritura 📂
- ⬇ Lee entrada estándar hasta encontrar el `limiter` ✍
- ⬇ Escribe las líneas en el archivo temporal
- ⬇ Reabre el archivo para lectura y lo asigna a `pipex->input_fd` 📖

### 8. `char *get_path(char *cmd, char **env)`
- ⬇ Obtiene la variable de entorno `PATH`
- ⬇ Itera sobre los directorios de `PATH`
- ⬇ Verifica si el comando es ejecutable ✅
- ⬇ Devuelve la ruta válida o `NULL` si no se encuentra ❌

### 9. `void cleanup(t_pipex *pipex)`
- ⬇ Libera memoria de la lista de comandos → `free_cmds()` 🗑
- ⬇ Cierra archivos abiertos ❌

