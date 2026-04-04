module Main

import AST;
import Implode;
import Generator;
import IO;

void main() {
    loc input = |file:///Users/juanestebangarciabonilla/ple_project2/instance/fullProgram.veri|;
    loc output = |file:///Users/juanestebangarciabonilla/ple_project2/instance/output/fullProgram.txt|;

    Module m = loadModule(input);
    str result = generateModule(m);

    writeFile(output, result);

    println("Parsed successfully: <m.name>");
    println("Output generated at: <output>");
}

