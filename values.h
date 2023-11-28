// This file contains function definitions for the evaluation functions

typedef char* CharPtr;
enum Operators {LESS, ADD, MULTIPLY, SUBTRACT, DIVIDE, EXPONENT, MODULO,
    EQUAL, NOT_EQUAL, GREATER, GREATER_EQUAL, LESS_EQUAL, OR, AND, NOT};

double evaluateReduction(Operators operator_, double head, double tail);
double evaluateRelational(double left, Operators operator_, double right);
double evaluateArithmetic(double left, Operators operator_, double right);
double evaluateLogical(double left, Operators operator_, double right);
