#include <stdio.h>

extern void asmMain(void);

int main(void) {

    printf("Before asmMain\n");
    asmMain();
    printf("After asmMain\n");

    return 0;
}