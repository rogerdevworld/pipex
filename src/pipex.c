/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/26 15:52:14 by rmarrero          #+#    #+#             */
/*   Updated: 2025/03/03 02:32:39 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "../include/pipex.h"

// Función principal
int	main(int ac, char **av, char **env)
{
	if (ac < 5)
		ft_exit_handler(1, "Usage: ./pipex infile cmd1 cmd2 outfile");
	ft_parse_args(ac, av, env);
	return (0);
}
// unlink(argv[agrc - 1]);

// Función para manejar errores y salir del programa
void	ft_exit_handler(int status, char *msg)
{
	ft_putstr_fd("pipex: ", STDERR_FILENO);
	ft_putendl_fd(msg, STDERR_FILENO);
	exit(status);
}

// Función para abrir un archivo según el modo (lectura, escritura, append)
int	ft_open_file(char *file, int mode)
{
	int	fd;

	if (mode == 0)
		fd = open(file, O_RDONLY);
	else if (mode == 1)
		fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0777);
	else if (mode == 2)
		fd = open(file, O_WRONLY | O_CREAT | O_APPEND, 0644);
	if (fd == -1)
		ft_exit_handler(1, "Failed to open file");
	return (fd);
}

// Función para verificar si el archivo de entrada existe
void	ft_check_infile(char *infile)
{
	if (access(infile, F_OK) == -1)
		ft_exit_handler(1, "Infile does not exist");
}

// Función para inicializar la estructura t_cmd
void	ft_init_cmd(t_cmd *cmd, char *cmd_str, char **env)
{
	cmd->args = ft_split(cmd_str, ' ');
	if (!cmd->args)
		ft_exit_handler(1, "Failed to split command");
	cmd->path = get_path(cmd->args[0], env);
	if (!cmd->path)
		ft_exit_handler(1, "Command not found");
}

// Función para liberar la memoria de la estructura t_cmd
void	ft_free_cmd(t_cmd *cmd)
{
	if (cmd->args)
		ft_free_tab(cmd->args);
	if (cmd->path)
		free(cmd->path);
}

// Función para ejecutar un comando
void	ft_exec_cmd(t_cmd *cmd, char **env)
{
	if (execve(cmd->path, cmd->args, env) == -1)
		ft_exit_handler(1, "Command execution failed");
}

// Función para crear un pipe y ejecutar un comando en el proceso hijo
void	ft_do_pipe(t_cmd *cmd, char **env)
{
	int		p_fd[2];
	pid_t	pid;

	if (pipe(p_fd) == -1)
		ft_exit_handler(1, "Pipe creation failed");
	pid = fork();
	if (pid == -1)
		ft_exit_handler(1, "Fork failed");
	if (pid == 0)
	{
		close(p_fd[0]);
		dup2(p_fd[1], STDOUT_FILENO);
		ft_exec_cmd(cmd, env);
	}
	else
	{
		close(p_fd[1]);
		dup2(p_fd[0], STDIN_FILENO);
		waitpid(pid, NULL, 0);
	}
}

// Función para manejar el here_doc
// Función para manejar el proceso hijo que escribe en el pipe
void	ft_here_doc_child(char *delimiter, int *p_fd)
{
	char	*line;

	close(p_fd[0]);
	while (1)
	{
		write(1, "pipex> ", 7);
		line = get_next_line(STDIN_FILENO);
		if (ft_strncmp(line, delimiter, ft_strlen(delimiter)) == 0)
		{
			free(line);
			break ;
		}
		write(p_fd[1], line, ft_strlen(line));
		free(line);
	}
	close(p_fd[1]);
	exit(0);
}

// Función principal para manejar el here_doc
void	ft_here_doc(char *delimiter)
{
	int		p_fd[2];
	pid_t	pid;

	if (pipe(p_fd) == -1)
		ft_exit_handler(1, "Pipe creation failed");
	pid = fork();
	if (pid == -1)
		ft_exit_handler(1, "Fork failed");
	if (pid == 0)
		ft_here_doc_child(delimiter, p_fd);
	else
	{
		close(p_fd[1]);
		dup2(p_fd[0], STDIN_FILENO);
		waitpid(pid, NULL, 0);
	}
}

// Función para manejar el caso del here_doc y apertura de archivo
void	ft_handle_here_doc(int ac, char **av, int *fd_out)
{
	if (ac < 6)
		ft_exit_handler(1, "Usage: ./pipex here_doc LIMITER cmd1 cmd2 outfile");
	*fd_out = ft_open_file(av[ac - 1], 2);
	ft_here_doc(av[2]);
}

// Función para manejar los archivos de entrada y salida
void	ft_handle_in_out(int ac, char **av, int *fd_in, int *fd_out)
{
	ft_check_infile(av[1]);
	*fd_in = ft_open_file(av[1], 0);
	*fd_out = ft_open_file(av[ac - 1], 1);
	dup2(*fd_in, STDIN_FILENO);
}

// Función para ejecutar los comandos
void	ft_execute_commands(int ac, char **av, char **env, int i)
{
	t_cmd	cmd;

	while (i < ac - 2)
	{
		ft_init_cmd(&cmd, av[i], env);
		ft_do_pipe(&cmd, env);
		ft_free_cmd(&cmd);
		i++;
	}
}

// Función principal para parsear los argumentos
void	ft_parse_args(int ac, char **av, char **env)
{
	int		i;
	t_cmd	cmd;
	int		fd_in;
	int		fd_out;

	i = 2;
	if (ft_strcmp(av[1], "here_doc") == 0)
	{
		ft_handle_here_doc(ac, av, &fd_out);
		i = 3;
	}
	else
	{
		ft_handle_in_out(ac, av, &fd_in, &fd_out);
	}
	ft_execute_commands(ac, av, env, i);
	ft_init_cmd(&cmd, av[ac - 2], env);
	dup2(fd_out, STDOUT_FILENO);
	ft_exec_cmd(&cmd, env);
	ft_free_cmd(&cmd);
}

char	*get_path(char *cmd, char **env)
{
	int		i;
	char	*exec;
	char	**allpath;
	char	*path_part;
	char	**s_cmd;

	i = -1;
	allpath = ft_split(ft_getenv("PATH", env), ':');
	s_cmd = ft_split(cmd, ' ');
	while (allpath[++i])
	{
		path_part = ft_strjoin(allpath[i], "/");
		exec = ft_strjoin(path_part, s_cmd[0]);
		free(path_part);
		if (access(exec, F_OK | X_OK) == 0)
		{
			ft_free_tab(allpath);
			ft_free_tab(s_cmd);
			return (exec);
		}
		free(exec);
	}
	ft_free_tab(allpath);
	ft_free_tab(s_cmd);
	return (ft_strdup(cmd));
}

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

char	*ft_getenv(char *name, char **env)
{
	int		i;
	int		j;
	char	*sub;

	i = 0;
	while (env[i])
	{
		j = 0;
		while (env[i][j] && env[i][j] != '=')
			j++;
		sub = ft_substr(env[i], 0, j);
		if (ft_strcmp(sub, name) == 0)
		{
			free(sub);
			return (env[i] + j + 1);
		}
		free(sub);
		i++;
	}
	return (NULL);
}
