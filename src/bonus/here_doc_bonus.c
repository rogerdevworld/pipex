/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parse.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/26 15:52:14 by rmarrero          #+#    #+#             */
/*   Updated: 2025/03/03 11:52:19 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "../include/pipex_bonus.h"

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

// -- main function to handle here_doc -- //
void	ft_here_doc(char *delimiter)
{
	int		p_fd[2];
	pid_t	pid;

	if (pipe(p_fd) == -1)
		ft_exit(1, "Pipe creation failed");
	pid = fork();
	if (pid == -1)
		ft_exit(1, "Fork failed");
	if (pid == 0)
		ft_here_doc_child(delimiter, p_fd);
	else
	{
		close(p_fd[1]);
		dup2(p_fd[0], STDIN_FILENO);
		waitpid(pid, NULL, 0);
	}
}
