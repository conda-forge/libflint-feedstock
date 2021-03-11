#!/usr/bin/env bash

chmod +x configure

export CFLAGS="$CFLAGS -funroll-loops -g -Wno-unknown-pragmas"
export CXXFLAGS="$CXXFLAGS -funroll-loops -g -Wno-unknown-pragmas"

#if [[ "$target-platform" == *-64 ]]; then
    #export CFLAGS="$CFLAGS -mpopcnt"
    #export CXXFLAGS="$CXXFLAGS -mpopcnt"
#fi

# This is set to reduce the number of random tests run so that CIs can run 
# tests to completion without timeouts.
echo "int flint_test_multiplier(){return 1;}" > test_helpers.c

if [[ "$WITH_NTL" == 1 ]]; then
  ./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX --with-ntl=$PREFIX --disable-static
else
  ./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX --disable-static
fi

make -j${CPU_COUNT}
make install

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
  make check -j${CPU_COUNT}
fi
