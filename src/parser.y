%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

void yyerror(const char *s);
int yylex();
int line = 1;

typedef struct ASTNode {
    char *type;
    char *value;
    struct ASTNode **children;
    int child_count;
} ASTNode;

ASTNode* create_node(const char *type, const char *value, int count, ...) {
    ASTNode *node = (ASTNode*) malloc(sizeof(ASTNode));
    node->type = strdup(type);
    node->value = value ? strdup(value) : NULL;
    node->child_count = count;
    if (count > 0) {
        node->children = (ASTNode**) malloc(sizeof(ASTNode*) * count);
        va_list args;
        va_start(args, count);
        for (int i = 0; i < count; i++) {
            node->children[i] = va_arg(args, ASTNode*);
        }
        va_end(args);
    } else {
        node->children = NULL;
    }
    return node;
}

void print_ast(ASTNode *node, int level) {
    if (!node) return;
    for (int i = 0; i < level; i++) printf(" ");
    if (node->value) {
        printf("%s (%s)\n", node->type, node->value);
    } else {
        printf("%s\n", node->type);
    }
    for (int i = 0; i < node->child_count; i++) {
        print_ast(node->children[i], level + 1);
    }
}

ASTNode *root = NULL;
%}

%union {
    char *str;
    struct ASTNode *node;
}

%token KW_MAIN KW_EXEC KW_VAR KW_ARRAY KW_INT KW_FLOAT KW_VOID KW_FUNC KW_RETURN KW_IF KW_ELSE KW_WHILE KW_FOR KW_IN KW_TO KW_STEP
%token <str> ID NUM_INT NUM_FLOAT
%token REL_EQ REL_NE REL_LE REL_GE

%type <node> program main_block stmt_list stmt var_declaration func_declaration type
%type <node> params param_list param expression simple_expression rel_op
%type <node> additive_expression term factor call args arg_list block

/* Definição estrita de precedência para evitar conflitos no IF/ELSE */
%nonassoc LOWER_THAN_ELSE
%nonassoc KW_ELSE

%right '='
%left REL_EQ REL_NE '<' '>' REL_LE REL_GE
%left '+' '-'
%left '*' '/' '%'

%%

program:
    main_block { root = $1; printf("\n--- ÁRVORE SINTÁTICA GERADA ---\n"); print_ast(root, 0); }
    ;

main_block:
    KW_MAIN '{' stmt_list KW_EXEC '}' { $$ = create_node("MAIN_BLOCK", NULL, 1, $3); }
    ;

stmt_list:
    stmt_list stmt { $$ = create_node("STMT_LIST", NULL, 2, $1, $2); }
    | /* vazio */ { $$ = NULL; }
    ;

stmt:
    var_declaration { $$ = $1; }
    | func_declaration { $$ = $1; }
    | expression ';' { $$ = $1; }
    | KW_IF expression block %prec LOWER_THAN_ELSE { 
        ASTNode *cond = create_node("COND", NULL, 1, $2);
        $$ = create_node("ECLIPSE_IF", NULL, 2, cond, $3); 
    }
    | KW_IF expression block KW_ELSE block { 
        ASTNode *cond = create_node("COND", NULL, 1, $2);
        $$ = create_node("ECLIPSE_IF_ELSE", NULL, 3, cond, $3, $5); 
    }
    | KW_WHILE expression block { $$ = create_node("ORBITAR_WHILE", NULL, 2, $2, $3); }
    | KW_FOR ID KW_IN expression KW_TO expression KW_STEP expression block {
        ASTNode *var = create_node("ID", $2, 0);
        $$ = create_node("TRAJETORIA_FOR", NULL, 5, var, $4, $6, $8, $9);
    }
    | KW_RETURN expression ';' { $$ = create_node("TRANSMITIR_RETURN", NULL, 1, $2); }
    | KW_RETURN ';' { $$ = create_node("TRANSMITIR_RETURN_VOID", NULL, 0); }
    ;

block:
    '{' stmt_list '}' { $$ = create_node("BLOCK", NULL, 1, $2); }
    ;

type:
    KW_INT { $$ = create_node("TYPE", "astro", 0); }
    | KW_FLOAT { $$ = create_node("TYPE", "nebula", 0); }
    | KW_VOID { $$ = create_node("TYPE", "vacuo", 0); }
    ;

