#pragma once

/// @defgroup libc libc
/// @{
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include <string>
// #include <iostream>
// #include <vector>
// #include <map>
/// @}

/// @defgroup main main
/// @{
int main(int argc, char *argv[]);
void arg(int argc, char *argv);
/// @}

/// @defgroup graph graph
/// @{

/// @brief @brief base graph node
class Object {
   public:
    Object();
    virtual ~Object();
};

/// @brief machine number, point,..
class Primitive : Object {};

/// @brief data container
class Container : Object {};

/// @brief GUI element
class GUI : Object {};

class Window : GUI {
   public:
    Window(std::string title, int width, int height);
    ~Window();
};
/// @}

/// @defgroup skelex skelex
/// @{
extern int yylex();
extern FILE *yyin;
extern char *yytext;
extern int yylineno;
extern char *filename;
extern int yyparse();
extern void yyerror(const char *msg);
#include "focg.parser.hpp"
/// @}
