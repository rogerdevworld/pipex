/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelona.    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/02/26 15:44:56 by rmarrero          #+#    #+#             */
/*   Updated: 2025/02/26 16:26:15 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef PIPEX_H
# define PIPEX_H

# include "../libft/libft.h"
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <stdio.h>

typedef struct s_cmd
{
    char    **args;     // Argumentos del comando (incluyendo el comando mismo)
    char    *path;      // Path del ejecutable
} t_cmd;

// Prototipos de funciones
void    ft_exit_handler(int status, char *msg);
int     ft_open_file(char *file, int mode);
void    ft_check_infile(char *infile);
void    ft_init_cmd(t_cmd *cmd, char *cmd_str, char **env);
void    ft_free_cmd(t_cmd *cmd);
void    ft_exec_cmd(t_cmd *cmd, char **env);
void    ft_do_pipe(t_cmd *cmd, char **env);
void    ft_here_doc(char *delimiter);
void    ft_parse_args(int ac, char **av, char **env);
char    *get_path(char *cmd, char **env);
void    ft_free_tab(char **tab);
char    *ft_getenv(char *name, char **env);
#endif