module Syntax

layout Layout = WhitespaceAndComment* !>> [\ \t\n\r#];
lexical WhitespaceAndComment = [\ \t\n\r] | @category="Comment" "#" ![\n]* $;

start syntax Module 
    = moduleDef: "defmodule" ID name Import* imports ModuleItem* items "end"
;

syntax Import 
    = importDef: "using" ID name
;

syntax ModuleItem 
    = spaceItem: SpaceDef space
    | operatorItem: OperatorDef op
    | varItem: VarDef var
    | ruleItem: RuleDef rule
    | expressionItem: ExpressionDef expr
;

syntax SpaceDef 
= spaceDef: "defspace" ID name ("\<" ID parent)? "end"
;

syntax OperatorDef 
    = operatorDef: "defoperator" OperatorName name ":" Type typ Attributes? attrs "end"
;

syntax OperatorName 
    = opId: ID name
    | opLit: OperatorLiteral op
;

syntax Type 
    = simpleType: ID name
    | funcType: ID from "->" Type to
;

syntax VarDef 
    = varDef: "defvar" {VarDecl ","}+ decls "end"
;

syntax VarDecl 
    = varDecl: ID name ":" ID type
;

syntax RuleDef 
    = ruleDef: "defrule" Application lhs "->" Application rhs "end"
;

syntax Attributes 
    = attributes: "[" AttributeItem+ items "]"
;

syntax AttributeItem 
    = attrItem: OperatorName name (":" AttributePayload payload)?
;

syntax AttributePayload 
    = payloadType: Type typ
    | payloadEmpty: ()
    | payloadId: ID name
;

syntax ExpressionDef 
    = exprDef: "defexpression" Expr expr Attributes? attrs "end"
;

syntax Expr 
    = expr: EquivExpr e
;

syntax EquivExpr 
    = equiv: {ImplExpr "="}+ exprs
;

syntax ImplExpr 
    = impl: {OrExpr "=>"}+ exprs
;

syntax OrExpr 
    = orExpr: {AndExpr "or"}+ exprs
;

syntax AndExpr 
    = andExpr: {NotExpr "and"}+ exprs
;

syntax NotExpr 
    = negExpr: "neg" NotExpr expr
    | atomExpr: Atom atom
;

syntax Atom 
    = quantified: QuantifiedExpr q
    | application: Application app
    | infix: InfixApp inf
    | id: ID name
    | int: INT value
    | float: FLOAT value
    | char: CHAR value
    | group: Group group
;

syntax Group 
    = group: "(" Expr expr ")"
;

syntax Application 
    = app: "(" OperatorName op Term+ args ")"
;

syntax Term 
    = termId: ID name
    | termInt: INT value
    | termFloat: FLOAT value
    | termChar: CHAR value
    | termApp: Application app
    | termQuant: QuantifiedExpr q
    | termGroup: Group group
;

syntax InfixApp 
    = infix: Term lhs InfixOp op Term rhs
;

syntax InfixOp 
    = opName: OperatorLiteral op
    | inOp: "in"
    | eqOp: "="
    | ltOp: "\<"
    | leOp: "\<="
    | gtOp: "\>"
    | geOp: "\>="
    | neqOp: "!="
;

syntax QuantifiedExpr 
    = quant: "(" Quantifier q ID var "in" ID space "." Expr body ")"
;

syntax Quantifier 
    = forall: "forall"
    | exists: "exists"
;

syntax OperatorLiteral 
    = mul: "*"
    | div: "/"
    | sub: "-"
    | add: "+"
    | pow: "**"
    | mod: "%"
    | lt: "\<"
    | gt: "\>"
    | le: "\<="
    | ge: "\>="
    | neq: "!="
    | eq: "=="
;

lexical INT = [0-9]+ !>> [0-9];
lexical FLOAT = [0-9]+ "." [0-9]+ !>> [0-9];
lexical CHAR = "\'" [a-zA-Z0-9] "\'";
lexical ID = ([a-zA-Z][a-zA-Z0-9\-]* !>> [a-zA-Z0-9\-]) \ Reserved;

keyword Reserved = "defmodule" | "using" | "defspace" | "defoperator" | "defexpression" 
                 | "defrule" | "defvar" | "end" | "forall" | "exists" | "defer" 
                 | "in" | "and" | "or" | "neg";
 