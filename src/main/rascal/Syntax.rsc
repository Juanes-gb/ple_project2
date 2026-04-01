module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] 
                             | @category="Comment" "#" ![\n]* $;


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


syntax SpaceDef 
    = spaceDef:
      'defspace' ID name
      ("\<" ID parent)?
      'end'
;

syntax OperatorDef
    = operatorDef:
      'defoperator' OperatorName name
      ':' Type typ
      Attributes? attrs
      'end'
;

syntax Attributes
    = attributes: "[" AttributeItem+ "]"
;

syntax AttributeItem
    = attrSimple: OperatorName name
    | attrValued: OperatorName name ":" AttributePayload payload
;

syntax AttributePayload
    = payloadType: Type
    | payloadEmpty: "∅"
    | payloadId:    ID
;

syntax VarDef
    = varDef:
      'defvar' {VarDecl ","}+ decls
      'end'
;

syntax VarDecl
    = varDecl: ID name ':' ID typ
;

syntax RuleDef
    = ruleDef:
      'defrule' Expr lhs
      "-\>" Expr rhs
      'end'
;

syntax ExpressionDef
    = exprDef:
      'defexpression' Expr body
      'end'
;

syntax OperatorName
    = opId:     ID
    | opSymbol: OperatorLiteral
;

syntax Type
    = simpleType: ID
    > arrowType:  ID "-\>" Type
;

syntax Expr
    = equiv:   Expr "≡" Expr
    > implies: Expr "=\>" Expr
    > or:      Expr 'or'  Expr
    > and:     Expr 'and' Expr
    > neg:     'neg' Expr
    > infix:   Expr InfixOp Expr
    > application: '(' OperatorName op Expr+ args ')'
    | quant:   QuantifiedExpr
    | identifier:      ID
    | group:   '(' Expr ')'
;


syntax QuantifiedExpr
    = quantExpr:
      '(' Quantifier ID 'in' ID '.' Expr ')'
;

syntax Quantifier
    = forall: 'forall'
    | exists: 'exists'
;

syntax InfixOp
    = infixOp:  OperatorLiteral
    | infixId:  ID
    | infixIn:  'in'
    | infixEq:  "="
    | infixLt:  "\<"
    | infixLe:  "\<="
    | infixGt:  "\>"
    | infixGe:  "\>="
    | infixNe:  "\<\>"
;

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

lexical ID = ([a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-]) \ Reserved;

keyword Reserved =
    'defmodule' | 'using'  | 'defspace'     | 'defoperator' |
    'defvar'    | 'end'    | 'defrule'      | 'defexpression' |
    'forall'    | 'exists' | 'in'           | 'and' |
    'or'        | 'neg'    | 'defer'
;