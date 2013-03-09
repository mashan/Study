#include <stdio.h>

int main(void)
{
    int a = 123;
    int *p_i;

    p_i = &a;

    printf("a = %d\n", a);
    printf("*p_i = %d\n", *p_i);

    *p_i = 456;

    printf("a = %d\n", a);
    printf("*p_i = %d\n", *p_i);

    char str[] = "sum";
    char *p_c;
    int i = 0;

    p_c = str;

    while ( *(p_c + i) != '\0' ) {
        printf("%c ", *(p_c + i));
        i++;
    }

    return 0;
}
