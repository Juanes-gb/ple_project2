module Main

import AST;
import Implode;
import IO;

void main() {
    loc f = |file:///Users/juanestebangarciabonilla/ple_project2/instance/fullProgram.veri|;
    Module m = loadModule(f);
    println("Parsed successfully: <m.name>");
}