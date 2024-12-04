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
# include<sys/types.h>
# include<sys/stat.h>
# include <fcntl.h>
# include "../src/libft/libft.h"
# include "../src/get_next_line/get_next_line.h"

# ifndef SIZE_MAX
#  define SIZE_MAX 4294967295
# endif

/* functions */
void	exit_handler(int n_exit);
int		open_file(char *file, int n);
char	*my_getenv(char *name, char **env);
char	*get_path(char *cmd, char **env);
void	exec(char *cmd, char **env);
void	ft_free_tab(char **tab);
void	here_doc_put_in(char **av, int *p_fd);
void	here_doc(char **av);
void	do_pipe(char *cmd, char **env);

/* Mandatory ft_printf */
int ft_validation(char c);
int		ft_printf(const char *str, ...);
void	is_flag(char c, va_list args, int *length, int *flag);
void	ft_unsigned_putnbr(unsigned int unsigned_nbr, int *length, int *flag);
void	ft_putchar(const char c, int *length, int *flag);
void	ft_putstr(char *args, int *length, int *flag);
void	ft_putnbr(int nbr, int *length, int *flag);
void	ft_pointer(size_t pointer, int *length, int *flag);
void	ft_hex(unsigned int nbr, int *length, char x, int *flag);
int	ft_strcmp(char *s1, char *s2);
/* functions of get_next_line_utils.c */
void	get_copy(t_list *list, char *line);
void	get_free_list(t_list **list, t_list *replace, char *buffer);
int		get_len(t_list *list);
t_list	*get_last_node(t_list *list);
int		find_new_line(t_list *list);
void	get_clear_remaining_data(t_list **list);
void	create_and_append(t_list **list, int fd);
char	*get_next_line(int fd);
#endif
