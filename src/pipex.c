#include "../include/pipex.h"

// Función para abrir archivos
int	open_file(char *file, int in_or_out)
{
	int	fd;

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

// Función para obtener el valor de una variable de entorno
char	*my_getenv(char *name, char **env)
{
	int	i;

	i = 0;
	while (env[i])
	{
		if (ft_strncmp(env[i], name, ft_strlen(name)) == 0
			&& env[i][ft_strlen(name)] == '=')
			return (env[i] + ft_strlen(name) + 1);
		i++;
	}
	return (NULL);
}

// Función para ejecutar un comando
void	exec_cmd(char *cmd, t_pipex *pipex)
{
	char	**args;
	char	*path;

	args = ft_split(cmd, ' ');
	path = get_path(args[0], pipex->env);
	if (execve(path, args, pipex->env) == -1)
	{
		perror("Command execution failed");
		ft_free_tab(args);
		free(path);
		exit(EXIT_FAILURE);
	}
}

// Resolver el path del comando
char	*get_path(char *cmd, char **env)
{
	char	*path_env;
	char	**paths;
	char	*path;
	int i = 0;

	path_env = my_getenv("PATH", env);
	if (!path_env)
		return (NULL);
	paths = ft_split(path_env, ':');
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

void	create_pipe_and_fork(t_pipex *pipex, t_cmd *commands, int *prev_fd)
{
	pid_t	pid;
	int		pipe_fd[2];

	if (commands->next)
	{
		if (pipe(pipe_fd) == -1)
			ft_error(1, "Pipe error");
	}
	else
		pipe_fd[1] = open_file(pipex->output_file, 1);
	pid = fork();
	if (pid == -1)
		ft_error(1, "Fork error");
	if (pid == 0)
	{
		dup2(*prev_fd, STDIN_FILENO);
		dup2(pipe_fd[1], STDOUT_FILENO);
		close(pipe_fd[0]);
		exec_cmd(commands->cmd, pipex);
	}
	close(*prev_fd);
	if (commands->next)
		close(pipe_fd[1]);
	*prev_fd = pipe_fd[0];
}

void	execute_commands(t_pipex *pipex)
{
	t_cmd	*commands;
	int		prev_fd;

	commands = pipex->cmds;
	prev_fd = open_file(pipex->input_file, 0);
	while (commands)
	{
		create_pipe_and_fork(pipex, commands, &prev_fd);
		commands = commands->next;
	}
	while (wait(NULL) > 0);
}

// Funciones auxiliares
void	ft_free_tab(char **tab)
{
	size_t	i;

	i = 0;
	while (tab[i])
		free(tab[i++]);
	free(tab);
}

// Manejo de errores
void	ft_error(int type_of_error, char *error_message)
{
	if (type_of_error == 1)
	{
		fprintf(stderr, "Error: %s\n", error_message);
		exit(EXIT_FAILURE);
	}
}


// Función principal
int	main(int argc, char **argv, char **env)
{
	int i = 2;
	if (argc < 5)
	{
		ft_error(1, "./pipex infile cmd1 cmd2 ... outfile\n");
		return (EXIT_FAILURE);
	}

	t_pipex pipex;
	pipex.env = env;
	pipex.input_file = argv[1];
	pipex.output_file = argv[argc - 1];
	pipex.cmds = NULL;

	while (i < argc - 1)
	{
		add_cmd(&pipex.cmds, create_cmd(argv[i]));
		i++;
	}
	execute_commands(&pipex);
	free_cmds(pipex.cmds);

	return (EXIT_SUCCESS);
}

