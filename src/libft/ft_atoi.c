/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_atoi.c                                          :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2024/09/11 18:38:41 by rmarrero          #+#    #+#             */
/*   Updated: 2024/09/18 06:44:35 by rmarrero         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */
#include "libft.h"

int	ft_atoi(const char *nptr)
{
	int		result;
	size_t	i;
	int		sign;

	sign = 1;
	i = 0;
	result = 0;
	while (nptr[i] == 32 || (nptr[i] >= 9 && nptr[i] <= 13))
		i++;
	if (nptr[i] == '-')
	{
		sign = -1;
		i++;
	}
	else if (nptr[i] == '+')
		i++;
	while (ft_isdigit(nptr[i]))
	{
		result = result * 10 + (nptr[i] - '0');
		i++;
	}
	return (result * sign);
}
/*
void test_comparison(const char *str) {
    int result_ft = ft_atoi(str);
    int result_std = atoi(str);

    printf("Input: \"%s\"\n", str);
    printf("ft_atoi result: %d\n", result_ft);
    printf("atoi result: %d\n", result_std);

    if (result_ft == result_std) {
        printf("PASSED: Both results are the same.\n");
    } else {
        printf("FAILED: Results are different.\n");
    }
    printf("--------\n");
}

int main() {
    test_comparison("123");
    test_comparison("-456");
    test_comparison("0");
    test_comparison("   789");
    test_comparison("   -234");
    test_comparison("12abc34");
    test_comparison("abc123");
    test_comparison("");
    test_comparison(" ");
    test_comparison("+");
    test_comparison("-");
    test_comparison("2147483648");
    test_comparison("2147483649");
    test_comparison("-2147483627172");
    test_comparison("-2147483649");
    test_comparison("----2147483648");
    test_comparison("-+2147483649");

    return 0;
}*/
