[en.subject.pdf](https://prod-files-secure.s3.us-west-2.amazonaws.com/5c7e4c63-a72d-46cd-a248-64130b551b7a/a03840b8-d874-4997-9906-0a7fc4aa4e1f/en.subject.pdf)

[GitHub - rogerdevworld/pipex](https://github.com/rogerdevworld/pipex)

# pipex paso a paso…

Voy a explicar paso a paso del proceso para hacer pipex proyecto de 42 con bonus desde un inicio.

**Lo primero a tener la cuenta es leer brevemente sobre las funciones:**

- **fork();**
    
    ### `fork()`: Creación de Procesos en C
    
    La función `fork()` se usa para crear un **nuevo proceso** en sistemas Unix. Es la base de la multitarea en Linux y se usa en programas como **minishell** y **pipex**.
    
    ---
    
    ### **Prototipo de `fork()`**
    
    ```c
    #include <unistd.h>
    pid_t fork(void);
    
    ```
    
    - **Retorno:**
        - **> 0** → Devuelve el PID del hijo en el **padre**.
        - **0** → Devuelve `0` en el **hijo**.
        - **1** → Error (no se creó el hijo).
    
    ---
    
    ### **Ejemplo Básico**
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    
    int main() {
        pid_t pid = fork();
    
        if (pid < 0) {
            perror("fork");
            return 1;
        }
    
        if (pid == 0) {
            printf("Soy el proceso hijo, PID: %d\n", getpid());
        } else {
            printf("Soy el proceso padre, PID: %d, Hijo: %d\n", getpid(), pid);
        }
    
        return 0;
    }
    
    ```
    
    🔹 **Explicación:**
    
    1. `fork()` crea un nuevo proceso duplicando el actual.
    2. **Padre** recibe el PID del hijo.
    3. **Hijo** recibe `0` y ejecuta su código.
    
    ---
    
    ### **Ejemplo con `pipe()` y `fork()`**
    
    Aquí, el padre escribe en el `pipe()` y el hijo lee.
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    #include <string.h>
    
    int main() {
        int fd[2];
        char mensaje[] = "Hola hijo!";
        char buffer[100];
    
        if (pipe(fd) == -1) {
            perror("pipe");
            return 1;
        }
    
        pid_t pid = fork();
    
        if (pid < 0) {
            perror("fork");
            return 1;
        }
    
        if (pid == 0) { // Proceso hijo
            close(fd[1]); // Cierra escritura
            read(fd[0], buffer, sizeof(buffer));
            printf("Hijo recibió: %s\n", buffer);
            close(fd[0]);
        } else { // Proceso padre
            close(fd[0]); // Cierra lectura
            write(fd[1], mensaje, strlen(mensaje) + 1);
            close(fd[1]);
        }
    
        return 0;
    }
    
    ```
    
    🔹 **Aplicaciones en `pipex` y `minishell`:**
    
    - Permite ejecutar comandos en paralelo.
    - Usa `execve()` para reemplazar el proceso hijo con un nuevo programa.
    - Redirige entradas/salidas con `dup2()`.
- **pipe();**
    
    ### `pipe()`: Teoría y Uso en C
    
    La función `pipe()` en C se usa para crear un **tubo de comunicación unidireccional** entre procesos. Es una de las primitivas básicas de IPC (**Inter-Process Communication**). Se usa comúnmente cuando un proceso quiere enviar datos a otro proceso.
    
    ### **Funcionamiento**
    
    Cuando se llama a `pipe(int pipefd[2])`, se crea un búfer en el kernel con dos extremos:
    
    - `pipefd[0]` → Extremo de **lectura**.
    - `pipefd[1]` → Extremo de **escritura**.
    
    Los datos escritos en `pipefd[1]` pueden ser leídos desde `pipefd[0]`. La comunicación es unidireccional, por lo que si se necesita comunicación bidireccional, se deben usar dos `pipe()`.
    
    ### **Prototipo de `pipe()`**
    
    ```c
    #include <unistd.h>
    int pipe(int pipefd[2]);
    
    ```
    
    - **Retorno:**
        - `0` en caso de éxito.
        - `1` en caso de error (y se establece `errno`).
    
    ---
    
    ### **Ejemplo de `pipe()`**
    
    Este código crea un `pipe()`, el proceso padre escribe en el pipe y el hijo lo lee.
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    #include <string.h>
    
    int main() {
        int fd[2]; // Array para los descriptores del pipe
        pid_t pid;
        char mensaje[] = "Hola desde el padre";
        char buffer[100];
    
        if (pipe(fd) == -1) { // Creación del pipe
            perror("pipe");
            return 1;
        }
    
        pid = fork(); // Crear un proceso hijo
    
        if (pid < 0) {
            perror("fork");
            return 1;
        }
    
        if (pid == 0) { // Proceso hijo
            close(fd[1]); // Cierra el extremo de escritura
            read(fd[0], buffer, sizeof(buffer)); // Lee del pipe
            printf("Hijo recibió: %s\n", buffer);
            close(fd[0]); // Cierra el extremo de lectura
        } else { // Proceso padre
            close(fd[0]); // Cierra el extremo de lectura
            write(fd[1], mensaje, strlen(mensaje) + 1); // Escribe en el pipe
            close(fd[1]); // Cierra el extremo de escritura
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### **Explicación del código**
    
    1. Se crea un **pipe** con `pipe(fd)`.
    2. Se hace un `fork()` para crear un proceso hijo.
    3. **Proceso padre:**
        - Cierra `fd[0]` (no necesita leer).
        - Escribe un mensaje en `fd[1]`.
        - Cierra `fd[1]` tras escribir.
    4. **Proceso hijo:**
        - Cierra `fd[1]` (no necesita escribir).
        - Lee desde `fd[0]` y muestra el mensaje.
        - Cierra `fd[0]`.
    
    Esto permite la comunicación entre los procesos de manera controlada.
    
    Si estás trabajando en `pipex`, esta es una base fundamental para redirigir la salida de un proceso a la entrada de otro. ¿Quieres que te explique cómo usar `pipe()` con `execve()`? 🚀
    
- **execve();**
    
    ### **¿Qué hace `execve()`?**
    
    `execve()` reemplaza el proceso actual con un nuevo programa.
    
    ### **Prototipo**
    
    ```c
    #include <unistd.h>
    int execve(const char *pathname, char *const argv[], char *const envp[]);
    
    ```
    
    - **`pathname`** → Ruta del ejecutable.
    - **`argv[]`** → Argumentos (incluye el nombre del programa).
    - **`envp[]`** → Variables de entorno.
    
    ---
    
    ### **Ejemplo con `pipe()`, `fork()` y `execve()`**
    
    Aquí, el padre ejecuta `ls -l` y pasa la salida al hijo, que ejecuta `wc -l`.
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    
    int main(int argc, char *argv[], char *envp[]) {
        int fd[2];  // Pipe
        pid_t pid;
    
        if (pipe(fd) == -1) {
            perror("pipe");
            return 1;
        }
    
        pid = fork();
        if (pid < 0) {
            perror("fork");
            return 1;
        }
    
        if (pid == 0) { // Proceso hijo - `wc -l`
            close(fd[1]); // Cierra escritura
            dup2(fd[0], STDIN_FILENO); // Redirige entrada estándar al pipe
            close(fd[0]);
    
            char *cmd[] = {"/usr/bin/wc", "-l", NULL};
            execve(cmd[0], cmd, envp); // Ejecuta `wc -l`
            perror("execve");
            exit(1);
        } else { // Proceso padre - `ls -l`
            close(fd[0]); // Cierra lectura
            dup2(fd[1], STDOUT_FILENO); // Redirige salida estándar al pipe
            close(fd[1]);
    
            char *cmd[] = {"/bin/ls", "-l", NULL};
            execve(cmd[0], cmd, envp); // Ejecuta `ls -l`
            perror("execve");
            exit(1);
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### **Explicación**
    
    1. Se crea un `pipe()`.
    2. `fork()` crea un hijo.
    3. **Proceso padre**:
        - Redirige `stdout` al `pipe`.
        - Ejecuta `ls -l` con `execve()`.
    4. **Proceso hijo**:
        - Redirige `stdin` al `pipe`.
        - Ejecuta `wc -l` con `execve()`.
    5. **Resultado**: `ls -l` lista archivos, su salida se envía por el pipe y `wc -l` cuenta las líneas.
    
    ---
    
    🔹 **Claves para `pipex` y `minishell`**:
    
    - `fork()` para crear procesos.
    - `execve()` para ejecutar comandos.
    - `pipe()` para conectar procesos.
    - `dup2()` para redirigir `stdin`/`stdout`.
- **dup2();**
    
    ### `dup2()`: Redirección de Entrada y Salida en C
    
    La función `dup2()` se usa para **redirigir descriptores de archivo**, esencial para proyectos como **pipex** y **minishell**, donde se deben redirigir `stdin` y `stdout` para encadenar comandos.
    
    ---
    
    ### **Prototipo de `dup2()`**
    
    ```c
    #include <unistd.h>
    int dup2(int oldfd, int newfd);
    
    ```
    
    - **`oldfd`** → Descriptor de archivo original.
    - **`newfd`** → Descriptor de archivo donde se redirige.
    - Retorna `1` en caso de error.
    
    ---
    
    ### **Ejemplo con `dup2()`, `fork()`, `pipe()` y `execve()`**
    
    Este código conecta `ls -l` con `wc -l`, usando `dup2()` para redirigir la salida del primero a la entrada del segundo.
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    
    int main(int argc, char *argv[], char *envp[]) {
        int fd[2];  // Pipe
        pid_t pid;
    
        if (pipe(fd) == -1) {
            perror("pipe");
            return 1;
        }
    
        pid = fork();
        if (pid < 0) {
            perror("fork");
            return 1;
        }
    
        if (pid == 0) { // Proceso hijo - `wc -l`
            close(fd[1]); // Cierra escritura
            dup2(fd[0], STDIN_FILENO); // Redirige entrada estándar al pipe
            close(fd[0]); // Cierra el descriptor duplicado
    
            char *cmd[] = {"/usr/bin/wc", "-l", NULL};
            execve(cmd[0], cmd, envp); // Ejecuta `wc -l`
            perror("execve");
            exit(1);
        } else { // Proceso padre - `ls -l`
            close(fd[0]); // Cierra lectura
            dup2(fd[1], STDOUT_FILENO); // Redirige salida estándar al pipe
            close(fd[1]); // Cierra el descriptor duplicado
    
            char *cmd[] = {"/bin/ls", "-l", NULL};
            execve(cmd[0], cmd, envp); // Ejecuta `ls -l`
            perror("execve");
            exit(1);
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### **Explicación paso a paso**
    
    1. **`pipe(fd)`** crea un canal de comunicación entre procesos.
    2. **`fork()`** crea un proceso hijo.
    3. **Proceso padre (`ls -l`)**
        - **Cierra `fd[0]`** (no necesita leer).
        - **`dup2(fd[1], STDOUT_FILENO)`** → Redirige la salida estándar al pipe.
        - **Ejecuta `execve()`** con `ls -l`.
    4. **Proceso hijo (`wc -l`)**
        - **Cierra `fd[1]`** (no necesita escribir).
        - **`dup2(fd[0], STDIN_FILENO)`** → Redirige la entrada estándar al pipe.
        - **Ejecuta `execve()`** con `wc -l`.
    5. **El resultado**: `ls -l` manda su salida a `wc -l`, que cuenta las líneas.
    
    ---
    
    ### **¿Por qué `dup2()` es clave en `pipex` y `minishell`?**
    
    - Permite redirigir archivos (`open()`) a `stdin` o `stdout`.
    - Facilita el encadenamiento de comandos (`|` en shells).
    - Se usa junto con `execve()` para ejecutar programas con redirección.
    
    💡 **¿Quieres un ejemplo con archivos en vez de pipes?** 🚀
    
- **acess();**
    
    ### `access()`: Comprobación de Permisos en C
    
    La función `access()` se usa para verificar si un archivo **existe** y si el usuario tiene **permisos** para acceder a él. Es clave en **pipex** y **minishell** para validar comandos y archivos antes de ejecutarlos con `execve()`.
    
    ---
    
    ### **Prototipo de `access()`**
    
    ```c
    #include <unistd.h>
    int access(const char *pathname, int mode);
    
    ```
    
    - **`pathname`** → Ruta del archivo o ejecutable.
    - **`mode`** → Tipo de comprobación:
        - `F_OK` → Verifica si el archivo **existe**.
        - `R_OK` → Verifica si es **legible**.
        - `W_OK` → Verifica si es **escribible**.
        - `X_OK` → Verifica si es **ejecutable**.
    
    **Retorno:**
    
    - `0` → Si el acceso está permitido.
    - `1` → Si hay error (`errno` indica el motivo).
    
    ---
    
    ### **Ejemplo con `access()`, `fork()`, `execve()` y `pipe()`**
    
    Este código valida si el comando `ls` es ejecutable antes de ejecutarlo y conectarlo a `wc -l`.
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <stdlib.h>
    
    int main(int argc, char *argv[], char *envp[]) {
        int fd[2];
        pid_t pid;
        char *cmd1 = "/bin/ls";
        char *cmd2 = "/usr/bin/wc";
    
        if (pipe(fd) == -1) {
            perror("pipe");
            return 1;
        }
    
        pid = fork();
        if (pid < 0) {
            perror("fork");
            return 1;
        }
    
        if (pid == 0) { // Hijo: Ejecuta `wc -l`
            close(fd[1]);
            dup2(fd[0], STDIN_FILENO);
            close(fd[0]);
    
            if (access(cmd2, X_OK) == 0) { // Verifica si `wc` es ejecutable
                char *args[] = {cmd2, "-l", NULL};
                execve(cmd2, args, envp);
            } else {
                perror("wc no ejecutable");
                exit(1);
            }
        } else { // Padre: Ejecuta `ls -l`
            close(fd[0]);
            dup2(fd[1], STDOUT_FILENO);
            close(fd[1]);
    
            if (access(cmd1, X_OK) == 0) { // Verifica si `ls` es ejecutable
                char *args[] = {cmd1, "-l", NULL};
                execve(cmd1, args, envp);
            } else {
                perror("ls no ejecutable");
                exit(1);
            }
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### **Explicación**
    
    1. **`access(cmd1, X_OK)`** → Verifica si `/bin/ls` es ejecutable.
    2. **`access(cmd2, X_OK)`** → Verifica si `/usr/bin/wc` es ejecutable.
    3. **Si el comando no es ejecutable**, muestra un error y termina.
    4. **Si es ejecutable**, `execve()` lo ejecuta.
    
    ---
    
    ### **¿Por qué `access()` es útil en `pipex` y `minishell`?**
    
    - **Verifica si un archivo existe antes de abrirlo.**
    - **Confirma si un comando es ejecutable antes de usar `execve()`.**
    - **Evita errores como "command not found" en una shell personalizada.**
    
    💡 **¿Quieres que te muestre cómo buscar comandos en `$PATH` con `access()`?** 🚀
    

---

Vale, ahora que ya tienes un concomimiento sobre las funciones, te explicare mas detalladamente como proceder para usarla en el proyecto:

### Variable de entorno.

Lo primero es conocer el `***env*` que está en el `*int main(int argc, char **argv, char **env)*` y lo vamos a utilizar: esto significa que hay una 3ºer argumento en el main y vamos a utilizar para obtener la variable de entorno la que nos interesa es la que dice PATH.

Crea un programa .c y compila este código y verás las variables de entorno, algo asi:

`*PATH:/home/rmarrero/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin*`

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv, char **envp)
{
    char *path = getenv("PATH");
    int i = 0;
    
    if (path)
        printf("PATH: %s\n", path);
	   else
        printf("La variable de entorno PATH no está definida.\n");
    
    while (envp[i] != NULL)
    {
        printf("Variable de entorno: %s\n", envp[i]);
        i++;
    }
    return 0;
}
```

- detalles del path (opcional):
    
    ```
    bash
    CopiarEditar
    /home/rmarrero/bin
    /usr/local/sbin
    /usr/local/bin
    /usr/sbin
    /usr/bin
    /sbin
    /bin
    /usr/games
    /usr/local/games
    /snap/bin
    ```
    
    - **`/home/rmarrero/bin`**: Este es un directorio dentro de tu carpeta de usuario (en este caso, `rmarrero`), y es comúnmente donde los usuarios colocan programas ejecutables personalizados o scripts.
    - **`/usr/local/sbin`** y **`/usr/local/bin`**: Son directorios comunes en sistemas Unix y Linux donde se colocan aplicaciones instaladas localmente (por el usuario o el administrador del sistema).
    - **`/usr/sbin`** y **`/usr/bin`**: Estos directorios contienen programas y herramientas del sistema que pueden ser ejecutados por cualquier usuario.
    - **`/sbin`** y **`/bin`**: Son directorios esenciales para el sistema operativo que contienen herramientas necesarias para la administración del sistema y para la ejecución de programas básicos.
    - **`/usr/games`** y **`/usr/local/games`**: Estos directorios son para juegos en sistemas Unix.
    - **`/snap/bin`**: Este directorio es para aplicaciones instaladas usando Snap, un sistema de distribución de software para Linux.
    
    Ejemplo con el comando ls:
    
    - **Busca en `/home/rmarrero/bin`:** Si el ejecutable `ls` estuviera en este directorio (por ejemplo, si tuvieras una versión personalizada del comando), lo encontraría aquí. Si no, pasa al siguiente directorio.
    - **Busca en `/usr/local/sbin`:** Este directorio generalmente contiene ejecutables del sistema que no forman parte del software estándar, sino de aplicaciones instaladas localmente. Aquí no suele estar `ls`, ya que no es una aplicación personalizada, pero se verifica.
    - **Busca en `/usr/local/bin`:** Al igual que el anterior, busca si hay alguna versión del comando `ls` en este directorio.
    - **Busca en `/usr/sbin`:** Este directorio está destinado a comandos de administración del sistema, y en general, no contiene `ls`.
    - **Busca en `/usr/bin`:** Este es el directorio donde típicamente se encuentra el comando `ls`. El sistema lo encuentra aquí y lo ejecuta.
    - **Busca en `/sbin`, `/bin`, `/usr/games`, `/usr/local/games`, `/snap/bin`:** Si no hubiera encontrado el ejecutable de `ls` en `/usr/bin`, seguiría buscando en estos otros directorios. Sin embargo, en la mayoría de los sistemas, `ls` estará en `/usr/bin`.
    
    Si no lo encuentro sale el error de 
    
    ```c
    bash: ls: command not found
    ```
    

---

Ya con los conceptos mas claros vamos a ir paso a paso la ejecución del pipex:

1. El primer paso sería crear un main.c y agregar nuestra función pricipal donde agreguemos los 3 argumentos ya mencionados.
2. El parseo de datos
3. Crear función para obtener los comando pasados como argv[i], para mi es una struct t_cmd que hace lo mismo que un malloc de strings, es decir, un split para los comandos.
4. Si ya tenemos los comandos sean dos o n comandos, vamos a por la funcion que ejecuta el proceso del padre y el hijo, ya lo veremos más a fondo.

Ya con esto mi main termina haces free(); de lo que necesites, etc.

---

Detalles de la función `*execute_commands();*` que sería la más importante del programa, ya que crea los `*fork();*` para cada comando. Intentaré dejar un diagrama para qué se vea más claro:

```
pipe()
 |
 |-- bucle para cada comando
      |
      |-- fork()
            |
            |-- hijo
                  |-- si es el primer comando: dup2(infile, STDIN)
                  |-- si es el último comando: dup2(outfile, STDOUT)
                  |-- para comandos intermedios: dup2(pipe_fd[1], STDOUT)
                  |-- cerrar todos los pipes
                  |-- execve(comando)
            |
            |-- padre
                  |-- cerrar extremos de pipe no utilizados
                  |-- continuar con el siguiente comando
                  |-- esperar al hijo si es el último comando
```

Explicaré esta función y voy a ir desglosando cada función que tengo que crear para que funcione:

1. En esta función principal lo primero es crear él una variable para meter la lista de comando, como sea que la guarde, el pid_t pid para el fork(); pid_t es como un size_t recuerdo, aunque ya debería estar claro, el pipe_fd[2]; y el fd_prev que seria el fd del infile.
2. ya con eso podemos hacer un bulce que se repita según la cantidad de comandos que hay el mismo llama a la funcion create_pipe que a su ves tiene un if (si hay comando crea una pipe(); válida que esté bien creado, 


Ejemplo 
Si ejecutamos el siguiente pipeline:  

```bash
< infile wc -l | cat -e
```

---

## **Flujo de ejecución**
Supongamos que `infile` contiene:

```
Hola
Mundo
42
```

### **Paso 1: `wc -l` (proceso hijo)**
- `< infile` redirige la entrada estándar (`stdin`) del proceso hijo para que lea desde `infile`.  
- `wc -l` cuenta el número de líneas en `infile` y devuelve `3`.  
- Su salida (`stdout`) es redirigida a la tubería (`pipe`).

Después de ejecutarse, `wc -l` escribe `3\n` en la tubería.

---

### **Paso 2: `cat -e` (proceso padre)**
- `cat -e` lee su entrada estándar (`stdin`) desde la tubería.  
- Como la tubería contiene `3\n`, `cat -e` lo convierte en `3$` (porque `cat -e` muestra `\n` como `$`).  
- Finalmente, imprime `3$` en la terminal.

---

## **Representación en código (`pipe_and_fork`)**
1. **Se crea la tubería (`pipe()`).**
2. **Se hace `fork()`, creando un hijo.**
3. **Código del hijo (`wc -l`):**
   - Cierra el extremo de lectura `p_fd[0]` (no lo usa).
   - Redirige `stdout` (`p_fd[1]`) para que su salida vaya a la tubería.
   - Ejecuta `wc -l`, que lee desde `infile` y escribe `3\n` en la tubería.
4. **Código del padre (`cat -e`):**
   - Cierra el extremo de escritura `p_fd[1]` (no lo usa).
   - Redirige `stdin` (`p_fd[0]`) para que lea desde la tubería.
   - Ejecuta `cat -e`, que convierte `3\n` en `3$` y lo imprime.

---

## **Flujo de datos en la tubería**
```
infile (Hola\nMundo\n42\n)  
   ↓  
wc -l (cuenta líneas, genera "3\n")  
   ↓  
(pipe)  
   ↓  
cat -e (convierte "3\n" en "3$")  
   ↓  
Terminal: **"3$"**
```

coso de infile 3 lineas wc -l cat -e wc -l cat -e

Si ejecutamos el siguiente pipeline:

```bash
< infile wc -l | cat -e | wc -l | cat -e
```

---

## **1. Representación en código (`ft_do_pipe`)**
Como este pipeline tiene **cuatro comandos**, se necesitan **tres tuberías** y **cuatro procesos** (uno por cada comando).

---

### **Paso 1: `wc -l` (proceso hijo 1)**
- **Crea una tubería (`pipe()`).**
- **Hace `fork()`, creando el hijo 1.**
- **En el hijo 1 (`wc -l`):**
  - Cierra `p_fd[0]` (no lo usa).
  - Redirige `stdout` (`p_fd[1]`) a la tubería.
  - Ejecuta `wc -l`, que cuenta las líneas de `infile` y escribe `3\n` en la tubería.
- **En el padre:**
  - Cierra `p_fd[1]` (no lo usa).
  - Redirige `stdin` (`p_fd[0]`) para que lea desde la tubería.

---

### **Paso 2: `cat -e` (proceso hijo 2)**
- **Crea una segunda tubería (`pipe()`).**
- **Hace `fork()`, creando el hijo 2.**
- **En el hijo 2 (`cat -e`):**
  - Cierra `p_fd[0]` (no lo usa).
  - Redirige `stdout` (`p_fd[1]`) a la nueva tubería.
  - Ejecuta `cat -e`, que convierte `3\n` en `3$` y lo escribe en la tubería.
- **En el padre:**
  - Cierra `p_fd[1]` (no lo usa).
  - Redirige `stdin` (`p_fd[0]`) para que lea desde la tubería.

---

### **Paso 3: `wc -l` (proceso hijo 3)**
- **Crea una tercera tubería (`pipe()`).**
- **Hace `fork()`, creando el hijo 3.**
- **En el hijo 3 (`wc -l`):**
  - Cierra `p_fd[0]` (no lo usa).
  - Redirige `stdout` (`p_fd[1]`) a la nueva tubería.
  - Ejecuta `wc -l`, que cuenta el número de líneas de la entrada (`stdin`).
  - Como `cat -e` devolvió una sola línea (`3$`), su salida es `1\n`.
- **En el padre:**
  - Cierra `p_fd[1]` (no lo usa).
  - Redirige `stdin` (`p_fd[0]`) para que lea desde la tubería.

---

### **Paso 4: `cat -e` (proceso hijo 4)**
- **Hace `fork()`, creando el hijo 4.**
- **En el hijo 4 (`cat -e`):**
  - Cierra `p_fd[0]` (no lo usa).
  - Redirige `stdout` (`p_fd[1]`) a la terminal.
  - Ejecuta `cat -e`, que convierte `1\n` en `1$` y lo imprime.

---

## **2. Flujo de datos en la tubería**
```
infile (Hola\nMundo\n42\n)  
   ↓  
wc -l (cuenta líneas, genera "3\n")  
   ↓  
(pipe)  
   ↓  
cat -e (convierte "3\n" en "3$")  
   ↓  
(pipe)  
   ↓  
wc -l (cuenta líneas, genera "1\n")  
   ↓  
(pipe)  
   ↓  
cat -e (convierte "1\n" en "1$")  
   ↓  
Terminal: **"1$"**
```

---

## **3. Salida esperada en la terminal**
```
1$
```

El resultado es `1$` porque:
1. `wc -l` cuenta las líneas en `infile`, resultando en `3\n`.
2. `cat -e` transforma `3\n` en `3$`.
3. `wc -l` cuenta **una sola línea** (`3$`), resultando en `1\n`.
4. `cat -e` transforma `1\n` en `1$`.

---

Biblio

[Pipes, Forks, & Dups: Understanding Command Execution and Input/Output Data Flow](https://www.rozmichelle.com/pipes-forks-dups/?source=post_page-----71984b3f2103---------------------------------------#pipelines)

[Pipex the 42 project “Understanding Pipelines in C”](https://medium.com/@omimouni33/pipex-the-42-project-understanding-pipelines-in-c-71984b3f2103)

[pipex tutorial — 42 project](https://csnotes.medium.com/pipex-tutorial-42-project-4469f5dd5901)

# **Proyecto Pipex 42 “Entendiendo los pipelines en C”**

Los pipelines son una piedra angular en los sistemas operativos tipo Unix, ya que permiten una comunicación fluida entre procesos al permitir que la salida de un proceso se convierta en la entrada de otro. En la programación en C, la `pipe()`función desempeña un papel fundamental en el establecimiento de canales de comunicación entre procesos a través de pipelines unidireccionales. Vamos a explorar más a fondo el funcionamiento de los pipelines y su implementación en C.

# **Tuberías en sistemas tipo Unix:**

En los shells similares a Unix, como Bash, las tuberías facilitan la concatenación de varios comandos, donde la salida de un comando fluye sin problemas hacia la entrada del siguiente. Esta orquestación se logra sin esfuerzo utilizando el operador de tubería `|`. Por ejemplo:

```
comando1 | comando2
```

Aquí, la salida generada por `command1` sirve como entrada para `command2`, creando efectivamente una tubería para el flujo de datos.

# **La `pipe()`función en C:**

En esencia, las tuberías son flujos almacenados en búfer vinculados de forma intrincada a dos descriptores de archivos, meticulosamente configurados para permitir la transferencia de datos de un extremo al otro. En el ámbito de la programación en C, la `pipe()` función surge como el conducto para construir tuberías unidireccionales. Su firma de función dice:

```c
			int pipe(int pipefd[2]) ;
```

La `pipe_fd` matriz encapsula dos números enteros, donde `pipefd[0]`representa el extremo de lectura de la tubería, mientras que `pipefd[1]`representa el extremo de escritura. Los datos escritos en `pipefd[1]`pueden recuperarse posteriormente de `pipefd[0]`, lo que fomenta la comunicación entre los procesos emparejados.

# **Explicación visual de las tuberías:**

```
              [Proceso A] [Proceso B]
                 | |
           (pd[0 ])<----- pipe -------(pd[1])
                  | |Fin
            de lecturaFin                    de escritura
```

Este esquema visual delinea la esencia de las tuberías, mostrándose `pd[0]`como el extremo de lectura, donde los datos inscritos por el Proceso B esperan ser consumidos por el Proceso A. Por el contrario, `pd[1]`se erige como el extremo de escritura, canalizando los datos escritos por el Proceso A hacia la ansiosa aceptación del Proceso B.

# **Gestión de procesos en C:**

En la programación en C, la gestión de procesos mediante canalizaciones requiere el uso de un conjunto de funciones como `fork()`, `execve()`, `dup2()`y `close()`.

- `fork()fork()fork()pipe()fork()`
    
    : Esta función crea un nuevo proceso haciendo una copia del actual. Cuando
    
    se llama a , se crean dos procesos: el padre y el hijo. El proceso padre continúa su ejecución desde donde
    
    fue llamado, mientras que el proceso hijo comienza desde el mismo punto pero con un identificador de proceso (PID) diferente. Además, si se creó previamente una tubería utilizando
    
    , los descriptores de archivo obtenidos de la tubería se comparten entre los procesos padre e hijo. Esto significa que los datos escritos en un descriptor se pueden leer desde el otro.
    
    esencialmente duplica la memoria del padre y los descriptores de archivo para el hijo, lo que les permite compartir información y trabajar juntos.
    

# **Integración con `fork()`comunicación entre procesos:**

La combinación `fork()`con `pipe()`abre oportunidades para la comunicación entre procesos. Una vez creados los procesos padre e hijo, ambos tienen acceso a los mismos descriptores de archivo, que son proporcionados por `pipe()`. Esta conexión compartida les permite intercambiar datos fácilmente a través de la tubería. Esta comunicación no se trata solo de transferir datos; permite la sincronización y la colaboración entre procesos. Esta colaboración es esencial para tareas como la creación de scripts de shell y la programación concurrente, lo que permite operaciones más complejas y eficientes.

![](https://miro.medium.com/v2/resize:fit:882/1*701AIwu3JBgeNRF1Ac_jCQ.jpeg)

- `execve()execve()`
    
    :Esta función es como el director de una orquesta. Ayuda a iniciar un nuevo proceso reemplazando el proceso actual por uno nuevo basado en un archivo específico. Imagina que tienes una nueva pieza musical (el nuevo proceso) y que
    
    es el director quien comienza a tocarla, reemplazando la pieza anterior.
    
- `dup2()dup2()dup2()`
    
    :Piense en esto
    
    como un hechizo mágico que hace una copia exacta de una varita mágica (descriptor de archivo) y la coloca en otra varita. Esto se usa a menudo para redirigir la entrada y la salida de un proceso. Por ejemplo, si desea que la salida vaya a un lugar diferente al habitual,
    
    puede hacer que eso suceda copiando la varita de salida a una nueva ubicación.
    
- `close()close()`
    
    :Cuando un archivo ya no es necesario,
    
    es como cerrar un libro después de terminar de leerlo. Es una forma de avisarle al sistema que ya no se usa un archivo o recurso, liberando así espacio y recursos para otras tareas.
    

En términos más simples, `execve()`inicia una nueva tarea, `dup2()`puede cambiar dónde van la entrada y la salida de la tarea, y `close()`finaliza y limpia las cosas cuando la tarea está hecha.

# **Explicación visual de `pipex`la función:**

```
              [Proceso padre]
                  / \
   [Proceso hijo1 ] [Proceso hijo2 ]
    (cmd1,entrada ) (cmd2,salida )
         | |
         | |
    [Entrada de canalización] [Salida de canalización]
```

![](https://miro.medium.com/v2/resize:fit:1400/1*qk2o6fO87biKE0TX_H_wsA.png)

When we use `fork()` along with `pipe()` for interprocess communication, it's like a parent creating two children. One child, let's call it Child Process 1, is responsible for taking input from `cmd1`. The other child, Child Process 2, is ready to give the results to `cmd2`. The pipe acts like a bridge between these children, making it easy for them to share information. It's like a secret passage that allows data to flow smoothly from input to output, making communication between the processes effortless.

# **Data Flow:**

- The input data originates from the designated input file. It then travels through the first process (`cmd1`), which acts upon it according to its instructions.
- The processed data is then sent to the write end (`pd[1]`) of the pipe, where it awaits consumption by the second process (Child Process 2). This data can be read by Child Process 2 through its standard input (`stdin`).

This explanation unveils the intricate workings of pipelines and interprocess communication in C, inviting exploration and innovation in the realm of programming.

---

# **tutorial de Pipex — 42 proyecto**

Pipex reproduce el comportamiento de la tubería de carcasa `|` comando en C.

Se lanza como `./pipex infile cmd1 cmd2 outfile` y se comporta como lo hace esta línea en el shell `< infile cmd1 | cmd2 > outfile` .

Este artículo está estructurado de la siguiente manera:

1 — Teoría de fondo — `pipe()` , `fork()` , `dup2()` y `execve()`

2 — Cómo hacer pipex con dos procesos secundarios

3 — El `access()` función

4 — Problemas encontrados con frecuencia

## **1 — Teoría de fondo — pipe(), fork(), dup2() y execve()**

```
# ./pipex infile cmd1 cmd2 outfiletubería()
 |
 |-- tenedor()
      |
      |-- niño // cmd1
      : |--dup2()
      : |--close end[0]
      : |--execve(cmd1)
      :
      |-- padre // cmd2
            |--dup2()
            |--close end[1]
            |--execve(cmd2)
```

La idea general: leemos de *infiel*, ejecute cmd1 con infile como entrada, envíe la salida a cmd2, que escribirá a *archivo*.

`pipe()` envía la salida del primero `execve()` como entrada al segundo `execve()`; `fork()` ejecuta dos procesos (es decir, dos comandos) en un solo programa; `dup2()` intercambia nuestros archivos con stdin y stdout.

Visualmente,

```
// cada cmd necesita un stdin (entrada) y devuelve una salida (a stdout)

    infile outfile
como stdin para cmd1 como stdout para cmd2
       | PIPE ↑
       | |--------------------------------
       ↓ | | |
      cmd1 --> end[1] ↔ end[0] --> cmd2
                     | |
            cmd1 |--------------------------| final[0]
           la salida lee el final[1]
         está escrito y envía cmd1
          para finalizar[1] salida a cmd2
       (end[1] se convierte en (end[0] se convierte
        cmd1 stdout) cmd2 stdin)
```

`pipe()` toma una matriz de dos int como `int end[2]`y los vincula. En una tubería, lo que se hace al final[0] es visible al final[1], y viceversa. Además, `pipe()` asigna un *fd* a cada extremo.

Fd son descriptores de archivos, y dado que los archivos se pueden leer y escribir, al obtener un fd cada uno, los dos extremos pueden comunicarse: end[1] escribirá a su propio fd, y end[0] leerá end[1]’s fd y escribirá a su propio.

```
vacío pipex(int f1, int f2)
{
    int fin[2];    tubo(extremo);
}
```

`fork()` dividirá nuestro proceso en dos subprocesos: devuelve 0 para el proceso hijo, un número distinto de cero para el proceso padre o un - 1 en caso de error.

También: `fork()` divide el proceso en dos *paralelo*, *simultáneo* procesos, que suceden en el *igual* tiempo.

```
vacío pipex(int f1, int f2)
{
    int fin[2];
    pid_t padre;    tubería(extremo);
    padre = fork();
    si (padre < 0)
         volver (perror("Fork: "));
    ¡si (!padre) // si fork() devuelve 0, estamos en el proceso infantil
        child_process(f1, cmd1);
    otra cosa
        parent_process(f2, cmd2);
}
```

*Interior* la tubería, todo va a uno de sus extremos, un extremo escribirá y el otro leerá (más sobre esto en la sección 4).

fin[1] es el proceso del niño, y fin[0] el proceso del padre: el niño escribe, mientras el padre lee. Y dado que para que algo se lea, primero debe escribirse, por lo que cmd1 será ejecutado por el niño y cmd2 por el padre.

Anteriormente, dijimos que la tubería crea fds.

Corremos piplex así `./pipex infile cmd1 cmd2 outfile` , así que el infile y el outfile necesitan convertirse en el stdin y stdout de la tubería.

En linux, puede verificar sus fds actualmente abiertos con el comando `ls -la /proc/$$/fd` (0, 1 y 2 se asignan por defecto a stdin, stdout y stderr). Nuestra mesa fd en este momento se ve así:

Para el *niño* proceso, queremos *infiel* ser nuestro stdin (lo queremos como entrada), y terminar[1] ser nuestro stdout (queremos escribir para terminar[1] la salida de cmd1).

En el *padre* proceso, queremos que end[0] sea nuestro stdin (end[0] lee desde end[1] la salida de cmd1), y *archivo* para ser nuestro stdout (queremos escribirle la salida de cmd2).

`dup2()` puede cambiar nuestros fds a stdin/stdout.

Del HOMBRE, `int dup2(int fd1, int fd2)` : cerrará fd2 y duplicará el valor de fd2 a fd1, o dicho de otra manera, redirigirá fd1 a fd2.

El proceso infantil, en pseudo código:

```
# child_process(f1, cmd1);//agregar protección si dup2() < 0
//dup2 close stdin, f1 se convierte en el nuevo stdin
dup2(f1, STDIN_FILENO); //queremos que f1 sea execve() entrada
dup2(end[1], STDOUT_FILENO); //queremos que end[1] sea execve() stdout
close(end[0]) # --> siempre cierra el extremo de la tubería que no usas
                    mientras la tubería esté abierta, el otro extremo lo hará
                    estar esperando algún tipo de entrada y no lo hará
                    poder terminar su proceso
cerrar(f1)
//ejecutar la función para cada ruta posible (ver más abajo)
salida(EXIT_FAILURE);
```

El proceso de los padres en pseudo código será similar, pero con `waitpid()` al principio, esperar a que el niño termine su proceso.

```
# parent_process(f2, cmd2);estado int;waitpid(-1, & estado, 0);
dup2(f2, ...); //f2 es el stdout
dup2(end[0], ...); //end[0] es el stdin
cerrar(fin[1])
cerrar(f2);
//ejecutar la función para cada ruta posible (ver más abajo)
salida(EXIT_FAILURE);
```

Con el stdin y el stdout correctos, podemos ejecutar el comando con `execve()` .

> Del HOMBRE,
> 
> 
> **int execve(const char *path, char *const argv[], char *envp[]);**
> 

```
int execve(const char *path, char *const argv[], char *envp[]);#trayecto: el camino a nuestro comando
        escriba 'which lsst y 'which wcury en su terminal
        verás la ruta exacta a los binarios de los comandos# argv[]: los args que necesita el comando, para ex. ills - laaur
          puede usar su ft_split para obtener un char **
          como este { "ls", "-la", NULL }
          debe ser nulo terminado# envp: la variable ambiental
        simplemente puede recuperarlo en su principal (ver más abajo)
        y pásalo a execve, no hay necesidad de hacer nada aquí
        en envp verá una línea PATH que contiene todo lo posible
        rutas a los binarios de los comandosint main(int ac, char **ag, char **envp)
{
     int f1;
     int f2;     f1 = open(ag[1], O_RDONLY);
     f2 = open(ag[4], O_CREAT | O_RDWR | O_TRUNC, 0644);
     si (f1 < 0 || f2 < 0)
          retorno (-1);
     pipex(f1, f2, ag, envp);
     retorno (0);
}
```

Para ver lo que hay dentro `envp`, tipo `env` en tu terminal.

Verás una línea `PATH` ésas son todas las rutas posibles hacia los binarios de comando.

Necesitarás dividir: puedes usar `:` como delimitador, y recuperarlos (pequeña nota sobre esto en la sección 4).

Su función execve tendrá que probar todos los caminos posibles hacia el cmd hasta que encuentre el bueno.

Para ver la ruta al comando `ls`, por ejemplo, puede escribir `which ls` en tu terminal. Si el comando no existe, execve no hará nada y devolverá - 1; de lo contrario, ejecutará el cmd, eliminará todos los procesos en curso (incluidas las variables, por lo que no tendrá que preocuparse por la libertad) y saldrá (más sobre esto, consulte la sección 3 a continuación). En pseudocódigo,

```
//análisis (en algún lugar de su código)char *PATH_from_envp;
char **mípatas;
char **mycmdargs;// recuperar la línea PATH de envp
PATH_from_envp = ft_substr(envp ...);
mypaths = ft_split(PATH_from_envp, ":"); //ver sección 4 para a
                                            pequeña nota[0]
mycmdargs = ft_split(ag[2], "");//en su proceso de hijo o padreint i;
char *cmd;i = -1;
mientras (mypaths[++i])
{
    cmd = ft_join(mypaths[i], ag[2]); //protege tu ft_join
    execve(cmd, mycmdargs, envp); // si execve tiene éxito, sale
    // perror("Error"); <- agregar perror a la depuración
    free(cmd) // si execve falla, liberamos y probamos una nueva ruta
}
retorno (EXIT_FAILURE);
```

## **2 — Cómo hacer pipex con dos procesos secundarios**

Podemos dividir la carga de trabajo pipex en diferentes niños, mientras que el padre espera a que se haga el trabajo y supervisar los niños *estado*.

Por lo tanto, tendremos que bifurcar dos veces, y asignar child1 para ejecutar cmd1, y child2 para ejecutar cmd2. El padre esperará al final. En pseudocódigo,

```
vacío pipex(int f1, int f2, char *cmd1, char *cmd 2)
{
    int fin[2];
    estado int;
    pid_t niño1;
    pid_t niño2;    tubería(extremo);
    child1 = tenedor();
    si (child1 < 0)
         volver (perror("Fork: "));
    si (child1 == 0)
        child_one(f1, cmd1);
    child2 = tenedor();
    si (child2 < 0)
         volver (perror("Fork: "));
    si (child2 == 0)
        niño_dos(f2, cmd2);
    close(end[0]); // este es el padre
    close(end[1]); // no hacer nada
    waitpid(child1, &status, 0); //supervisando a los niños
    waitpid(child2, &status, 0); //mientras terminan sus tareas
}
```

## **3 — El `access()` función**

Si corres `< infile pikachu | ls > oufile` en el caparazón, te pondrás `-bash: pikachu: command not found`.

Si ahora corres `./pipex infile pikachu ls outfile`, su programa no hará nada y saldrá sin mensajes de error. `execve()` no ejecutará nada si no se encuentra el comando. Debe verificar si existe antes de su ejecución.

Para hacer esto, compruebe el `access()` función. Con el modo adecuado, puede usarlo para verificar si el comando existe y es *ejecutable*.

## **4 — Problemas encontrados con frecuencia**

[0] En cuanto a dividir su ruta envp, imprima el resultado de su división y eche un vistazo. Añadir a `/` al final para que el camino funcione correctamente.

[1] Si inicia su programa y se atasca sin ejecutar nada, lo más probable es que un extremo de la tubería no se haya cerrado correctamente. Hasta que un extremo esté abierto, el otro estará esperando la entrada y su proceso no terminará.

[2] Uso `perror("Error")` para depurar, especialmente justo después `fork()` o `execve()`, para ver lo que está pasando en la tubería. Dentro de la tubería, todo lo hecho va a uno de sus extremos. printf para ex. impresión woniat a la terminal o se imprimirá a su archivo de salida (porque intercambiamos el stdout); `perror("Error")` funcionará porque imprime a stderr.

[3] Manejar los derechos de archivo cuando usted `open()` ellos. Error de devolución si el archivo no se puede abrir, leer o escribir. Compruebe cómo el shell trata el infile y el outfile cuando no existen, no son legibles, escribibles, etc. (`chmod` es tu mejor amigo).

---

![](https://www.rozmichelle.com/wp-content/uploads/pipefinal-1.png)

**Nota: es necesario tener conocimientos básicos de comandos Unix y C/C++ para comprender esta publicación. Mi objetivo es explicar el flujo de datos entre procesos cuando se ejecutan comandos. Si desea pasar directamente a la parte del pipeline, haga clic [aquí](https://www.rozmichelle.com/pipes-forks-dups/?source=post_page-----71984b3f2103---------------------------------------#pipelines) .**

Actualmente estoy inscrito en una clase de programación de sistemas en Stanford (CS110: Principios de sistemas informáticos). Es la segunda clase de sistemas que he tomado (la primera fue CS107, que enseña C y se centra en la comprensión de punteros y gestión de memoria). Esta clase se centra principalmente en el funcionamiento interno del sistema operativo, utilizando C y C++ para enseñarnos conceptos como gestión de procesos, ejecución de programas y manejo de datos. Si bien disfruté y comprendí rápidamente los conceptos enseñados en CS107, me resultó más difícil comprender el material en CS110. La clase en sí es extremadamente interesante y está bien enseñada, pero mi principal punto de dolor ha sido comprender la forma en que los procesos comparten datos y cómo funcionan la entrada y la salida a través de los comandos ingresados en la terminal. Sin embargo, en los últimos días, finalmente encontré claridad cuando comencé a crear diagramas para modelar el comportamiento del proceso y la ruta que toman los datos a medida que viajan de un comando a otro. Me gustaría compartir lo que he aprendido con ustedes. En esta publicación, repasaremos cómo los comandos Unix se pasan datos entre sí a través de tuberías y redirección de entrada/salida e ilustraré lo que realmente sucede con el flujo de datos cuando se ejecuta un comando.

# Descriptores de archivos

Comencemos con un modelo básico de “escribir algo en el teclado, presionar enter y obtener un resultado” que consiste en ejecutar un solo comando en la terminal sin redirección de entrada/salida. Unix asocia la entrada con el teclado de la terminal y la salida con la pantalla de la terminal de manera predeterminada. Unix es famoso por modelar prácticamente todo lo que hay en la computadora como un archivo, incluido el teclado y el monitor. Por lo tanto, escribir en la “pantalla” es en realidad solo escribir en el archivo que administra la visualización de datos en la pantalla. De manera similar, leer datos del teclado significa leer datos del archivo que representa el teclado. En el contexto de esta discusión, nos referiremos a la entrada y la salida como datos de texto que entran y salen de un proceso.

Los datos fluyen a través de secuencias que transfieren bytes de un área a otra. Hay tres secuencias de entrada/salida (E/S) predeterminadas: **entrada estándar (stdin)** , **salida estándar (stdout)** y **error estándar (stderr)** . De manera predeterminada, cada una de estas secuencias tiene un descriptor de archivo específico. Un descriptor de archivo es un entero asociado con un archivo abierto (cuyo funcionamiento está más allá del alcance de esta discusión), y los procesos usan descriptores de archivo para manejar datos. Las tres secuencias predeterminadas tienen los siguientes números de descriptor de archivo: stdin = 0, stdout = 1 y stderr = 2. Los descriptores de archivo se almacenan en una tabla de descriptores de archivo, y cada proceso tiene su propia tabla de descriptores de archivo (con 0, 1 y 2 creados y asignados a sus secuencias apropiadas de manera predeterminada cuando se crea el proceso). Cada secuencia no tiene idea de dónde provienen o a dónde van los datos enviados o leídos desde su descriptor; las secuencias simplemente tratan con los descriptores de archivo, no con las fuentes de datos en sí. El proceso solo necesita manejar el descriptor de archivo, no el archivo en sí; El kernel administra el archivo de forma segura.

Además de 0, 1 y 2, los procesos utilizan otros descriptores de archivo según sea necesario. El descriptor de archivo más bajo sin usar (sin abrir) siempre se utiliza cuando se asigna un nuevo descriptor de archivo. Por lo tanto, el descriptor de archivo 3 suele ser el primero en la fila que se utiliza después de que se configuren 0, 1 y 2 de forma predeterminada.

# Flujo de datos

Ahora estamos listos para hablar sobre el flujo de datos en profundidad. Cuando ejecutamos comandos en la terminal, cualquier entrada y salida debe manejarse de manera apropiada. El proceso que se crea para cada comando debe saber qué datos, si los hay, tomar como entrada y, posiblemente, qué datos tomar como salida. El proceso de cada comando también debe saber dónde enviar y recibir dichos datos. Para representar el flujo de datos entrantes (a través de la entrada estándar desde el teclado de manera predeterminada) y salientes (a través de la salida estándar a la terminal de manera predeterminada, y también a través de la salida estándar si algo sale mal), utilizaré diagramas como el siguiente:

![](http://www.rozmichelle.com/wp-content/uploads/pipe10-640x131.png)

Flujo de datos conceptual para los flujos de entrada (0) y salida (1) estándar

La figura anterior representa la configuración predeterminada de los flujos de entrada y salida. El teclado pasa datos al programa que ejecuta el comando (desde la perspectiva del comando, recibe la entrada a través de stdin), y ese programa envía la salida a la terminal a través de stdout. Represento el flujo de datos de izquierda a derecha. También utilizo las palabras "in" y "out" para representar datos que entran en un área y salen de otra área, respectivamente. Aunque en este caso "in" y "out" están asociados con stdin y stdout respectivamente, este no será necesariamente el caso en diagramas futuros. Por lo tanto, coloco los números de descriptor de archivo junto al "archivo" asociado que corresponde a la acción "in"/"out" relevante para dejar en claro qué descriptor de archivo se está utilizando para qué propósito. Generalmente, los datos que fluyen "hacia" algo se consideran entrada (y se leen  **desde** una fuente a través de un descriptor de archivo) y los datos que fluyen "hacia" algo se consideran salida (y se **escriben** en una fuente a través de un descriptor de archivo). Dicho de otra manera: **la entrada se lee desde algún lugar; la salida se escribe en algún lugar** . Este modelo mental resultará útil en futuros diagramas que sean más complejos.

Una cosa a tener en cuenta es que en realidad hay dos flujos que pueden escribir la salida en la terminal de forma predeterminada: stdout y stderr. El flujo stderr se utiliza cuando algo sale mal al intentar ejecutar un comando. Por ejemplo, el siguiente comando **ls dir_x**  en mi terminal intenta enumerar el contenido del directorio inexistente dir_x:

```
$ ls dir_x
ls: cannot access dir_x: No such file or directory
```

En este ejemplo, el flujo que se utiliza para mostrar la segunda línea es en realidad stderr, no stdout. Dado que stderr también va a la terminal de forma predeterminada, vemos el mensaje de error en la terminal. Si el directorio existiera, stdout mostraría el contenido del directorio en la pantalla.

Aquí hay un diagrama actualizado que muestra los extremos de salida del flujo tanto para stdout como para stderr:

![](http://www.rozmichelle.com/wp-content/uploads/pipe11-640x129.png)

Flujo de datos conceptual para los flujos de entrada estándar (0), salida (1) y error (2)

Recuerde que la palabra "out" simplemente significa salida, y el descriptor de archivo asociado con cada salida se muestra junto a ella. Ahora que comprende que stderr existe y se puede utilizar, en realidad lo dejaré fuera de los diagramas de flujo de datos futuros a menos que un ejemplo utilice específicamente stderr. ¡Solo recuerde que existe!

Ahora podemos explorar el flujo de datos mediante comandos. Algunos comandos leen la entrada y escriben la salida, pero otros solo hacen una o ninguna de las dos cosas. Exploraremos diferentes casos, pero primero, analicemos qué significa realmente la entrada aquí. Técnicamente, desde la perspectiva del shell (el shell procesa la línea de comandos que se le da al terminal), cualquier cosa que se escriba en el teclado (incluido el comando en sí) es "entrada" en el sentido general, pero estamos tratando específicamente con la entrada y la salida que necesitan los comandos para que los procesos que ejecutan los comandos transfieran datos hacia y desde los archivos (incluidos el teclado y la pantalla). Los argumentos de comando que son opciones realmente se leen desde la línea de comando (como una matriz de argumentos); la entrada real se lee desde un archivo abierto que está asociado con un descriptor de archivo. Por lo tanto, defino la entrada a un comando como datos que se pasan específicamente mediante stdin (u otro descriptor de archivo reutilizado que se pueda leer), ya sea que se escriban a través del teclado, se redirijan a través de la redirección de E/S (explicado más adelante) o posiblemente se pasen al comando como un argumento de archivo (en lugar de un argumento de opción). Si se pasa un archivo como argumento, entonces lo considero entrada si el proceso realmente leerá o manipulará el **contenido** de ese archivo (por ejemplo, para ordenar el contenido), en lugar de simplemente hacer referencia al archivo en sí (por ejemplo, para moverlo o cambiarle el nombre).

Como nota al margen, los argumentos de las opciones de la línea de comandos son el resultado de otra opción de diseño de Unix que permite que la modificación del comportamiento de un comando ejecutado se transmita por separado de la entrada recibida. Mantener los argumentos y la entrada separados facilita la tarea cuando se utilizan tuberías.

Veamos ahora algunos ejemplos. Para ilustrar un comando que no puede tener entrada pero sí salida, considere **ls** , que enumera todos los archivos en el directorio actual:

```
$ ls
dir1
file1
file2
```

Esto se puede visualizar de la siguiente manera:

![](http://www.rozmichelle.com/wp-content/uploads/pipe12.png)

El comando ls.

Si un comando no acepta la entrada desde la entrada estándar, entonces los datos que se pasan a dicho comando simplemente serán ignorados por el programa que ejecuta el comando, ya que no fue escrito para manejar datos de entrada. Por ejemplo, **< words.txt ls** enumerará los archivos y directorios en el directorio actual e ignorará la entrada que fue redirigida a la entrada estándar (esto utiliza redirección de E/S, que explicaré más adelante).

Veamos un comando que, si todo va bien, no toma ninguna entrada ni da ninguna salida: **mv** , que se puede utilizar para mover o renombrar archivos. Si le doy el nombre de un archivo o directorio que se puede mover o renombrar correctamente, entonces no se emiten datos a través de stdout o stderr. Recuerde que, dado que el contenido de este archivo no se lee ni se utiliza de ninguna manera, el archivo que se pasa no se considera una entrada. En una llamada exitosa a este comando, tendría este diagrama muy simple:

![](http://www.rozmichelle.com/wp-content/uploads/pipe-mvout-300x149.png)

Sin entrada ni salida

Sin embargo, si uso **mv** incorrectamente y se produce un error, entonces tendré salida a stderr:

```
$ mv
mv: missing file operand
Try 'mv --help' for more information.
```

![](http://www.rozmichelle.com/wp-content/uploads/pipe13-640x299.png)

Llamar a mv sin argumentos

Hagamos las cosas más interesantes. Uno de mis ejemplos favoritos de un comando que lee la entrada y escribe la salida es  **sort** . Cuando se utiliza sin argumentos de archivo y sin redirección de entrada, la terminal espera a que el usuario ingrese las cadenas a ordenar (una cadena por línea). Una vez que el usuario escribe Ctrl-D (que cierra el extremo de escritura del canal de comunicación que conecta el teclado con la entrada estándar del proceso **sort** ), el proceso que ejecuta  **sort** sabrá que se ingresaron todas las cadenas deseadas. Por lo tanto, estas cadenas se pasan a través de la entrada estándar al proceso que ejecuta el comando, se ordenan por dicho proceso y luego se escriben en la terminal a través de la salida estándar. ¡Bastante ingenioso! Aquí hay un ejemplo de entrada/salida:

```
$ sort
cherry
banana
apple
apple
banana
cherry
```

Las cadenas en negrita son entradas del usuario y las cadenas que siguen representan el resultado ordenado. Este es el flujo de datos para este ejemplo:

![](http://www.rozmichelle.com/wp-content/uploads/pipe14-640x317.png)

El comando sort. Se escribe la entrada en el teclado y luego se muestra el resultado en orden ordenado.

Tenga en cuenta que **sort** también puede tomar un argumento de nombre de archivo para obtener la entrada del archivo especificado en lugar de esperar a que el usuario ingrese los datos (por ejemplo, **sort words.txt** ), lo que sigue nuestra definición de entrada, ya que es un archivo y no un argumento de opción como en **sort -r** . Además,  **sort**  puede tomar la entrada a través de la redirección de entrada, lo que explicaré más adelante.

Ahora que comprendemos la idea general del flujo de datos desde stdin a stdout o stderr, podemos analizar cómo controlar el flujo de entrada y salida. Explicaré dos formas de hacerlo: utilizando tuberías, que permiten que la salida de un proceso pase como entrada a otro proceso, y utilizando la redirección de E/S, que permite que los archivos sean la fuente y el destino de los datos en lugar del teclado y la terminal predeterminados. ¡Qué divertido! Vamos a profundizar en el tema.

# Introducción a las tuberías

Unix tiene una filosofía de diseño simple pero valiosa, como lo explicó Doug McIlroy, el inventor de la tubería Unix:

> “Escribe programas que hagan una cosa y que la hagan bien. Escribe programas que funcionen juntos. Escribe programas que gestionen flujos de texto, porque esa es una interfaz universal”.
> 

El concepto de canalización es extremadamente poderoso. Las canalizaciones permiten que los datos de un proceso pasen a otro (a través de un flujo de datos unidireccional) de modo que los comandos se puedan encadenar entre sí mediante sus flujos. Esto permite que los comandos trabajen juntos para lograr un objetivo mayor. Este encadenamiento de procesos se puede representar mediante una canalización **:**  los comandos de una canalización se conectan a través de canalizaciones, donde los datos se comparten entre procesos al fluir de un extremo de la canalización al otro. Dado que cada comando de la canalización se ejecuta en un proceso separado, cada uno con un espacio de memoria separado, necesitamos una forma de permitir que esos procesos se comuniquen entre sí. Este es exactamente el comportamiento que   proporciona la llamada al sistema **pipe() .**

En términos de implementación, las tuberías son simplemente flujos almacenados en búfer que están asociados con dos descriptores de archivo que están configurados para que el primero pueda leer los datos que se escriben en el segundo. Específicamente, en el código escrito para manejar la ejecución de comandos en una tubería, se crea una matriz de dos números enteros y una llamada **pipe()** llena la matriz con dos descriptores de archivo disponibles (generalmente los dos valores más bajos disponibles) de modo que el primer descriptor de archivo en la matriz pueda leer los datos escritos en el segundo.

Naturalmente, las tuberías físicas son una gran analogía para esta abstracción. Podemos pensar en el flujo de datos que comienza en un proceso como agua en un entorno aislado, y la única forma de permitir que el agua fluya al entorno del siguiente proceso es conectar los entornos con una tubería. De esta manera, el agua (datos) fluye desde el primer entorno (proceso) hacia la tubería, llenando la tubería con toda su agua y luego drenando su agua hacia el otro entorno. Este flujo de datos es exactamente lo que intento capturar en el diagrama para el siguiente ejemplo de tubería, **sort | grep ea** :

![](http://www.rozmichelle.com/wp-content/uploads/pipe-1.png)

ordenar | grep ea

Analicemos esto pieza por pieza. El comando **sort** , como en el ejemplo anterior, espera la entrada del usuario (que introduce tres cadenas para ordenar) a través de stdin (descriptor de archivo 0). A continuación, las cadenas se ordenan y se envían como salida a través de stdout, que se introduce en la tubería. Esto se hace permitiendo que stdout introduzca datos en el extremo izquierdo de la tubería (descriptor de archivo 4) en lugar de en la terminal. Estoy omitiendo un detalle aquí, pero este proceso se explica con más profundidad más adelante en esta publicación.

Antes de continuar, aquí hay un detalle importante: ¿recuerdas cuando mencioné que cada proceso obtiene su propia tabla de descriptores de archivos? Bueno, dado que cada comando en la canalización se ejecuta en un proceso separado, cada comando tiene su propia versión de los descriptores de archivos, incluidos sus propios stdin, stdout y stderr. Esto significa que el 0 que se muestra en el lado izquierdo del diagrama pertenece al proceso que ejecuta **sort** y, por lo tanto, está en una tabla de descriptores de archivos diferente a la del 1 que se muestra a la derecha, que pertenece al proceso que ejecuta **grep** . Sin embargo, dado que los flujos están configurados para enviar datos más allá de los límites del proceso, el resultado final es que los datos terminan donde pertenecen siempre que se hayan transmitido correctamente por la canalización.

Continuando: ahora que el  comando **sort**  tiene una lista ordenada de cadenas como salida, debe pasarla a través de la tubería creada para comunicar los datos al siguiente proceso, **grep** . Ignorando los descriptores de archivo 3 y 4 por un momento, observe las palabras "in" y "out": vemos que los datos fluyen **fuera**  del  proceso **sort** y **dentro de** la tubería, donde luego pasan **fuera de**  la tubería y  **dentro** del proceso grep . "In" y "out" se expresan según el contexto en el que se usan: ya sea dentro de la tubería o fuera de ella.

Con eso en mente, ahora podemos analizar los descriptores de archivo entregados por la  llamada **pipe()** . Supongamos que en el código que ejecuta los comandos en la secuencia de comandos, la  llamada **pipe()** llena una matriz de descriptores de archivo {3, 4} de modo que los datos escritos en 4 se puedan leer desde 3. En realidad, no importa cuáles sean estos números o incluso si están en orden creciente. Imagine que la matriz es {pickle, mickeymouse} si eso ayuda; los valores dados solo importan para el proceso, ¡pero el propósito de los descriptores de archivo importa para los datos! El propósito de cada descriptor de archivo depende de qué índice esté cada uno en la matriz.

Hay un concepto **muy** importante que entender aquí, uno que me llevó un tiempo entender finalmente (y eso no sucedió hasta que creé estos diagramas debido a la forma en que funciona mi cerebro visual). Recuerde que en mi modelo mental, los datos fluyen de izquierda a derecha en los diagramas. Los descriptores de archivo en la matriz están configurados de modo que lo que se escribe en 4 se pueda leer desde 3, por lo que puede que se pregunte por qué 4 se muestra en el lado izquierdo de la tubería en la imagen de arriba y 3 está en el derecho, en lugar de al revés. La clave para entender es que **las acciones de lectura y escritura definidas por una llamada pipe() son desde la perspectiva de los dos procesos que utilizan la tubería , ¡no la tubería en sí!**  Por lo tanto, cuando la  llamada **pipe()** define 4 como el extremo escribible de la tubería, significa que es el extremo de la tubería en el que el **proceso del primer comando** escribe la salida para que la tubería misma reciba esos datos como entrada. No significa lo contrario: que 4 sea el lado de la tubería desde donde la tubería escribe los datos, lo que te tentaría a etiquetar el lado derecho de la tubería como 4. De manera similar, 3 es el extremo legible de la tubería, lo que significa que es el extremo de la tubería desde donde el **proceso del segundo comando** lee los datos. ¡Todo es cuestión de contexto! :)

De esta manera, los datos pasan a la tubería, donde permanecen hasta que se reciben todos los datos para que puedan drenarse hacia el proceso **grep** . Como último paso, y con suerte relativamente fácil, el proceso que ejecuta **grep** busca en la entrada que recibió de la salida de la tubería líneas que contengan "ea". Luego, utiliza su flujo de salida estándar para enviar las cadenas coincidentes a la terminal. ¡Listo! ¡No está mal para nuestro primer tutorial de tubería! A continuación, profundizaremos aún más en la comprensión de cómo el código puede ejecutar estos procesos. Nuestra comprensión de cómo funciona **pipe()** es, en mi opinión, la mitad de la batalla. Comprender **fork()** y **dup2()** es la otra mitad. ¡Veamos cómo funcionan estas funciones!

# Ejecución de comandos en una canalización

En los diagramas que hemos visto hasta ahora, se utilizaron tuberías al pasar datos de un proceso de comando a otro, pero no hemos analizado la jerarquía de procesos que ejecutan dichos comandos. En clase, aprendimos a escribir programas de manera que cada comando se ejecute en un proceso secundario en lugar de en el proceso principal (el proceso que realiza la llamada). Normalmente, el proceso principal realiza cualquier configuración necesaria y luego crea un proceso secundario mediante una llamada **fork()** , que crea un clon del estado de memoria y los descriptores de archivo del proceso principal. De este modo, el proceso secundario termina con una copia independiente de las variables y los descriptores de archivo que existían en el proceso principal en el momento de la llamada **fork()** . Después de la llamada **fork()** , los cambios en el proceso principal no serán visibles para el proceso secundario y viceversa.

Este patrón children-execute-commands parece innecesario para ejecutar un solo comando, ya que podríamos simplemente ejecutar el comando en el padre sin crear un hijo, pero cuando piensas en lo que se necesita para hacer que el código sea lo suficientemente genérico para que funcione tanto para un solo comando como para varios comandos en una secuencia de comandos, entonces tiene sentido que siempre haya un proceso hijo diferente que ejecute cada comando. Hay excepciones a esta regla, como ejecutar un comando integrado que simplemente se puede ejecutar en el padre, pero para esta discusión, asumiremos que todos los comandos se ejecutan en procesos hijos.

Veamos un ejemplo pedante de un código C que ejecuta el comando **sort** . En este ejemplo, la entrada se imprime directamente en un descriptor de archivo mediante **dprintf()**  para mostrarle un caso en el que se utiliza una tubería para enviar datos desde el padre al hijo. Esta es una versión simplificada del código de muestra proporcionado a la clase por nuestro instructor, Jerry:

```
#include <unistd.h>
#include <sys/wait.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int fds[2];                      // an array that will hold two file descriptors
  pipe(fds);                       // populates fds with two file descriptors
  pid_t pid = fork();              // create child process that is a clone of the parent

  if (pid == 0) {                  // if pid == 0, then this is the child process
    dup2(fds[0], STDIN_FILENO);    // fds[0] (the read end of pipe) donates its data to file descriptor 0
    close(fds[0]);                 // file descriptor no longer needed in child since stdin is a copy
    close(fds[1]);                 // file descriptor unused in child
    char *argv[] = {(char *)"sort", NULL};   // create argument vector
    if (execvp(argv[0], argv) < 0) exit(0);  // run sort command (exit if something went wrong)
  }

  // if we reach here, we are in parent process
  close(fds[0]);                 // file descriptor unused in parent
  const char *words[] = {"pear", "peach", "apple"};
  // write input to the writable file descriptor so it can be read in from child:
  size_t numwords = sizeof(words)/sizeof(words[0]);
  for (size_t i = 0; i < numwords; i++) {
    dprintf(fds[1], "%s\n", words[i]);
  }

  // send EOF so child can continue (child blocks until all input has been processed):
  close(fds[1]);

  int status;
  pid_t wpid = waitpid(pid, &status, 0); // wait for child to finish before exiting
  return wpid == pid && WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}
```

El programa está escrito para ejecutar un comando específico: **sort** . Así es como funciona el código: en el proceso padre, se crea una matriz para almacenar dos descriptores de archivo. Después de la llamada **a pipe()** , la matriz se llena con los descriptores de archivo conectados, donde el primero se leerá desde el proceso hijo y el segundo será escrito por el proceso padre. Luego se llama a **fork()** para crear el proceso hijo, que tiene una copia de los descriptores de archivo y la memoria del padre. A partir de ese punto, verificamos si estamos ejecutando en el proceso hijo. Si es así, el hijo llama a **dup2()** para hacer que su stdin se asocie con el extremo legible de la tubería, que corresponde a fds[0]. Un detalle importante sobre la forma en que funciona **dup2()** es que primero cerrará su segundo parámetro, que es un descriptor de archivo, si es necesario. Por lo tanto, en este ejemplo, stdin (que está abierto por defecto) se cierra primero, lo que eliminará su referencia al archivo de teclado predeterminado. Entonces, la entrada estándar del proceso secundario podrá recibir datos a través de fds[0] en lugar de hacerlo desde el teclado. ¡Esa es la magia de **dup2()** !

Ahora que la entrada estándar del hijo está lista para leer datos, el hijo cierra los descriptores de archivo creados por la llamada **pipe(),** ya que ya no son necesarios en el hijo. Luego, el hijo ejecuta el  comando **sort**  y espera a que todos los datos del padre se escriban en el extremo apropiado de la tubería antes de ordenar los datos.

Es posible que cuando se llama a **fork()** , el hijo se ponga en marcha antes de que continúe el padre, en cuyo caso el hijo se cuelga hasta que recibe toda la entrada. Una vez que finaliza el comando sort, el proceso hijo finaliza después de la llamada **execvp()** (que ejecuta el comando dado) y cierra sus descriptores de archivo predeterminados 0, 1 y 2 automáticamente. Después de la llamada **fork()** que crea el hijo, el padre cierra fds[0] ya que no es necesario en el padre (el padre solo necesita escribir datos, no leerlos). Luego, el padre escribe cada palabra en la matriz dada en el extremo escribible de la tubería (fds[1]), agregando un carácter de nueva línea al final para permitir que el comando sort reciba correctamente cada palabra en una nueva línea. Cuando se han escrito todas las palabras, el padre cierra fds[1] ya que terminó de escribir datos, lo que envía un EOF al hijo para permitirle ejecutar el comando sort. El padre espera responsablemente a que el hijo termine (a través de la llamada **waitpid()** ) antes de salir. La última línea es simplemente una forma ordenada de devolver un valor que depende de si las cosas salieron como se esperaba.

Cuando todo está dicho y hecho, este es el diagrama de flujo de datos para toda la secuencia de eventos:

![](http://www.rozmichelle.com/wp-content/uploads/pipe20.png)

El flujo de datos final del ejemplo de código. En el hijo, el descriptor de archivo 3 se copió en la entrada estándar del hijo, luego se cerró 3 y solo se utiliza la entrada estándar del hijo para obtener datos, como se representa mediante los números en el lado derecho de la barra vertical.

Tenga en cuenta que este ejemplo muestra cómo se utiliza una tubería, pero en este caso no es necesaria. Por ejemplo, el hijo podría acceder a los datos desde la entrada estándar predeterminada sin ninguna interferencia del padre, lo que no requeriría el uso de una tubería. Este código simplemente muestra cómo las tuberías configuran la comunicación de un proceso a otro, y este patrón es crucial cuando se administran tuberías que tienen más de un comando.

Para tener una idea de lo que sucede en este código, he diseñado los siguientes diagramas. En las imágenes a continuación, las líneas muestran la asociación entre un descriptor de archivo y el archivo abierto al que apunta. Las direcciones de las flechas de línea representan el flujo de datos. Esperamos que estos diagramas aclaren qué descriptores de archivo necesitan el padre y el hijo, lo que a su vez debería ayudar a explicar cuándo es apropiado cerrar un descriptor de archivo para evitar una fuga. También tenga en cuenta que, dado que no se garantiza que las instrucciones en el padre se ejecuten antes que las instrucciones en el hijo, algunos de los pasos a continuación podrían ocurrir en momentos diferentes. Las imágenes son solo para darle una idea de lo que podría suceder durante la ejecución, aunque algunos pasos podrían intercambiarse en el camino.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-2.png)

Cuando se inicia el programa, se crea el proceso padre con los flujos predeterminados configurados en su tabla de descriptores de archivos. Las flechas muestran el flujo de datos: stdin recibe la entrada del teclado y stdout y stderr envían la salida a la pantalla del terminal.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-3.png)

La llamada pipe() busca los dos descriptores de archivo siguientes disponibles y asocia cada uno con el extremo correspondiente de la tubería creada. En este caso, un proceso puede leer a través de 3 y escribir a través de 4.

![](http://www.rozmichelle.com/wp-content/uploads/pipes1-4.png)

La llamada fork() crea el proceso hijo, que es una copia de la memoria y la tabla de descriptores de archivos del proceso padre en ese momento. Los archivos con los que están asociados los descriptores de archivos del proceso padre son los mismos archivos con los que están asociados los descriptores de archivos del proceso hijo.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-5.png)

El padre cierra el descriptor de archivo que no necesita. El hijo llama a dup2() para que su entrada estándar sea una copia de fds[0], cerrando primero el descriptor de archivo 0.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-6.png)

El padre escribe datos en el extremo escribible de la tubería. El hijo cierra los descriptores de archivo que no necesita.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-7.png)

Después de escribir todos los datos, el padre cierra fds[1] para informar al hijo que se han enviado todos los datos.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-2-1.png)

El proceso secundario ejecuta el comando de clasificación en la entrada.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-9.png)

La salida ordenada se envía a la terminal y el hijo envía una señal cuando termina, lo que permitirá que el proceso padre finalice.

![](http://www.rozmichelle.com/wp-content/uploads/pipesgraph1-2-2.png)

Los procesos limpian por sí solos los descriptores de archivo predeterminados. Todos los descriptores de archivo adicionales utilizados durante la ejecución del programa se han cerrado correctamente.

En particular, observe los pasos que tienen líneas azules, que representan el flujo de datos en ese momento. Si encadena esos pasos, obtendrá lo siguiente: el padre escribe datos en el extremo escribible de la tubería, que luego el hijo lee desde el extremo legible de la tubería a través del descriptor de archivo stdin del hijo y, por último, esos datos se envían desde el hijo como salida a la terminal. En pocas palabras, todas las demás líneas del diagrama terminan entregando datos a otros o ni siquiera se utilizan. Además, cuando el programa termina, los descriptores de archivo que debían cerrarse desaparecen. Este es un pequeño ejemplo de programa, pero puede ver lo desordenado que puede volverse cuando hay tuberías involucradas. Sin embargo, este es un proceso hermoso: lleve un registro de los datos y limpie después, ¡y el caos se resolverá solo al final!

Una cosa que notará aquí es que los descriptores de archivo con los que comienza una tubería pueden ser redirigidos a otro flujo según sea necesario. La tubería es una comodidad que le brinda dos descriptores de archivo que están configurados para funcionar juntos, pero sus propósitos pueden ser redirigidos según sea necesario para garantizar que los datos fluyan hacia y desde los lugares correctos.

Con suerte, estos diagramas aclararán lo que sucede cuando se crean procesos para ejecutar comandos. Es importante comprender no solo cómo se utilizan los descriptores de archivos, sino también cuándo no se utilizan para poder cerrarlos de manera adecuada. Son poderosos y es muy fácil equivocarse o dejarlos atrás.

# Redirección de E/S

Hay un último tema que me gustaría tratar. En nuestra discusión hasta ahora, hemos explorado el comportamiento predeterminado que viene con el uso de los tres descriptores de archivo predeterminados, donde usamos el teclado y la terminal para toda la entrada inicial y la salida final, respectivamente. También hemos visto cómo podemos pasar datos entre procesos en una canalización. ¿Qué sucede si queremos usar un archivo existente como entrada para el primer comando en una canalización en lugar de usar el teclado para la entrada, o qué sucede si queremos enviar la salida del último comando de la canalización a un archivo? Esto se puede hacer con la redirección de E/S. En la línea de comandos, el carácter “<” se usa para la redirección de entrada y ">” se usa para la redirección de salida, donde el archivo de salida se crea si no existe o se sobrescribe si ya existe. Para agregar datos a un archivo de salida en lugar de sobrescribir el contenido, puede usar ">>". Veamos un ejemplo que usa tanto la redirección de entrada como la de salida. Digamos que tenemos el archivo **words.txt** con el siguiente contenido:

```
$ cat words.txt
pear
peach
apple
```

Podemos usar este archivo como entrada para el comando **de clasificación** y luego enviar el contenido a otro archivo (o incluso al mismo archivo si lo desea) como se muestra a continuación:

```
$ < words.txt sort > words2.txt
```

Tenga en cuenta que no hay salida en la pantalla porque la salida se almacena en **words2.txt** . También podríamos escribir este comando como **sort < words.txt > words2.txt** . Si usamos **cat** para imprimir el contenido del archivo de salida, obtenemos lo siguiente:

```
$ cat words2.txt
apple
peach
pear
```

Resulta que implementar la redirección de E/S es relativamente sencillo. Podemos simplemente usar la magia **dup2()** que vimos antes:

```
// if first command in pipeline has input redirection
if (hasInputFile && is1stCommand) {
  int fdin = open(inputFile, O_RDONLY, 0644);
  dup2(fdin, STDIN_FILENO);
  close(fdin);
}

// if last command in pipeline has output redirection
if (hasOutputFile && isLastCommand) {
  int fdout = open(outputFile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
  dup2(fdout, STDOUT_FILENO);
  close(fdout);
}
```

Esperamos que este código sea bastante sencillo. Si hay una entrada para redirigir (cuya detección se maneja en otra función que no se muestra aquí), entonces llame a **open()** en el archivo y asigne ese flujo de datos al descriptor de archivo que usa **open()** . Luego, use la magia **dup2()** para permitir que stdin lea el contenido de ese archivo como entrada. De manera similar, si la redirección de salida está al final de la tubería, entonces redirija stdout para escribir el contenido del último comando en el archivo especificado.

Aquí hay un diagrama que representa el ejemplo anterior:

![](http://www.rozmichelle.com/wp-content/uploads/pipeio.png)

Redirección de entrada y salida

Quizás te preguntes por qué los descriptores de archivo comienzan con 3. Ejecuté este comando en un mini-shell que escribí para una tarea, por lo que puedo imprimir los descriptores de archivo que se asignan cuando ejecuto cualquier comando. Mi shell usa el código que se muestra arriba. Ten en cuenta que primero verifico si hay redirección de entrada. Si la hay, llamo al comando **open()** para leer los datos, que asigna este flujo al descriptor de archivo 3. Una vez que redirijo stdin para manejar los datos que maneja 3, cierro 3, lo que hace que 3 esté disponible para la verificación de redirección de salida. Por lo tanto, ambos archivos comienzan usando 3, pero luego se redirigen adecuadamente al flujo que necesita los datos, como lo muestra el texto tachado en rojo.

Aquí se puede ver el poder de Unix en acción, donde no sólo podemos encadenar pequeños programas para crear un programa más grande, sino que también podemos cargar datos en una secuencia de comandos y generar datos en un archivo para su uso futuro. Me parece todo tan mágico. :)

# Resumen

Para terminar lo que hemos discutido, veamos un largo proceso con un ejemplo trivial pero potencialmente útil. Imaginemos que usted quiere averiguar cuál es el color más querido entre un grupo de personas. Alguien escribe una lista de colores donde cada línea representa el color favorito de una persona. Su trabajo es tomar ese archivo y ejecutar algunos comandos en él, idealmente en un proceso impresionante, de modo que los tres colores más populares se guarden en un nuevo archivo junto con un recuento de cuántos votos recibió cada color. Así es como podría hacerlo:

```
$ < colors.txt sort | uniq -c | sort -r | head -3 > favcolors.txt
```

Y aquí está el diagrama:

![](http://www.rozmichelle.com/wp-content/uploads/pipefinal-1.png)

Encontrar el color más popular

Los comandos funcionan de la siguiente manera: **colors.txt** contiene una lista de colores que se ingresaron en orden aleatorio. El comando **uniq** elimina cualquier línea que sea igual a la línea anterior, eliminando efectivamente todas las líneas duplicadas consecutivas. Para que esto funcione como se desea, primero debemos ordenar la lista de colores, por eso llamamos **sort** first. Luego llamamos **uniq -c** , donde la opción **-c** eliminará los colores duplicados y también mostrará un recuento de cuántas veces apareció cada color. A continuación, ordenamos estos datos en orden descendente (que es lo que hace la opción **-r** cuando se pasa a **sort** ). Por último, llamamos **head -3** para obtener las tres primeras líneas del resultado y almacenamos esa salida en **favcolors.txt** . ¡Genial! Al final, **favcolors.txt** tiene los siguientes datos deseados:

```
$ cat favcolors.txt
      4 red
      3 blue
      2 green
```

Este es un ejemplo más complejo que otros que hemos estudiado, y los descriptores de archivo que se muestran en el diagrama lo dejan claro. Debido a que mi programa de shell llama a pipe() antes de verificar la redirección de E/S, el primer conducto obtiene los descriptores de archivo 3 y 4 y luego a los descriptores de archivo para los archivos de entrada y salida se les asignan 5 y 6, respectivamente. Una vez que 5 y 6 se redirigen a stdin y stdout, respectivamente, se cierran (como se muestra en los extremos izquierdo y derecho del diagrama). Para cuando se crea el segundo conducto, puede usar algunos descriptores de archivo reciclados, y lo mismo ocurre con el último conducto. No se preocupe demasiado por cómo se reciclan los descriptores de archivo porque eso es específico de mi código, pero sepa que todo se limpia al final y los datos se pasan correctamente.

Hemos cubierto bastante material y, aunque adoro a mi público, en realidad escribí esto más por mi propia cordura que por cualquier otra cosa. Pero, como siempre, espero que esto haya sido útil. Escribir todo esto y crear los diagramas definitivamente solidificó mi propia comprensión de todo, aunque tal vez una semana demasiado tarde para las pesadillas de exámenes parciales y tareas que experimenté la semana pasada. :)

Un agradecimiento especial para Hemanth, el asistente del curso que respondió a mis innumerables preguntas sobre estos temas. Le envié muchos diagramas para asegurarme de que fueran precisos y claros, y su ayuda realmente me ayudó a entender mejor las cosas. El personal del curso ha sido increíble, pero Hemanth realmente ha hecho todo lo posible para ayudarme. Lo mismo se aplica al profesor, Jerry, que ha tolerado mis muchas preguntas y ataques de pánico sobre mi desempeño en el curso. :) También le agradezco que haya revisado esta publicación para comprobar su precisión. Un sistema de apoyo como este es la razón por la que amo tanto a Stanford.
