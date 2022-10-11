classpath = build:./antlr-4.11.1-complete.jar

build:
	mkdir -p build/
	javac -d build/ -cp $(classpath) *.java

run: build
	java -cp $(classpath) Main ../test-fixtures/users.thrift

clean:
	$(RM) -r build/

.PHONY: build run clean

