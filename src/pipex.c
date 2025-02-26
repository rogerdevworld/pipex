#include "../include/pipex.h"

// Manejo de listas de comandos
t_cmd	*create_cmd(char *cmd)
{
	t_cmd	*new_cmd;

	new_cmd = malloc(sizeof(t_cmd));
	if (!new_cmd)
		return (NULL);
	new_cmd->cmd = ft_strdup(cmd);
	new_cmd->next = NULL;
	return (new_cmd);
}

void	add_cmd(t_cmd **cmd_list, t_cmd *new_cmd)
{
	t_cmd	*temp;

	if (!*cmd_list)
		*cmd_list = new_cmd;
	else
	{
		temp = *cmd_list;
		while (temp->next)
			temp = temp->next;
		temp->next = new_cmd;
	}
}

void	free_cmds(t_cmd *cmd_list)
{
	t_cmd	*temp;

	while (cmd_list)
	{
		temp = cmd_list;
		cmd_list = cmd_list->next;
		free(temp->cmd);
		free(temp);
	}
}

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

void	handle_here_doc(t_pipex *pipex, char *limiter)
{
	char	*line;
	int		temp_fd;
	size_t	limiter_len;

	temp_fd = open(TEMP_FILE, O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (temp_fd == -1)
		ft_error(1, "Error creating temporary file");

	limiter_len = ft_strlen(limiter);
	while (1)
	{
		write(1, "> ", 2);
		line = get_next_line(STDIN_FILENO);
		if (!line || (ft_strncmp(line, limiter, limiter_len) == 0 && line[limiter_len] == '\n'))
		{
			free(line);
			break;
		}
		write(temp_fd, line, ft_strlen(line));
		free(line);
	}
	close(temp_fd);

	pipex->input_fd = open(TEMP_FILE, O_RDONLY);
	if (pipex->input_fd == -1)
		ft_error(1, "Error opening temporary file");
}


// Función para buscar una variable de entorno
char	*my_getenv(char *name, char **env)
{
	int	i;
	size_t	name_len;

	name_len = ft_strlen(name);
	i = 0;
	while (env[i])
	{
		if (ft_strncmp(env[i], name, name_len) == 0 && env[i][name_len] == '=')
			return (env[i] + name_len + 1);
		i++;
	}
	return (NULL);
}

// Función para manejar errores
void	ft_error(int type_of_error, char *error_message)
{
	if (type_of_error == 1)
	{
		fprintf(stderr, "Error: %s\n", error_message);
		exit(EXIT_FAILURE);
	}
}

// Función para liberar un array de strings
void	ft_free_tab(char **tab)
{
	size_t	i;

	i = 0;
	while (tab[i])
	{
		free(tab[i]);
		i++;
	}
	free(tab);
}

// Función para liberar recursos
void	cleanup(t_pipex *pipex)
{
	free_cmds(pipex->cmds);
	if (pipex->input_fd != -1)
		close(pipex->input_fd);
}

// Función para ejecutar un comando
void exec_cmd(char *cmd, t_pipex *pipex)
{
    char **args;
    char *path;

    args = ft_split(cmd, ' ');
    if (!args)
        ft_error(1, "Failed to split command");

    path = get_path(args[0], pipex->env);
    if (!path)
    {
        ft_free_tab(args);
        ft_error(1, "Command not found");
    }

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
    char *path_env;
    char **paths;
    char *path;
    int i;

    path_env = my_getenv("PATH", env);
    if (!path_env)
        return (NULL);
    paths = ft_split(path_env, ':');
    i = 0;
    while (paths[i])
    {
        path = ft_strjoin(ft_strjoin(paths[i], "/"), cmd);
        if (access(path, F_OK | X_OK) == 0)
        {
            ft_free_tab(paths);
            return (path);
        }
        free(path);
        i++;
    }
    ft_free_tab(paths);
    return (NULL);
}

// Crear pipes y forks
void create_pipe_and_fork(t_pipex *pipex, t_cmd *commands, int *prev_fd)
{
    pid_t pid;
    int pipe_fd[2];

    if (commands->next)
    {
        if (pipe(pipe_fd) == -1)
            ft_error(1, "Pipe error");
    }

    pid = fork();
    if (pid == -1)
        ft_error(1, "Fork error");

    if (pid == 0) // Proceso hijo
    {
        if (*prev_fd != STDIN_FILENO)
        {
            dup2(*prev_fd, STDIN_FILENO); // Redirigir la entrada estándar
            close(*prev_fd); // Cerrar el descriptor de archivo duplicado
        }

        if (commands->next)
        {
            dup2(pipe_fd[1], STDOUT_FILENO); // Redirigir la salida estándar
            close(pipe_fd[0]); // Cerrar el extremo de lectura del pipe
            close(pipe_fd[1]); // Cerrar el extremo de escritura del pipe
        }
        else
        {
            // Último comando: redirigir la salida al archivo de salida
            int out_fd = open_file(pipex->output_file, 1);
            dup2(out_fd, STDOUT_FILENO);
            close(out_fd);
        }

        exec_cmd(commands->cmd, pipex);
    }
    else // Proceso padre
    {
        if (*prev_fd != STDIN_FILENO)
            close(*prev_fd); // Cerrar el descriptor de archivo anterior

        if (commands->next)
        {
            close(pipe_fd[1]); // Cerrar el extremo de escritura del pipe
            *prev_fd = pipe_fd[0]; // Guardar el extremo de lectura para el siguiente comando
        }
    }
}

// Ejecutar todos los comandos
void execute_commands(t_pipex *pipex)
{
    t_cmd *commands;
    int prev_fd;

    commands = pipex->cmds;
    prev_fd = pipex->input_fd;

    while (commands)
    {
        create_pipe_and_fork(pipex, commands, &prev_fd);
        commands = commands->next;
    }

    // Esperar a que todos los procesos hijos terminen
    while (wait(NULL) > 0);
}

// Inicializar la estructura pipex
void	initialize_pipex(t_pipex *pipex, int argc, char **argv, char **env)
{
	pipex->env = env;
	pipex->cmds = NULL;

	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
	{
		pipex->input_file = NULL;
		pipex->output_file = argv[argc - 1];
		handle_here_doc(pipex, argv[2]);
		parse_commands(pipex, argc - 1, argv + 1);
	}
	else
	{
		pipex->input_file = argv[1];
		pipex->output_file = argv[argc - 1];
		parse_commands(pipex, argc, argv);
	}
}

// Parsear los comandos
void	parse_commands(t_pipex *pipex, int argc, char **argv)
{
	int	i;

	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
		i = 3; // Saltar el nombre del programa, "here_doc" y el limiter
	else
		i = 2; // Saltar el nombre del programa y el archivo de entrada

	while (i < argc - 1)
	{
		add_cmd(&pipex->cmds, create_cmd(argv[i]));
		i++;
	}
}

// Función principal
int	main(int argc, char **argv, char **env)
{
	t_pipex	pipex;

	if (argc < 5)
	{
		ft_error(1, "./pipex infile cmd1 cmd2 ... outfile\n");
		return (EXIT_FAILURE);
	}
	if (ft_strncmp(argv[1], "here_doc", 8) == 0 && argc < 6)
	{
		ft_error(1, "./pipex here_doc LIMITER cmd1 cmd2 ... outfile\n");
		return (EXIT_FAILURE);
	}

	initialize_pipex(&pipex, argc, argv, env);
	execute_commands(&pipex);
	cleanup(&pipex);

	// Eliminar el archivo temporal
	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
		unlink(TEMP_FILE);

	return (EXIT_SUCCESS);
}