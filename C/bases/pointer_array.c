#include <stdio.h>

int main(void)
{
    char str[] = "Array", *p = str;
    char str[] = "Array", *p;
//    p = str;
    char *s = "String";

    printf("配列のアドレス = %p\n", p);
    printf("文字列定数のアドレス = %p\n", s);

    while (*p != '\0') {
        printf("%c", *p);
        p++;
    }
    printf("\n");

    while (*s != '\0') {
        printf("%c", *s);
        s++;
    }

    return 0;
}
