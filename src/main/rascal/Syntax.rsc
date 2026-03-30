module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

start syntax Module 
    = moduleDef: 'defmodule' ID name Import* imports ModuleItem* items 'end'
;

syntax Import 
    = importDef: 'using' ID name
;

syntax ModuleItem 
    = spaceItem: SpaceDef space
;

syntax SpaceDef 
    = spaceDef: 'defspace' ID name 'end'
;

lexical ID = ([a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-]) \ Reserved;
keyword Reserved = "defmodule" | "using" | "defspace" | "end";