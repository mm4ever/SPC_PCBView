# CMake generated Testfile for 
# Source directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/column
# Build directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/column
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(column-reader-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/column-reader-test")
set_tests_properties(column-reader-test PROPERTIES  LABELS "unittest")
add_test(column-writer-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/column-writer-test")
set_tests_properties(column-writer-test PROPERTIES  LABELS "unittest")
add_test(levels-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/levels-test")
set_tests_properties(levels-test PROPERTIES  LABELS "unittest")
add_test(properties-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/properties-test")
set_tests_properties(properties-test PROPERTIES  LABELS "unittest")
add_test(scanner-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/scanner-test")
set_tests_properties(scanner-test PROPERTIES  LABELS "unittest")
add_test(statistics-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/statistics-test")
set_tests_properties(statistics-test PROPERTIES  LABELS "unittest")
