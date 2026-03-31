module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] 
                             | @category="Comment" "#" ![\n]* $;

// ── Módulo ────────────────────────────────────────────────

start syntax Module
    = moduleDef:
      'defmodule' ID name
      Import* imports
      ModuleItem* items
      'end'
;

syntax Import
    = importDef:
      'using' ID name
;

syntax ModuleItem
    = spaceItem:      SpaceDef
    | operatorItem:   OperatorDef
    | varItem:        VarDef
    | ruleItem:       RuleDef
    | expressionItem: ExpressionDef
;

// ── Definiciones ──────────────────────────────────────────

syntax SpaceDef
    = spaceDef:
      'defspace' ID name
      'end'
;

syntax OperatorDef
    = operatorDef:
      'defoperator' OperatorName name
      ':' Type typ
      'end'
;

syntax VarDef
    = varDef:
      'defvar' VarDecl first
      (',' VarDecl)* rest
      'end'
;

syntax VarDecl
    = varDecl: ID name ':' ID typ
;

syntax RuleDef
    = ruleDef:
      'defrule' Application lhs
      "-\>" Application rhs
      'end'
;

syntax ExpressionDef
    = exprDef:
      'defexpression' Expr body
      'end'
;

// ── Tipos ─────────────────────────────────────────────────

syntax OperatorName
    = opId:     ID
    | opSymbol: OperatorLiteral
;

syntax Type
    = simpleType: ID
    > arrowType:  ID "-\>" Type
;

// ── Expresiones (precedencia declarativa, sin "pass") ─────
//   Rascal resuelve ambigüedad con > entre alternativas.
//   Mayor prioridad = más abajo en la lista.

syntax Expr
    = equiv:   Expr "\u2261" Expr
    > implies: Expr "=\>" Expr
    > or:      Expr 'or'  Expr
    > and:     Expr 'and' Expr
    > neg:     'neg' Expr
    > infix:   Expr InfixOp Expr
    | quant:   QuantifiedExpr
    | app:     Application
    | id:      ID
    | group:   '(' Expr ')'
;

// ── Aplicación: (op arg1 arg2 ...) ───────────────────────
//   Term es lo que puede aparecer como argumento (no Expr completo
//   para evitar ambigüedad con Group y Application)

syntax Application
    = application: '(' OperatorName Arg+ ')'
;

syntax Arg
    = argId:    ID
    | argApp:   Application
    | argQuant: QuantifiedExpr
    | argGroup: '(' Expr ')'
;

// ── Expresión cuantificada ────────────────────────────────

syntax QuantifiedExpr
    = quantExpr:
      '(' Quantifier ID 'in' ID '.' Expr ')'
;

syntax Quantifier
    = forall: 'forall'
    | exists: 'exists'
;

// ── Operadores infix ──────────────────────────────────────

syntax InfixOp
    = infixOp:  OperatorLiteral
    | infixIn:  'in'
    | infixEq:  "="
    | infixLt:  "\<"
    | infixLe:  "\<="
    | infixGt:  "\>"
    | infixGe:  "\>="
    | infixNe:  "\<\>"
;

// ── Literales ─────────────────────────────────────────────

syntax OperatorLiteral
    = mul: "*"
    | div: "/"
    | sub: "-"
    | add: "+"
    | pow: "**"
//    | mod: "%"
    | lt:  "\<"
    | gt:  "\>"
    | le:  "\<="
    | ge:  "\>="
    | ne:  "\<\>"
    | eq:  "="
;

// ── Lexicals ──────────────────────────────────────────────

lexical ID = ([a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-]) \ Reserved;

keyword Reserved =
    'defmodule' | 'using'  | 'defspace'     | 'defoperator' |
    'defvar'    | 'end'    | 'defrule'      | 'defexpression' |
    'forall'    | 'exists' | 'in'           | 'and' |
    'or'        | 'neg'    | 'defer'
;