#include "../include/pipex.h"

// Función para abrir archivos
int open_file(char *file, int in_or_out)
{
    int fd;

    if (in_or_out == 0)
        fd = open(file, O_RDONLY);
    else
        fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0777);
    if (fd == -1)
    {
        perror(file);
        exit(EXIT_FAILURE);
    }
    return (fd);
}

// Manejo de listas de comandos
t_cmd *create_cmd(char *cmd)
{
    t_cmd *new_cmd = malloc(sizeof(t_cmd));
    if (!new_cmd)
        return NULL;
    new_cmd->cmd = ft_strdup(cmd);
    new_cmd->next = NULL;
    return new_cmd;
}

// Función para obtener el valor de una variable de entorno
char *my_getenv(char *name, char **env)
{
    int i = 0;
    while (env[i])
    {
        if (ft_strncmp(env[i], name, ft_strlen(name)) == 0 && env[i][ft_strlen(name)] == '=')
            return env[i] + ft_strlen(name) + 1;
        i++;
    }
    return NULL;
}

void add_cmd(t_cmd **cmd_list, t_cmd *new_cmd)
{
    if (!*cmd_list)
        *cmd_list = new_cmd;
    else
    {
        t_cmd *temp = *cmd_list;
        while (temp->next)
            temp = temp->next;
        temp->next = new_cmd;
    }
}

void free_cmds(t_cmd *cmd_list)
{
    t_cmd *temp;

    while (cmd_list)
    {
        temp = cmd_list;
        cmd_list = cmd_list->next;
        free(temp->cmd);
        free(temp);
    }
}

// Función para ejecutar un comando
void exec_cmd(char *cmd, t_pipex *pipex)
{
    char **args = ft_split(cmd, ' ');
    char *path = get_path(args[0], pipex->env);

    if (execve(path, args, pipex->env) == -1)
    {
        perror("Command execution failed");
        ft_free_tab(args);
        free(path);
        exit(EXIT_FAILURE);
    }
}

// Resolver el path del comando
char *get_path(char *cmd, char **env)
{
    char *path_env = my_getenv("PATH", env);
    if (!path_env)
        return NULL;

    char **paths = ft_split(path_env, ':');
    for (int i = 0; paths[i]; i++)
    {
        char *path = ft_strjoin(ft_strjoin(paths[i], "/"), cmd);
        if (access(path, F_OK | X_OK) == 0)
        {
            ft_free_tab(paths);
            return path;
        }
        free(path);
    }
    ft_free_tab(paths);
    return NULL;
}

void execute_commands(t_pipex *pipex)
{
    t_cmd *current = pipex->cmds;
    int pipe_fd[2];
    int prev_fd = open_file(pipex->input_file, 0);  // Abrir archivo de entrada

    while (current)
    {
        if (current->next)
        {
            if (pipe(pipe_fd) == -1)
                ft_error(1, "Pipe error");
        }
        else
        {
            // Abrir el archivo de salida solo para el último comando
            pipe_fd[1] = open_file(pipex->output_file, 1);
        }

        pid_t pid = fork();
        if (pid == -1)
            ft_error(1, "Fork error");

        if (pid == 0) // Proceso hijo
        {
            // Redirigir la entrada del archivo al stdin
            dup2(prev_fd, STDIN_FILENO);
            // Si no es el último comando, redirigir la salida al pipe
            if (current->next)
                dup2(pipe_fd[1], STDOUT_FILENO);
            else // Último comando, redirigir la salida al archivo
                dup2(pipe_fd[1], STDOUT_FILENO);
            
            close(pipe_fd[0]);
            exec_cmd(current->cmd, pipex);
        }

        // Cerrar los descriptores de archivos en el proceso padre
        close(prev_fd);
        if (current->next)
            close(pipe_fd[1]);
        prev_fd = pipe_fd[0];  // Preparar para la siguiente iteración
        current = current->next;
    }

    // Esperar a que todos los procesos hijos terminen
    while (wait(NULL) > 0);
}


// Funciones auxiliares
void ft_free_tab(char **tab)
{
    size_t i = 0;
    while (tab[i])
        free(tab[i++]);
    free(tab);
}

// Manejo de errores
void ft_error(int type_of_error, char *error_message)
{
    if (type_of_error == 1)
    {
        fprintf(stderr, "Error: %s\n", error_message);
        exit(EXIT_FAILURE);
    }
}

// Función principal
int main(int argc, char **argv, char **env)
{
    if (argc < 5)
    {
        ft_error(1, "./pipex infile cmd1 cmd2 ... outfile\n");
        return EXIT_FAILURE;
    }

    t_pipex pipex;
    pipex.env = env;
    pipex.input_file = argv[1];
    pipex.output_file = argv[argc - 1];
    pipex.cmds = NULL;

    for (int i = 2; i < argc - 1; i++)
        add_cmd(&pipex.cmds, create_cmd(argv[i]));

    execute_commands(&pipex);
    free_cmds(pipex.cmds);

    return EXIT_SUCCESS;
}