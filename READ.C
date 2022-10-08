#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  FILE *f;
  int i;

  if (argc != 3) {
    fprintf(stderr, "usage: %s <file> <count>\n", argv[0]);
    return -1;
  }

  f = fopen(argv[1], "rb");
  if (f == NULL) {
    perror("fopen");
    return -1;
  }

  for (i = 0; i < atoi(argv[2]); i++) {
    printf("%02x\n", fgetc(f));
  }

  fclose(f);

  return 0;
}
