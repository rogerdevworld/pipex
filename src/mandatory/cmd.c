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

// -- function to initialize the t_cmd structure -- //
void	ft_init_cmd(t_cmd *cmd, char *cmd_str, char **env)
{
	cmd->args = ft_split(cmd_str, ' ');
	if (!cmd->args)
		ft_exit(1, "Failed to split command");
	cmd->path = get_path(cmd->args[0], env);
	if (!cmd->path)
		ft_exit(1, "Command not found");
}

// -- function to free the memory of the structure t_cmd -- //
void	ft_free_cmd(t_cmd *cmd)
{
	if (cmd->args)
		ft_free_tab(cmd->args);
	if (cmd->path)
		free(cmd->path);
}
