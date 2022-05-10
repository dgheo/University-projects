/*
 * Loader Implementation
 *
 * 2018, Operating Systems
 * Digori Gheorghe 331CC
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include "exec_parser.h"


static so_exec_t *exec;
static char *path_to_exec;


/*page struct to store page number and next page* */
typedef struct page_struct {
	int no;
	struct page_struct *next;
} page_struct_x;


/*my handler function*/
static void sigseg_handler(int signum, siginfo_t *info, void *context)
{
	void *seg_begin;
	void *seg_end;
	so_seg_t *segment = NULL;
	int i;
	char buff[getpagesize()];
	void *adr = info->si_addr;/*addres for segment that produced seg fault*/
	int x;
	int fd = -1;

/*iterate threw all the segments to find in which segment is de address.*/
	for (i = 0; i < exec->segments_no; i++) {
		/*find the memory limits address for a segment*/
		seg_begin = (void *)exec->segments[i].vaddr;
		seg_end = seg_begin + exec->segments[i].mem_size;

		if (seg_begin <= adr && adr < seg_end)
			segment = &(exec->segments[i]);
	}

	if (!segment)
		signal(SIGSEGV, SIG_DFL);
	unsigned int pag_nr =  ((unsigned int) info->si_addr - segment->vaddr);
	/*get number of pages*/
	pag_nr = pag_nr / getpagesize();
	/*get page limits in memory*/
	unsigned int pag_begin = pag_nr * getpagesize();
	unsigned int pag_end = pag_begin + getpagesize();
	/*address where the page will be mapped*/
	unsigned int norm_pag_begin = pag_begin + segment->vaddr;

	page_struct_x *p;

	/*find the page*/
	p = segment->data;

	while (p) {
		if (p->no == pag_nr)
			signal(SIGSEGV, SIG_DFL);
		p = p->next;

	}
	/*map the page and save the addres at the start page*/
	void *page_addr =
	mmap((void *)norm_pag_begin, getpagesize(),
				PROT_WRITE | PROT_READ | PROT_EXEC,
				MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
	DIE((int)page_addr == 0, "Mmap error");

	unsigned int data_bytes;
	unsigned int f_size = segment->file_size;

	/*check if the page contains bytes from the executable file*/
	if (f_size < pag_begin)
		data_bytes = 0;
	else if (pag_begin <= f_size && f_size < pag_end)
		data_bytes = f_size - pag_begin;
	else
		data_bytes = getpagesize();

	/*open and read from the file all necesary bytes in buffer*/
	if (data_bytes > 0) {

		fd = open(path_to_exec, O_RDONLY);
		DIE(fd < 0, "Open error");
		/*get the page offest*/
		unsigned int page_offset = segment->offset + pag_begin;
		/*seek the offset*/
		x = lseek(fd, page_offset, SEEK_SET);
		DIE(x < 0, "lseek error");
		/*read bytes from the file*/
		x = (int)read(fd, buff, data_bytes);
		DIE(x < 0, "Read error");
	}

	/*copy bytes from buffer to the page address*/
	x = (int)memcpy((char *)page_addr, buff, data_bytes);
	DIE(x < 0, "Memcpy error");

	/*close the file*/
	if (fd > 0) {
		x = close(fd);
		DIE(x < 0, "Close error");
	}

	/*protect the page with segment specified permitions*/
	x = mprotect((void *)norm_pag_begin, getpagesize(), segment->perm);
	DIE(x < 0, "Mprotect error");

	/*alloc memory for page*/
	page_struct_x *q = mmap(NULL, sizeof(page_struct_x),
		PROT_WRITE | PROT_READ,
		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	DIE((int)q == 0, "Mmap error");

	q->no = pag_nr;
	q->next = NULL;

	if (!segment->data)
		segment->data = (void *)q;
	else {
		p = (page_struct_x *)segment->data;
		while (p->next != NULL)
			p = p->next;
		p->next = q;
	}
}


/* SIGSEGV signals treating routine */
int so_init_loader(void)
{
	int x;
	struct sigaction sa;
	/*
	 *for known and mapped segment run default handler
	 *for unmapped, known segment - map the segment.
	 */
	x = (int) memset(&sa, 0, sizeof(sa));
	DIE(x == 0, "Memset error");

	sa.sa_sigaction = sigseg_handler;
	sa.sa_flags = SA_SIGINFO;
	sigaction(SIGSEGV, &sa, NULL);

	return 0;
}


int so_execute(char *path, char *argv[])
{
	int i;
	/*check exec*/
	path_to_exec = path;
	exec = so_parse_exec(path);

	if (!exec)
		return -1;

	for (i = 0; i < exec->segments_no; i++)
		exec->segments[i].data = NULL;
	so_start_exec(exec, argv);

	return 0;
}
