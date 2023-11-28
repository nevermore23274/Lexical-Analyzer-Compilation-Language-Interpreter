%{

#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>

using namespace std;

#include "values.h"
#include "listing.h"
#include "symbols.h"

int yylex();
void yyerror(const char* message);

Symbols<double> symbols;

double result;

double *par;

int i = 0;

%}


%union
{
	CharPtr iden;
	Operators oper;
	double value;
}

%token <iden> IDENTIFIER
%token <value> INT_LITERAL BOOL_LITERAL REAL_LITERAL

%token <oper> EXPOP ADDOP MULOP RELOP REMOP
%token <oper> OROP ANDOP NOTOP

%token BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token ARROW ELSE CASE ENDCASE ENDIF IF OTHERS REAL THEN WHEN

%type <value> body statement_ statement reductions expression binary relation term
	factor exponent unary primary cases case
%type <oper> operator

%%

function:
	function_header optional_variable body {result = $3;} ;

function_header:
	FUNCTION IDENTIFIER parameters RETURNS type ';' |
	FUNCTION IDENTIFIER RETURNS type ';' |
	error ';' ;

optional_variable:
	optional_variable variable |
	error ';' |
	;

variable:
	IDENTIFIER ':' type IS statement_ {symbols.insert($1, $5);} ;

parameters:
	parameter optional_parameter ;

optional_parameter:
	optional_parameter ',' parameter |
	;

parameter:
	IDENTIFIER ':' type {symbols.insert($1, par[i]); i++;} ;

type:
	INTEGER |
	REAL |
	BOOLEAN ;

body:
	BEGIN_ statement_ END ';' {$$ = $2;} ;

statement_:
	statement ';' |
	error ';' {$$ = 0;} ;

statement:
	expression |
	REDUCE operator reductions ENDREDUCE {$$ = $3;} ; |
	IF expression THEN statement_ ELSE statement_ ENDIF
	{$$ = $2 ? $4 : $6;} ; |
	CASE expression IS cases OTHERS ARROW statement_ ENDCASE
	{
		if (!isnan($4)) {
			$$ = $4;
		} else {
			$$ = $7;
		}
		;
	} ;

cases:
	cases case
	{
		if (!isnan($1)) {
			$$ = $1;
		} else {
			$$ = $2;
		}
		;
	} ; |
	{$$ = NAN;} ;

case:
	WHEN INT_LITERAL ARROW statement_
	{
		if ($<value>-2 == $2) {
			$$ = $4;
		} else {
			$$ = NAN;
		}
		;
	} ; |
	error ';' {$$ = 0;} ;

operator:
	RELOP |
	ADDOP |
	MULOP |
	REMOP |
	EXPOP ;

reductions:
	reductions statement_ {$$ = evaluateReduction($<oper>0, $1, $2);} |
	{$$ = $<oper>0 == ADD ? 0 : 1;} ;

expression:
	expression OROP binary {$$ = evaluateLogical($1, $2, $3);} |
	binary ;

binary:
	binary ANDOP relation {$$ = evaluateLogical($1, $2, $3);} |
	relation ;

relation:
	relation RELOP term {$$ = evaluateRelational($1, $2, $3);} |
	term ;

term:
	term ADDOP factor {$$ = evaluateArithmetic($1, $2, $3);} |
	factor ;

factor:
	factor MULOP exponent {$$ = evaluateArithmetic($1, $2, $3);} |
	factor REMOP exponent |
	exponent ;

exponent:
	unary |
	unary EXPOP exponent {$$ = evaluateArithmetic($1, $2, $3);} ;

unary:
	NOTOP unary {$$ = evaluateLogical($2, $1, $2);} |
	primary ;

primary:
	'(' expression ')' {$$ = $2;} |
	INT_LITERAL |
	REAL_LITERAL |
	BOOL_LITERAL |
	IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;

%%

void yyerror(const char* message)
{
	appendError(SYNTAX, message);
}

int main(int argc, char *argv[])
{
	int size = (argc-1);
	par = new double[size];
	for(int i = 1; i < argc; i++) {
		double x = atof(argv[i]);
		par[i - 1] = x;
	}

	firstLine();
	yyparse();
	if (lastLine() == 0)
		cout << "Result = " <<result << endl;
	return 0;
} 
