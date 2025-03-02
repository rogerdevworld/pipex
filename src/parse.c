/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   parse.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/28 23:30:48 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/28 23:30:50 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/pipex.h"

// Función para manejar errores
void	ft_error(char *error_message)
{
	ft_putstr_fd("Error: ", 2);
	ft_putstr_fd(error_message, 2);
	ft_putstr_fd("\n", 2);
	exit(EXIT_FAILURE);
}

// Parsear los comandos
void	parse_commands(t_pipex *pipex, int argc, char **argv)
{
	int	i;

	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
		i = 3;
	else
		i = 2;
	while (i < argc - 1)
	{
		add_cmd(&pipex->cmds, create_cmd(argv[i]));
		i++;
	}
}

int	validate_arguments(int argc, char **argv)
{
	if (argc < 5)
	{
		ft_error("./pipex infile cmd1 cmd2 ... outfile\n");
		return (EXIT_FAILURE);
	}
	if (ft_strncmp(argv[1], "here_doc", 8) == 0 && argc < 6)
	{
		ft_error("./pipex here_doc LIMITER cmd1 cmd2 ... outfile\n");
		return (EXIT_FAILURE);
	}
	return (EXIT_SUCCESS);
}
