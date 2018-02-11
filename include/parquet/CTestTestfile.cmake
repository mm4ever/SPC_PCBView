# CMake generated Testfile for 
# Source directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet
# Build directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(compression-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/compression-test")
set_tests_properties(compression-test PROPERTIES  LABELS "unittest")
add_test(encoding-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/encoding-test")
set_tests_properties(encoding-test PROPERTIES  LABELS "unittest")
add_test(public-api-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/public-api-test")
set_tests_properties(public-api-test PROPERTIES  LABELS "unittest")
add_test(types-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/types-test")
set_tests_properties(types-test PROPERTIES  LABELS "unittest")
add_test(reader-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/reader-test")
set_tests_properties(reader-test PROPERTIES  LABELS "unittest")
add_test(schema-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/schema-test")
set_tests_properties(schema-test PROPERTIES  LABELS "unittest")
