/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   libft.h                                            :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/12 18:01:25 by rmarrero          #+#    #+#             */
/*   Updated: 2024/11/23 13:34:26 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#ifndef LIBFT_H
# define LIBFT_H
# include <stddef.h>
# include <unistd.h>
# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <limits.h>
# include <fcntl.h>
# include <stdarg.h>
# include <stdint.h>

# ifndef SIZE_MAX
#  define SIZE_MAX 4294967295
# endif

/* Mandaroty */
//void functions
void	*ft_memset(void *s, int c, size_t n);
void	ft_bzero(void *s, size_t n);
void	*ft_memcpy(void *dest, const void *src, size_t n);
void	*ft_memmove(void *dest, const void *src, size_t n);
void	*ft_memchr(const void *s, int c, size_t n );

//int funtions
int		ft_isalpha(int c);
int		ft_isdigit(int c);
int		ft_isalnum(int c);
int		ft_isascii(int c);
int		ft_isprint(int c);
int		ft_toupper(int c);
int		ft_tolower(int c);
int		ft_strncmp(const char *s1, const char *s2, size_t n);
int		ft_strcmp(char *s1, char *s2);
int		ft_memcmp(const void *s1, const void *s2, size_t n);
int		ft_atoi(const char *nptr);

//size_t functions
size_t	ft_strlen(const char *str);
size_t	ft_strlcpy(char *dest, const char *src, size_t	size);
size_t	ft_strlcat(char *dest, char *src, unsigned int size);

//char functions
char	*ft_strchr(const char *s, int c);
char	*ft_strrchr(const char *str, char c);
char	*ft_strnstr(const char *big, const char *little, size_t len);

//parte 2
char	*ft_strtrim(char const *s1, char const *set);
char	*ft_strjoin(char const *s1, char const *s2);
char	*ft_substr(char const *s, unsigned int start, size_t len);
char	**ft_split(char const *s, char c);
char	*ft_itoa(int n);
char	*ft_strmapi(char const *s, char (*f)(unsigned int, char));
void	ft_striteri(char *s, void (*f)(unsigned int, char*));
void	ft_putchar_fd(char c, int fd);
void	ft_putstr_fd(char *s, int fd);
void	ft_putendl_fd(char *s, int fd);
void	ft_putnbr_fd(int n, int fd);
void	*ft_calloc(size_t count, size_t size);
char	*ft_strdup(const char *s);

/* Bonus */
/* Bonus struct  */
typedef struct s_list
{
	char			*content;
	struct s_list	*next;
}	t_list;
/* Bonus Functions */

/* t_list */
t_list	*ft_lstlast(t_list *lst);
t_list	*ft_lstnew(void *content);
t_list	*ft_lstmap(t_list *lst, void *(*f)(void *), void (*del)(void *));

/* int */
int		ft_lstsize(t_list *lst);

/* void */
void	ft_lstadd_front(t_list **lst, t_list *new);
void	ft_lstadd_back(t_list **lst, t_list *new);
void	ft_lstdelone(t_list *lst, void (*del)(void*));
void	ft_lstclear(t_list **lst, void (*del)(void*));
void	ft_lstiter(t_list *lst, void (*f)(void *));

/* get_next_line */
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

/* ft_printf */
/* valitions */
int ft_validation(char c);
/* main funtion*/
int		ft_printf(const char *str, ...);

/* cazador de flgas */
void	is_flag(char c, va_list args, int *length, int *flag);

/* • %u Imprime un número decimal (base 10) sin signo. */
void	ft_unsigned_putnbr(unsigned int unsigned_nbr, int *length, int *flag);

/* • %c Imprime un solo carácter. */
void	ft_putchar(const char c, int *length, int *flag);

/* • %s Imprime una string (como se define por defecto en C) */
void	ft_putstr(char *args, int *length, int *flag);

/* 
• %d Imprime un número decimal (base 10).
• %i Imprime un entero en base 10.
*/
void	ft_putnbr(int nbr, int *length, int *flag);

/* • %p El puntero void * dado como argumento
 * se imprime en formato hexadecimal. */
void	ft_pointer(size_t pointer, int *length, int *flag);

/* • %x Imprime un número hexadecimal (base 16) en minúsculas.
• %X Imprime un número hexadecimal (base 16) en mayúsculas. */
void	ft_hex(unsigned int nbr, int *length, char x, int *flag);

#endif
