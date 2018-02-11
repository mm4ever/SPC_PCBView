# CMake generated Testfile for 
# Source directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/util
# Build directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/util
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(bit-util-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/bit-util-test")
set_tests_properties(bit-util-test PROPERTIES  LABELS "unittest")
add_test(comparison-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/comparison-test")
set_tests_properties(comparison-test PROPERTIES  LABELS "unittest")
add_test(memory-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/memory-test")
set_tests_properties(memory-test PROPERTIES  LABELS "unittest")
add_test(rle-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/rle-test")
set_tests_properties(rle-test PROPERTIES  LABELS "unittest")
