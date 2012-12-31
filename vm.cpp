#include <stdio.h>
#include <stdlib.h>
#include <sstream>
#include <iostream>

#define NUM_REGS 4
long long regs[NUM_REGS];

FILE* objectFile;
char curLine[1024];

void die(const char* message)
{
	printf("ERROR: %s\n", message);
	exit(1);
}
int getLine()
{
	while (fgets(curLine, sizeof(curLine), objectFile))
	{
		int i;
		std::stringstream ss(curLine);
		if (ss >> std::hex >> i)
		{
			return i;
		}
		else
			die("couldnt convert object to command");
	}
}

int fetch()
{
	return getLine();
	// return prog[pc++];
}

int instrNum = 0;
// operands
int reg1 	 = 0;
int reg2   	 = 0;
int reg3 	 = 0;
int imm 	 = 0;
// decode a word
void decode(int instr)
{
	instrNum 	= (instr & 0xF000) >> 12;
	reg1 		= (instr & 0xF00)  >> 8;
	reg2		= (instr & 0xF0)   >> 4;
	reg3		= (instr & 0xF);
	imm			= (instr & 0xFF);
}

// vm runs until 0
int running = 1; 
//eval last decoded instruction
void eval()
{
	switch(instrNum)
	{
	case 0: // halt
		printf("halt\n");
		running = 0;
		break;
	case 1: // loadi
		printf("loadi r%d #%d\n", reg1, imm);
		regs[reg1] = imm;
		break;
	case 2: // loadr
		printf("loadr r%d r%d\n", reg1, reg2);
		regs[reg1] = regs[reg2];
		break;
	case 3: // add
		printf("add r%d r%d r%d\n", reg1, reg2, reg3);
		regs[reg1] = regs[reg2] + regs[reg3];
		break;
	case 4: // sub
		printf("sub r%d r%d r%d\n", reg1, reg2, reg3);
		regs[reg1] = regs[reg2] - regs[reg3];
		break;
	case 5: // mul
		printf("mul r%d r%d r%d\n", reg1, reg2, reg3);
		regs[reg1] = regs[reg2] * regs[reg3];
		break;
	case 6: // div
		printf("div r%d r%d r%d\n", reg1, reg2, reg3);
		regs[reg1] = regs[reg2] / regs[reg3];
		break;
	}
}
void showRegs()
{
	int i;
	printf("regs = ");
	for (i = 0; i < NUM_REGS; i++)
		printf("%04X ", regs[i]);
	printf("\n");
}
void run()
{
	while(running)
	{
		int instr = fetch();
		decode(instr);
		showRegs();
		eval();
	}
	showRegs();
}
int main(int argc, char* argv[])
{
	if (argc < 2)
		die("USAGE: vm <assembly file>");
	objectFile = fopen(argv[1], "r");
	if (!objectFile)
		die("bad filename");
	run();
	return 0;
}