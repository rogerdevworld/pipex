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

int     main(int argc, char **argv, char  **envp)
{
        //if (!ft_pars_error(argc, argv, env))
        //        return (NULL);
	while (*envp)
	{
		printf("%s\n", *envp);
		envp++;
	}
}

