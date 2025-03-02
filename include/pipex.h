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
# include <fcntl.h>
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
# include <sys/wait.h>
# include <unistd.h>

# define TEMP_FILE ".here_doc"

typedef struct s_cmd
{
	char			*cmd;
	struct s_cmd	*next;
}					t_cmd;

typedef struct s_pipex
{
	char			*input_file;
	char			*output_file;
	char			**env;
	t_cmd			*cmds;
	int				input_fd;
}					t_pipex;

// Funciones principales
void				initialize_pipex(t_pipex *pipex, int argc, char **argv,
						char **env);
void				execute_commands(t_pipex *pipex);
void				cleanup(t_pipex *pipex);

// Manejo de comandos
t_cmd				*create_cmd(char *cmd);
void				add_cmd(t_cmd **cmd_list, t_cmd *new_cmd);
void				free_cmds(t_cmd *cmd_list);

// Manejo de archivos
int					open_file(char *file, int in_or_out);
void				handle_here_doc(t_pipex *pipex, char *limiter);

// Ejecución de comandos
void				exec_cmd(char *cmd, t_pipex *pipex);
char				*get_path(char *cmd, char **env);

// Utilidades
void	ft_error(char *error_message);
void				ft_free_tab(char **tab);
char				**ft_split(char const *s, char c);
char				*ft_strdup(const char *s1);
char				*ft_strjoin(char const *s1, char const *s2);
int					ft_strncmp(const char *s1, const char *s2, size_t n);
size_t				ft_strlen(const char *s);
char				*my_getenv(char *name, char **env);
// En pipex.h
void				parse_commands(t_pipex *pipex, int argc, char **argv);

void	create_pipe_and_fork(t_pipex *pipex, t_cmd *commands, int *prev_fd);
void	validate_infile(char *infile);
int	validate_arguments(int argc, char **argv);
#endif