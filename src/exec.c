/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   exec.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/28 23:30:22 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/28 23:30:25 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/pipex.h"

// Ejecutar todos los comandos
void	execute_commands(t_pipex *pipex)
{
	t_cmd	*commands;
	int		prev_fd;

	commands = pipex->cmds;
	prev_fd = pipex->input_fd;
	while (commands)
	{
		create_pipe_and_fork(pipex, commands, &prev_fd);
		commands = commands->next;
	}
	while (wait(NULL) > 0)
		;
}

void	handle_here_doc(t_pipex *pipex, char *limiter)
{
	char	*line;
	int		temp_fd;
	size_t	limiter_len;

	temp_fd = open(TEMP_FILE, O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (temp_fd == -1)
		ft_error("Error creating temporary file");
	limiter_len = ft_strlen(limiter);
	while (1)
	{
		write(1, "pipex> ", 7);
		line = get_next_line(STDIN_FILENO);
		if (!line || (ft_strncmp(line, limiter, limiter_len) == 0
				&& line[limiter_len] == '\n'))
		{
			free(line);
			break ;
		}
		write(temp_fd, line, ft_strlen(line));
		free(line);
	}
	close(temp_fd);
	pipex->input_fd = open(TEMP_FILE, O_RDONLY);
	if (pipex->input_fd == -1)
		ft_error("Error opening temporary file");
}

// Función para ejecutar un comando
void	exec_cmd(char *cmd, t_pipex *pipex)
{
	char	**args;
	char	*path;

	args = ft_split(cmd, ' ');
	if (!args)
		ft_error("Failed to split command");
	path = get_path(args[0], pipex->env);
	if (!path)
	{
		ft_free_tab(args);
		ft_error("Command not found");
	}
	if (execve(path, args, pipex->env) == -1)
	{
		perror("Command execution failed");
		ft_free_tab(args);
		free(path);
		exit(EXIT_FAILURE);
	}
}
