grammar Thrift;

document
    : docs* header* definition* EOF
    ;

header
    : namespace
    ;

namespace
    : 'namespace' language namespace_value
    ;

language
  : '*' | identifier
  ;

namespace_value
  : identifier | LITERAL
  ;

definition
    : enum_rule | struct_rule
    ;

enum_rule
    : docs* 'enum' identifier '{' enum_field* docs* '}'
    ;

enum_field
    : docs* identifier ('=' integer)? list_separator?
    ;

struct_rule
    : docs* 'struct' identifier '{' field* docs* '}'
    ;

field
    : docs* field_id? field_req? field_type identifier list_separator?
    ;

field_id
    : integer ':'
    ;

field_req
    : 'required'
    | 'optional'
    ;

field_type
    : base_type | field_type_name
    ;

field_type_name
    : field_type_namespace? identifier
    ;

field_type_namespace
    : identifier '.'
    ;

integer
    : INTEGER | HEX_INTEGER
    ;

BOOLEAN
    : 'true' | 'false'
    ;

INTEGER
    : ('+' | '-')? DIGIT+
    ;

HEX_INTEGER
    : '-'? '0x' HEX_DIGIT+
    ;

list_separator
    : COMMA | ';'
    ;

base_type
    : TYPE_I64 | TYPE_STRING
    ;

TYPE_I64: 'i64';
TYPE_STRING: 'string';

LITERAL
    : (('"' ~'"'* '"') | ('\'' ~'\''* '\''))
    ;

identifier
    : IDENTIFIER
    | base_type
    ;

IDENTIFIER
    : (LETTER | '_') (LETTER | DIGIT | '.' | '_')*
    ;

COMMA
    : ','
    ;

fragment LETTER
    : 'A'..'Z' | 'a'..'z'
    ;

fragment DIGIT
    : '0'..'9'
    ;

fragment HEX_DIGIT
    : DIGIT | 'A'..'F' | 'a'..'f'
    ;

WS
    : (' ' | '\t' | '\r' '\n' | '\n')+ -> channel(HIDDEN)
    ;

docs
    : ML_DOCS
    ;

ML_DOCS
    : '/**' .*? '*/' WS* ('\r')? '\n'
    ;
