/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   get_next_line_bonus.h                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <rmarrero@student.42barcelon      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/27 23:05:39 by rmarrero          #+#    #+#             */
/*   Updated: 2024/10/08 18:28:12 by root             ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#ifndef GET_NEXT_LINE_BONUS_H
# define GET_NEXT_LINE_BONUS_H

# include <fcntl.h>
# include <stdio.h>
# include <unistd.h>
# include <stdlib.h>
# include <limits.h>
#include "../libft/libft.h"

/* define of flags -D BUFFER_SIZE X */
# ifndef BUFFER_SIZE
#  define BUFFER_SIZE 42
# endif

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