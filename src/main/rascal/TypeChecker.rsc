module TypeChecker

import IO;
import List;
import String;

import AST;

list[str] checkModule(Module m) {
    set[str] knownTypes = collectKnownTypes(m);
    set[str] knownSpaces = collectKnownSpaces(m);
    set[str] knownVars = collectKnownVars(m);
    set[str] knownOperators = collectKnownOperators(m);

    list[str] errors = [];

    switch (m) {
        case moduleDef(name, imports, items): {
            for (item <- items) {
                errors += checkItem(item, knownTypes, knownSpaces, knownVars, knownOperators);
            }
        }
    }

    return errors;
}

void printCheckResult(Module m) {
    list[str] errors = checkModule(m);

    if (size(errors) == 0) {
        println("Type check successful.");
        println("No semantic errors found.");
    }
    else {
        println("Type check failed.");
        println("Semantic errors found:");

        for (error <- errors) {
            println(" - <error>");
        }
    }
}

bool isValidModule(Module m) {
    list[str] errors = checkModule(m);
    return size(errors) == 0;
}

set[str] collectKnownTypes(Module m) {
    set[str] knownTypes = {"Int", "Bool", "Char", "String"};

    switch (m) {
        case moduleDef(name, imports, items): {
            knownTypes += {name};

            for (imp <- imports) {
                knownTypes += collectTypeFromImport(imp);
            }

            for (item <- items) {
                knownTypes += collectTypeFromItem(item);
            }
        }
    }

    return knownTypes;
}

set[str] collectTypeFromImport(importDef(name)) {
    return {name};
}

set[str] collectTypeFromItem(spaceItem(spaceDef(name, typ, parent))) {
    return {name};
}

set[str] collectTypeFromItem(spaceItem(spaceDefNoParent(name, typ))) {
    return {name};
}

set[str] collectTypeFromItem(operatorItem(op)) {
    return {};
}

set[str] collectTypeFromItem(varItem(var)) {
    return {};
}

set[str] collectTypeFromItem(ruleItem(rule)) {
    return {};
}

set[str] collectTypeFromItem(expressionItem(expr)) {
    return {};
}

set[str] collectKnownSpaces(Module m) {
    set[str] knownSpaces = {};

    switch (m) {
        case moduleDef(name, imports, items): {
            for (item <- items) {
                knownSpaces += collectSpaceFromItem(item);
            }
        }
    }

    return knownSpaces;
}

set[str] collectSpaceFromItem(spaceItem(spaceDef(name, typ, parent))) {
    return {name};
}

set[str] collectSpaceFromItem(spaceItem(spaceDefNoParent(name, typ))) {
    return {name};
}

set[str] collectSpaceFromItem(operatorItem(op)) {
    return {};
}

set[str] collectSpaceFromItem(varItem(var)) {
    return {};
}

set[str] collectSpaceFromItem(ruleItem(rule)) {
    return {};
}

set[str] collectSpaceFromItem(expressionItem(expr)) {
    return {};
}

set[str] collectKnownVars(Module m) {
    set[str] knownVars = {};

    switch (m) {
        case moduleDef(name, imports, items): {
            for (item <- items) {
                knownVars += collectVarFromItem(item);
            }
        }
    }

    return knownVars;
}

set[str] collectVarFromItem(varItem(varDef(decls))) {
    set[str] vars = {};

    for (decl <- decls) {
        vars += collectVarFromDecl(decl);
    }

    return vars;
}

set[str] collectVarFromItem(spaceItem(space)) {
    return {};
}

set[str] collectVarFromItem(operatorItem(op)) {
    return {};
}

set[str] collectVarFromItem(ruleItem(rule)) {
    return {};
}

set[str] collectVarFromItem(expressionItem(expr)) {
    return {};
}

set[str] collectVarFromDecl(varDecl(name, typ)) {
    return {name};
}

set[str] collectKnownOperators(Module m) {
    set[str] knownOperators = {};

    switch (m) {
        case moduleDef(name, imports, items): {
            for (item <- items) {
                knownOperators += collectOperatorFromItem(item);
            }
        }
    }

    return knownOperators;
}

set[str] collectOperatorFromItem(operatorItem(operatorDef(name, typ, attrs))) {
    return {operatorNameToString(name)};
}

set[str] collectOperatorFromItem(spaceItem(space)) {
    return {};
}

set[str] collectOperatorFromItem(varItem(var)) {
    return {};
}

set[str] collectOperatorFromItem(ruleItem(rule)) {
    return {};
}

set[str] collectOperatorFromItem(expressionItem(expr)) {
    return {};
}

str operatorNameToString(opId(name)) {
    return name;
}

str operatorNameToString(opSymbol(symbol)) {
    return symbol;
}

list[str] checkItem(spaceItem(spaceDef(name, typ, parent)), set[str] knownTypes, set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkType(typ, knownTypes);

    if (!(parent in knownSpaces)) {
        errors += ["Undefined parent space: <parent>"];
    }

    return errors;
}

list[str] checkItem(spaceItem(spaceDefNoParent(name, typ)), set[str] knownTypes, set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkType(typ, knownTypes);

    return errors;
}

list[str] checkItem(operatorItem(operatorDef(name, typ, attrs)), set[str] knownTypes, set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkType(typ, knownTypes);
    errors += checkAttributes(attrs, knownTypes);

    return errors;
}

