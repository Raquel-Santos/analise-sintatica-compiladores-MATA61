# Trabalho 2 – Analisador Sintático da OrbitLang

## 1. Objetivo do Trabalho
O objetivo deste trabalho é desenvolver um analisador sintático utilizando Flex e Bison para a linguagem OrbitLang, criada no Trabalho 1 de MATA61.

## 2. Características da Linguagem OrbitLang
A OrbitLang, inspirada na missão espacial Artemis II da NASA, possui a temática espacial e atende aos requisitos propostos pela disciplina.

### 2.1 Paradigma
A linguagem é:
- Imperativa
- Compatível com ASCII
- Fortemente tipada
- Tipagem estática

### 2.2 Tipos de dados

  |**Tipo**|**Palavra Reservada**|**Descrição**|
  |-|-|-|   
  |Inteiro|astro|Valores inteiros|   
  |Float|nebula|Valores de ponto flutuante|
  |Void|vacuo|Funções sem retorno|

### 2.3 Declaração de Variáveis

Exemplo:
```
sinal astro velocidade = 100;
```
Significado:
```
tipo: astro
nome: velocidade
valor inicial: 100
```

### 2.4 Declaração de Vetores

Exemplo:
```
frota astro sensores[10];
```
Significado:
```
vetor de inteiros
10 posições
```

### 2.5 Estrutura Condicionais

Simples:
```
eclipse velocidade > 50{
}
```
Composta:
```
eclipse velocidade > 50{
}supernova{
}
```

### 2.6 Estrutura de Repetição

While:
```
orbitar energia > 0{
}
```
For:
```
trajetoria i em 0 ate 10 passo 1{
}
```

### 2.7 Funções

Exemplo:
```
propulsor astro soma(
    astro a,
    astro b
)
{
  transmitir a+b;
}
```

## 3. Estrutura Gerak do Projeto
O projeto foi dividido em quatro arquivos:

- orbit.l
- orbit.y
- ast.h
- ast.c

### 3.1 orbit.l
Responsável pela análise léxica.

Funções:
- Reconhecer palavras reservadas
- Reconhecer números
- Reconhecer Identificadores
- Reconhercer Operadores
- Reconhecer Delimitadores
- Ignorar Comentários
- Enviar tokens para o Bison

### 3.2 orbit.y
Responsável pela análise sintática.

Funções:
- Validar a gramática
- Verificar a estrutura do programa
- Construir a AST

### 3.3 ast.h
Responsável por definir a estrutura da AST.

### 3.4 ast.c
Responsável por implementar:

- Criação dos nós
- Ligação entre nós
- Impressão da árvore
- Liberação de memória

## 4. Projeto da AST

### 4.1 Objetivo
Representar a estrutura lógica do programa reconhecido.

Exemplo:

- Código:
```
sinal astro velocidade = 100;
```

- Árvore:
```
DECL_VAR
├── TIPO(astro)
├── ID(velocidade)
└── INT(100)
```

### 4.2 Estrutura Escolhida
Foi adotada a técnica: 

```
Child-Sibling
```

### 4.3 Estrutura do nó
Arquivo:

```
ast.h
```

```
typedef struct ASTNode {

    char *label;

    struct ASTNode *child;

    struct ASTNode *sibling;

} ASTNode;
```

### 4.4 Significado dos Campos
**label**

Texto armazenado no nó.

Exemplo:

```
PROGRAMA

IF

ID(velocidade)

INT(100)
```

**child**
Primeiro filho do nó.

**sibling**
Próximo irmão do nó.

### 4.5 Justificativa
Essa representação foi escolhida porque:

- Consome pouca memória
- Permite número variável de filhos
- É simples de implementar no Bison

## 5. Implementação da AST
Arquivo:

```
ast.c
```

## 5.1 createNode()
Objetivo: Criar um novo nó.

Exemplo:

```
ASTNode *node =
    createNode("PROGRAMA");
```

## 5.2 addChild()
Objetivo: Adicionar filhos a um nó.

Exemplo:

```
addChild(decl, tipo);
addChild(decl, id);
addChild(decl, valor);
```

Resultado:

```
DECL_VAR
├── TIPO
├── ID
└── INT
```

## 5.3 printAST()
Objetivo: Exibir a árvore.

Exemplo:
```
PROGRAMA
  DECL_VAR
     TIPO(astro)
     ID(velocidade)
     INT(100)
```

## 5.4 freeAST()
Objetivo: Liberar toda a memória utilizada.

## 6. Especificação da Gramática

### 6.1 Programa
```
PROGRAMA ::= orbitA
    {
        lista_comandos
        decolar
    }
  
```

### 6.2 Lista de Comandos
```
lista_comandos ::= comando
lista_comandos ::= lista_comandos comando  
```

### 6.3 Comandos
```
comando ::= declaracao
comando ::= atribuicao
comando ::= if_stmt
comando ::= while_stmt
comando ::= for_stmt
comando ::= funcao
comando ::= retorno
```

### 6.4 Declaração de Variável
```
sinal astro velocidade = 100;
```

Produção:

```
declaracao ::= sinal tipo ID
            =
            expressao
            ;
```

### 6.5 Declaração de Vetor
```
frota astro sensores[10];
```

Produção:

```
declaracao ::= frota tipo ID
            [
                ID
            ]
            ;
```

### 6.6 Atribuição
```
velocidade = velocidade + 10;
```

Produção:

```
atribuicao  ::= ID
                =
                expressao
                ;           
```

### 6.7 Expressões
```
a+b
a-b
a*b
a/b
a%b
```

Produção:

```
expressao ::= expressao + expressao
expressao ::= expressao - expressao
expressao ::= expressao * expressao
expressao ::= expressao / expressao
expressao ::= expressao % expressao  
```

### 6.8 Comparações
```
==
!=
<
>
<=
>=
```


### 6.9 if
```
eclipse comparacao bloco
```

### 6.10 if else
```
eclipse comparacao bloco
supernova bloco
```

### 6.11 while
```
orbitar comparacao bloco
```

### 6.12 for
```
trajetoria i em 0 ate 10 passo 1
```

### 6.12 Funções
```
propulsor astro soma(
    astro a,
    astro b
)
{
}
```

### 6.13 Chamada de Funções
```
soma(10,20)
```

### 6.14 Retorno
```
transmitir resultado;
```

## 7. Implementação do Lexer (orbit.l)
O analisador léxico foi adaptado do Trabalho 1.

**Alteração principal:**

- Antes:
```
PRINT_TOKEN("KW_IF");
```

- Depois:
```
return KW_IF;
```

**Explicação:**
O Flen não imprime mais os tokens, ou seja, agora ele envia os tokens para o Bison.

**Uso do yylval:**
Identificadores e números precisam enviar seus valores.
- Exemplo:
```
yylval.str = strdup(yytext);
return ID;
```

## 8. Estrutura Esperada da AST
Exemplo:

- Código:
```
sinal astro velocidade = 100;
```

- Árvore:
```
DECL_VAR
├── TIPO(astro)
├── ID(velocidade)
└── INT(100)
```

- Código:
```
eclipse velocidade > 50{
}
```

- Árvore:
```
IF
├── >
│ ├── ID(velocidade)
│ └── INT(50)
└── BLOCO
```
