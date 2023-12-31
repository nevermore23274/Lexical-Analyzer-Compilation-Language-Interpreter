/* This file contains flex input file */

%{
#include <string>

using namespace std;

#include "values.h"
#include "listing.h"
#include "tokens.h"

%}

%option noyywrap

ws		[ \t\r]+
comment		\-\-.*\n|\/\/.*\n
line		[\n]
id		[A-Za-z][A-Za-z0-9]*([_]?[A-Za-z0-9]*[A-Za-z0-9])*
digit		[0-9]
int		{digit}+
real		{int}([.]{int}*[eE]?[+-]?{int}*)?
punc		[\(\),:;]
%%

{ws}		{ ECHO; }
{comment}	{ ECHO; nextLine();}
{line}		{ ECHO; nextLine();}
"=>"		{ ECHO; return(ARROW); }
"<"		{ ECHO; yylval.oper = LESS; return(RELOP); }
"="		{ ECHO;	yylval.oper = EQUAL; return(RELOP); }
"/="		{ ECHO; yylval.oper = NOT_EQUAL; return(RELOP); }
">"		{ ECHO; yylval.oper = GREATER; return(RELOP); }
">="		{ ECHO;	yylval.oper = GREATER_EQUAL; return(RELOP); }
"<="		{ ECHO; yylval.oper = LESS_EQUAL; return(RELOP); }
"+"		{ ECHO; yylval.oper = ADD; return(ADDOP); }
"-"		{ ECHO; yylval.oper = SUBTRACT; return(ADDOP); }
"*"		{ ECHO; yylval.oper = MULTIPLY; return(MULOP); }
"/"		{ ECHO; yylval.oper = DIVIDE; return(MULOP); }
"**"		{ ECHO; yylval.oper = EXPONENT; return(EXPOP); }
rem		{ ECHO; yylval.oper = MODULO; return(REMOP);	}
begin		{ ECHO; return(BEGIN_); }
boolean		{ ECHO; return(BOOLEAN); }
end		{ ECHO; return(END); }
endreduce	{ ECHO; return(ENDREDUCE); }
function	{ ECHO; return(FUNCTION); }
integer		{ ECHO; return(INTEGER); }
is		{ ECHO; return(IS); }
reduce		{ ECHO; return (REDUCE); }
returns		{ ECHO; return(RETURNS); }
and		{ ECHO; yylval.oper = AND; return(ANDOP); }
case		{ ECHO; return(CASE);	}
else		{ ECHO; return(ELSE);	}
endcase		{ ECHO; return(ENDCASE);}
endif		{ ECHO; return(ENDIF);	}
if		{ ECHO;	return(IF);	}
others		{ ECHO; return(OTHERS);	}
real		{ ECHO; return(REAL);	}
then		{ ECHO; return(THEN);	}
when		{ ECHO; return(WHEN);	}
or		{ ECHO; yylval.oper = OR; return(OROP);	}
not		{ ECHO; yylval.oper = NOT; return(NOTOP);	}
true		{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL);}
false		{ ECHO; yylval.value = atoi(yytext); return(BOOL_LITERAL);}
{id}		{ ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1);
			strcpy(yylval.iden, yytext); return(IDENTIFIER);}
{int}		{ ECHO; yylval.value = atoi(yytext); return(INT_LITERAL); }
{real}		{ ECHO; yylval.value = atof(yytext); return(REAL_LITERAL);}
{punc}		{ ECHO; return(yytext[0]); }
.		{ ECHO; appendError(LEXICAL, yytext); }

%%
