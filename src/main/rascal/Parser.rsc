module Parser

import Syntax;
import AST;
import ParseTree;

start[Module] parseFile(loc file)
    = parse(#start[Module], file, allowAmbiguity=true);

start[Module] parseString(str src)
    = parse(#start[Module], src, allowAmbiguity=true);

