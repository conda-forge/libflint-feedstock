mkdir build
cd build

cmake ^
  -G "Ninja" ^
  -DBUILD_TESTING=ON ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  ..

cmake --build . --target fmpz_poly_factor-test-t-factor -- -j%CPU_COUNT%

ctest -j%CPU_COUNT% --verbose --timeout 180 -R "^fmpz_poly_factor-test-t-factor$"
