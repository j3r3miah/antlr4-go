#!/bin/sh

cd "$(dirname $(readlink -f "$0" ))"


ANTLR="/Users/jeremiah_boyle/.m2/repository/org/antlr//antlr4/4.11.2-SNAPSHOT/antlr4-4.11.2-SNAPSHOT-complete.jar"
if [ "$1" != "fork" ]; then
    wget --quiet -c https://www.antlr.org/download/antlr-4.11.1-complete.jar
    ANTLR="./antlr-4.11.1-complete.jar"
fi

java -Xmx500M -cp "$ANTLR" org.antlr.v4.Tool \
    -Dlanguage=Go -package parser *.g4

java -Xmx500M -cp "$ANTLR" org.antlr.v4.Tool \
    -Dlanguage=Java -package parser *.g4

rm *.interp *.tokens
