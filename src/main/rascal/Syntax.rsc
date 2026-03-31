module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

// Minimal stable core

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
    = spaceItem: SpaceDef space
    | operatorItem: OperatorDef op
    | varItem: VarDef var
;

syntax SpaceDef 
    = spaceDef:
    'defspace' ID name
    'end'
;

syntax OperatorDef 
    = operatorDef:
    'defoperator' OperatorName name
    ':'
    Type typ
    'end'
;

syntax OperatorName 
    = opId: ID name
    | opSymbol: OperatorLiteral op
;

syntax Type 
    = simpleType: ID name
;

syntax VarDef
    = varDef:
    'defvar' VarDecl first
    (',' VarDecl)* rest
    'end'
;

syntax VarDecl
    = varDecl:
    ID name
    ':'
    ID typ
;

syntax OperatorLiteral
    = mul: "*"
    | div: "/"
    | sub: "-"
    | add: "+"
    | pow: "**"
    | eq: "="
;

lexical ID = ([a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-]) \ Reserved;
keyword Reserved = "defmodule" | "using" | "defspace" | "defoperator" | "defvar" | "end";