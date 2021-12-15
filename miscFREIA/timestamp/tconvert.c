#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[])
{
#define MAXN 80
#define N 20

  time_t result;
  unsigned long usecs = 0;
  struct tm tm;
  double tstamp;
  char timestring[MAXN];
  char hrs[N];
  char tmps[N];
 
  unsigned long offset = 3092601600-1009756800;
 /* 2001-12-31 00:00:00 Labview - 2001-12-31 00:00:00 Unix */
  if (argc == 2) {
    tstamp = atof (argv[1]);
    result = trunc(tstamp);
    usecs = (tstamp - result) *1e9;
    result -= offset;
    localtime_r ((&result), &tm);
   printf ("%s %.10f %u %09lu\n", argv[1], tstamp, result, usecs);
    strftime(timestring, MAXN, "%a %b %d ", &tm);
    strftime(hrs, N, "%T", &tm);
    sprintf (tmps, "%s.%09u", hrs, usecs);
    strcat (timestring, tmps);
    strftime(tmps, N, " %Z %Y", &tm);
    strcat (timestring, tmps);
    printf ("%s\n", timestring);
  } else {
    result = time(NULL);
  }
  printf("%s%u secs since the Epoch\n",
	 asctime(localtime(&result)),
	 result);
  return(0);
}
