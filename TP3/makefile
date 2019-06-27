tp3: tp3.l tp3.y
	flex tp3.l
	yacc -d tp3.y
	cc -o tp3  y.tab.c -ly -lm

tp32: tp3_2.l tp3_2.y
	flex tp3_2.l
	yacc -d tp3_2.y
	cc -o tp3_2 y.tab.c -ly -lm
clean:
	rm -f y.tab.c y.tab.h lex.yy.c tp3
	rm -f tp3_2