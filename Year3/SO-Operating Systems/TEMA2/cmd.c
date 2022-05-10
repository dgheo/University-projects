/**
 * Operating Systems 2013-2017 - Assignment 2
 *
 * Digori Gheorghe 331CC
 *
 */

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>

#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "cmd.h"
#include "utils.h"

#define READ		0
#define WRITE		1
#define FD_ERROR "Error opening filedescriptor"

/*redirect filedescriptor if is STDIN*/
static void redirect_to_input(simple_command_t *scmd)
{
	char *in_f = get_word(scmd->in);
	int my_fd = open(in_f, O_RDONLY, 0644);
	/*check my_fd*/
	DIE(my_fd < 0, FD_ERROR);
	/*copy STDIN*/
	dup2(my_fd, STDIN_FILENO);
	free(in_f);
	close(my_fd);
}
/*redirect filedescriptor if is STDOUT usinf io_flags*/
static void redirect_to_output(simple_command_t *scmd)
{
	int my_fd;
	char *out_f = get_word(scmd->out);

	if (scmd->io_flags % 2 != 1) {
		my_fd = open(out_f, O_WRONLY | O_CREAT | O_TRUNC, 0644);
		DIE(my_fd < 0, FD_ERROR);
	} else {
		my_fd = open(out_f, O_WRONLY | O_CREAT | O_APPEND, 0644);
		DIE(my_fd < 0, FD_ERROR);
	}
	dup2(my_fd, STDOUT_FILENO);
	close(my_fd);
	free(out_f);
}
/*redirect filedescriptor if is STDERR usinf io_flags*/
static void redirect_to_error(simple_command_t *scmd)
{
	int my_fd;
	char *err_f = get_word(scmd->err);

	if (scmd->io_flags >= 2) {
		my_fd = open(err_f, O_WRONLY | O_CREAT | O_APPEND, 0644);
		DIE(my_fd < 0, FD_ERROR);
	} else {
		my_fd = open(err_f, O_WRONLY | O_CREAT | O_TRUNC, 0644);
		DIE(my_fd < 0, FD_ERROR);
	}
	dup2(my_fd, STDERR_FILENO);
	close(my_fd);
	free(err_f);
}

/*redirect by type (input, output or error)*/
static void solve_redirections(simple_command_t *scmd)
{
	char *out_com = get_word(scmd->out);
	char *err_com = get_word(scmd->err);
	/*input*/
	if (scmd->in)
		redirect_to_input(scmd);
	/*output*/
	if (scmd->out)
		redirect_to_output(scmd);
	/*error and out*/
	if (scmd->err && scmd->out && strcmp(out_com, err_com) == 0) {
		dup2(STDOUT_FILENO, STDERR_FILENO);
	/*error*/
	} else if (scmd->err) {
		redirect_to_error(scmd);
	}
	free(out_com); free(err_com);
}

/**
 * Internal change-directory command.
 */
static bool shell_cd(word_t *dir)
{
	/* execute cd */
	int r;
	char *cale = get_word(dir);
	/*execute*/
	if (dir == NULL)
		return -1;
	r = chdir(cale);
	free(cale);
	return r;
}

/**
 * Internal exit/quit command.
 */
static int shell_exit(void)
{
	/* execute exit/quit */
	return SHELL_EXIT;
}

void free_and_close(char *comand, char **argument, char *enviro_check,
					int in, int out, int err)
{
	int x, i;
	/*close filedescriptors*/
	close(STDIN_FILENO);
	close(STDOUT_FILENO);
	close(STDERR_FILENO);

	/* restore the file descriptors for in, out and err */
	x = dup2(in, STDIN_FILENO);
	DIE(x < 0, "dup2 ERROR");
	x = dup2(out, STDOUT_FILENO);
	DIE(x < 0, "dup2 ERROR");
	x = dup2(err, STDERR_FILENO);
	DIE(x < 0, "dup2 ERROR");
	close(in);
	close(out);
	close(err);
	free(enviro_check);
	free(comand);
	i = 0;
	/*free for argument elements*/
	while (argument[i] != NULL) {
		free(argument[i]);
		i++;
	}
	free(argument);
}
/**
 * Parse a simple command (internal, environment variable assignment,
 * external command).
 */
static int parse_simple(command_t *c, int level, command_t *father,
						simple_command_t *scmd)
{

	int state, in, out, err;
	int r = 0;
	pid_t pid;
	char *comand, **argument;
	char *name = NULL;
	char *value = NULL;
	char *enviro_check = NULL;

	if (scmd->verb->next_part)
		enviro_check = get_word(scmd->verb->next_part);

	/* save the file descriptors for in, out and err */
	in = dup(STDIN_FILENO);
	out = dup(STDOUT_FILENO);
	err = dup(STDERR_FILENO);
	/*go and solve redirection*/
	solve_redirections(scmd);
	/*get comand and argument*/
	comand = get_word(c->scmd->verb);
	argument = get_argv(c->scmd, &state);

	do {
		/*if command is cd go to shell_cd*/
		if (strcmp(comand, "cd") == 0) {
			r = shell_cd(scmd->params);
			break;
		}
		/*if exit go to shell_exit*/
		if (strcmp(comand, "exit") == 0 ||
						strcmp(comand, "quit") == 0) {
			r = shell_exit();
			free_and_close(comand, argument, enviro_check,
						in, out, err);
			return r;
		}
		/*if is enviroment set enviroment variables*/
		if ((enviro_check != NULL) && (enviro_check[0] == '=')) {
			name = strtok(comand, "=");
			value = strtok(NULL, "=");
			/*Setenv(comand);*/
			r = setenv(name, value, 1);
			DIE(r < 0, "Setenv error");
			break;
		}
		/*if is external - fork new child process*/
		pid = fork();
		if (!pid)
			DIE(pid < 0, "fork_error");
		/*child process exec*/
		if (pid == 0) {
			execvp(comand, argument);
			fprintf(stderr, "Execution failed for '%s'\n", comand);
			exit(EXIT_FAILURE);
		}
		/*wait children to terminate execution*/
		waitpid(pid, &r, 0);
	} while (0);
	free_and_close(comand, argument, enviro_check, in, out, err);
	return r;
}

