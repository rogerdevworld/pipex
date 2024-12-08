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

/* libs  */
# include <stdio.h>
# include <unistd.h>
# include <errno.h>
# include <stdlib.h>
# include <stdarg.h>
# include <stdint.h>
# include <stddef.h>
# include <string.h>
# include <limits.h>
# include <sys/types.h>
# include <sys/wait.h>
# include <sys/types.h>
# include <sys/stat.h>
# include <fcntl.h>

/* my funtions of the libs */
# include "../libft/libft.h"

# ifndef SIZE_MAX
#  define SIZE_MAX 4294967295
# endif

/* functions */
void	exit_handler(int n_exit);
int		open_file(char *file, int n);
char	*ft_path(char *name, char **env);
char	*get_path(char *cmd, char **env);
void	exec(char *cmd, char **env);
void	ft_free_tab(char **tab);
void	here_doc_put_in(char **av, int *p_fd);
void	here_doc(char **av);
void	do_pipe(char *cmd, char **env);
int	ft_strcmp(char *s1, char *s2);
void	ft_error(int type_of_error, char *error_messege);

#endif
