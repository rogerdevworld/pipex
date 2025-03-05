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

#ifndef PIPEX_BONUS_H
# define PIPEX_BONUS_H

# include "../libft/libft.h"
# include <fcntl.h>
# include <stdio.h>
# include <stdlib.h>
# include <sys/wait.h>
# include <unistd.h>

// -- strct cmd path and commads -- //
typedef struct s_cmd
{
	char	**args;
	char	*path;
}			t_cmd;

// -- pipe and fork algorithms -- //
// -- 1. parse args and filter cases of here_doc -- //
void		ft_parse_args(int argc, char **argv, char **env);

// -- A case here_doc -- //
// -- 1.1 here_doc no initial values of the infile -- // //
void		ft_here_doc(char *delimiter);

// -- 1.2 sinedo the here_doc no initial values of the infile -- // //
void		ft_here_doc_child(char *delimiter, int *p_fd);

// -- B case with infile -- //
// -- the function gives the initial values to the fd_in & fd_out -- //
// -- and uses dup2(fd[infile], STDIN_FILENO); and does a check of infile -- //
void		ft_in_out(int argc, char **argv, int *fd_in, int *fd_out);

// -- 1.1 calls the functions of init_cmd, pipe's & free_cmd -- // //
void		ft_execute_commands(int argc, char **argv, char **env, int i);

// -- 1.1.1 init_cmd we save the command paths and the compound commands --///
void		ft_init_cmd(t_cmd *cmd, char *cmd_str, char **env);

// -- 1.1.1.1.1 loading commands in args and the path with get_path(); -- // //
char		*get_path(char *cmd, char **env);

// -- 1.1.1.1.1.1 getting the path -- //
// -- /home/rmarrero/bin:/usr/local/sbin: -- //
char		*ft_getenv(char *name, char **env);

// -- 1.1.2 main process of fork's & pipe's -- // //
void		ft_pipe_and_fork(t_cmd *cmd, char **env);

// -- 1.1.2.1 we apply in execve and if it goes well we replace the process --
	//
void		ft_exec_cmd(t_cmd *cmd, char **env);

// -- 1.1.3  free struct -- //
void		ft_free_cmd(t_cmd *cmd);

// --- free path -- //
void		ft_free_tab(char **tab);

// --- utils -- //
void		ft_exit(int status, char *msg);

// -- open infile o outfile -- //
int			ft_open(char *file, int mode);

// -- check infile -- //
void		ft_check_infile(char *infile);

// -- initialization of strct cmd -- // //
void		ft_init_cmd(t_cmd *cmd, char *cmd_str, char **env);

// -- get path /usr/bin/ls, /usr/bin/cat or /usr/bin/wc -- //
char		*get_path(char *cmd, char **env);

#endif