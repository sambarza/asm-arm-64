#include "stdio.h"
#include "stdlib.h"

extern "C" {
    char *getTitle(void);
    void asmMain(void);
}

int main(int argc, char** argv) {

    char *title = getTitle();

    printf("Before : %s\n", title);
    asmMain();
    printf("After : %s\n", title);

    return 0;
}