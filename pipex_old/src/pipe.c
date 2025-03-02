/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipe.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/28 23:30:36 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/28 23:56:06 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/pipex.h"

void	redirect_io_and_execute(t_pipex *pipex, t_cmd *commands, int *prev_fd, int *pipe_fd)
{
	int out_fd;

	if (*prev_fd != STDIN_FILENO)
	{
		dup2(*prev_fd, STDIN_FILENO);
		close(*prev_fd);
	}
	if (commands->next)
	{
		dup2(pipe_fd[1], STDOUT_FILENO);
		close(pipe_fd[0]);
		close(pipe_fd[1]);
	}
	else
	{
		out_fd = ft_open(pipex->output_file, 1);
		dup2(out_fd, STDOUT_FILENO);
		close(out_fd);
	}
	exec_cmd(commands->cmd, pipex);
}

static void	handle_parent_process(int *prev_fd, int *pipe_fd, t_cmd *commands)
{
	if (*prev_fd != STDIN_FILENO)
		close(*prev_fd);
	if (commands->next)
	{
		close(pipe_fd[1]);
		*prev_fd = pipe_fd[0];
	}
}

void	create_pipe_and_fork(t_pipex *pipex, t_cmd *commands, int *prev_fd)
{
	int		pipe_fd[2];
	pid_t	pid;

	if (commands->next && pipe(pipe_fd) == -1)
		ft_error("Pipe error");
	pid = fork();
	if (pid == -1)
		ft_error("Fork error");
	if (pid == 0)
		redirect_io_and_execute(pipex, commands, prev_fd, pipe_fd);
	else
		handle_parent_process(prev_fd, pipe_fd, commands);
}
