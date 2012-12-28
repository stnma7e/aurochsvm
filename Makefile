% : %.hs
	ghc --make $<
% : %.c
	gcc $<
% : %.cpp
	g++ $<

all: asm vm

clean:
	rm -rf asm.exe asm.hi asm.o
	rm -rf a.exe
	rm -rf com.o
