module KotlinGenerator

import IO;
import List;
import String;

import AST;
import Parser;
import Implode;
import TypeChecker;
import Generator;

void main() {
    loc input = |project://ple_project4/instance/fullProgram.vl|;
    loc output = |project://ple_project4/instance/kotlin/FullProgram.kt|;

    Module m = loadModule(input);
    list[str] errors = checkModule(m);

    if (size(errors) == 0) {
        str kotlinCode = generateKotlinProgram(m);

        writeFile(output, kotlinCode);

        println("Parsed successfully: <m.name>");
        println("Type check successful.");
        println("No semantic errors found.");
        println("Kotlin file generated at: <output>");
    }
    else {
        println("Parsed successfully: <m.name>");
        println("Type check failed.");
        println("Semantic errors found:");

        for (error <- errors) {
            println(" - <error>");
        }

        println("Kotlin file was not generated because the program has semantic errors.");
    }
}

str generateKotlinProgram(Module m) {
    return
        "fun main() {\n" +
        generateKotlinPrints(m) +
        "}\n"
    ;
}

str generateKotlinPrints(Module m) {
    str generatedText = generateModule(m);
    list[str] lines = split("\n", generatedText);

    return intercalate("", [generatePrintLine(line) | line <- lines]);
}

str generatePrintLine(str line) {
    return "    println(\"<escapeKotlinString(line)>\")\n";
}

str escapeKotlinString(str text) {
    str result = text;

    result = replaceAll(result, "\\", "\\\\");
    result = replaceAll(result, "\"", "\\\"");
    result = replaceAll(result, "$", "\\$");

    return result;
}

