package main

import (
	"antlr4/parser"
	"fmt"
	"github.com/antlr/antlr4/runtime/Go/antlr/v4"
	"os"
)

type TreeShapeListener struct {
	*parser.BaseThriftListener
}

func NewTreeShapeListener() *TreeShapeListener {
	return new(TreeShapeListener)
}

func (this *TreeShapeListener) EnterEveryRule(ctx antlr.ParserRuleContext) {
	//fmt.Println(ctx.GetText())
}

func main() {
	fmt.Printf("Parsing %s\n", os.Args[1])
	WalkFile(os.Args[1])
}

func ParseFile(filename string) *parser.ThriftParser {
	input, _ := antlr.NewFileStream(filename)
	lexer := parser.NewThriftLexer(input)
	stream := antlr.NewCommonTokenStream(lexer, 0)
	return parser.NewThriftParser(stream)
}

func WalkFile(filename string) {
	p := ParseFile(filename)
	// p.AddErrorListener(antlr.NewDiagnosticErrorListener(true))
	p.BuildParseTrees = true
	tree := p.Document()
	antlr.ParseTreeWalkerDefault.Walk(NewTreeShapeListener(), tree)
}

type Context struct {
	Namespace string
	Structs   []string
	Enums     []string
}

/*
func LoadContext(p *parser.ThriftParser) Context {
	ret := Context{}
	doc := p.Document()
	for _, header := range doc.AllHeader() {
		if ns := header.Namespace(); ns != nil {
			ret.Namespace = ns.Namespace_value().GetText()
		}
	}
	for _, def := range doc.AllDefinition() {
		if o := def.Enum_rule(); o != nil {
			ret.Enums = append(ret.Enums, o.Identifier().GetText())
		} else if o := def.Struct_rule(); o != nil {
			ret.Structs = append(ret.Structs, o.Identifier().GetText())
		}
	}
	return ret
}
*/

func LoadContext(p *parser.ThriftParser) Context {
	ret := Context{}
	doc := p.Document().(*parser.DocumentContext)
    for _, header := range doc.AllHeader() {
        if ns := header.(*parser.HeaderContext).Namespace(); ns != nil {
			ret.Namespace = ns.(*parser.NamespaceContext).Namespace_value().GetText()
        }
    }
	for _, def := range doc.AllDefinition() {
		if o := def.(*parser.DefinitionContext).Enum_rule(); o != nil {
			ret.Enums = append(ret.Enums, o.(*parser.Enum_ruleContext).Identifier().GetText())
		} else if o := def.(*parser.DefinitionContext).Struct_rule(); o != nil {
			ret.Structs = append(ret.Structs, o.(*parser.Struct_ruleContext).Identifier().GetText())
		}
	}
	return ret
}
