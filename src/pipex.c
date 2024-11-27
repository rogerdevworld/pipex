/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.c                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/11/26 12:55:33 by rmarrero          #+#    #+#             */
/*   Updated: 2024/11/26 15:35:47 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "../include/pipex.h"

char	*ft_find_command(char *path, char *command)
{
	char	**paths;
	char	*full_path;
	int		i;

	if (!path || !command)
		return (NULL);
	// Dividir PATH en un array de directorios
	paths = ft_split(path, ':');
	if (!paths)
		return (NULL);
	i = 0;
	while (paths[i])
	{
		// Construir la ruta completa: paths[i] + "/" + command
		full_path = ft_strjoin(paths[i], "/");
		full_path = ft_strjoin(full_path, command);
		if (!full_path)
			break;
		// Verificar si el comando es ejecutable
		if (access(full_path, X_OK) == 0)
		{
			// Liberar memoria de paths y devolver full_path
			while (paths[i])
				free(paths[i++]);
			free(paths);
			return (full_path);
		}
		free(full_path);
		i++;
	}
	// Liberar memoria si no se encontró el comando
	while (paths[i])
		free(paths[i++]);
	free(paths);
	return (NULL);
}


int	main(int argc, char **argv, char **envp)
{
	if (!ft_error(argc, argv, envp))
	{
		fprintf(stderr, "Error: Validación fallida.\n");
		return (EXIT_FAILURE);
	}
	// Continúa con la lógica de pipex si todo está correcto
	printf("Todas las validaciones pasaron. Continuando...\n");
	return (EXIT_SUCCESS);
}

