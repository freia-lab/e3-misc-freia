#include <stdio.h>
#include <time.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>

#include <dbDefs.h>
#include <registryFunction.h>
#include <subRecord.h>
#include <aSubRecord.h>
#include <epicsExport.h>

int mySubDebug;

static long myAsubInit(aSubRecord *precord)
{
    if (mySubDebug)
        printf("Record %s called myAsubInit(%p)\n",
               precord->name, (void*) precord);
    return 0;
}
static long myAsubProcess(aSubRecord *precord)
{
#define MAXN 80
#define N 20

  epicsOldString outs;
  time_t result;
  unsigned long usecs = 0;
  struct tm tm;
  char timestring[MAXN];
  char hrs[N];
  char tmps[N];
  double tstamp;
  /* 2001-12-31 00:00:00 Labview - 2001-12-31 00:00:00 Unix */
  unsigned long offset = 3092601600-1009756800;

  if (mySubDebug > 5) {
    printf("Record %s called myAsubProcess(%p)\n",
	   precord->name, (void*) precord);
    printf ("Input: %.9f\n", *((double *) precord->a));
  }

  tstamp = *(double *) precord->a;

  result = trunc(tstamp);
  usecs = (tstamp - result) *1e9;
  result -= offset;
  localtime_r ((&result), &tm);
  strftime(timestring, MAXN, "%a %b %d ", &tm);
  strftime(hrs, N, "%T", &tm);
  sprintf (tmps, "%s.%09lu", hrs, usecs);
  strcat (timestring, tmps);
  strftime(tmps, N, " %Z %Y", &tm);
  strcat (timestring, tmps);

  strncpy ((char *) precord->vala, timestring, 40);
  if (mySubDebug > 4) {  
    printf ("Output: %s p->vala: %p: %s\n", outs, (void*) (precord->vala), 
	    (char *)  precord->vala);
    printf ("Old output: %s\n",  (char *)  precord->ovla);
  } 
  return 0;
}

/* Register these symbols for use by IOC code: */
epicsExportAddress(int, mySubDebug);
epicsRegisterFunction(myAsubInit);
epicsRegisterFunction(myAsubProcess);

