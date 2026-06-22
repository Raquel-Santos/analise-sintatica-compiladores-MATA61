# Documentação do Trabalho 2 – Analisador Sintático da Linguagem OrbitLang

## 1. Introdução

O objetivo deste trabalho foi desenvolver um analisador sintático para a linguagem OrbitLang utilizando a ferramenta Bison, integrado ao analisador léxico desenvolvido anteriormente com Flex no trabalho 1.

A linguagem OrbitLang foi criada especificamente para este trabalho e possui temática espacial inspirada na missão espacial Artemis II. A linguagem atende aos requisitos propostos nos requisitos do trabalho, permitindo a declaração de variáveis, vetores, funções, estruturas condicionais, estruturas de repetição e expressões aritméticas.

Além da análise sintática, foi implementada a geração automática de uma Árvore Sintática Abstrata (AST), permitindo visualizar a estrutura hierárquica do programa analisado.

---

## 2. Compilação e Execução

### 2.1 Dependências

Para compilar o projeto é necessário possuir as seguintes ferramentas instaladas:

- Flex
- Bison
- GCC

### 2.2 Estrutura dos Arquivos
parser.y
cosmoScript.l
parser.tab.h
parser.tab.c

Onde:

- **parser.y**: analisador sintático desenvolvido com Bison;
- **CosmoScript.l**: analisador léxico desenvolvido com Flex;
- **parser.tab.h**: definição das estruturas da AST;
- **parser.tab.c**: implementação das operações da AST.

### 2.3 Geração do Parser

````
bison -d parser.y
````
Arquivos gerados:

parser.tab.c
parser.tab.h

### 2.4 Geração do Scanner Léxico

````
flex cosmoScript.l
````
Arquivo gerado:

lex.yy.c

### 2.5 Compilação
````
gcc parser.tab.c lex.yy.c -o cosmoScript
````
Executável gerado:

cosmoScript

### 2.6 Execução
````
./cosmoScript < programa.cosmo
````
Exemplo:
````
./cosmoScript < teste1.cosmo
````

---

## 3. Alterações em Relação ao Trabalho 1

No Trabalho 1 foi implementado apenas o analisador léxico.

No Trabalho 2 foram adicionados:

- Regras sintáticas utilizando Bison;
- Controle de precedência entre operadores;
- Estruturas condicionais;
- Estruturas de repetição;
- Definição de funções;
- Chamada de funções;
- Construção automática da AST;
- Impressão da árvore sintática.

As palavras reservadas e os tokens definidos anteriormente foram mantidos.

---

## 4. Características da Linguagem OrbitLang

### 4.1 Paradigma

A linguagem é:

- Imperativa;
- Compatível com ASCII;
- Fortemente tipada;
- Tipagem estática.

### 4.2 Tipos de Dados

|**Tipo**|**Palavra Reservada**|**Descrição**|
|-|-|-|
|Inteiro| astro| Valores inteiros|
|Float| nebula| Valores de ponto flutuante|
|Void| vacuo| Funções sem retorno|

**Conclusão:**

Os tipos implementados permitem manipular valores numéricos e definir funções com ou sem retorno.

### 4.3 Declaração de Variáveis

**Exemplo:**

````
sinal astro velocidade = 100;
````

**Significado:**

- **sinal**: declaração de variável;
- **astro**: tipo inteiro;
- **velocidade**: identificador;
- **100**: valor inicial.

**Conclusão:**

A linguagem permite declaração e inicialização de variáveis com tipagem estática.

### 4.4 Declaração de Vetores

**Exemplo:**
````
frota astro sensores[10];
````

**Significado:**

- vetor do tipo inteiro;
- identificador "sensores";
- capacidade para 10 elementos.

**Conclusão:**

Os vetores permitem armazenar múltiplos valores do mesmo tipo.

### 4.5 Estruturas Condicionais

**Condicional simples:**

````
eclipse velocidade > 50 {
}
````

**Condicional composta:**

````
eclipse velocidade > 50 {
}
supernova {
}
````
**Conclusão:**

As estruturas condicionais permitem a tomada de decisões durante a execução do programa.

### 4.6 Estruturas de Repetição

**While:**
````
orbitar energia > 0 {
}
````
**For:**
````
trajetoria i em 0 ate 10 passo 1 {
}
````
**Conclusão:**

As estruturas de repetição permitem executar comandos diversas vezes de forma controlada.

### 4.7 Funções
````
propulsor astro soma(astro a, astro b)
{
    transmitir a + b;
}
````
**Conclusão:**

As funções permitem modularizar o código e reutilizar funcionalidades.

---

## 5. Estrutura Geral do Projeto

O projeto foi dividido em quatro módulos principais:

- parser.y
- cosmoScript.l
- parser.tab.h
- parser.tab.c

### 5.1 cosmoScript.l

Responsável pela análise léxica.

**Principais Funções:**

