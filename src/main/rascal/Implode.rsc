module Implode

import Syntax;
import Parser;
import AST;
import IO;

import ParseTree;

public Module implodeModule(Tree pt) = implode(#Module, pt);
public Module loadModule(loc l) = implode(#Module, parseFile(l));

