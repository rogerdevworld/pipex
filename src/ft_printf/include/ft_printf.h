/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.h                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/22 14:15:26 by rmarrero          #+#    #+#             */
/*   Updated: 2024/10/22 14:35:05 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#ifndef FT_PRINTF_H
# define FT_PRINTF_H

/* lib std */
# include <stdio.h>
# include <unistd.h>
# include <stdarg.h>
# include <stdint.h>

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
