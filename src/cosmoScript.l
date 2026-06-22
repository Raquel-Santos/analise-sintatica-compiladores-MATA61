%{
#include <stdio.h>
#include <string.h>
#include "parser.tab.h"

extern int line;
%}

WHITE [ \t\r]+

%%

"orbitA" { return KW_MAIN; }
"decolar" { return KW_EXEC; }
"sinal" { return KW_VAR; }
"frota" { return KW_ARRAY; }
"astro" { return KW_INT; }
"nebula" { return KW_FLOAT; }
"vacuo" { return KW_VOID; }
"propulsor" { return KW_FUNC; }
"transmitir" { return KW_RETURN; }
"eclipse" { return KW_IF; }
"supernova" { return KW_ELSE; }
"orbitar" { return KW_WHILE; }
"trajetoria" { return KW_FOR; }
"em" { return KW_IN; }
"ate" { return KW_TO; }
"passo" { return KW_STEP; }

"==" { return REL_EQ; }
"!=" { return REL_NE; }
"<=" { return REL_LE; }
">=" { return REL_GE; }

[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return ID; }
[0-9]+\.[0-9]+ { yylval.str = strdup(yytext); return NUM_FLOAT; }
[0-9]+ { yylval.str = strdup(yytext); return NUM_INT; }

\n { line++; }
{WHITE} { /* Ignora espaços e quebras no estilo Windows \r */ }

"//".* { /* Ignora comentário de linha */ }
"/*"([^*]|\*+[^*/])*\*+"/" { /* Ignora comentário de bloco */ }

"{" { return '{'; }
"}" { return '}'; }
"(" { return '('; }
")" { return ')'; }
"[" { return '['; }
"]" { return ']'; }
"," { return ','; }
";" { return ';'; }
":" { return ':'; }
"+" { return '+'; }
"-" { return '-'; }
"*" { return '*'; }
"/" { return '/'; }
"%" { return '%'; }
"=" { return '='; }
"<" { return '<'; }
">" { return '>'; }

. { printf("Erro léxico na linha %d: caractere invalido '%s'\n", line, yytext); }

%%

int yywrap() {
    return 1;
}

