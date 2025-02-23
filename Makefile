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
OBJS = ./src/pipex.c ./src/commands.c ./libft/libft.a
BOBJS = src/pipex_bonus.c ./libft/libft.a
HEADER = include/pipex.h
CC = cc
CFLAGS = -Wall -Werror -Wextra
RM = rm -f
TESTER = tester_pipex.sh
#color
RED     = \033[31m
GREEN   = \033[32m
YELLOW  = \033[33m
BLUE    = \033[34m
RESET   = \033[0m

ifdef BONUS
	OBJECTS = $(BOBJS)
else
	OBJECTS = $(OBJS)
endif

#Reglas
all: $(NAME)

$(NAME): $(HEADER) Makefile
	make all -C libft
	@echo "$(GREEN)Compilando pipex...$(RESET)"
	$(CC) -o $(NAME) $(OBJECTS) -g
	@echo "$(BLUE)"
	@echo "$(YELLOW)           ($(RESET)__$(YELLOW))\           $(RESET)"
	@echo "$(YELLOW)           ($(RESET)oo$(YELLOW))\\________  $(RESET)"
	@echo "$(RESET)           /|| \\        \\ PIPEX READY$(RESET)"
	@echo "$(RESET)              ||------w | $(RESET)"
	@echo "$(RESET)              ||       || $(RESET)"
	@echo "$(YELLOW)THE COW MAKES MUUUUUUUUUU!$(RESET)"
	@echo "$(RESET)"

bonus: 
	@$(MAKE) BONUS=42 --no-print-directory

tester: $(NAME)
	sh $(TESTER)
clean:
	@echo "$(GREEN)eliminado...$(RESET)"
	$(RM) .o
	make clean -C libft

fclean: clean
	@echo "$(GREEN)eliminando todo...$(RESET)"
	$(RM) $(NAME)
	make fclean -C libft
	
re: fclean all

.PHONY : all clean fclean re