/**
 * Process two commands in parallel, by creating two children.
 */
static bool do_in_parallel(command_t *cmd1, command_t *cmd2, int level,
		command_t *father)
{
	/* comand cmd1 and cmd2 are executed simultaneously */
	int rez;
	int stat;
	int wait_rez;
	int pid;
	/*create process*/
	pid = fork();
	if (!pid)
		DIE(pid < 0, "fork_error");
	/*if is child - execute command now*/
	if (pid == 0) {
		rez = parse_command(cmd1, level, father);
		DIE(rez < 0, "do in parallel error");
		exit(rez);
	} else {
		/*if parrent do another comand and after wait the child*/
		rez = parse_command(cmd2, level, father);
		DIE(rez < 0, "do in parallel error");
	}
	/* wait for child */
	wait_rez = waitpid(pid, &stat, 0);
	DIE(wait_rez < 0, "PID_timeout");
	return rez;
}

/**
 * Run commands by creating an anonymous pipe (cmd1 | cmd2)
 */
static bool do_on_pipe(command_t *cmd1, command_t *cmd2, int level,
		command_t *father)
{
/*redirect the output of cmd1 to the input of cmd2 */
	int my_fd[2];
	int rez, state, in, out, x;
	pid_t pid, wait;

	/* save the file descriptors for in and out */
	in = dup(STDIN_FILENO);
	out = dup(STDOUT_FILENO);

	rez = pipe(my_fd);
	DIE(rez < 0, "Error pipe");

	/*start process*/
	pid = fork();
	/*check if we had a valid pid*/
	if (!pid)
		DIE(pid, "fork_error");
	/*if we have child proocess*/
	if (pid == 0) {
		/* stop input my_fd*/
		rez = close(my_fd[0]);
		DIE(rez < 0, "Close ERROR");

		/* make a duplicate in for STDOUT in my_fd */
		rez = dup2(my_fd[1], STDOUT_FILENO);
		DIE(rez < 0, "dup2 ERROR");

		/* go and execute comand*/
		rez = parse_command(cmd1, level+1, father);

		/* close my_fd*/
		close(my_fd[1]);
		exit(rez);

	} else if (pid > 0) {		/*else we have parrent process */
		/* close output for fildescriptor */
		rez = close(my_fd[1]);
		DIE(rez < 0, "Close ERROR");

		/* make a duplicate in for STDIN in my_fd */
		rez = dup2(my_fd[0], STDIN_FILENO);
		DIE(rez < 0, "dup2 ERROR");

		/* go and execute comand*/
		rez = parse_command(cmd2, level + 1, father);
		/* wait for child */
		wait = waitpid(pid, &state, 0);
		DIE(wait < 0, "waitpid");
	}
	/* restore file descriptors */
	x = dup2(in, STDIN_FILENO);
	DIE(x < 0, "dup2 ERROR");
	x = dup2(out, STDOUT_FILENO);
	DIE(x < 0, "dup2 ERROR");

	/* close my file descriptors */
	close(my_fd[0]);
	close(in);
	close(out);
	return rez;
}
/**
 * Parse and execute a command.
 */
int parse_command(command_t *c, int level, command_t *father)
{
	int rez;

	if (c->op == OP_NONE) {
		/* execute a simple command */
		rez = parse_simple(c, level + 1, father, c->scmd);
		return rez;
	}
	switch (c->op) {
	case OP_SEQUENTIAL:
		/* execute the commands one after the other */
		rez = parse_command(c->cmd1, level + 1, c);
		rez = parse_command(c->cmd2, level + 1, c);
		break;

	case OP_PARALLEL:
		/* execute the commands simultaneously */
		rez = do_in_parallel(c->cmd1, c->cmd2, level + 1, c);
		break;

	case OP_CONDITIONAL_NZERO:
		/* execute the second command only if the first one
		 * returns non zero
		 */
		rez = parse_command(c->cmd1, level + 1, c);
		if (rez)
			rez = parse_command(c->cmd2, level + 1, c);
		break;

	case OP_CONDITIONAL_ZERO:
		/* execute the second command only if the first one
		 * returns zero
		 */
		rez = parse_command(c->cmd1, level + 1, c);
		if (rez == 0)
			rez = parse_command(c->cmd2, level + 1, c);
		break;

	case OP_PIPE:
		/* redirect the output of the first command to the
		 * input of the second
		 */
		rez = do_on_pipe(c->cmd1, c->cmd2, level + 1, c);
		break;
	default:
		return SHELL_EXIT;
	}

	return rez;
}
