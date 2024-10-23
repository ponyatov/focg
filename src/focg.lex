%{
    #include "focg.hpp"

    char *filename = nullptr;
%}

%option noyywrap yylineno

sign     [+\-]
dec      [0-9]+
alpha    [_a-zA-Z]
alphanum [_a-zA-Z0-9]

%%
