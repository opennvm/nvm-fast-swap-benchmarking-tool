#include <sys/mman.h>

void __attribute__ ((constructor)) init(void)
{
	mlockall(MCL_CURRENT|MCL_FUTURE);
}

void __attribute__ ((destructor)) fini(void)
{
	munlockall();
}
