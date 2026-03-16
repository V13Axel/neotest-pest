local utils = require("neotest-pest.utils")

describe("get_test_results", function()
  local output_file = "/tmp/nvomhYaIPj/3"

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
            warnings = "0",
          },
          testsuite = {
            {
              _attr = {
                assertions = "1",
                errors = "0",
                failures = "0",
                file = "tests/Examples/some/deep/nesting/NestingTest.php",
                name = "P\\Tests\\Examples\\some\\deep\\nesting\\NestingTest",
                skipped = "0",
                tests = "1",
                time = "0.002344",
                warnings = "0",
              },
              testcase = {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Examples\\some\\deep\\nesting\\NestingTest",
                  classname = "Tests.Examples.some.deep.nesting.NestingTest",
                  file = "tests/Examples/some/deep/nesting/NestingTest.php",
                  name = "is true",
                  time = "0.002344",
                },
              },
            },
            {
              _attr = {
                assertions = "15",
                errors = "0",
                failures = "0",
                file = "tests/Feature/UserTest.php",
                name = "P\\Tests\\Feature\\UserTest",
                skipped = "0",
                tests = "5",
                time = "0.004385",
                warnings = "0",
              },
              testcase = {
                {
                  _attr = {
                    assertions = "3",
                    class = "Tests\\Feature\\UserTest",
                    classname = "Tests.Feature.UserTest",
                    file = "tests/Feature/UserTest.php",
                    name = "class constructor",
                    time = "0.000941",
                  },
                },
                {
                  _attr = {
                    assertions = "2",
                    class = "Tests\\Feature\\UserTest",
                    classname = "Tests.Feature.UserTest",
                    file = "tests/Feature/UserTest.php",
                    name = "tellName",
                    time = "0.000494",
                  },
                },
                {
                  _attr = {
                    assertions = "2",
                    class = "Tests\\Feature\\UserTest",
                    classname = "Tests.Feature.UserTest",
                    file = "tests/Feature/UserTest.php",
                    name = "can tellAge",
                    time = "0.000384",
                  },
                },
                {
                  _attr = {
                    assertions = "3",
                    class = "Tests\\Feature\\UserTest",
                    classname = "Tests.Feature.UserTest",
                    file = "tests/Feature/UserTest.php",
                    name = "addFavoriteMovie",
                    time = "0.000959",
                  },
                },
                {
                  _attr = {
                    assertions = "5",
                    class = "Tests\\Feature\\UserTest",
                    classname = "Tests.Feature.UserTest",
                    file = "tests/Feature/UserTest.php",
                    name = "removeFavoriteMovie",
                    time = "0.001608",
                  },
                },
              },
            },
            {
              _attr = {
                assertions = "1",
                errors = "0",
                failures = "0",
                file = "tests/Unit/ExampleTest.php",
                name = "P\\Tests\\Unit\\ExampleTest",
                skipped = "0",
                tests = "1",
                time = "0.000116",
                warnings = "0",
              },
              testcase = {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Unit\\ExampleTest",
                  classname = "Tests.Unit.ExampleTest",
                  file = "tests/Unit/ExampleTest.php",
                  name = "example",
                  time = "0.000116",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Examples/some/deep/nesting/NestingTest.php::is true"] = {
        output_file = output_file,
        short = "PASSED | is true",
        status = "passed",
      },
      ["tests/Feature/UserTest.php::addFavoriteMovie"] = {
        output_file = output_file,
        short = "PASSED | addFavoriteMovie",
        status = "passed",
      },
      ["tests/Feature/UserTest.php::can tellAge"] = {
        output_file = output_file,
        short = "PASSED | can tellAge",
        status = "passed",
      },
      ["tests/Feature/UserTest.php::class constructor"] = {
        output_file = output_file,
        short = "PASSED | class constructor",
        status = "passed",
      },
      ["tests/Feature/UserTest.php::removeFavoriteMovie"] = {
        output_file = output_file,
        short = "PASSED | removeFavoriteMovie",
        status = "passed",
      },
      ["tests/Feature/UserTest.php::tellName"] = {
        output_file = output_file,
        short = "PASSED | tellName",
        status = "passed",
      },
      ["tests/Unit/ExampleTest.php::example"] = {
        output_file = output_file,
        short = "PASSED | example",
        status = "passed",
      },
    }

    assert.are.same(utils.get_test_results(xml_output, output_file), expected)
  end)

  it("parses output with single test", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "3",
            errors = "0",
            failures = "0",
            name = "tests/Feature/UserTest.php",
            skipped = "0",
            tests = "1",
            time = "0.004366",
            warnings = "0",
          },
          testsuite = {
            _attr = {
              assertions = "3",
              errors = "0",
              failures = "0",
              file = "tests/Feature/UserTest.php",
              name = "P\\Tests\\Feature\\UserTest",
              skipped = "0",
              tests = "1",
              time = "0.004366",
              warnings = "0",
            },
            testcase = {
              _attr = {
                assertions = "3",
                class = "Tests\\Feature\\UserTest",
                classname = "Tests.Feature.UserTest",
                file = "tests/Feature/UserTest.php",
                name = "addFavoriteMovie",
                time = "0.004366",
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/UserTest.php::addFavoriteMovie"] = {
        output_file = output_file,
        short = "PASSED | addFavoriteMovie",
        status = "passed",
      },
    }

    assert.are.same(utils.get_test_results(xml_output, output_file), expected)
  end)

  it("parses output with a single failing test", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "1",
            errors = "0",
            failures = "1",
            name = "",
            skipped = "0",
            tests = "1",
            time = "0.004215",
            warnings = "0",
          },
          testsuite = {
            _attr = {
              assertions = "1",
              errors = "0",
              failures = "1",
              file = "tests/Feature/UserTest.php",
              name = "P\\Tests\\Feature\\UserTest",
              skipped = "0",
              tests = "1",
              time = "0.004215",
              warnings = "0",
            },
            testcase = {
              _attr = {
                assertions = "1",
                class = "Tests\\Feature\\UserTest",
                classname = "Tests.Feature.UserTest",
                file = "tests/Feature/UserTest.php",
                name = "is false",
                time = "0.004215",
              },
              failure = {
                "tests/Feature/UserTest.php::it is false\nFailed asserting that true is false.\n\ntests/Feature/UserTest.php:39\nvendor/pestphp/pest/src/Expectation.php:316\nvendor/pestphp/pest/src/Support/Reflection.php:38\nvendor/pestphp/pest/src/Support/HigherOrderMessage.php:96\nvendor/pestphp/pest/src/Support/HigherOrderMessageCollection.php:43\nvendor/pestphp/pest/src/Factories/TestCaseFactory.php:148\nvendor/pestphp/pest/src/Concerns/Testable.php:302\nvendor/pestphp/pest/src/Support/ExceptionTrace.php:29\nvendor/pestphp/pest/src/Concerns/Testable.php:303\nvendor/pestphp/pest/src/Concerns/Testable.php:279\nvendor/pestphp/pest/src/Console/Command.php:119\nvendor/pestphp/pest/bin/pest:62\nvendor/pestphp/pest/bin/pest:63",
                _attr = {
                  type = "PHPUnit\\Framework\\ExpectationFailedException",
                },
              },
            },
          },
        },
      },
    }

    local message =
      "tests/Feature/UserTest.php::it is false\nFailed asserting that true is false.\n\ntests/Feature/UserTest.php:39\nvendor/pestphp/pest/src/Expectation.php:316\nvendor/pestphp/pest/src/Support/Reflection.php:38\nvendor/pestphp/pest/src/Support/HigherOrderMessage.php:96\nvendor/pestphp/pest/src/Support/HigherOrderMessageCollection.php:43\nvendor/pestphp/pest/src/Factories/TestCaseFactory.php:148\nvendor/pestphp/pest/src/Concerns/Testable.php:302\nvendor/pestphp/pest/src/Support/ExceptionTrace.php:29\nvendor/pestphp/pest/src/Concerns/Testable.php:303\nvendor/pestphp/pest/src/Concerns/Testable.php:279\nvendor/pestphp/pest/src/Console/Command.php:119\nvendor/pestphp/pest/bin/pest:62\nvendor/pestphp/pest/bin/pest:63"

    local expected = {
      ["tests/Feature/UserTest.php::is false"] = {
        errors = { { message = message } },
        output_file = output_file,
        status = "failed",
        short = "FAILED | is false\n\n" .. message,
      },
    }

    local results = utils.get_test_results(xml_output, output_file)
    local key = "tests/Feature/UserTest.php::is false"

    assert.are.same(results[key].errors[1].message, expected[key].errors[1].message)
    assert.are.same(results, expected)
  end)

  it("parses output with errors", function()
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
            warnings = "0",
          },
          testsuite = {
            _attr = {
              assertions = "0",
              errors = "1",
              failures = "0",
              file = "tests/Feature/UserTest.php",
              name = "P\\Tests\\Feature\\UserTest",
              skipped = "0",
              tests = "1",
              time = "0.002610",
              warnings = "0",
            },
            testcase = {
              _attr = {
                assertions = "0",
                class = "Tests\\Feature\\UserTest",
                classname = "Tests.Feature.UserTest",
                file = "tests/Feature/UserTest.php",
                name = "tellName",
                time = "0.002610",
              },
              error = {
                "tests/Feature/UserTest.php::tellName\nException: Oops!\n\ntests/Feature/UserTest.php:24\nvendor/pestphp/pest/src/Factories/TestCaseFactory.php:151\nvendor/pestphp/pest/src/Concerns/Testable.php:302\nvendor/pestphp/pest/src/Support/ExceptionTrace.php:29\nvendor/pestphp/pest/src/Concerns/Testable.php:303\nvendor/pestphp/pest/src/Concerns/Testable.php:279\nvendor/pestphp/pest/src/Console/Command.php:119\nvendor/pestphp/pest/bin/pest:62\nvendor/pestphp/pest/bin/pest:63",
                _attr = {
                  type = "Exception",
                },
              },
            },
          },
        },
      },
    }

    local message =
      "tests/Feature/UserTest.php::tellName\nException: Oops!\n\ntests/Feature/UserTest.php:24\nvendor/pestphp/pest/src/Factories/TestCaseFactory.php:151\nvendor/pestphp/pest/src/Concerns/Testable.php:302\nvendor/pestphp/pest/src/Support/ExceptionTrace.php:29\nvendor/pestphp/pest/src/Concerns/Testable.php:303\nvendor/pestphp/pest/src/Concerns/Testable.php:279\nvendor/pestphp/pest/src/Console/Command.php:119\nvendor/pestphp/pest/bin/pest:62\nvendor/pestphp/pest/bin/pest:63"

    local expected = {
      ["tests/Feature/UserTest.php::tellName"] = {
        errors = { { message = message } },
        output_file = output_file,
        status = "failed",
        short = "ERROR | tellName\n\n" .. message,
      },
    }

    assert.are.same(utils.get_test_results(xml_output, output_file), expected)
  end)

  it("parses parameterized tests with all datasets passing", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "2",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "2",
            time = "0.002671",
          },
          testsuite = {
            _attr = {
              assertions = "2",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_handles_parameterized_values",
              skipped = "0",
              tests = "2",
              time = "0.002671",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::it handles parameterized values with data set \"('parameter 1')\"",
                  name = "it handles parameterized values with data set \"('parameter 1')\"",
                  time = "0.002222",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::it handles parameterized values with data set \"('parameter 2')\"",
                  name = "it handles parameterized values with data set \"('parameter 2')\"",
                  time = "0.000450",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::handles parameterized values"] = {
        output_file = output_file,
        short = "PASSED | handles parameterized values",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses parameterized tests where one dataset fails", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "2",
            errors = "0",
            failures = "1",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "2",
            time = "0.003906",
          },
          testsuite = {
            _attr = {
              assertions = "2",
              errors = "0",
              failures = "1",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_has_a_failing_parameterized_test",
              skipped = "0",
              tests = "2",
              time = "0.003906",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it has a failing parameterized test with data set "(1)"',
                  name = 'it has a failing parameterized test with data set "(1)"',
                  time = "0.000553",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it has a failing parameterized test with data set "(2)"',
                  name = 'it has a failing parameterized test with data set "(2)"',
                  time = "0.003353",
                },
                failure = {
                  'it has a failing parameterized test with data set "(2)"Failed asserting that 2 is identical to 1.\nat tests/Feature/ParameterizedTest.php:8',
                  _attr = {
                    type = "PHPUnit\\Framework\\ExpectationFailedException",
                  },
                },
              },
            },
          },
        },
      },
    }

    local message =
      'it has a failing parameterized test with data set "(2)"Failed asserting that 2 is identical to 1.\nat tests/Feature/ParameterizedTest.php:8'

    local expected = {
      ["tests/Feature/ParameterizedTest.php::has a failing parameterized test"] = {
        errors = { { message = message } },
        output_file = output_file,
        status = "failed",
        short = "FAILED | has a failing parameterized test\n\n" .. message,
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses parameterized tests using test() instead of it()", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "2",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "2",
            time = "0.001000",
          },
          testsuite = {
            _attr = {
              assertions = "2",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_handles_parameterized_values",
              skipped = "0",
              tests = "2",
              time = "0.001000",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::handles parameterized values with data set \"('value 1')\"",
                  name = "handles parameterized values with data set \"('value 1')\"",
                  time = "0.000500",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::handles parameterized values with data set \"('value 2')\"",
                  name = "handles parameterized values with data set \"('value 2')\"",
                  time = "0.000500",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::handles parameterized values"] = {
        output_file = output_file,
        short = "PASSED | handles parameterized values",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses parameterized tests with named datasets", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "3",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "3",
            time = "0.001450",
          },
          testsuite = {
            _attr = {
              assertions = "3",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_handles_named_datasets",
              skipped = "0",
              tests = "3",
              time = "0.001450",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it handles named datasets with data set "dataset "small number""',
                  name = 'it handles named datasets with data set "dataset "small number""',
                  time = "0.000511",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it handles named datasets with data set "dataset "medium number""',
                  name = 'it handles named datasets with data set "dataset "medium number""',
                  time = "0.000505",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it handles named datasets with data set "dataset "large number""',
                  name = 'it handles named datasets with data set "dataset "large number""',
                  time = "0.000434",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::handles named datasets"] = {
        output_file = output_file,
        short = "PASSED | handles named datasets",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses parameterized tests with object datasets", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "2",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "2",
            time = "0.000907",
          },
          testsuite = {
            _attr = {
              assertions = "2",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_handles_object_datasets",
              skipped = "0",
              tests = "2",
              time = "0.000907",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it handles object datasets with data set "(stdClass) #1"',
                  name = 'it handles object datasets with data set "(stdClass) #1"',
                  time = "0.000479",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it handles object datasets with data set "(stdClass) #2"',
                  name = 'it handles object datasets with data set "(stdClass) #2"',
                  time = "0.000428",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::handles object datasets"] = {
        output_file = output_file,
        short = "PASSED | handles object datasets",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses parameterized tests with a single dataset entry", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "1",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "1",
            time = "0.002494",
          },
          testsuite = {
            _attr = {
              assertions = "1",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_handles_a_single_dataset_entry",
              skipped = "0",
              tests = "1",
              time = "0.002494",
            },
            testcase = {
              _attr = {
                assertions = "1",
                class = "Tests\\Feature\\ParameterizedTest",
                classname = "Tests.Feature.ParameterizedTest",
                file = "tests/Feature/ParameterizedTest.php::it handles a single dataset entry with data set \"('only one')\"",
                name = "it handles a single dataset entry with data set \"('only one')\"",
                time = "0.002494",
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::handles a single dataset entry"] = {
        output_file = output_file,
        short = "PASSED | handles a single dataset entry",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses parameterized tests with edge case strings in datasets", function()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "5",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "5",
            time = "0.002355",
          },
          testsuite = {
            _attr = {
              assertions = "5",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_handles_edge_case_strings",
              skipped = "0",
              tests = "5",
              time = "0.002355",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::it handles edge case strings with data set \"('')\"",
                  name = "it handles edge case strings with data set \"('')\"",
                  time = "0.000443",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::it handles edge case strings with data set \"(' ')\"",
                  name = "it handles edge case strings with data set \"(' ')\"",
                  time = "0.000427",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it handles edge case strings with data set "(\'string with "quotes"\')"',
                  name = 'it handles edge case strings with data set "(\'string with "quotes"\')"',
                  time = "0.000431",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::it handles edge case strings with data set \"('string with 'single quotes'')\"",
                  name = "it handles edge case strings with data set \"('string with 'single quotes'')\"",
                  time = "0.000542",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = "tests/Feature/ParameterizedTest.php::it handles edge case strings with data set \"('line1line2')\"",
                  name = "it handles edge case strings with data set \"('line1line2')\"",
                  time = "0.000512",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::handles edge case strings"] = {
        output_file = output_file,
        short = "PASSED | handles edge case strings",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses repeated tests using ->repeat()", function()
    -- Pest's ->repeat() produces the same "with data set" JUnit XML format as ->with()
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "3",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "3",
            time = "0.005610",
          },
          testsuite = {
            _attr = {
              assertions = "3",
              errors = "0",
              failures = "0",
              file = "tests/Feature/ParameterizedTest.php",
              name = "Tests\\Feature\\ParameterizedTest::__pest_evaluable_it_runs_repeatedly",
              skipped = "0",
              tests = "3",
              time = "0.005610",
            },
            testcase = {
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it runs repeatedly with data set "(1)"',
                  name = 'it runs repeatedly with data set "(1)"',
                  time = "0.004672",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it runs repeatedly with data set "(2)"',
                  name = 'it runs repeatedly with data set "(2)"',
                  time = "0.000487",
                },
              },
              {
                _attr = {
                  assertions = "1",
                  class = "Tests\\Feature\\ParameterizedTest",
                  classname = "Tests.Feature.ParameterizedTest",
                  file = 'tests/Feature/ParameterizedTest.php::it runs repeatedly with data set "(3)"',
                  name = 'it runs repeatedly with data set "(3)"',
                  time = "0.000451",
                },
              },
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::runs repeatedly"] = {
        output_file = output_file,
        short = "PASSED | runs repeatedly",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it('does not strip "with" from regular test names containing that word', function()
    -- Regression test: a test named "works with normal assertions" should NOT
    -- have "with" stripped from its name (only "with data set ..." is stripped)
    local xml_output = {
      testsuites = {
        testsuite = {
          _attr = {
            assertions = "1",
            errors = "0",
            failures = "0",
            name = "Tests\\Feature\\ParameterizedTest",
            skipped = "0",
            tests = "1",
            time = "0.002596",
          },
          testcase = {
            _attr = {
              assertions = "1",
              class = "Tests\\Feature\\ParameterizedTest",
              classname = "Tests.Feature.ParameterizedTest",
              file = "tests/Feature/ParameterizedTest.php::it works with normal assertions",
              name = "it works with normal assertions",
              time = "0.002596",
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/ParameterizedTest.php::works with normal assertions"] = {
        output_file = output_file,
        short = "PASSED | works with normal assertions",
        status = "passed",
      },
    }

    assert.are.same(expected, utils.get_test_results(xml_output, output_file))
  end)

  it("parses output with skipped tests", function()
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
            warnings = "0",
          },
          testsuite = {
            _attr = {
              assertions = "0",
              errors = "0",
              failures = "0",
              file = "tests/Feature/UserTest.php",
              name = "P\\Tests\\Feature\\UserTest",
              skipped = "1",
              tests = "1",
              time = "0.001544",
              warnings = "0",
            },
            testcase = {
              _attr = {
                assertions = "0",
                class = "Tests\\Feature\\UserTest",
                classname = "Tests.Feature.UserTest",
                file = "tests/Feature/UserTest.php",
                name = "skipped",
                time = "0.001544",
              },
              skipped = {},
            },
          },
        },
      },
    }

    local expected = {
      ["tests/Feature/UserTest.php::skipped"] = {
        output_file = output_file,
        short = "SKIPPED | skipped",
        status = "skipped",
      },
    }

    assert.are.same(utils.get_test_results(xml_output, output_file), expected)
  end)
end)
-- vim: fdm=indent fdl=2
