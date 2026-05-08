module VeriLangTypePal

import IO;
import List;

import AST;
import Parser;
import Implode;
import TypeChecker;

import analysis::typepal::TypePal;

void printTypePalResult(loc input) {
    Module m = loadModule(input);
    list[str] errors = checkModule(m);

    if (size(errors) == 0) {
        println("TypePal integration executed successfully.");
        println("Type check successful.");
        println("No semantic errors found.");
    }
    else {
        println("TypePal integration executed with semantic errors.");
        println("Type check failed.");
        println("Semantic errors found:");

        for (error <- errors) {
            println(" - <error>");
        }
    }
}

bool isTypePalValid(loc input) {
    Module m = loadModule(input);
    list[str] errors = checkModule(m);

    return size(errors) == 0;
}

list[str] getTypePalMessages(loc input) {
    Module m = loadModule(input);
    list[str] errors = checkModule(m);

    return errors;
}

