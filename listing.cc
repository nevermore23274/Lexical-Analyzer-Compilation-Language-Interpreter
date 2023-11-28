// This file contains the bodies of the functions that produces the compilation
// listing

#include <cstdio>
#include <string>
#include <iostream>
using namespace std;

#include "listing.h"

static int lineNumber;
static string error = "";
static int totalErrors = 0;
static int TotalLexErrors = 0;
static int TotalSynErrors = 0;

static void displayErrors();

void firstLine() {
    lineNumber = 1;
    printf("\n%4d  ", lineNumber);
}

void nextLine() {
    displayErrors();
    lineNumber++;
    printf("%4d  ", lineNumber);
}

int lastLine() {
    printf("\r");
    displayErrors();
    printf("     \n");
    
    if (totalErrors > 0) {
        cout << "Lexical Errors " << TotalLexErrors << "\n";
        cout << "Syntax Errors " << TotalSynErrors << "\n";
        printf("Semantic Errors 0\n");
    } else {
        printf("Compiled Successfully\n");
    }
    
    return totalErrors;
}

void appendError(ErrorCategories errorCategory, string message) {
    string messages[] = {
        "Lexical Error, Invalid Character ", 
        "", 
        "Semantic Error, ", 
        "Semantic Error, Duplicate Identifier: ", 
        "Semantic Error, Undeclared "
    };

    if (messages[errorCategory] == "Lexical Error, Invalid Character ") {
        TotalLexErrors++;
    } else if (messages[errorCategory] == "") {
        TotalSynErrors++;
    }

    error = messages[errorCategory] + message;
    totalErrors++;
}

void displayErrors() {
    if (!error.empty()) {
        printf("%s\n", error.c_str());
        error = "";
    }
}

