package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestWalkFile(t *testing.T) {
	WalkFile("test-fixtures/users.thrift")
}

func TestLoadContext(t *testing.T) {
	p := ParseFile("test-fixtures/users.thrift")
	ctx := LoadContext(p)
	expected := Context{
		Namespace: "com.foo.api",
		Enums:     []string{"UserType"},
		Structs:   []string{"User"},
	}
	assert.Equal(t, expected, ctx)
}
