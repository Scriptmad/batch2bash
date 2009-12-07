/* using tabs to get same spacing, this is going to look bad with other tab lengths */

%{
	#include <string.h>
	#include "y.tab.h"
    #include "defs.h"

	
	extern YYSTYPE yylval;
	int line = 1;
	

%}


letter				[_a-zA-Z]
digit					[0-9]

%%

echo.*				{ yylval = (int)strdup(yytext + 4); return ECHO; }
rem[\t ].*		{ yylval = (int)strdup(yytext + 3); return REM; }
":".+			    { yylval = (int)strdup(yytext + 1); return LABEL; }
"/".					{ yylval = (int)strdup(yytext+1); return PARAMETER; } 
call	 	   		{ return CALL; }
choice				{ return CHOICE; }
con						{ return CONSOLE; }
errorlevel		{ return RETVALUE; }
exists				{ return EXISTS; }
if						{ return IF; }
for						{ return FOR; }
goto					{ return GOTO; }
not						{ return NOT; }
nul						{ return NUL; }
off						{ return OFF; /*is this really a keyword?*/}
pause					{ return PAUSE; }
set						{ return SET; }
shift					{ return SHIFT; }
sgn						{ return SIGN; }
equ						{ yylval = EQ; return RELOP; }
neq						{ yylval = NE; return RELOP; }
lss						{ yylval = LT; return RELOP; }
leq						{ yylval = LE; return RELOP; }
gtr						{ yylval = GT; return RELOP; }
geq						{ yylval = GE; return RELOP; }
">"						{ yylval = W; return REDIRECT; }
">>"					{ yylval = A; return REDIRECT; }
"<"						{ yylval = R; return REDIRECT; }
"=="					{ yylval = EQ; return STROP; }
"!==!"			  { yylval = NE; return STROP; }
"!"						{ yylval = NEG; return STROP; }
"|"						{ return PIPE; }
"@"						{ return NOECHO; }
"*"						{ yylval = MANY; return WILDCARD; /* hmm */}
"?"						{ yylval = ONE; return WILDCARD; /* hmm */}
"%"    	  		{ return PERCENT; }



assign				{ return ASSIGN; }
attrib				{ return ATTRIB; }
cd						{ return CD; }
chdir					{ return CHDIR; }
cls 					{ return CLS; }
comp 					{ return COMP; }
copy					{ return COPY; }
del			 			{ return DEL; }
deltr 				{ return DELTR; }
dir						{ return DIR; }
erase					{ return ERASE; }
exit					{ return EXIT; }
fc						{ return FC; }
find					{ return FIND; }
md						{ return MD; }
mkdir					{ return MKDIR; }
more					{ return MORE; }
move					{ return MOVE; }
path					{ return PATH; }
ren						{ return REN; }
rd						{ return RD; }
rmdir					{ return RMDIR; }
sort					{ return SORT; }
time					{ return TIME; }
type					{ return TYPE; }
xcopy					{ return XCOPY; }

{letter}({letter}|{digit})* { return ID; }
":"						{ return COLON; }
"/"						{ return SLASH; }
"\\"					{ return BACKSLASH; }
[\t ]+				{ return WHITESPACE; }
\n|\n\r				{ line++; return NEWLINE; }
\"					{			int in_string = 1;
								char c;
								while (in_string) {
									c = input();
									if (c == '"') {
										in_string = 0;
									} else if (c == '\n') {
									line++;
									} else if (c == EOF) {
										fprintf(stderr, "\nerror: string not closed");
									}
							}
						}

.							{ printf("\n LEXICAL ERROR on character %c in line %d", yytext[0], line); }

%%

int yywrap() {
	return 1;
}