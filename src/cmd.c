/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   cmd.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/28 23:30:54 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/28 23:30:55 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "../include/pipex.h"

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
