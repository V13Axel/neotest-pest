local nio = require("nio")
local a = nio.tests
local lib = require("neotest.lib")
local ts = lib.treesitter

local query = [[
    ((expression_statement
        (member_call_expression
            name: (name) @member_name (#eq? @member_name "group")
            arguments: (arguments . (argument (string (string_content) @namespace.name)))
        ) @member
    )) @namespace.definition

    ((function_call_expression
        function: (name) @func_name (#eq? @func_name "describe")
        arguments: (arguments . (argument (_ (string_content) @namespace.name)))
    )) @namespace.definition

    ((function_call_expression
        function: (name) @func_name (#match? @func_name "^(test|it)$")
        arguments: (arguments . (argument (_ (string_content) @test.name)))
    )) @test.definition
]]

local opts = { nested_namespaces = true }

--- Helper to extract type and name from a tree node list, ignoring range/id/path.
--- tree:to_list() returns { {data}, {child1}, {child2}, ... } where each child
--- is itself { {data}, {grandchild1}, ... }.
local function simplify_tree(list)
  local data = list[1]
  local result = { type = data.type, name = data.name }
  local children = {}
  for i = 2, #list do
    children[#children + 1] = simplify_tree(list[i])
  end
  if #children > 0 then
    result.children = children
  end
  return result
end

describe("discover_positions", function()
  a.it("discovers it() and test() as test positions", function()
    local source = [[<?php
it('does something', function () {
    expect(true)->toBeTrue();
});

test('does something else', function () {
    expect(true)->toBeTrue();
});
]]
    local tree = ts.parse_positions_from_string("tests/Feature/ExampleTest.php", source, query, opts)
    local result = simplify_tree(tree:to_list())

    assert.equals("file", result.type)
    assert.equals(2, #result.children)
    assert.equals("test", result.children[1].type)
    assert.equals("does something", result.children[1].name)
    assert.equals("test", result.children[2].type)
    assert.equals("does something else", result.children[2].name)
  end)

  a.it("discovers describe() as a namespace with child tests", function()
    local source = [[<?php
describe('Describe Block', function () {
    it('should work', function () {
        expect(true)->toBeTrue();
    });

    it('should also work', function () {
        expect(true)->toBeTrue();
    });
});
]]
    local tree = ts.parse_positions_from_string("tests/Feature/DescribeTest.php", source, query, opts)
    local result = simplify_tree(tree:to_list())

    assert.equals("file", result.type)
    assert.equals(1, #result.children)

    local describe = result.children[1]
    assert.equals("namespace", describe.type)
    assert.equals("Describe Block", describe.name)
    assert.equals(2, #describe.children)
    assert.equals("test", describe.children[1].type)
    assert.equals("should work", describe.children[1].name)
    assert.equals("test", describe.children[2].type)
    assert.equals("should also work", describe.children[2].name)
  end)

  a.it("discovers nested describe blocks", function()
    local source = [[<?php
describe('Outer', function () {
    describe('Inner', function () {
        it('works nested', function () {
            expect(true)->toBeTrue();
        });
    });

    it('works at outer level', function () {
        expect(true)->toBeTrue();
    });
});
]]
    local tree = ts.parse_positions_from_string("tests/Feature/NestedTest.php", source, query, opts)
    local result = simplify_tree(tree:to_list())

    assert.equals("file", result.type)
    assert.equals(1, #result.children)

    local outer = result.children[1]
    assert.equals("namespace", outer.type)
    assert.equals("Outer", outer.name)
    assert.equals(2, #outer.children)

    local inner = outer.children[1]
    assert.equals("namespace", inner.type)
    assert.equals("Inner", inner.name)
    assert.equals(1, #inner.children)
    assert.equals("test", inner.children[1].type)
    assert.equals("works nested", inner.children[1].name)

    assert.equals("test", outer.children[2].type)
    assert.equals("works at outer level", outer.children[2].name)
  end)

  a.it("discovers describe blocks alongside top-level tests", function()
    local source = [[<?php
it('top level test', function () {
    expect(true)->toBeTrue();
});

describe('A Block', function () {
    it('inside describe', function () {
        expect(true)->toBeTrue();
    });
});

test('another top level', function () {
    expect(true)->toBeTrue();
});
]]
    local tree = ts.parse_positions_from_string("tests/Feature/MixedTest.php", source, query, opts)
    local result = simplify_tree(tree:to_list())

    assert.equals("file", result.type)
    assert.equals(3, #result.children)

    assert.equals("test", result.children[1].type)
    assert.equals("top level test", result.children[1].name)

    assert.equals("namespace", result.children[2].type)
    assert.equals("A Block", result.children[2].name)
    assert.equals(1, #result.children[2].children)
    assert.equals("test", result.children[2].children[1].type)
    assert.equals("inside describe", result.children[2].children[1].name)

    assert.equals("test", result.children[3].type)
    assert.equals("another top level", result.children[3].name)
  end)

  a.it("discovers describe blocks with parameterized tests", function()
    local source = [[<?php
describe('Math', function () {
    it('adds numbers', function (int $a, int $b, int $expected) {
        expect($a + $b)->toBe($expected);
    })->with([
        [1, 2, 3],
        [4, 5, 9],
    ]);

    test('subtracts numbers', function (int $a, int $b, int $expected) {
        expect($a - $b)->toBe($expected);
    })->with([
        [5, 3, 2],
    ]);
});
]]
    local tree = ts.parse_positions_from_string("tests/Feature/DescribeWithTest.php", source, query, opts)
    local result = simplify_tree(tree:to_list())

    assert.equals("file", result.type)
    assert.equals(1, #result.children)

    local describe = result.children[1]
    assert.equals("namespace", describe.type)
    assert.equals("Math", describe.name)
    assert.equals(2, #describe.children)
    assert.equals("test", describe.children[1].type)
    assert.equals("adds numbers", describe.children[1].name)
    assert.equals("test", describe.children[2].type)
    assert.equals("subtracts numbers", describe.children[2].name)
  end)
end)
-- vim: fdm=indent fdl=2