list[str] checkItem(varItem(varDef(decls)), set[str] knownTypes, set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    for (decl <- decls) {
        errors += checkVarDecl(decl, knownTypes);
    }

    return errors;
}

list[str] checkItem(ruleItem(ruleDef(lhs, rhs)), set[str] knownTypes, set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkExpr(lhs, knownSpaces, knownVars, knownOperators);
    errors += checkExpr(rhs, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkItem(expressionItem(exprDef(body)), set[str] knownTypes, set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkExpr(body, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkVarDecl(varDecl(name, typ), set[str] knownTypes) {
    list[str] errors = [];

    errors += checkType(typ, knownTypes);

    return errors;
}

list[str] checkAttributes(list[Attributes] attrsList, set[str] knownTypes) {
    list[str] errors = [];

    for (attrs <- attrsList) {
        errors += checkSingleAttributes(attrs, knownTypes);
    }

    return errors;
}

list[str] checkSingleAttributes(attributes(items), set[str] knownTypes) {
    list[str] errors = [];

    for (item <- items) {
        errors += checkAttributeItem(item, knownTypes);
    }

    return errors;
}

list[str] checkAttributeItem(attrSimple(name), set[str] knownTypes) {
    return [];
}

list[str] checkAttributeItem(attrValued(name, payload), set[str] knownTypes) {
    list[str] errors = [];

    errors += checkAttributePayload(payload, knownTypes);

    return errors;
}

list[str] checkAttributePayload(payloadType(t), set[str] knownTypes) {
    return checkType(t, knownTypes);
}

list[str] checkAttributePayload(payloadEmpty(), set[str] knownTypes) {
    return [];
}

list[str] checkAttributePayload(payloadId(name), set[str] knownTypes) {
    return [];
}

list[str] checkType(simpleType(name), set[str] knownTypes) {
    list[str] errors = [];

    if (!(name in knownTypes)) {
        errors += ["Undefined type: <name>"];
    }

    return errors;
}

list[str] checkType(paramType(name, inner), set[str] knownTypes) {
    list[str] errors = [];

    if (!(name in knownTypes)) {
        errors += ["Undefined parameterized type: <name>"];
    }

    errors += checkType(inner, knownTypes);

    return errors;
}

list[str] checkType(arrowType(from, to), set[str] knownTypes) {
    list[str] errors = [];

    errors += checkType(from, knownTypes);
    errors += checkType(to, knownTypes);

    return errors;
}

list[str] checkExpr(identifier(name), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    if (!(name in knownVars) && !(name in knownSpaces)) {
        errors += ["Undefined identifier: <name>"];
    }

    return errors;
}

list[str] checkExpr(application(op, args), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];
    str opName = operatorNameToString(op);

    if (!(opName in knownOperators)) {
        errors += ["Undefined operator: <opName>"];
    }

    for (arg <- args) {
        errors += checkExpr(arg, knownSpaces, knownVars, knownOperators);
    }

    return errors;
}

list[str] checkExpr(neg(expr), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    return checkExpr(expr, knownSpaces, knownVars, knownOperators);
}

list[str] checkExpr(and(lhs, rhs), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkExpr(lhs, knownSpaces, knownVars, knownOperators);
    errors += checkExpr(rhs, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkExpr(or(lhs, rhs), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkExpr(lhs, knownSpaces, knownVars, knownOperators);
    errors += checkExpr(rhs, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkExpr(implies(lhs, rhs), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkExpr(lhs, knownSpaces, knownVars, knownOperators);
    errors += checkExpr(rhs, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkExpr(equiv(lhs, rhs), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    errors += checkExpr(lhs, knownSpaces, knownVars, knownOperators);
    errors += checkExpr(rhs, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkExpr(infix(lhs, op, rhs), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];

    if (!(isBuiltInInfix(op)) && !(op in knownOperators)) {
        errors += ["Undefined infix operator: <op>"];
    }

    errors += checkExpr(lhs, knownSpaces, knownVars, knownOperators);
    errors += checkExpr(rhs, knownSpaces, knownVars, knownOperators);

    return errors;
}

list[str] checkExpr(group(expr), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    return checkExpr(expr, knownSpaces, knownVars, knownOperators);
}

list[str] checkExpr(quant(q), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    return checkQuantifiedExpr(q, knownSpaces, knownVars, knownOperators);
}

list[str] checkQuantifiedExpr(quantExpr(q, var, domain, body), set[str] knownSpaces, set[str] knownVars, set[str] knownOperators) {
    list[str] errors = [];
    set[str] newVars = knownVars;

    if (!(domain in knownSpaces)) {
        errors += ["Undefined quantifier domain: <domain>"];
    }

    newVars += {var};

    errors += checkExpr(body, knownSpaces, newVars, knownOperators);

    return errors;
}

bool isBuiltInInfix(str op) {
    bool result = false;

    if (op == "=") {
        result = true;
    }
    else if (op == "\<") {
        result = true;
    }
    else if (op == "\<=") {
        result = true;
    }
    else if (op == "\>") {
        result = true;
    }
    else if (op == "\>=") {
        result = true;
    }
    else if (op == "\<\>") {
        result = true;
    }
    else if (op == "+") {
        result = true;
    }
    else if (op == "-") {
        result = true;
    }
    else if (op == "*") {
        result = true;
    }
    else if (op == "/") {
        result = true;
    }
    else if (op == "%") {
        result = true;
    }
    else if (op == "**") {
        result = true;
    }
    else if (op == "in") {
        result = true;
    }

    return result;
}

