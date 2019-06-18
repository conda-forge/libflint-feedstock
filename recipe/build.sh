#!/usr/bin/env bash

chmod +x configure

if [[ "$cxx_compiler" == "toolchain_cxx" ]]; then
    export CFLAGS="$CFLAGS -ansi -pedantic -Wall -O2 -funroll-loops -g -mpopcnt -Wno-unknown-pragmas"
    export CXXFLAGS="$CXXFLAGS -std=c++11 -pedantic -Wall -O2 -funroll-loops -g -mpopcnt -Wno-unknown-pragmas"
else
    export CFLAGS="$CFLAGS -funroll-loops -g -mpopcnt -Wno-unknown-pragmas"
    export CXXFLAGS="$CXXFLAGS -funroll-loops -g -mpopcnt -Wno-unknown-pragmas"
fi

# This is set to reduce the number of random tests run so that CIs can run 
# tests to completion without timeouts.
echo "int flint_test_multiplier(){return 1;}" > test_helpers.c

./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-ntl=$PREFIX
make -j${CPU_COUNT}
make install
ls -al ${PREFIX}/lib
make check -j${CPU_COUNT}
