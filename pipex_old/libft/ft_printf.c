/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/10/22 14:06:47 by rmarrero          #+#    #+#             */
/*   Updated: 2024/11/26 16:23:01 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "libft.h"

/* dejare el ft_printf para manejo de errores 
 * etc y llamar a las funciones finales */
int	ft_printf(const char *str, ...)
{
	int		i;
	va_list	args;
	int		length;
	int		flag;

	i = 0;
	length = 0;
	flag = 1;
	va_start(args, str);
	if (!*str)
		return (0);
	while (str[i])
	{
		if (str[i] == '%')
		{
			i++;
			if (str[i])
				if (ft_validation(str[i]) == 1)
					is_flag(str[i], args, &length, &flag);
				else
					return (-1);
			else
				break ;
		}
		else
			ft_putchar(str[i], &length, &flag);
		if (flag == -1)
			return (-1);
		i++;
	}
	va_end(args);
	return (length);
}
