module Generator

import IO;
import List;
import String;


import AST;
import Parser;
import Implode;

void main() {
    loc f = |file:///C:/Users/Ana%20Maria/Downloads/ple_project2/instance/test1.veri|;
    Module m = loadModule(f);
    println(generateModule(m));
}

str generateModule(moduleDef(name, imports, items)) =
    "Module: <name>\n\n" +
    generateImports(imports) +
    generateItems(items)
;

str generateImports([]) = "";
str generateImports(list[Import] imps) = "Imports:\n" +
    intercalate("", [ " - <n>\n" | importDef(n) <- imps ]) + 
    "\n"
;

str generateItems(list[ModuleItem]items) =
    intercalate("\n", [ generateItem(i) | i <- items ])
;

str generateItem(varItem(varDef(decls))) = 
    "Variables: \n" +
    intercalate("", [ " - <n>: <t>\n" | varDecl(n, t) <- decls ]) +
    "\n"
;

str generateItem(ruleItem(ruleDef(lhs, rhs))) = 
    "Rule: <generateExpr(lhs)> -\> <generateExpr(rhs)>\n\n"
;

str generateItem(spaceItem(spaceDef(name, parent))) =
    "Space: <name>\n\n"
;

str generateItem(operatorItem(operatorDef(name, typ, attrs))) = 
    "Operator: <generateOp(name)> : <generateType(typ)>"   
    + generateAttrs(attrs) + "\n\n"
;

str generateAttrs([]) = "";
str generateAttrs(list[AttributeItem] attrs) = 
    intercalate("", [ generateAttr(a) | a <- attrs ]) + "\n"
;

str generateAttr(attrSimple(name)) = " - <generateOp(name)>\n";
str generateAttr(attrValued(name, payload)) = 
    " - <generateOp(name)> : <generatePayload(payload)>\n"
;

str generatePayload(payloadType(t)) = generateType(t);
str generatePayload(payloadEmpty()) = "∅";
str generatePayload(payloadId(n)) = n;


str generateItem(expressionItem(exprDef(e))) = 
    "Expression: <generateExpr(e)>\n\n"
;

str generateExpr(identifier(n)) = n;

str generateExpr(application(op, args)) =
    "(<generateOp(op)> " + 
    intercalate(" ", [ generateExpr(a) | a <- args ]) + 
    ")"
;

str generateExpr(neg(e)) = 
    "neg <generateExpr(e)>"
;

str generateExpr(and(e1, e2)) = 
    "<generateExpr(e1)> and <generateExpr(e2)>"
;

str generateExpr(or(e1, e2)) = 
    "<generateExpr(e1)> or <generateExpr(e2)>"
;

str generateExpr(implies(e1, e2)) = 
    "<generateExpr(e1)> -\> <generateExpr(e2)>"
;

str generateExpr(equiv(e1, e2)) = 
    "<generateExpr(e1)> ≡ <generateExpr(e2)>"
;

str generateExpr(infix(e1, op, e2)) = 
    "<generateExpr(e1)> <op> <generateExpr(e2)>"
;

str generateExpr(group(e)) = 
    "(<generateExpr(e)>)"
;

// definiciones necesarias extras

str generateOp(opId(n)) = n;
str generateOp(opSymbol(s)) = s;
str generateType(simpleType(n)) = n;
str generateType(arrowType(a, b)) = 
    "<a> -\> <generateType(b)>"
;

