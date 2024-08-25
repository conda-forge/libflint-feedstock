REM reduce the number of tests
echo int flint_test_multiplier(){return 1;} > test_helpers.c

mkdir build
cd build

cmake ^
  -G "Ninja" ^
  -DBUILD_TESTING=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  ..

ninja -j%CPU_COUNT%

ctest -j%CPU_COUNT% --verbose --timeout 600

ninja install
