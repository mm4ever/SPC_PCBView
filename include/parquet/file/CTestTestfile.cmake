# CMake generated Testfile for 
# Source directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/file
# Build directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/file
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(file-deserialize-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/file-deserialize-test")
set_tests_properties(file-deserialize-test PROPERTIES  LABELS "unittest")
add_test(file-metadata-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/file-metadata-test")
set_tests_properties(file-metadata-test PROPERTIES  LABELS "unittest")
add_test(file-serialize-test "/home/rime/apache-parquet-cpp-1.0.0/build-support/run-test.sh" "/home/rime/apache-parquet-cpp-1.0.0" "test" "/home/rime/apache-parquet-cpp-1.0.0/build/debug/file-serialize-test")
set_tests_properties(file-serialize-test PROPERTIES  LABELS "unittest")
