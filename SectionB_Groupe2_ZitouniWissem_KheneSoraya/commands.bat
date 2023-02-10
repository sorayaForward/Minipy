flex lexicalem.l
bison -d syntm.y
gcc lex.yy.c syntm.tab.c -lfl -ly -o tpcompile
tpcompile<exemple.txt

