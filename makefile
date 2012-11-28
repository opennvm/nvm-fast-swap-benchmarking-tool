all:
	gcc -shared -fPIC -o lockmem.so lockmem.c
	gcc  -o getprocinfo getprocinfo.c
clean:
	rm -rf getprocinfo lockmem.so
