local utils = require("neotest-pest.utils")

describe("get_test_results", function()
    it("parses output with whole file", function()
        local output_file = "/tmp/nvimhYaIPj/3"
        local xml_output = {
            testsuites = {
                testsuite = {
                    _attr = {
                        assertions = "17",
                        errors = "0",
                        failures = "0",
                        name = "",
                        skipped = "0",
                        tests = "7",
                        time = "0.006846",
                        warnings = "0"
                    },
                    testsuite = { {
                        _attr = {
                            assertions = "1",
                            errors = "0",
                            failures = "0",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Examples/some/deep/nesting/NestingTest.php",
                            name = "P\\Tests\\Examples\\some\\deep\\nesting\\NestingTest",
                            skipped = "0",
                            tests = "1",
                            time = "0.002344",
                            warnings = "0"
                        },
                        testcase = {
                            _attr = {
                                assertions = "1",
                                class = "Tests\\Examples\\some\\deep\\nesting\\NestingTest",
                                classname = "Tests.Examples.some.deep.nesting.NestingTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Examples/some/deep/nesting/NestingTest.php",
                                name = "is true",
                                time = "0.002344"
                            }
                        }
                    }, {
                        _attr = {
                            assertions = "15",
                            errors = "0",
                            failures = "0",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                            name = "P\\Tests\\Feature\\UserTest",
                            skipped = "0",
                            tests = "5",
                            time = "0.004385",
                            warnings = "0"
                        },
                        testcase = { {
                            _attr = {
                                assertions = "3",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "class constructor",
                                time = "0.000941"
                            }
                        }, {
                            _attr = {
                                assertions = "2",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "tellName",
                                time = "0.000494"
                            }
                        }, {
                            _attr = {
                                assertions = "2",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "can tellAge",
                                time = "0.000384"
                            }
                        }, {
                            _attr = {
                                assertions = "3",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "addFavoriteMovie",
                                time = "0.000959"
                            }
                        }, {
                            _attr = {
                                assertions = "5",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "removeFavoriteMovie",
                                time = "0.001608"
                            }
                        } }
                    }, {
                        _attr = {
                            assertions = "1",
                            errors = "0",
                            failures = "0",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Unit/ExampleTest.php",
                            name = "P\\Tests\\Unit\\ExampleTest",
                            skipped = "0",
                            tests = "1",
                            time = "0.000116",
                            warnings = "0"
                        },
                        testcase = {
                            _attr = {
                                assertions = "1",
                                class = "Tests\\Unit\\ExampleTest",
                                classname = "Tests.Unit.ExampleTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Unit/ExampleTest.php",
                                name = "example",
                                time = "0.000116"
                            }
                        }
                    } }
                }
            }
        }

        local expected = {
            ["/Users/michaelutz/Code/neotest-pest/tests/Examples/some/deep/nesting/NestingTest.php::is true"] = {
                output_file = output_file,
                short = "TESTS.EXAMPLES.SOME.DEEP.NESTING.NESTINGTEST\n-> PASSED - is true",
                status = "passed"
            },
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::addFavoriteMovie"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - addFavoriteMovie",
                status = "passed"
            },
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::can tellAge"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - can tellAge",
                status = "passed"
            },
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::class constructor"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - class constructor",
                status = "passed"
            },
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::removeFavoriteMovie"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - removeFavoriteMovie",
                status = "passed"
            },
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::tellName"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - tellName",
                status = "passed"
            },
            ["/Users/michaelutz/Code/neotest-pest/tests/Unit/ExampleTest.php::example"] = {
                output_file = output_file,
                short = "TESTS.UNIT.EXAMPLETEST\n-> PASSED - example",
                status = "passed"
            }
        }

        assert.are.same(utils.get_test_results(xml_output, output_file), expected)
    end)
end)
