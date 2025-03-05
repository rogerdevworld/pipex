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

// -- main function to parse arguments -- //
void	ft_parse_args(int argc, char **argv, char **env)
{
	int		i;
	t_cmd	cmd;
	int		fd_in;
	int		fd_out;

	i = 2;
	if (ft_strcmp(argv[1], "here_doc") == 0)
	{
		if (argc < 6)
			ft_exit(1, "Usage: ./pipex here_doc LIMITER cmd1 cmd2 outfile");
		fd_out = ft_open(argv[argc - 1], 1);
		ft_here_doc(argv[2]);
		i = 3;
	}
	else
	{
		ft_in_out(argc, argv, &fd_in, &fd_out);
	}
	ft_execute_commands(argc, argv, env, i);
	ft_init_cmd(&cmd, argv[argc - 2], env);
	dup2(fd_out, STDOUT_FILENO);
	ft_exec_cmd(&cmd, env);
	ft_free_cmd(&cmd);
}
