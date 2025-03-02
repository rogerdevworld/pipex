/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex_utils.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/28 23:30:31 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/28 23:47:01 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/pipex.h"

// Función para abrir archivos
int	open_file(char *file, int in_or_out)
{
	int	fd;

	if (in_or_out == 0)
		fd = open(file, O_RDONLY);
	else
		fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (fd == -1)
	{
		perror(file);
		exit(EXIT_FAILURE);
	}
	return (fd);
}

// Inicializar la estructura pipex
void	initialize_pipex(t_pipex *pipex, int argc, char **argv, char **env)
{
	pipex->env = env;
	pipex->cmds = NULL;
	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
	{
		pipex->input_file = NULL;
		pipex->output_file = argv[argc - 1];
		handle_here_doc(pipex, argv[2]);
		parse_commands(pipex, argc - 1, argv + 1);
	}
	else
	{
		pipex->input_file = argv[1];
		pipex->output_file = argv[argc - 1];
		parse_commands(pipex, argc, argv);
	}
}

// Función para liberar un array de strings
void	ft_free_tab(char **tab)
{
	size_t	i;

	i = 0;
	while (tab[i])
	{
		free(tab[i]);
		i++;
	}
	free(tab);
}

// Función para liberar recursos
void	cleanup(t_pipex *pipex)
{
	free_cmds(pipex->cmds);
	if (pipex->input_fd != -1)
		close(pipex->input_fd);
}
