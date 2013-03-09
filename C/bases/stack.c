#include <stdio.h>

a (int i) {
    if (i>0) {
        a( --i );
    }
    else {
        printf("reached zero \n");
    }
    return;
}

int main()
{
    a(1);
}
