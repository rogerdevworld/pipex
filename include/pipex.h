/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   pipex.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/11/26 13:12:27 by rmarrero          #+#    #+#             */
/*   Updated: 2024/11/26 16:32:59 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#ifndef	PIPEX_H
# define PIPEX_H

# include <unistd.h>
# include <stdlib.h>
# include <stdio.h>
# include <fcntl.h>
# include <stdio.h>
# include <sys/wait.h>
# include <string.h>
#include "../libft/libft.h"

// Estructura para una lista de comandos
typedef struct s_cmd
{
    char            *cmd;          // Comando completo
    struct s_cmd    *next;         // Siguiente comando
} t_cmd;

// Estructura principal del programa
typedef struct s_pipex
{
    char    **env;                 // Variables de entorno
    char    *input_file;           // Archivo de entrada
    char    *output_file;          // Archivo de salida
    t_cmd   *cmds;                 // Lista de comandos
} t_pipex;

// Funciones de manejo de archivos
int     open_file(char *file, int in_or_out);

// Manejo de listas
t_cmd   *create_cmd(char *cmd);
void    add_cmd(t_cmd **cmd_list, t_cmd *new_cmd);
void    free_cmds(t_cmd *cmd_list);

// Funciones auxiliares
void    ft_free_tab(char **tab);
char    *my_getenv(char *name, char **env);
char    *get_path(char *cmd, char **env);

// Ejecución de comandos
void    exec_cmd(char *cmd, t_pipex *pipex);

// Funciones para manejo de procesos y pipes
void    parent_process(t_pipex *pipex, int *pipe_fd, char *cmd, int output_fd);
void    execute_commands(t_pipex *pipex);

// Manejo de errores
void    ft_error(int type_of_error, char *error_message);

#endif
