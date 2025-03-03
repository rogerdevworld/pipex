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
#include "../include/pipex.h"

// Función para manejar errores y salir del programa
void	ft_exit_handler(int status, char *msg)
{
	ft_putstr_fd("pipex: ", STDERR_FILENO);
	ft_putendl_fd(msg, STDERR_FILENO);
	exit(status);
}

// Función para verificar si el archivo de entrada existe
void	ft_check_infile(char *infile)
{
	if (access(infile, F_OK) == -1)
		ft_exit_handler(1, "Infile does not exist");
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
