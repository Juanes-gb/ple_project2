module RunnerJson

import IO;
import List;
import String;

import AST;
import Implode;
import TypeChecker;
import Generator;

void main(list[str] args) {
    if (size(args) == 0) {
        printJson(runOnFile(|project://ple_project4/instance/fullProgram.vl|));
    } else {
        printJson(runOnFile(toLocation(args[0])));
    }
}

loc toLocation(str path) {
    return |file:///| + path;
}

void printJson(map[str, value] result) {
    str json = buildJson(result);
    println(json);
}

str buildJson(map[str, value] m) {
    list[str] parts = [];

    for (str k <- m) {
        value v = m[k];
        parts += ["\"<k>\": <toJsonValue(v)>"];
    }

    return "{\n" + intercalate(",\n", parts) + "\n}";
}

str toJsonValue(bool b)       = b ? "true" : "false";
str toJsonValue(str s)        = "\"<escapeJson(s)>\"";
str toJsonValue(list[str] ls) = "[" + intercalate(", ", ["\"<escapeJson(x)>\"" | x <- ls]) + "]";
str toJsonValue(value v)      = "\"<v>\"";

str escapeJson(str s) {
    str r = s;
    r = replaceAll(r, "\\", "\\\\");
    r = replaceAll(r, "\"", "\\\"");
    r = replaceAll(r, "\n", "\\n");
    r = replaceAll(r, "\r", "\\r");
    r = replaceAll(r, "\t", "\\t");
    return r;
}

map[str, value] runOnFile(loc input) {
    try {
        Module m = loadModule(input);
        list[str] errors = checkModule(m);
        bool ok = size(errors) == 0;

        str moduleName = "";
        switch (m) {
            case moduleDef(name, _, _): moduleName = name;
        }

        list[str] outputLines = [];
        if (ok) {
            str generated = generateModule(m);
            outputLines = split("\n", generated);
        }

        return (
            "success"      : ok,
            "parseOk"      : true,
            "typeCheckOk"  : ok,
            "semanticOk"   : ok,
            "module"       : moduleName,
            "semanticErrors": errors,
            "typeErrors"   : [],
            "output"       : outputLines,
            "error"        : "",
            "codigoFormateado": ok ? generateModule(m) : "",
            "resumen"      : "Module: <moduleName> | Items: <countItems(m)>"
        );
    } catch e: {
        return (
            "success"      : false,
            "parseOk"      : false,
            "typeCheckOk"  : false,
            "semanticOk"   : false,
            "module"       : "",
            "semanticErrors": [],
            "typeErrors"   : [],
            "output"       : [],
            "error"        : "Parse error: <e>",
            "codigoFormateado": "",
            "resumen"      : ""
        );
    }
}

int countItems(moduleDef(_, _, items)) = size(items);
