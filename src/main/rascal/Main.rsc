module Main

import AST;
import Implode;
import Generator;
import TypeChecker;
import IO;
import List;

void main() {
    loc input = |project://ple_project2/instance/fullProgram.vl|;
    loc output = |project://ple_project2/instance/output/fullProgram.txt|;

    Module m = loadModule(input);
    list[str] errors = checkModule(m);

    if (size(errors) == 0) {
        str result = generateModule(m);

        writeFile(output, result);

        println("Parsed successfully: <m.name>");
        println("Type check successful.");
        println("No semantic errors found.");
        println("Output generated at: <output>");
    }
    else {
        println("Parsed successfully: <m.name>");
        println("Type check failed.");
        println("Semantic errors found:");

        for (error <- errors) {
            println(" - <error>");
        }

        println("Output was not generated because the program has semantic errors.");
    }
}

