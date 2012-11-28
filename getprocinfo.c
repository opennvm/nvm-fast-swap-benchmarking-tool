#define _GNU_SOURCE 
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdarg.h>
#include <errno.h>

static char array[4096];
int main(int argc, char *argv[])
{
	int fd;
	char path[100];
	unsigned long delay = 1, count = 0;
	int infinite = 0;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s procfile [delay [count]]\n", argv[0]);
		return EINVAL;
	}

	snprintf(path, 100, "/proc/%s", argv[1]);
	fd = open(path, O_RDONLY);

	if (fd < 0) {
		fprintf(stderr, "Wrong procfile\n");
		return EINVAL;
	}

	if (argc >= 3)
		delay = atol(argv[2]);
	if (argc >= 4)
		count = atol(argv[3]);
	if (count == 0)
		infinite = 1;

	while (1) {
		int len;
		lseek(fd, 0, SEEK_SET);
		while (1) {
			len = read(fd, array, 4095);
			if (len == 0)
				break;
			array[len] = 0;
			printf("%s", array);
		}
		printf("\n");
		if (!infinite && (--count) == 0)
			break;

		sleep(delay);
	}
	close(fd);
	return 0;
}
