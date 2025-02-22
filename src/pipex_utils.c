/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex_utils.c                                      :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/22 23:02:17 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/22 23:02:19 by rmarrero         ###   ########.fr       */
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

// Manejo de listas de comandos
t_cmd	*create_cmd(char *cmd)
{
	t_cmd	*new_cmd;

	new_cmd = malloc(sizeof(t_cmd));
	if (!new_cmd)
		return (NULL);
	new_cmd->cmd = ft_strdup(cmd);
	new_cmd->next = NULL;
	return (new_cmd);
}

// Función para obtener el valor de una variable de entorno
char	*my_getenv(char *name, char **env)
{
	int	i;

	i = 0;
	while (env[i])
	{
		if (ft_strncmp(env[i], name, ft_strlen(name)) == 0
			&& env[i][ft_strlen(name)] == '=')
			return (env[i] + ft_strlen(name) + 1);
		i++;
	}
	return (NULL);
}

void	add_cmd(t_cmd **cmd_list, t_cmd *new_cmd)
{
	t_cmd	*temp;

	if (!*cmd_list)
		*cmd_list = new_cmd;
	else
	{
		temp = *cmd_list;
		while (temp->next)
			temp = temp->next;
		temp->next = new_cmd;
	}
}

void	free_cmds(t_cmd *cmd_list)
{
	t_cmd	*temp;

	while (cmd_list)
	{
		temp = cmd_list;
		cmd_list = cmd_list->next;
		free(temp->cmd);
		free(temp);
	}
}

// Función para ejecutar un comando
void	exec_cmd(char *cmd, t_pipex *pipex)
{
	char	**args;
	char	*path;

	args = ft_split(cmd, ' ');
	path = get_path(args[0], pipex->env);
	if (execve(path, args, pipex->env) == -1)
	{
		perror("Command execution failed");
		ft_free_tab(args);
		free(path);
		exit(EXIT_FAILURE);
	}
}
