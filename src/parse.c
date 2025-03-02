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
void	ft_error(int type_of_error, char *error_message)
{
	if (type_of_error == 1)
	{
		fprintf(stderr, "Error: %s\n", error_message);
		exit(EXIT_FAILURE);
	}
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
