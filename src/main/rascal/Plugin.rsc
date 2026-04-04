module Plugin

import IO;
import ParseTree;
import util::Reflective;
import util::IDEServices;
import util::LanguageServer;

import Syntax;

PathConfig pcfg = pathConfig(srcs=[|file:///Users/juanestebangarciabonilla/ple_project2/src/main/rascal|]);
Language verilangLang = language(pcfg, "Verilang", "veri", "Plugin", "contribs");

set[LanguageService] contribs() = {
    parser(start[Module] (str program, loc src) {
        return parse(#start[Module], program, src, allowAmbiguity=true);
    })
};

void main() {
    registerLanguage(verilangLang);
}

