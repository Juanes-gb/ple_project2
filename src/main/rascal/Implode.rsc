module Implode

import Syntax;
import Parser;
import AST;
import ParseTree;

Tree filterAmb(amb(set[Tree] alts)) {
    for (Tree t <- alts) return t;
    throw "empty amb";
}
default Tree filterAmb(Tree t) = t;

public Module loadModule(loc l) {
    Tree pt = parseFile(l).top;
    Tree filtered = visit(pt) { case Tree t => filterAmb(t) };
    return implode(#Module, filtered);
}

