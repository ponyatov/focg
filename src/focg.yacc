%{
    #include "focg.hpp"
%}

%defines %union { Object *o; }

%%
syntax :

%%

extern void yyerror(const char *msg) {
    fprintf(stderr, "\n\n%s:%i:%s [%s]\n\n", filename, yylineno, msg, yytext);
    exit(-1);
}
