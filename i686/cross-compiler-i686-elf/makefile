all: export_envs make_binutils make_gcc

export_envs:
	@ export PREFIX="$HOME/opt/cross"
	@ export TARGET=i686-elf
	@ export PATH="$PREFIX/bin:$PATH"

make_binutils:
	@ cd $HOME/src
	@ mkdir build-binutils
	@ cd build-binutils
	@ $BINUTILS_PACKAGE/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
	@ make -j 8
	@ make -j 8 install

make_gcc:
	@ cd $HOME/src 
	@ mkdir build-gcc
	@ cd build-gcc
	@ $GCC_PACKAGE/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
	@ make -j 8 all-gcc
	@ make -j 8 all-target-libgcc
	@ make -j 8 install-gcc
	@ make -j 8 install-target-libgcc