- Reconhecer palavras reservadas;
- Reconhecer identificadores;
- Reconhecer números inteiros;
- Reconhecer números float;
- Reconhecer operadores aritméticos;
- Reconhecer operadores de comparação;
- Reconhecer delimitadores;
- Ignorar comentários;
- Ignorar espaços em branco;
- Enviar tokens para o Bison.

**Conclusão:**

O arquivo "cosmoScript.l" converte o código-fonte em uma sequência de tokens.

### 5.2 parser.y

Responsável pela análise sintática.

**Principais Funções:**

- Definir a gramática da linguagem;
- Validar a estrutura dos programas;
- Construir a AST;
- Detectar erros sintáticos.

**Conclusão:**

O arquivo "parser.y" garante que os programas sigam as regras sintáticas da linguagem.

### 5.3 parser.tab.h

Responsável por definir a estrutura da AST.

**Principais Funções:**

- Definir os nós da AST;
- Declarar as funções de manipulação da árvore.

## 5.4 parser.tab.c

**Responsável por implementar:**

- Criação dos nós;
- Inserção de filhos;
- Impressão da AST;
- Liberação de memória.

**Conclusão:**

Os arquivos "parser.tab.h" e "parser.tab.c" implementam toda a infraestrutura da árvore sintática.

---

## 6. Estrutura da AST

A AST foi implementada utilizando uma estrutura dinâmica composta por:

- Tipo do nó;
- Valor associado ao nó;
- Vetor de filhos;
- Quantidade de filhos.

````
typedef struct ASTNode {
    char *type;
    char *value;
    struct ASTNode **children;
    int child_count;
} ASTNode;
````
**Exemplos de nós:**

- MAIN_BLOCK
- SINAL_VAR
- SINAL_ARRAY
- ASSIGN
- ECLIPSE_IF
- ORBITAR_WHILE
- TRAJETORIA_FOR
- PROPULSOR_FUNC
- FUNC_CALL
- TRANSMITIR_RETURN

**Conclusão:**

A estrutura adotada facilita a representação hierárquica dos programas.

---

## 7. Gramática Principal

Regra inicial:
```
program ::= main_block
```

Bloco principal:
```
main_block ::= orbitA { stmt_list } decolar
```

Todo programa deve possuir:

- Palavra inicial "orbitA";
- Lista de comandos;
- Palavra final "decolar".

**Conclusão:**

Essa regra define a estrutura básica de qualquer programa OrbitLang.

---

## 8. Regras de Produção e Justificativas

### 8.1 Declaração de Variáveis
```
sinal tipo identificador ;
```
**Justificativa:**

Permite criar variáveis com tipagem estática.

### 8.2 Declaração de Vetores
```
frota tipo identificador [ tamanho ];
```
**Justificativa:**

Permite armazenar coleções de valores do mesmo tipo.

### 8.3 Atribuições

Exemplos:
```
velocidade = 100;
sensores[2] = 50;
```
**Justificativa:**

Permite modificar variáveis e elementos de vetores.

### 8.4 Expressões Aritméticas

**Operadores implementados:**
```
+
-
*
/
%
```
**Precedência:**

1. Multiplicação, divisão e módulo;
2. Soma e subtração.

**Justificativa:**

Evita ambiguidades sintáticas.

### 8.5 Operadores de Comparação
```
<
>
==
!=
<=
>=
```

**Justificativa:**

São utilizados em estruturas condicionais e de repetição.

### 8.6 Estruturas Condicionais

**Palavras reservadas:**

`
eclipse
supernova
`

**Justificativa:**

Permitem tomada de decisão simples e composta.

### 8.7 Estruturas de Repetição

**Palavras reservadas:**

`
orbitar
trajetoria
`

**Justificativa:**

Permitem repetição condicional e controlada.

### 8.8 Funções

**Palavra reservada:**

`
propulsor
`

**Justificativa:**

Permite modularização do código.

### 8.9 Retorno

**Palavra reservada:**

`
transmitir
`

**Justificativa:**

Permite retornar valores de funções.

---

## 9. Exemplo de Árvore Sintática

**Código:**
```
sinal astro velocidade = 100;
```

**AST:**
```
SINAL_VAR_INIT
├── TYPE(astro)
├── ID(velocidade)
└── NUM_INT(100)
```
---

## 10. Tratamento de Erros

Foi implementada a função:

`
yyerror()
`

Responsável por informar erros sintáticos encontrados durante a análise.

**Exemplo:**

`
Erro sintático na linha 12
`

**Conclusão:**

O tratamento de erros permite identificar rapidamente problemas sintáticos.

---

## 11. Conclusão

O analisador sintático da linguagem OrbitLang foi desenvolvido utilizando Flex e Bison, atendendo aos requisitos estabelecidos pela disciplina.

A linguagem implementa variáveis, vetores, expressões aritméticas, estruturas condicionais, estruturas de repetição e funções com parâmetros e retorno tipado.

Além disso, a construção automática da AST permite visualizar a estrutura sintática dos programas analisados, servindo como base para futuras etapas de um compilador.
