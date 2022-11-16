local utils = require("neotest-pest.utils")

describe("get_test_results", function()
    local output_file = "/tmp/nvimhYaIPj/3"

    it("parses output with whole file", function()
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

    it('parses output with single test', function()
        local xml_output = {
            testsuites = {
                testsuite = {
                    _attr = {
                        assertions = "3",
                        errors = "0",
                        failures = "0",
                        name = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                        skipped = "0",
                        tests = "1",
                        time = "0.004366",
                        warnings = "0"
                    },
                    testsuite = {
                        _attr = {
                            assertions = "3",
                            errors = "0",
                            failures = "0",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                            name = "P\\Tests\\Feature\\UserTest",
                            skipped = "0",
                            tests = "1",
                            time = "0.004366",
                            warnings = "0"
                        },
                        testcase = {
                            _attr = {
                                assertions = "3",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "addFavoriteMovie",
                                time = "0.004366"
                            }
                        }
                    }
                }
            }
        }

        local expected = {
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::addFavoriteMovie"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - addFavoriteMovie",
                status = "passed"
            }
        }

        assert.are.same(utils.get_test_results(xml_output, output_file), expected)
    end)

    it('parses output with a failing test', function()
        local xml_output = {
            testsuites = {
                testsuite = {
                    _attr = {
                        assertions = "16",
                        errors = "0",
                        failures = "1",
                        name = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                        skipped = "0",
                        tests = "6",
                        time = "0.007869",
                        warnings = "0"
                    },
                    testsuite = {
                        _attr = {
                            assertions = "16",
                            errors = "0",
                            failures = "1",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                            name = "P\\Tests\\Feature\\UserTest",
                            skipped = "0",
                            tests = "6",
                            time = "0.007869",
                            warnings = "0"
                        },
                        testcase = { {
                            _attr = {
                                assertions = "3",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "class constructor",
                                time = "0.003293"
                            }
                        }, {
                            _attr = {
                                assertions = "2",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "tellName",
                                time = "0.000584"
                            }
                        }, {
                            _attr = {
                                assertions = "2",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "can tellAge",
                                time = "0.000396"
                            }
                        }, {
                            _attr = {
                                assertions = "1",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "is false",
                                time = "0.001134"
                            },
                            failure = { "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::it is false\nFailed asserting that true is false.\n\n/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php:33\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Expectation.php:316\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Support/Reflection.php:38\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Support/HigherOrderMessage.php:96\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Support/HigherOrderMessageCollection.php:43\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Factories/TestCaseFactory.php:148\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Concerns/Testable.php:302\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Support/ExceptionTrace.php:29\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Concerns/Testable.php:303\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Concerns/Testable.php:279\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Console/Command.php:119\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/bin/pest:62\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/bin/pest:63",
                                _attr = {
                                    type = "PHPUnit\\Framework\\ExpectationFailedException"
                                }
                            }
                        }, {
                            _attr = {
                                assertions = "3",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "addFavoriteMovie",
                                time = "0.001189"
                            }
                        }, {
                            _attr = {
                                assertions = "5",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "removeFavoriteMovie",
                                time = "0.001273"
                            }
                        } }
                    }
                }
            }
        }

        local expected = {
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
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::is false"] = {
                errors = { {} },
                output_file = output_file,
                status = "failed"
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
            }
        }

        assert.are.same(utils.get_test_results(xml_output, output_file), expected)
    end)

    it('parses output with errors', function()
        local xml_output = {
            testsuites = {
                testsuite = {
                    _attr = {
                        assertions = "0",
                        errors = "1",
                        failures = "0",
                        name = "",
                        skipped = "0",
                        tests = "1",
                        time = "0.002610",
                        warnings = "0"
                    },
                    testsuite = {
                        _attr = {
                            assertions = "0",
                            errors = "1",
                            failures = "0",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                            name = "P\\Tests\\Feature\\UserTest",
                            skipped = "0",
                            tests = "1",
                            time = "0.002610",
                            warnings = "0"
                        },
                        testcase = {
                            _attr = {
                                assertions = "0",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "tellName",
                                time = "0.002610"
                            },
                            error = { "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::tellName\nException: Oops!\n\n/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php:24\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Factories/TestCaseFactory.php:151\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Concerns/Testable.php:302\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Support/ExceptionTrace.php:29\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Concerns/Testable.php:303\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Concerns/Testable.php:279\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/src/Console/Command.php:119\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/bin/pest:62\n/Users/michaelutz/Code/neotest-pest/vendor/pestphp/pest/bin/pest:63",
                                _attr = {
                                    type = "Exception"
                                }
                            }
                        }
                    }
                }
            }
        }

        local expected = {
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::tellName"] = {
                errors = { {} },
                output_file = output_file,
                status = "failed"
            }
        }

        assert.are.same(utils.get_test_results(xml_output, output_file), expected)
    end)

    it('parses output with skipped tests', function()
        local xml_output = {
            testsuites = {
                testsuite = {
                    _attr = {
                        assertions = "0",
                        errors = "0",
                        failures = "0",
                        name = "",
                        skipped = "1",
                        tests = "1",
                        time = "0.001544",
                        warnings = "0"
                    },
                    testsuite = {
                        _attr = {
                            assertions = "0",
                            errors = "0",
                            failures = "0",
                            file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                            name = "P\\Tests\\Feature\\UserTest",
                            skipped = "1",
                            tests = "1",
                            time = "0.001544",
                            warnings = "0"
                        },
                        testcase = {
                            _attr = {
                                assertions = "0",
                                class = "Tests\\Feature\\UserTest",
                                classname = "Tests.Feature.UserTest",
                                file = "/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php",
                                name = "tellName",
                                time = "0.001544"
                            },
                            skipped = {}
                        }
                    }
                }
            }
        }

        local expected = {
            ["/Users/michaelutz/Code/neotest-pest/tests/Feature/UserTest.php::tellName"] = {
                output_file = output_file,
                short = "TESTS.FEATURE.USERTEST\n-> PASSED - tellName",
                status = "passed"
            }
        }

        assert.are.same(utils.get_test_results(xml_output, output_file), expected)
    end)
end)
