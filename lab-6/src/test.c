#include <unistd.h>
#include <sys/syscall.h>
#include <stdio.h>
#include <errno.h>

#define SYSCALL_NR 386 

int main(void) {
    printf("Attempting to invoke the 'greet' system call...\n");

    long ret = syscall(SYSCALL_NR);

    if (ret == 0) {
        printf("System call executed successfully! Return value: %ld\n", ret);
    } else {
        printf("System call failed. Error: %s (Code: %d)\n", strerror(errno), errno);
    }

    printf("Exiting test program.\n");
    return 0;
}
