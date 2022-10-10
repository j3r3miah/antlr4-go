grammar Thrift;

document
    : docs* header* definition* EOF
    ;

header
    : include | namespace
    ;

include
    : 'include' LITERAL
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
    : const_rule | typedef | enum_rule | struct_rule | union | exception | service
    ;

const_rule
    : docs* 'const' field_type identifier '=' const_value list_separator?
    ;

typedef
    : docs* 'typedef' field_type identifier type_annotations?
    ;

enum_rule
    : docs* 'enum' identifier '{' enum_field* docs* '}' type_annotations?
    ;

enum_field
    : docs* identifier ('=' integer)? type_annotations? list_separator?
    ;

struct_rule
    : docs* 'struct' identifier '{' field* docs* '}' type_annotations?
    ;

union
    : docs* 'union' identifier '{' field* docs* '}' type_annotations?
    ;

exception
    : docs* 'exception' identifier '{' field* docs* '}' type_annotations?
    ;

service
    : docs* 'service' identifier service_extends? '{' function* docs* '}' type_annotations?
    ;

service_extends
    : 'extends' identifier
    ;

field
    : docs* field_id? field_req? field_type
        identifier ('=' const_value)? type_annotations? list_separator?
    ;

field_id
    : integer ':'
    ;

field_req
    : 'required'
    | 'optional'
    ;

function
    : docs* oneway? function_type
        identifier '(' field* ')' throws_list? type_annotations? list_separator?
    ;

oneway
    : ('oneway' | 'async')
    ;

function_type
    : field_type
    | 'void'
    ;

throws_list
    : 'throws' '(' field* ')'
    ;

type_annotations
    : '(' type_annotation* ')'
    ;

type_annotation
    : docs* identifier ('=' annotation_value)? list_separator?
    ;

annotation_value
    : integer | LITERAL
    ;

field_type
    : base_type | field_type_name | container_type
    ;

field_type_name
    : field_type_namespace? identifier
    ;

field_type_namespace
    : identifier '.'
    ;

base_type
    : real_base_type type_annotations?
    ;

container_type
    : map_type | set_type | list_type
    ;

map_type
    : 'map' '<' field_type COMMA field_type '>' type_annotations?
    ;

set_type
    : 'set' '<' field_type '>' type_annotations?
    ;

list_type
    : 'list' '<' field_type '>' type_annotations?
    ;

const_value
    : integer | DOUBLE | BOOLEAN | LITERAL | identifier | const_list | const_map
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

DOUBLE
    : ('+' | '-')? ( DIGIT+ ('.' DIGIT+)? | '.' DIGIT+ ) (('E' | 'e') INTEGER)?
    ;

const_list
    : '[' (const_value list_separator?)* ']'
    ;

const_map_entry
    : const_value ':' const_value list_separator?
    ;

const_map
    : '{' const_map_entry* '}'
    ;

list_separator
    : COMMA | ';'
    ;

real_base_type
    : TYPE_BOOL | TYPE_BYTE | TYPE_I16 | TYPE_I32 | TYPE_I64 | TYPE_DOUBLE | TYPE_STRING |
        TYPE_BINARY | TYPE_JSON_OBJECT | TYPE_ID | TYPE_DATE | TYPE_DATE_TIME
    ;

TYPE_BOOL: 'bool';
TYPE_BYTE: 'byte';
TYPE_I16: 'i16';
TYPE_I32: 'i32';
TYPE_I64: 'i64';
TYPE_DOUBLE: 'double';
TYPE_STRING: 'string';
TYPE_BINARY: 'binary';
TYPE_ID: 'id';
TYPE_JSON_OBJECT: 'json_object';
TYPE_DATE: 'date';
TYPE_DATE_TIME: 'date_time';

LITERAL
    : (('"' ~'"'* '"') | ('\'' ~'\''* '\''))
    ;

identifier
    : IDENTIFIER
    | real_base_type
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
    : ML_DOCS | SL_COMMENT
    ;

ML_DOCS
    : '/**' .*? '*/' WS* ('\r')? '\n' // ML_COMMENT differences: starts with two stars(*) and ends with \n
    ;

SL_COMMENT
    : ('//' | '#') (~'\n')* ('\r')? ('\n' | EOF)? -> channel(HIDDEN)
    ;

ML_COMMENT
    : '/*' .*? '*/' -> channel(HIDDEN)
    ;
