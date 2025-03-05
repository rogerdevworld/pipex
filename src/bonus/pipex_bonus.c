/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/26 15:52:14 by rmarrero          #+#    #+#             */
/*   Updated: 2025/03/03 11:52:19 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "../include/pipex_bonus.h"

// -- main -- //
int	main(int argc, char **argv, char **env)
{
	if (argc < 5)
		ft_exit(1, "Usage: ./pipex infile cmd1 cmd2 outfile");
	ft_parse_args(argc, argv, env);
	return (0);
}

// -- function to execute a command -- //
void	ft_exec_cmd(t_cmd *cmd, char **env)
{
	if (execve(cmd->path, cmd->args, env) == -1)
		ft_exit(1, "Command execution failed");
}

// -- function for creating a pipe and executing -- //
// -- a command in the child process -- //
void	ft_pipe_and_fork(t_cmd *cmd, char **env)
{
	int		p_fd[2];
	pid_t	pid;

	if (pipe(p_fd) == -1)
		ft_exit(1, "pipe failed");
	pid = fork();
	if (pid == -1)
		ft_exit(1, "fork failed");
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

// -- function for handling input and output files -- //
void	ft_in_out(int argc, char **argv, int *fd_in, int *fd_out)
{
	ft_check_infile(argv[1]);
	*fd_in = ft_open(argv[1], 0);
	*fd_out = ft_open(argv[argc - 1], 1);
	dup2(*fd_in, STDIN_FILENO);
}

// -- function to execute commands -- //
void	ft_execute_commands(int argc, char **argv, char **env, int i)
{
	t_cmd	cmd;

	while (i < argc - 2)
	{
		ft_init_cmd(&cmd, argv[i], env);
		ft_pipe_and_fork(&cmd, env);
		ft_free_cmd(&cmd);
		i++;
	}
}
