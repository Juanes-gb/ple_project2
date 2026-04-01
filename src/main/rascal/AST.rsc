module AST

data Module
    = moduleDef(str name, list[Import] imports, list[ModuleItem] items)
;

data Import
    = importDef(str name)
;

data ModuleItem
    = spaceItem(SpaceDef space)
    | operatorItem(OperatorDef op)
    | varItem(VarDef var)
    | ruleItem(RuleDef rule)
    | expressionItem(ExpressionDef expr)
;

data SpaceDef
    = spaceDef(str name, str parent)
    | spaceDefNoParent(str name)
;

data OperatorDef
    = operatorDef(OperatorName name, Type typ, list[AttributeItem] attrs)
;

data OperatorName
    = opId(str name)
    | opSymbol(str symbol)
;

data Type
    = simpleType(str name)
    | arrowType(str from, Type to)
;

data VarDef
    = varDef(list[VarDecl] decls)
;

data VarDecl
    = varDecl(str name, str typ)
;

data RuleDef
    = ruleDef(Expr lhs, Expr rhs)
;

data ExpressionDef
    = exprDef(Expr body)
;

data AttributeItem
    = attrSimple(OperatorName name)
    | attrValued(OperatorName name, AttributePayload payload)
;

data AttributePayload
    = payloadType(Type t)
    | payloadEmpty()
    | payloadId(str name)
;

data Expr
    = equiv(Expr lhs, Expr rhs)
    | implies(Expr lhs, Expr rhs)
    | or(Expr lhs, Expr rhs)
    | and(Expr lhs, Expr rhs)
    | neg(Expr expr)
    | infix(Expr lhs, str infixOp, Expr rhs)
    | application(OperatorName appOp, list[Expr] args)
    | quantified(str quantifier, str var, str domain, Expr body)
    | identifier(str name)
    | group(Expr expr)
;