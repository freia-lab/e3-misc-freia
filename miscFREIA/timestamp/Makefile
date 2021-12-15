#OPT    =  -g
OPT     =  -O
COPT  = $(OPT)
LOPT = $(OPT)
LFLAGS = -lm

CC      = cc $(COPT)
LINK    = cc $(LOPT)


OBJS = tconvert.o

.c.o: ; $(CC) -c $<

TARGET = tconvert 

$(TARGET): $(OBJS) 
	$(LINK) $(OBJS) $(LFLAGS) -o $(TARGET)

clean:
	$(RM) *.o *~
