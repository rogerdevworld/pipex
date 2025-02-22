/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/22 23:02:09 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/22 23:02:10 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/pipex.h"

// Resolver el path del comando
char	*get_path(char *cmd, char **env)
{
	char	*path_env;
	char	**paths;
	char	*path;

	path_env = my_getenv("PATH", env);
	if (!path_env)
		return (NULL);
	paths = ft_split(path_env, ':');
	for (int i = 0; paths[i]; i++)
	{
		path = ft_strjoin(ft_strjoin(paths[i], "/"), cmd);
		if (access(path, F_OK | X_OK) == 0)
		{
			ft_free_tab(paths);
			return (path);
		}
		free(path);
	}
	ft_free_tab(paths);
	return (NULL);
}

void	execute_commands(t_pipex *pipex)
{
	t_cmd	*current;
	pid_t	pid;
	int		pipe_fd[2];
	int		prev_fd;

	current = pipex->cmds;
	prev_fd = open_file(pipex->input_file, 0);
	while (current)
	{
		if (current->next)
		{
			if (pipe(pipe_fd) == -1)
				ft_error(1, "Pipe error");
		}
		else
			pipe_fd[1] = open_file(pipex->output_file, 1);
		pid = fork();
		if (pid == -1)
			ft_error(1, "Fork error");
		if (pid == 0) // Proceso hijo
		{
			dup2(prev_fd, STDIN_FILENO);
			dup2(pipe_fd[1], STDOUT_FILENO);
			close(pipe_fd[0]);
			exec_cmd(current->cmd, pipex);
		}
		close(prev_fd);
		if (current->next)
			close(pipe_fd[1]);
		prev_fd = pipe_fd[0];
		current = current->next;
	}
	while (wait(NULL) > 0)
		;
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
	int		i;
	t_pipex	pipex;

	i = 2;
	if (argc < 5)
	{
		ft_error(1, "./pipex infile cmd1 cmd2 ... outfile\n");
		return (EXIT_FAILURE);
	}
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
