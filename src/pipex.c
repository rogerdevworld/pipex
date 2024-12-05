#include "../include/pipex.h"

void	exit_handler(int n_exit)
{
	if (n_exit == 1)
		ft_putstr_fd("./pipex infile cmd cmd outfile\n", 2);
	exit(0);
}

int	open_file(char *file, int in_or_out)
{
	int	ret;

	if (in_or_out == 0)
		ret = open(file, O_RDONLY, 0777);
	if (in_or_out == 1)
		ret = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (in_or_out == 2)
		ret = open(file, O_WRONLY | O_CREAT | O_APPEND, 0777);
	if (ret == -1)
		exit(0);
	return (ret);
}
int	ft_strcmp(char *s1, char *s2)
{
	size_t	i;

	i = 0;
	if (!s1)
		return (1);
	while (s1[i] || s2[i])
	{
		if (s1[i] != s2[i])
			return (s1[i] - s2[i]);
		i++;
	}
	return (0);
}

void	ft_free_tab(char **tab)
{
	size_t	i;

	i = 0;
	while (tab[i])
	{
		free(tab[i]);
		i++;
	}
	free(tab);
}

char	*my_getenv(char *name, char **env)
{
	int		i;
	int		j;
	char	*sub;

	i = 0;
	while (env[i])
	{
		j = 0;
		while (env[i][j] && env[i][j] != '=')
			j++;
		sub = ft_substr(env[i], 0, j);
		if (ft_strcmp(sub, name) == 0)
		{
			free(sub);
			return (env[i] + j + 1);
		}
		free(sub);
		i++;
	}
	return (NULL);
}

char	*get_path(char *cmd, char **env)
{
	int		i;
	char	*exec;
	char	**allpath;
	char	*path_part;
	char	**s_cmd;

	i = -1;
	allpath = ft_split(my_getenv("PATH", env), ':');
	s_cmd = ft_split(cmd, ' ');
	while (allpath[++i])
	{
		path_part = ft_strjoin(allpath[i], "/");
		exec = ft_strjoin(path_part, s_cmd[0]);
		free(path_part);
		if (access(exec, F_OK | X_OK) == 0)
		{
			ft_free_tab(s_cmd);
			return (exec);
		}
		free(exec);
	}
	ft_free_tab(allpath);
	ft_free_tab(s_cmd);
	return (cmd);
}

void	exec(char *cmd, char **env)
{
	char	**s_cmd;
	char	*path;

	s_cmd = ft_split(cmd, ' ');
	path = get_path(s_cmd[0], env);
	if (execve(path, s_cmd, env) == -1)
	{
		ft_putstr_fd("pipex: command not found: ", 2);
		ft_putendl_fd(s_cmd[0], 2);
		ft_free_tab(s_cmd);
		exit(0);
	}
}

void	here_doc_put_in(char **av, int *p_fd)
{
	char	*ret;

	close(p_fd[0]);
	while (1)
	{
		ret = get_next_line(0);
		if (ft_strncmp(ret, av[2], ft_strlen(av[2])) == 0)
		{
			free(ret);
			exit(0);
		}
		ft_putstr_fd(ret, p_fd[1]);
		free(ret);
	}
}

void	here_doc(char **av)
{
	int		p_fd[2];
	pid_t	pid;

	if (pipe(p_fd) == -1)
		exit(0);
	pid = fork();
	if (pid == -1)
		exit(0);
	if (!pid)
		here_doc_put_in(av, p_fd);
	else
	{
		close(p_fd[1]);
		dup2(p_fd[0], 0);
		wait(NULL);
	}
}

void	do_pipe(char *cmd, char **env)
{
	pid_t	pid;
	int		p_fd[2];

	if (pipe(p_fd) == -1)
		exit(0);
	pid = fork();
	if (pid == -1)
		exit(0);
	if (!pid)
	{
		close(p_fd[0]);
		dup2(p_fd[1], 1);
		exec(cmd, env);
	}
	else
	{
		close(p_fd[1]);
		dup2(p_fd[0], 0);
	}
}

