["(" ")" "[" "]" "{" "}"] @punctuation.bracket

[(string)
 (here_string)
 (byte_string)] @string

(regex) @string.special
(escape_sequence) @escape

(number) @number
(character) @constant.builtin
(boolean) @constant.builtin
(keyword) @constant

(extension) @keyword.directive
(lang_name) @variable.builtin

(symbol) @variable

((symbol) @operator
 (#any-of? @operator "+" "-" "*" "/" "=" ">" "<" ">=" "<=" "equal?" "eq?" "eqv?"))

(list
  .
  (symbol) @keyword
  (#any-of? @keyword
    "and"
    "begin"
    "begin0"
    "begin-for-syntax"
    "case"
    "case-lambda"
    "cond"
    "define"
    "define/contract"
    "define-values"
    "define-syntax"
    "define-syntax-rule"
    "else"
    "for"
    "for*"
    "for/list"
    "for*/list"
    "for/fold"
    "for*/fold"
    "if"
    "lambda"
    "λ"
    "let"
    "let*"
    "let-values"
    "let*-values"
    "letrec"
    "letrec-values"
    "let-syntax"
    "letrec-syntax"
    "local"
    "match"
    "match*"
    "match-lambda"
    "match-let"
    "module"
    "module*"
    "module+"
    "or"
    "parameterize"
    "provide"
    "quote"
    "quasiquote"
    "require"
    "set!"
    "struct"
    "syntax"
    "syntax-rules"
    "unless"
    "unquote"
    "unquote-splicing"
    "when"
    "with-handlers"
    "with-syntax"))

(list
  .
  (symbol) @function.builtin
  (#any-of? @function.builtin
    "abs"
    "add1"
    "append"
    "apply"
    "boolean?"
    "caar"
    "cadr"
    "car"
    "cdar"
    "cddr"
    "cdr"
    "cons"
    "display"
    "displayln"
    "error"
    "filter"
    "foldl"
    "foldr"
    "format"
    "length"
    "list"
    "list*"
    "list?"
    "map"
    "member"
    "memq"
    "memv"
    "newline"
    "not"
    "null?"
    "number?"
    "pair?"
    "printf"
    "procedure?"
    "quote"
    "read"
    "reverse"
    "string?"
    "sub1"
    "symbol?"
    "values"
    "vector"
    "vector?"
    "void"
    "zero?"))

(list
  .
  (symbol) @keyword
  .
  (list
    .
    (symbol)+ @variable.parameter)
  (#any-of? @keyword
    "lambda"
    "λ"
    "define-values"
    "define-syntaxes"
    "define-values-for-export"
    "define-values-for-syntax"
    "define-syntax-rule"))

(list
  .
  (symbol) @keyword
  .
  (list
    .
    (symbol) @function
    .
    (symbol)* @variable.parameter)
  (#any-of? @keyword "define" "define/contract"))

(quote . (symbol)) @constant

(quote
  .
  (list
    .
    (symbol)* @variable))

(quote
  _ @constant)

(quote
  (_ _* @constant))

(quote
  (_ (_ _* @constant)))

(quote
  (_ (_ (_ _* @constant))))

(sexp_comment
  _ @comment)

(sexp_comment
  (_ _* @comment))

(sexp_comment
  (_ (_ _* @comment)))

(sexp_comment
  (_ (_ (_ _ @comment))))

[(comment)
 (block_comment)] @comment
