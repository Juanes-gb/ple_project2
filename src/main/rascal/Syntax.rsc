module Syntax

layout Layout = [\ \t\n\r]*;

lexical ID = [a-zA-Z][a-zA-Z0-9\-]*;

start syntax Module
    = "defmodule" ID Import* "end"
    ;

syntax Import
    = "using" ID
    ;

