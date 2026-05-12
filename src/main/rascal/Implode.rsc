module Implode

import Syntax;
import Parser;
import AST;
import ParseTree;
import Set;

bool isApplicationTree(Tree t) {
    bool result = false;

    switch (t) {
        case appl(prod(label("application", sort("Expr")), _, _), _): {
            result = true;
        }
        default: {
            result = false;
        }
    }

    return result;
}

Tree chooseAmbAlternative(set[Tree] alts) {
    Tree selected = getOneFrom(alts);
    bool foundApplication = false;

    for (Tree t <- alts) {
        if (isApplicationTree(t) && !foundApplication) {
            selected = t;
            foundApplication = true;
        }
    }

    return selected;
}

Tree filterAmb(amb(set[Tree] alts)) {
    Tree selected = chooseAmbAlternative(alts);
    return selected;
}

default Tree filterAmb(Tree t) = t;

public Module loadModule(loc l) {
    Tree pt = parseFile(l).top;
    Tree filtered = visit(pt) {
        case Tree t => filterAmb(t)
    };

    return implode(#Module, filtered);
}