int	main(int argc, char **argv, char **env)
{
	int		i;
	int		fd_in;
	int		fd_out;

	if (argc < 5)
		exit_handler(1);
	if (ft_strcmp(argv[1], "here_doc") == 0)
	{
		if (argc < 6)
			exit_handler(1);
		i = 3;
		fd_out = open_file(argv[argc - 1], 2);
		here_doc(argv);
	}
	else
	{
		i = 2;
		fd_in = open_file(argv[1], 0);
		fd_out = open_file(argv[argc - 1], 1);
		dup2(fd_in, 0);
	}
	while (i < argc - 2)
		do_pipe(argv[i++], env);
	dup2(fd_out, 1);
	exec(argv[argc - 2], env);
}

/* get_next_line */
t_list	*get_last_node(t_list *list)
{
	if (!list)
		return (NULL);
	while (list->next)
		list = list->next;
	return (list);
}

int	get_len(t_list *list)
{
	int	i;
	int	len;

	if (!list)
		return (0);
	len = 0;
	while (list)
	{
		i = 0;
		while (list->content[i])
		{
			if (list->content[i] == '\n')
				return (++len);
			++i;
			++len;
		}
		list = list->next;
	}
	return (len);
}

void	get_copy(t_list *list, char *line)
{
	int	i;
	int	j;

	if (!list)
		return ;
	j = 0;
	while (list)
	{
		i = 0;
		while (list->content[i])
		{
			if (list->content[i] == '\n')
			{
				line[j++] = '\n';
				line[j] = '\0';
				return ;
			}
			line[j++] = list->content[i++];
		}
		list = list->next;
	}
	line[j] = '\0';
}

int	find_new_line(t_list *list)
{
	int	i;

	if (!list)
		return (0);
	while (list)
	{
		i = 0;
		while (list->content[i] && i < BUFFER_SIZE)
		{
			if (list->content[i] == '\n')
				return (1);
			i++;
		}
		list = list->next;
	}
	return (0);
}

void	create_and_append(t_list **list, int fd)
{
	t_list	*new_node;
	t_list	*last_node;
	char	*buffer;
	int		bytes_read;

	while (!find_new_line(list[fd]))
	{
		buffer = malloc(BUFFER_SIZE + 1);
		bytes_read = read(fd, buffer, BUFFER_SIZE);
		if (!(buffer) || bytes_read <= 0)
			return (free(buffer), (void)0);
		buffer[bytes_read] = '\0';
		new_node = malloc(sizeof(t_list));
		if (!new_node)
			return ;
		new_node->content = buffer;
		new_node->next = NULL;
		if (!list[fd])
			list[fd] = new_node;
		else
		{
			last_node = get_last_node(list[fd]);
			last_node->next = new_node;
		}
	}
}

char	*get_next_line(int fd)
{
	static t_list	*list[4096];
	char			*line;

	line = NULL;
	if (BUFFER_SIZE < 0 || fd < 0)
		return (NULL);
	create_and_append(list, fd);
	line = malloc(get_len(list[fd]) + 1);
	if (!(list[fd]) || !(line))
		return (free(line), NULL);
	get_copy(list[fd], line);
	get_clear_remaining_data(&list[fd]);
	return (line);
}

void	get_free_list(t_list **list, t_list *replace, char *buffer)
{
	t_list	*tmp;

	if (NULL == *list)
		return ;
	while (*list)
	{
		tmp = (*list)->next;
		free((*list)->content);
		free(*list);
		*list = tmp;
	}
	*list = NULL;
	if (replace->content[0])
		*list = replace;
	else
	{
		free(buffer);
		free(replace);
	}
}

void	get_clear_remaining_data(t_list **list)
{
	char	*buffer;
	t_list	*last;
	t_list	*replace;
	int		i;
	int		j;

	i = 0;
	j = 0;
	buffer = malloc(BUFFER_SIZE + 1);
	replace = malloc(sizeof(t_list));
	if (!(buffer) || !(replace))
		return ;
	last = get_last_node(*list);
	while (last->content[i] && last->content[i] != '\n')
		++i;
	while (last->content[i] && last->content[++i])
		buffer[j++] = last->content[i];
	buffer[j] = '\0';
	replace->content = buffer;
	replace->next = NULL;
	get_free_list(list, replace, buffer);
}
//comand > 
//gcc -o get_next_line main.c get_next_line.c get_next_line_utils.c -I./includes
