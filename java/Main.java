import static parser.ThriftParser.DocumentContext;
import static parser.ThriftParser.HeaderContext;
import static parser.ThriftParser.DefinitionContext;
import static parser.ThriftParser.Enum_ruleContext;
import static parser.ThriftParser.Struct_ruleContext;

import java.util.*;
import java.text.*;
import java.io.IOException;
import parser.*;
import org.antlr.v4.runtime.*;

class Main {
  public static void main(String[] args) throws IOException {
    ThriftParser p = parseFile(args[0]);
    Context ctx = loadContext(p);
    System.out.println(ctx.namespace);
	}

  public static class Context {
    public String namespace;
    public List<String> Enums = new ArrayList<String>();
    public List<String> Structs = new ArrayList<String>();
  }

  public static ThriftParser parseFile(String filename) throws IOException {
    CharStream input = CharStreams.fromFileName(filename);
    ThriftLexer lexer = new ThriftLexer(input);
    CommonTokenStream stream = new CommonTokenStream(lexer);
    return new ThriftParser(stream);
  }

  public static Context loadContext(ThriftParser p) {
    Context ret = new Context();
    DocumentContext doc = p.document();
    for (HeaderContext header : doc.header()) {
      if (header.namespace() != null) {
        ret.namespace = header.namespace().namespace_value().getText();
      }
    }
    for (DefinitionContext def : doc.definition()) {
      if (def.enum_rule() != null) {
        ret.Enums.add(def.enum_rule().identifier().getText());
      } else if (def.struct_rule() != null) {
        ret.Structs.add(def.struct_rule().identifier().getText());
      }
    }
    return ret;
  }
}
