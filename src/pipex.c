/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/26 15:52:14 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/26 16:30:51 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "../include/pipex.h"

// Función principal
int	main(int argc, char **argv, char **env)
{
	t_pipex	pipex;

	if (validate_arguments(argc, argv) == EXIT_FAILURE)
		return (EXIT_FAILURE);
	initialize_pipex(&pipex, argc, argv, env);
	execute_commands(&pipex);
	cleanup(&pipex);
	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
		unlink(TEMP_FILE);
	return (EXIT_SUCCESS);
}
