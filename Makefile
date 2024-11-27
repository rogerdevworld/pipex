# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rmarrero <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/11/13 12:28:02 by rmarrero          #+#    #+#              #
#    Updated: 2024/11/13 12:44:26 by rmarrero         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #
# Mandatory functions
NAME = pipex
SRC = ./src/
OBJS = $(wildcard $(SRC)*.c)
PRINTF = $(wildcard $(SRC)ft_printf/src/*.c)
LIBFT = $(wildcard $(SRC)libft/*.c)
HEADER = pipex.h
CC = cc
CFLAGS = -Wall -Werror -Wextra
RM = rm -f

#color
RED     = \033[31m
GREEN   = \033[32m
YELLOW  = \033[33m
BLUE    = \033[34m
RESET   = \033[0m

#Reglas
all: $(NAME)
#@echo "$(BLUE)Compilando el proyecto...$(RESET)"
$(NAME): $(LIBFT) $(OBJS)  $(PRINTF)
	$(CC) -o $(NAME) $?

clean:
	$(RM) .o

fclean: clean
	$(RM) $(NAME)
	
re: fclean all

.PHONY : all clean fclean re