#!/usr/bin/env bash

chmod +x configure

export CFLAGS="$CFLAGS -funroll-loops -g -Wno-unknown-pragmas"
export CXXFLAGS="$CXXFLAGS -funroll-loops -g -Wno-unknown-pragmas"

# This is set to reduce the number of random tests run so that CIs can run 
# tests to completion without timeouts.
echo "int flint_test_multiplier(){return 1;}" > test_helpers.c

./configure --prefix=$PREFIX --with-gmp=$PREFIX --with-mpfr=$PREFIX --disable-static --disable-arch

[[ "$target_platform" == "win-64" ]] && patch_libtool

make -j${CPU_COUNT}
make install

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != 1 ]]; then
  make check -j${CPU_COUNT}
fi
