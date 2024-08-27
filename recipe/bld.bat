REM reduce the number of tests
echo int flint_test_multiplier(){return 1;} > test_helpers.c

set "CFLAGS=%CFLAGS% /experimental:c11atomics /std:c11"

copy %LIBRARY_LIB%\libpthread.dll.a %LIBRARY_LIB%\pthread.lib

mkdir build
cd build

cmake ^
  -G "Ninja" ^
  -DBUILD_TESTING=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DENABLE_AVX2=OFF ^
  -DENABLE_AVX512=OFF ^
  ..

ninja -j%CPU_COUNT%

ctest -j%CPU_COUNT% --verbose --timeout 600

ninja install

del /S /Q %LIBRARY_LIB%\pthread.lib
