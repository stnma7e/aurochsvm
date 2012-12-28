% : %.hs
	ghc --make $<
% : %.c
	gcc $<
% : %.cpp
	g++ $<

all: asm vm
	asm com.asm com.o

clean:
	rm -rf asm.exe asm.hi
	rm -rf a.exe
	rm -rf *.o
