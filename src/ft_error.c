/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_error.c                                         :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/11/26 13:04:38 by rmarrero          #+#    #+#             */
/*   Updated: 2024/11/26 15:52:39 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "../include/pipex.h"

// ft_error();
int	ft_error(int argc, char **argv, char **envp)
{
	return (!num_of_param(argc) || !ft_first_file(argv) || !comand_no_found(argv, envp));
}
//validador de argumentos
int	num_of_param(int argc)
{
	if (argc < 5 || (argc % 2) == 0)
    	return (ft_print_error(),0);
	return (1);
}

//verificacion de archivo
int	ft_first_file(char **argv)
{
	if (access(argv[1], R_OK) == -1)
		ft_print_error();
}

char *ft_getenv(char *name, char **envp)
{
    int i = 0;
    
    while (envp[i])
    {
        // Compara el principio de cada string con el nombre que buscamos
        if (ft_strncmp(envp[i], name, ft_strlen(name)) == 0 && envp[i][ft_strlen(name)] == '=')
        {
            // Devuelve el valor de la variable de entorno (después del '=')
            return &envp[i][ft_strlen(name) + 1];
        }
        i++;
    }
    // Si no se encuentra, devuelve NULL
    return (NULL);
}

int	comand_no_found(char **argv, char **envp)
{
	char	*path;
	char	*cmd;
	int		i;

	i = 2; // Comandos empiezan en argv[2]
	while (argv[i + 1]) // Excluye archivo de salida
	{
		path = ft_getenv("PATH", envp); // Busca la variable PATH en envp
		cmd = ft_find_command(path, argv[i]); // Construye el path completo del comando
		if (!cmd || access(cmd, X_OK) == -1)
		{
			free(cmd); // Libera memoria si fue asignada
			return (ft_print_error(), 0);
		}
		free(cmd); // Libera memoria tras validar el comando
		i++;
	}
	return (1);
}

void	ft_print_error()
{
	perror("Error");
}