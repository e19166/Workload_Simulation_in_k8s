#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>

int main() {
    int i;
    pid_t pid, mpid, ppid, cpid;

    for (i = 0; i < 4; i++) {
        pid = fork();
        mpid = getpid();
        ppid = getppid();

        if (pid < 0) {
            fprintf(stderr, "Fork Failed!");
            return 1;
        } else if (pid == 0) {
            printf("child: my pid = %d, parent pid = %d\n", mpid, ppid);
        } else {
            printf("parent: my pid = %d, parent pid = %d\n", mpid, ppid);
            printf("--> I just spawned a child with pid %d\n", pid);
            wait(NULL);
        }
    }

    return 0;
}
