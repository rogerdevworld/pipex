Funciones permitidas:

open, close, read, write, malloc, free, perror, strerror, access, dup, dup2, execve, exit, fork, pipe, unlink, wait, waitpid

---

- ## int execve(const char *pathname, char *const argv[], char *const envp[]);
    
    `execve` es una llamada al sistema fundamental en sistemas operativos basados en Unix, como Linux. Es parte de las funciones que permiten reemplazar el contenido de un proceso con el de un nuevo programa, lo que resulta útil en el desarrollo de aplicaciones que necesitan lanzar o ejecutar otros programas.
    
    ### **Prototipo**
    
    En el lenguaje C, `execve` se declara de la siguiente manera:
    
    ```c
    #include <unistd.h>
    
    int execve(const char *pathname, char *const argv[], char *const envp[]);
    
    ```
    
    ### **Descripción de los parámetros**
    
    1. **`pathname`**:
        - Es una cadena de caracteres que indica la ruta al archivo ejecutable que se desea ejecutar. Puede ser una ruta absoluta o relativa.
    2. **`argv`**:
        - Es un arreglo de punteros a cadenas de caracteres. Representa los argumentos que se pasarán al programa. El primer argumento (normalmente `argv[0]`) suele ser el nombre del programa.
    3. **`envp`**:
        - Es un arreglo de punteros a cadenas de caracteres que define el entorno del nuevo programa (variables de entorno, como `PATH` o `HOME`).
    
    ### **Funcionamiento**
    
    - **Reemplazo del proceso:**
    Cuando se llama a `execve`, el programa actual se reemplaza completamente por el programa especificado. Esto significa que el código, los datos y el estado del programa original desaparecen, y se inicia la ejecución del nuevo programa en el contexto del mismo proceso.
    - **Nunca regresa si tiene éxito:**
    Si la ejecución es exitosa, `execve` no regresa al programa llamante, porque el nuevo programa toma su lugar.
    - **Error:**
    Si falla, `execve` retorna `-1` y establece `errno` con el código de error correspondiente.
    
    ### **Ejemplo básico**
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <errno.h>
    
    int main() {
        char *argv[] = { "/bin/ls", "-l", "/home", NULL }; // Argumentos para 'ls'
        char *envp[] = { "HOME=/home/user", "PATH=/bin:/usr/bin", NULL }; // Variables de entorno
    
        if (execve("/bin/ls", argv, envp) == -1) {
            perror("execve");
            return 1;
        }
    
        return 0; // Nunca se ejecutará si execve tiene éxito
    }
    
    ```
    
    ### **Casos de uso comunes**
    
    1. **Reemplazo de procesos en un sistema operativo:**
    Se utiliza en sistemas tipo Unix cuando se desea cambiar la ejecución del proceso actual sin crear uno nuevo.
    2. **Implementación de shells:**
    Los shells como `bash` o `zsh` usan `execve` para ejecutar comandos.
    3. **Ejecución segura de programas:**
    En combinación con `fork`, permite ejecutar programas sin interferir con el proceso padre.
    
    ### **Errores comunes**
    
    1. **`EACCES`:** Permiso denegado para ejecutar el archivo.
    2. **`ENOENT`:** El archivo especificado no existe.
    3. **`ENOMEM`:** No hay suficiente memoria para cargar el nuevo programa.
    4. **`EFAULT`:** Puntero inválido para `pathname`, `argv` o `envp`.
    
    ### **Relación con otras funciones `exec`**
    
    `execve` es la versión más básica de la familia de funciones `exec`. Otras funciones, como `execl`, `execv`, o `execvp`, son envolturas que facilitan el uso de `execve`. Por ejemplo:
    
    - `execvp` busca el ejecutable en los directorios listados en `PATH`.
    - `execl` permite pasar los argumentos como una lista en lugar de un arreglo.
- ## pid_t fork(void);
    
    La función `fork()` en C es una llamada al sistema que se utiliza en sistemas operativos tipo Unix para crear un nuevo proceso. Este nuevo proceso es una copia casi exacta del proceso padre que llamó a `fork()`.
    
    ### Prototipo de `fork()`
    
    ```c
    #include <unistd.h>
    pid_t fork(void);
    
    ```
    
    - **Cabecera:** Está declarada en `<unistd.h>`.
    - **Valor de retorno:** Devuelve un valor de tipo `pid_t`, que es un entero con signo:
        - **0**: Si el proceso es el hijo.
        - **Un valor positivo:** Si el proceso es el padre. Este valor es el PID (identificador de proceso) del proceso hijo.
        - **1**: Si ocurre un error (por ejemplo, recursos insuficientes). En este caso, no se crea ningún proceso hijo.
    
    ---
    
    ### Funcionamiento
    
    Cuando se llama a `fork()`, el sistema operativo crea un nuevo proceso (el hijo), que es una copia del proceso padre. El código del proceso padre sigue ejecutándose después de la llamada a `fork()`, al igual que el código del proceso hijo, pero ambos se ejecutan de manera independiente.
    
    El nuevo proceso hijo:
    
    - Hereda el espacio de memoria, las variables, los descriptores de archivo y el estado de ejecución del padre, pero tienen direcciones de memoria separadas.
    
    ---
    
    ### Ejemplo simple de uso de `fork()`
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <sys/types.h>
    
    int main() {
        pid_t pid;
    
        pid = fork(); // Crear un nuevo proceso
    
        if (pid < 0) {
            // Error al crear el proceso hijo
            perror("Error en fork");
            return 1;
        } else if (pid == 0) {
            // Código que ejecuta el proceso hijo
            printf("Soy el proceso hijo. Mi PID es %d\n", getpid());
        } else {
            // Código que ejecuta el proceso padre
            printf("Soy el proceso padre. Mi PID es %d y mi hijo tiene el PID %d\n", getpid(), pid);
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### Salida esperada
    
    Cuando ejecutas este programa, obtendrás dos salidas (una del proceso padre y otra del hijo), aunque no siempre están en el mismo orden porque los procesos se ejecutan de forma independiente:
    
    ```
    Soy el proceso padre. Mi PID es 1234 y mi hijo tiene el PID 1235
    Soy el proceso hijo. Mi PID es 1235
    
    ```
    
    ---
    
    ### Consideraciones importantes
    
    1. **Espacio de memoria independiente:** Aunque el hijo hereda una copia del espacio de memoria del padre, cualquier cambio en las variables del hijo no afecta al padre y viceversa.
    2. **Ejecución simultánea:** Los procesos padre e hijo pueden ejecutarse en cualquier orden.
    3. **Uso con `wait()`:** Es común usar funciones como `wait()` o `waitpid()` para que el padre espere a que el hijo termine su ejecución.
    4. **Errores:** Asegúrate de manejar posibles errores al llamar a `fork()`, ya que no siempre se puede garantizar que el sistema tenga recursos para crear un nuevo proceso.
    
    Esta función es clave para construir sistemas multiproceso y se utiliza ampliamente en servidores y aplicaciones concurrentes.
    
- # int pipe(int pipefd[2]);
    
    La función `pipe()` en C se utiliza para crear un canal de comunicación unidireccional entre procesos relacionados (como un proceso padre e hijo). Este canal permite que un proceso escriba datos en un extremo del canal, mientras que el otro proceso puede leer esos datos desde el otro extremo.
    
    ---
    
    ### Prototipo de `pipe()`
    
    ```c
    #include <unistd.h>
    int pipe(int pipefd[2]);
    
    ```
    
    - **Parámetro:**
        - `pipefd`: Es un array de dos enteros (`int pipefd[2]`).
            - `pipefd[0]`: Es el extremo de lectura de la tubería.
            - `pipefd[1]`: Es el extremo de escritura de la tubería.
    - **Valor de retorno:**
        - **0:** Si la tubería se creó correctamente.
        - **1:** Si ocurrió un error (por ejemplo, recursos insuficientes o límites de tuberías alcanzados). En este caso, se establece `errno`.
    
    ---
    
    ### Funcionamiento básico
    
    1. **Crear la tubería:** Llama a `pipe()` para inicializar un canal.
    2. **Dividir procesos:** Usualmente se usa junto con `fork()`.
    3. **Comunicar datos:**
        - Un proceso escribe datos en `pipefd[1]` (extremo de escritura).
        - El otro proceso lee datos desde `pipefd[0]` (extremo de lectura).
    
    Los datos en la tubería tienen una estructura de tipo FIFO (First-In, First-Out): lo que se escribe primero es lo que se lee primero.
    
    ---
    
    ### Ejemplo simple con `pipe()` y `fork()`
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <string.h>
    
    int main() {
        int pipefd[2];
        pid_t pid;
        char mensaje[] = "Hola desde el proceso padre";
        char buffer[100];
    
        // Crear la tubería
        if (pipe(pipefd) == -1) {
            perror("Error al crear la tubería");
            return 1;
        }
    
        // Crear el proceso hijo
        pid = fork();
    
        if (pid < 0) {
            perror("Error en fork");
            return 1;
        } else if (pid == 0) {
            // Proceso hijo
            close(pipefd[1]); // Cierra el extremo de escritura
            read(pipefd[0], buffer, sizeof(buffer));
            printf("Proceso hijo recibió: %s\n", buffer);
            close(pipefd[0]); // Cierra el extremo de lectura
        } else {
            // Proceso padre
            close(pipefd[0]); // Cierra el extremo de lectura
            write(pipefd[1], mensaje, strlen(mensaje) + 1);
            close(pipefd[1]); // Cierra el extremo de escritura
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### Salida esperada
    
    Al ejecutar este programa, el proceso hijo imprimirá el mensaje enviado por el proceso padre:
    
    ```
    Proceso hijo recibió: Hola desde el proceso padre
    
    ```
    
    ---
    
    ### Detalles importantes
    
    1. **Unidireccionalidad:** Los datos solo pueden fluir en una dirección por una tubería. Si necesitas comunicación bidireccional, debes usar dos tuberías.
    2. **Cierre de extremos no usados:** Es importante cerrar los extremos de la tubería que no se utilizan (por ejemplo, el hijo debe cerrar el extremo de escritura y el padre el de lectura).
    3. **Bloqueo:** Si un proceso intenta leer de una tubería vacía, se bloquea hasta que haya datos disponibles. Si intenta escribir en una tubería llena, también se bloquea.
    4. **Tamaño limitado:** Las tuberías tienen un tamaño máximo de búfer, definido por el sistema operativo.
    
    ---
    
    ### Casos de uso comunes
    
    - Comunicación entre procesos padre e hijo.
    - Implementación de pipelines en shells (como `ls | grep txt`).
    - Transferencia de datos entre procesos relacionados en sistemas multiproceso.
    
    Esta función es esencial para la programación de sistemas concurrentes y se utiliza ampliamente junto con `fork()` para implementar patrones de comunicación eficiente entre procesos.
    
- # pid_t waitpid(pid_t pid, int *status, int options);
    
    La función `waitpid()` en C se utiliza para que un proceso padre espere la terminación de un proceso hijo específico. A diferencia de `wait()`, que espera a que cualquier proceso hijo termine, `waitpid()` ofrece más control sobre el proceso hijo que se espera, permitiendo especificar un identificador de proceso (PID) y un conjunto de opciones adicionales.
    
    ### Prototipo de `waitpid()`
    
    ```c
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <unistd.h>
    pid_t waitpid(pid_t pid, int *status, int options);
    
    ```
    
    - **Parámetros:**
        - `pid`: El PID del proceso hijo que el padre quiere esperar. Hay tres posibilidades:
            - Un valor positivo: Espera al proceso hijo con el PID especificado.
            - `1`: Espera a cualquier hijo (similar a `wait()`).
            - `0`: Espera a cualquier hijo cuyo grupo de procesos sea el mismo que el del proceso que llama a `waitpid()`.
            - Un valor negativo: Espera a cualquier hijo cuyo PID sea menor que el valor absoluto de `pid`.
        - `status`: Un puntero a una variable donde se almacenará el estado de terminación del proceso hijo. Si no te interesa el estado, puedes pasar `NULL`.
        - `options`: Un conjunto de opciones que puede ser uno de los siguientes:
            - `0`: Comportamiento estándar (bloquea hasta que el hijo termine).
            - `WNOHANG`: Si el proceso hijo no ha terminado, no bloquea y devuelve inmediatamente.
            - `WUNTRACED`: Reporta los procesos que están detenidos (aunque no hayan terminado).
            - `WCONTINUED`: Reporta los procesos que se han reanudado después de estar detenidos.
    - **Valor de retorno:**
        - **PID del hijo**: Si la llamada es exitosa, devuelve el PID del hijo que terminó (o `0` si se espera a un hijo en el mismo grupo de procesos).
        - **1**: Si ocurre un error, se devuelve `1` y se establece `errno`.
    
    ---
    
    ### Función `waitpid()` y el estado de terminación
    
    El parámetro `status` es un entero en el que se almacena el estado del proceso hijo. Este valor puede ser procesado usando macros como:
    
    - `WIFEXITED(status)`: Verdadero si el proceso hijo terminó normalmente (con `exit()` o `return`).
    - `WEXITSTATUS(status)`: Devuelve el código de salida del proceso hijo (si terminó normalmente).
    - `WIFSIGNALED(status)`: Verdadero si el proceso hijo terminó debido a una señal no atrapada.
    - `WTERMSIG(status)`: Devuelve el número de la señal que causó la terminación (si terminó por señal).
    - `WIFSTOPPED(status)`: Verdadero si el proceso hijo fue detenido por una señal.
    - `WSTOPSIG(status)`: Devuelve la señal que causó la detención (si fue detenida).
    
    ---
    
    ### Ejemplo de uso de `waitpid()`
    
    ```c
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/wait.h>
    #include <unistd.h>
    
    int main() {
        pid_t pid, result;
        int status;
    
        pid = fork(); // Crear un nuevo proceso hijo
    
        if (pid < 0) {
            perror("Error en fork");
            return 1;
        } else if (pid == 0) {
            // Proceso hijo
            printf("Soy el hijo, mi PID es %d\n", getpid());
            exit(42); // El hijo termina con un código de salida 42
        } else {
            // Proceso padre
            result = waitpid(pid, &status, 0); // Esperar a que termine el hijo
    
            if (result == -1) {
                perror("Error en waitpid");
                return 1;
            }
    
            if (WIFEXITED(status)) {
                printf("El hijo terminó con el código de salida: %d\n", WEXITSTATUS(status));
            } else if (WIFSIGNALED(status)) {
                printf("El hijo terminó debido a una señal: %d\n", WTERMSIG(status));
            }
    
            printf("El proceso padre (PID %d) ha terminado\n", getpid());
        }
    
        return 0;
    }
    
    ```
    
    ---
    
    ### Salida esperada:
    
    ```
    Soy el hijo, mi PID es 1235
    El hijo terminó con el código de salida: 42
    El proceso padre (PID 1234) ha terminado
    
    ```
    
    ### Explicación del ejemplo:
    
    1. El proceso padre crea un hijo con `fork()`.
    2. El proceso hijo termina con un código de salida `42` usando `exit()`.
    3. El proceso padre espera específicamente a su hijo con `waitpid()`.
    4. El padre verifica el estado de terminación del hijo con `WIFEXITED()` y obtiene el código de salida con `WEXITSTATUS()`.
    
    ---
    
    ### Consideraciones importantes:
    
    1. **Evitar procesos huérfanos:** Si el proceso padre no llama a `waitpid()` o `wait()`, el hijo se convierte en un proceso huérfano, y el sistema operativo lo adoptará.
    2. **Uso de `WNOHANG`:** Si no deseas que el proceso padre se bloquee mientras espera, puedes usar la opción `WNOHANG` en `waitpid()`, lo que hará que la función devuelva inmediatamente si el hijo no ha terminado.
    3. **Multiples hijos:** Si tienes varios procesos hijos, puedes llamar a `waitpid()` para esperar a procesos específicos usando sus PIDs. También puedes usar un bucle para esperar a varios hijos si es necesario.
    
    La función `waitpid()` es muy útil para gestionar múltiples procesos hijos y obtener detalles sobre su terminación, lo que ayuda en la programación de aplicaciones concurrentes y en la gestión de recursos del sistema.
    
- # int access(const char *pathname, int mode);
    
    La función `access()` en C se utiliza para comprobar si un archivo existe y si el proceso tiene permisos para acceder a él de una manera específica (lectura, escritura, ejecución). Es una función útil para verificar la accesibilidad de un archivo antes de realizar operaciones en él, como leerlo o escribir en él.
    
    ### Prototipo de `access()`
    
    ```c
    #include <unistd.h>
    int access(const char *pathname, int mode);
    
    ```
    
    ### Parámetros:
    
    - **`pathname`**: Es una cadena de caracteres que contiene la ruta del archivo que se va a comprobar.
    - **`mode`**: Es un valor que especifica el tipo de acceso que se desea comprobar. Los valores posibles son:
        - `F_OK`: Comprobar si el archivo existe.
        - `R_OK`: Comprobar si el archivo es legible (tiene permisos de lectura).
        - `W_OK`: Comprobar si el archivo es escribible (tiene permisos de escritura).
        - `X_OK`: Comprobar si el archivo es ejecutable (tiene permisos de ejecución).
    
    ### Valor de retorno:
    
    - **0**: Si la operación de comprobación fue exitosa (el archivo existe y se tiene acceso según el modo especificado).
    - **1**: Si la operación de comprobación falla (el archivo no existe o no se tiene el acceso solicitado). En este caso, `errno` se establece para indicar el error.
    
    ---
    
    ### Ejemplo de uso de `access()`
    
    ```c
    #include <stdio.h>
    #include <unistd.h>
    #include <errno.h>
    
    int main() {
        const char *archivo = "mi_archivo.txt";
    
        // Comprobar si el archivo existe
        if (access(archivo, F_OK) == 0) {
            printf("El archivo existe.\n");
    
            // Comprobar si el archivo es legible
            if (access(archivo, R_OK) == 0) {
                printf("El archivo es legible.\n");
            } else {
                printf("El archivo NO es legible.\n");
            }
    
            // Comprobar si el archivo es escribible
            if (access(archivo, W_OK) == 0) {
                printf("El archivo es escribible.\n");
            } else {
                printf("El archivo NO es escribible.\n");
            }
    
            // Comprobar si el archivo es ejecutable
            if (access(archivo, X_OK) == 0) {
                printf("El archivo es ejecutable.\n");
            } else {
                printf("El archivo NO es ejecutable.\n");
            }
        } else {
            perror("Error al comprobar el archivo");
        }
    
        return 0;
    }
    
    ```
    
    ### Salida esperada (dependiendo del archivo y sus permisos):
    
    ```
    El archivo existe.
    El archivo es legible.
    El archivo NO es escribible.
    El archivo NO es ejecutable.
    
    ```
    
    ---
    
    ### Explicación del ejemplo:
    
    1. Primero, se utiliza `access()` con `F_OK` para verificar si el archivo "mi_archivo.txt" existe.
    2. Luego, se comprueba si el archivo es legible (`R_OK`), escribible (`W_OK`) y ejecutable (`X_OK`).
    3. Si alguna de las comprobaciones falla, `access()` devuelve `1`, y el programa informa sobre el tipo de error mediante `perror()`.
    
    ---
    
    ### Consideraciones importantes:
    
    1. **`access()` no garantiza que el acceso funcione posteriormente**: Aunque `access()` te dice si el proceso tiene permisos de acceso al archivo en el momento en que se llama, no garantiza que estos permisos se mantendrán válidos cuando realmente accedas al archivo, debido a posibles cambios en los permisos o en el entorno (por ejemplo, si el archivo es borrado o sus permisos cambian entre el momento en que se llama a `access()` y cuando intentas abrirlo).
    2. **Efecto de `access()` en la caché de permisos**: `access()` no consulta el sistema de archivos directamente. En lugar de eso, se basa en la información de permisos en caché del sistema operativo, por lo que el uso de esta función puede no reflejar los cambios de permisos realizados después de que se haya ejecutado.
    3. **Uso en aplicaciones de seguridad**: Aunque `access()` se puede usar para verificar permisos, no es la herramienta más segura en sistemas de alta seguridad. Esto se debe a que puede haber una ventana de tiempo entre la comprobación de permisos y la operación real en el archivo, durante la cual los permisos o el archivo pueden cambiar (un problema conocido como **race condition**).
    4. **Permisos de usuario y propietario**: El comportamiento de `access()` depende de los permisos del proceso que realiza la llamada. Si el proceso tiene los permisos adecuados (por ejemplo, si es el propietario del archivo o tiene privilegios de superusuario), la llamada devolverá `0`
- int dup(int oldfd); e int dup2(int oldfd, int newfd);
    
    Las funciones `dup()` y `dup2()` en C son utilizadas para duplicar descriptores de archivo. Ambas permiten crear una copia de un descriptor de archivo y asociarlo con un nuevo descriptor. Estas funciones son útiles, por ejemplo, cuando necesitas redirigir la entrada/salida estándar de un proceso (como en la creación de pipes o redirección de salida en un shell).
    
    ### Prototipo de `dup()` y `dup2()`
    
    1. **`dup()`**:
        
        ```c
        #include <unistd.h>
        int dup(int oldfd);
        
        ```
        
        - **`oldfd`**: Es el descriptor de archivo que se desea duplicar.
        - **Valor de retorno**:
            - Devuelve el nuevo descriptor de archivo duplicado (mayor o igual a 0) si la operación es exitosa.
            - Devuelve **1** si ocurre un error, y establece `errno`.
    2. **`dup2()`**:
        
        ```c
        #include <unistd.h>
        int dup2(int oldfd, int newfd);
        
        ```
        
        - **`oldfd`**: El descriptor de archivo que se va a duplicar.
        - **`newfd`**: El nuevo descriptor de archivo que se creará.
        - **Valor de retorno**:
            - Devuelve el nuevo descriptor de archivo duplicado (`newfd`) si la operación es exitosa.
            - Devuelve **1** si ocurre un error, y establece `errno`.
    
    ---
    
    ### Diferencias clave entre `dup()` y `dup2()`
    
    1. **Comportamiento con `newfd`**:
        - **`dup()`**: No se especifica qué descriptor de archivo debe utilizarse para la copia. El sistema operativo automáticamente asigna el descriptor de archivo más bajo disponible.
        - **`dup2()`**: Tienes control total sobre el descriptor de archivo de destino. Si el descriptor de archivo `newfd` ya está en uso, se cierra antes de asignarlo al nuevo descriptor duplicado.
    2. **Comportamiento cuando `oldfd` y `newfd` son iguales**:
        - **`dup()`**: No tiene este caso, ya que el nuevo descriptor se asigna automáticamente.
        - **`dup2()`**: Si `oldfd` es igual a `newfd`, `dup2()` no hace nada y retorna el valor de `newfd` sin realizar ninguna operación. Esto permite evitar duplicar un descriptor innecesariamente.
    3. **Manejo de errores**:
        - Ambas funciones retornan `1` si ocurre un error, pero la diferencia es que `dup2()` te da un control más preciso sobre el descriptor de archivo de destino, ya que puedes verificar si ya está en uso o no antes de llamar a la función.
    
    ---
    
    ### Ejemplo de uso de `dup()` y `dup2()`
    
    1. **Ejemplo de `dup()`**:
    En este ejemplo, redirigimos la salida estándar (stdout) a un archivo.
        
        ```c
        #include <stdio.h>
        #include <unistd.h>
        #include <fcntl.h>
        
        int main() {
            int fd = open("salida.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (fd == -1) {
                perror("Error al abrir el archivo");
                return 1;
            }
        
            // Duplicar stdout (descriptor 1) al archivo
            int newfd = dup(fd);
            if (newfd == -1) {
                perror("Error en dup");
                return 1;
            }
        
            // Ahora la salida estándar está redirigida a "salida.txt"
            printf("Este texto se escribirá en el archivo salida.txt\n");
        
            close(fd); // Cerrar el archivo original
        
            return 0;
        }
        
        ```
        
        **Explicación**:
        
        - `open()` abre un archivo para escritura.
        - `dup(fd)` duplica el descriptor de archivo `fd` (del archivo `salida.txt`) y lo asigna a un descriptor libre (el más bajo disponible).
        - Después de la llamada a `dup()`, la salida estándar se redirige al archivo, por lo que cualquier impresión con `printf()` se escribirá en el archivo.
    2. **Ejemplo de `dup2()`**:
    Este ejemplo también redirige la salida estándar, pero con control sobre el descriptor de archivo de destino.
        
        ```c
        #include <stdio.h>
        #include <unistd.h>
        #include <fcntl.h>
        
        int main() {
            int fd = open("salida.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
            if (fd == -1) {
                perror("Error al abrir el archivo");
                return 1;
            }
        
            // Redirigir stdout (1) al archivo con dup2
            if (dup2(fd, STDOUT_FILENO) == -1) {
                perror("Error en dup2");
                return 1;
            }
        
            // Ahora la salida estándar está redirigida a "salida.txt"
            printf("Este texto se escribirá en el archivo salida.txt\n");
        
            close(fd); // Cerrar el archivo original
        
            return 0;
        }
        
        ```
        
        **Explicación**:
        
        - `dup2(fd, STDOUT_FILENO)` redirige explícitamente la salida estándar (descriptor 1) al archivo `salida.txt`.
        - Después de la llamada a `dup2()`, la salida estándar se redirige, y `printf()` escribe en el archivo.
    
    ---
    
    ### Resumen de diferencias:
    
    1. **`dup()`** asigna automáticamente un descriptor de archivo disponible, mientras que **`dup2()`** permite especificar el descriptor de destino.
    2. **`dup()`** no permite evitar la duplicación si los descriptores ya son iguales, mientras que **`dup2()`** lo permite y no realiza ninguna acción si `oldfd` y `newfd` son iguales.
    3. **`dup2()`** es más flexible cuando se necesita control total sobre el descriptor de archivo de destino.
    
    ---
    
    ### Usos comunes:
    
    - Redirección de entrada y salida en shells.
    - Crear pipes y redirigir la entrada/salida entre procesos.
    - Duplicar descriptores de archivos estándar (`stdin`, `stdout`, `stderr`) a otros archivos o dispositivos.
    
    Ambas funciones son herramientas poderosas para manipular flujos de datos y manejar entrada/salida en programación de sistemas.
    
- # char *strerror(int errnum);
    
    La función `strerror()` en C se utiliza para convertir un código de error numérico (almacenado en `errno`) en una cadena de texto que describe ese error. Es muy útil para proporcionar mensajes de error descriptivos en programas que manejan situaciones donde pueden ocurrir fallos del sistema, como la apertura de archivos, operaciones de entrada/salida, entre otros.
    
    ### Prototipo de `strerror()`
    
    ```c
    #include <string.h>
    char *strerror(int errnum);
    
    ```
    
    ### Parámetros:
    
    - **`errnum`**: Un número de error (generalmente, un valor de `errno`) que representa el tipo de error que ocurrió.
    
    ### Valor de retorno:
    
    - **Devuelve**: Una cadena de caracteres que describe el error correspondiente al número de error proporcionado en `errnum`. La cadena es estática, es decir, no se debe modificar, ya que puede ser sobrescrita por sucesivas llamadas a `strerror()`.
    
    ---
    
    ### Uso común de `strerror()`
    
    Por lo general, se usa junto con la variable global `errno`, que es definida por el sistema operativo y contiene el código de error de la última operación del sistema que falló.
    
    ### Ejemplo básico de `strerror()`:
    
    ```c
    #include <stdio.h>
    #include <string.h>
    #include <errno.h>
    
    int main() {
        // Intentar abrir un archivo que no existe
        FILE *file = fopen("archivo_inexistente.txt", "r");
    
        if (file == NULL) {
            // Si fopen falla, errno se establecerá con el código de error
            printf("Error al abrir el archivo: %s\n", strerror(errno));
        }
    
        return 0;
    }
    
    ```
    
    ### Explicación del ejemplo:
    
    1. **`fopen()`** intenta abrir un archivo que no existe, lo que causa un error.
    2. Cuando un error ocurre en una operación del sistema, **`errno`** se establece automáticamente con el número de error correspondiente.
    3. La función **`strerror(errno)`** convierte el valor numérico almacenado en `errno` en una cadena de texto descriptiva que se imprime en la consola.
    
    ### Salida esperada (dependiendo del sistema operativo):
    
    ```
    Error al abrir el archivo: No such file or directory
    
    ```
    
    ### Códigos de error comunes:
    
    Algunos ejemplos de errores que puedes encontrar usando `strerror()` (y sus códigos correspondientes en `errno`) incluyen:
    
    - **`ENOENT`** (2): No existe el archivo o directorio. Ejemplo: intentar abrir un archivo que no existe.
    - **`EACCES`** (13): Permiso denegado. Ejemplo: intentar abrir un archivo sin permisos de lectura.
    - **`ENOMEM`** (12): No hay suficiente memoria.
    - **`EBADF`** (9): Descriptor de archivo inválido. Ejemplo: intentar leer desde un descriptor de archivo que no está abierto.
    - **`EIO`** (5): Error de entrada/salida.
    
    ### Ejemplo de varios errores:
    
    ```c
    #include <stdio.h>
    #include <string.h>
    #include <errno.h>
    
    int main() {
        // Intentar abrir un archivo inexistente
        FILE *file = fopen("archivo_inexistente.txt", "r");
    
        if (file == NULL) {
            // Usar strerror para obtener una descripción del error
            printf("Error: %s\n", strerror(errno));
        }
    
        // Intentar dividir por cero
        int x = 0;
        int y = 1 / x; // Esto causará un error de división por cero
    
        if (errno == 8) { // Verificando el código de error de la división
            printf("Error de división por cero: %s\n", strerror(errno));
        }
    
        return 0;
    }
    
    ```
    
    ### Salida esperada:
    
    ```
    Error: No such file or directory
    Error de división por cero: Arithmetic operation resulted in an overflow
    
    ```
    
    ---
    
    ### Consideraciones:
    
    1. **Dependencia de `errno`**: `strerror()` depende de la variable global `errno`, que se establece automáticamente cuando ocurre un error en una función del sistema (como la apertura de un archivo, el envío de datos a través de un socket, etc.).
        - **Importante**: No todas las funciones del sistema establecen `errno` al fallar. Algunas funciones no afectan el valor de `errno`, por lo que es posible que tengas que asignarlo manualmente en esos casos.
    2. **Descriptores de error**: La cadena retornada por `strerror()` describe el error de manera legible, lo que facilita la depuración en comparación con solo usar los valores numéricos de `errno`.
    3. **Hilos**: En sistemas multihilo, cada hilo tiene su propia copia de `errno`, lo que significa que el valor de `errno` es local al hilo y no se comparte entre hilos.
    4. **Errores al usar `strerror()`**: Algunos sistemas pueden no tener todos los códigos de error implementados en la cadena devuelta por `strerror()`. En tal caso, puedes obtener un mensaje como "Unknown error".

---

Ahora tenemos que plantear el problema ya teniendo la idea principal de que tenemos un archivo inicial infile como dice que el subject que si o si tenemos que verificar que esté con access vemos que debemos correr un comando con execve y luego si el comando existe.

- main.c
    
    ```c
    int	main(int ac, char **av, char **env)
    {
    	int		i;
    	int		fd_in;
    	int		fd_out;
    
    	if (ac < 5)
    		exit_handler();
    	if (ft_strcmp(av[1], "here_doc") == 0)
    	{
    		if (ac < 6)
    			exit_handler();
    		i = 3;
    		fd_out = open_file(av[ac - 1], 2);
    		here_doc(av);
    	}
    	else
    	{
    		i = 2;
    		fd_in = open_file(av[1], 0);
    		fd_out = open_file(av[ac - 1], 1);
    		dup2(fd_in, 0);
    	}
    	while (i < ac - 2)
    		do_pipe(av[i++], env);
    	dup2(fd_out, 1);
    	exec(av[ac - 2], env);
    }
    ```
___
## Diagrama del Mandatory
```
./pipex infile cmd1 cmd2 outfile
        |
      pipe()  // Crea un pipe, que genera dos extremos: end[0] (lectura) y end[1] (escritura)
        |
    fork()  // Se crea un proceso hijo para ejecutar cmd1
        |
    +--- child (cmd1)  // Proceso hijo ejecutando cmd1
    |      |
    |      |-- dup2()    // Redirige la entrada estándar (stdin) al extremo de lectura del pipe (end[0])
    |      |-- close(end[0])  // Cierra el extremo de lectura del pipe en el proceso hijo
    |      |-- close(end[1])  // Cierra el extremo de escritura del pipe en el proceso hijo
    |      |-- execve(cmd1)  // Ejecuta el comando cmd1
    |
    +--- parent (cmd2)  // Proceso padre ejecutando cmd2
           |
           |-- dup2()    // Redirige la salida estándar (stdout) al extremo de escritura del pipe (end[1])
           |-- close(end[1])  // Cierra el extremo de escritura del pipe en el proceso padre
           |-- close(end[0])  // Cierra el extremo de lectura del pipe en el proceso padre
           |-- execve(cmd2)  // Ejecuta el comando cmd2
```
## Diagrama del bonus
```
./pipex infile cmd1 cmd2 cmd3 cmd4 outfile
        |
    pipe()    // Crea el primer pipe
        |
    fork()    // Crea un proceso hijo para cmd1
        |
    +--- child (cmd1)  
    |      |
    |      |-- dup2()    // Redirige stdin a infile
    |      |-- dup2()    // Redirige stdout a pipe[1] (escritura del primer pipe)
    |      |-- close()   // Cierra los extremos innecesarios
    |      |-- execve(cmd1)
    |
    +--- parent  
           |
           |-- loop through cmd2, cmd3, cmd4 (each time create a new pipe and fork)
           |
           pipe()  // Crea el siguiente pipe
           |
        fork()    // Crea un proceso hijo para cmd2, y así sucesivamente
           |
        +--- child (cmd2)
        |      |
        |      |-- dup2()    // Redirige stdin a pipe[0] (lectura del primer pipe)
        |      |-- dup2()    // Redirige stdout a pipe[1] (escritura del segundo pipe)
        |      |-- close()   // Cierra los extremos innecesarios
        |      |-- execve(cmd2)
        |
        +--- parent
               |
           repeat for cmd3, cmd4, etc.
               |
           final dup2() // Redirige stdout a outfile (para el último comando)
           close()  // Cierra los extremos de los pipes
           execve(cmd4)  // Ejecuta el último comando
```