var_declaration:
    KW_VAR type ID ';' {
        ASTNode *id = create_node("ID", $3, 0);
        $$ = create_node("SINAL_VAR", NULL, 2, $2, id);
    }
    | KW_VAR type ID '=' expression ';' {
        ASTNode *id = create_node("ID", $3, 0);
        ASTNode *init = create_node("INIT", NULL, 2, id, $5);
        $$ = create_node("SINAL_VAR_INIT", NULL, 2, $2, init);
    }
    | KW_ARRAY type ID '[' NUM_INT ']' ';' {
        ASTNode *id = create_node("FROTA_ARRAY_ID", $3, 0);
        ASTNode *size = create_node("SIZE", $5, 0);
        $$ = create_node("SINAL_ARRAY", NULL, 3, $2, id, size);
    }
    ;

func_declaration:
    KW_FUNC type ID '(' params ')' block {
        ASTNode *id = create_node("FUNC_ID", $3, 0);
        $$ = create_node("PROPULSOR_FUNC", NULL, 4, $2, id, $5, $7);
    }
    ;

params:
    param_list { $$ = $1; }
    | /* vazio */ { $$ = create_node("PARAMS", "vacuo", 0); }
    ;

param_list:
    param_list ',' param { $$ = create_node("PARAM_LIST", NULL, 2, $1, $3); }
    | param { $$ = $1; }
    ;

param:
    type ID { 
        ASTNode *id = create_node("ID", $2, 0);
        $$ = create_node("PARAM", NULL, 2, $1, id); 
    }
    ;

expression:
    ID '=' expression {
        ASTNode *id = create_node("ID", $1, 0);
        $$ = create_node("ASSIGN", NULL, 2, id, $3);
    }
    | ID '[' expression ']' '=' expression {
        ASTNode *id = create_node("ARRAY_ACCESS", $1, 0);
        $$ = create_node("ASSIGN_ARRAY", NULL, 3, id, $3, $6);
    }
    | simple_expression { $$ = $1; }
    ;

simple_expression:
    additive_expression rel_op additive_expression { $$ = create_node("COMPARISON", NULL, 3, $1, $2, $3); }
    | additive_expression { $$ = $1; }
    ;

rel_op:
    '<' { $$ = create_node("OP", "<", 0); }
    | '>' { $$ = create_node("OP", ">", 0); }
    | REL_EQ { $$ = create_node("OP", "==", 0); }
    | REL_NE { $$ = create_node("OP", "!=", 0); }
    | REL_LE { $$ = create_node("OP", "<=", 0); }
    | REL_GE { $$ = create_node("OP", ">=", 0); }
    ;

additive_expression:
    additive_expression '+' term { $$ = create_node("ADD", NULL, 2, $1, $3); }
    | additive_expression '-' term { $$ = create_node("SUB", NULL, 2, $1, $3); }
    | term { $$ = $1; }
    ;

term:
    term '*' factor { $$ = create_node("MULT", NULL, 2, $1, $3); }
    | term '/' factor { $$ = create_node("DIV", NULL, 2, $1, $3); }
    | term '%' factor { $$ = create_node("MOD", NULL, 2, $1, $3); }
    | factor { $$ = $1; }
    ;

factor:
    '(' expression ')' { $$ = $2; }
    | ID { $$ = create_node("ID", $1, 0); }
    | ID '[' expression ']' {
        ASTNode *id = create_node("ARRAY_ACCESS", $1, 0);
        $$ = create_node("ARRAY_USE", NULL, 2, id, $3);
    }
    | NUM_INT { $$ = create_node("NUM_INT", $1, 0); }
    | NUM_FLOAT { $$ = create_node("NUM_FLOAT", $1, 0); }
    | call { $$ = $1; }
    ;

call:
    ID '(' args ')' {
        ASTNode *id = create_node("CALL_ID", $1, 0);
        $$ = create_node("FUNC_CALL", NULL, 2, id, $3);
    }
    ;

args:
    arg_list { $$ = $1; }
    | /* vazio */ { $$ = NULL; }
    ;

arg_list:
    arg_list ',' expression { $$ = create_node("ARG_LIST", NULL, 2, $1, $3); }
    | expression { $$ = $1; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro sintático na linha %d: %s\n", line, s);
}

int main() {
    return yyparse();
}
