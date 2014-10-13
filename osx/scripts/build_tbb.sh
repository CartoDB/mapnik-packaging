#!/usr/bin/env bash
set -e -u
set -o pipefail
mkdir -p ${PACKAGES}
mkdir -p ${BUILD}/lib/
mkdir -p ${BUILD}/include/
cd ${PACKAGES}

TBB_VERSION="tbb43_20140724oss"

if [ ! -f ${TBB_VERSION}_src.tgz ]; then
    echoerr "downloading intel tbb"
    curl -s -S -f -O -L https://www.threadingbuildingblocks.org/sites/default/files/software_releases/source/${TBB_VERSION}_src.tgz
else
    echoerr "using cached node at ${TBB_VERSION}_src.tgz"
fi

echoerr 'building tbb'

function create_links() {
    libname=$1
    if [ -f $BUILD/lib/${libname}.so ]; then rm $BUILD/lib/${libname}.so; fi
    cp $(pwd)/build/BUILDPREFIX_release/${libname}.so.2 ${BUILD}/lib/
    ln -s $BUILD/lib/${libname}.so.2 $BUILD/lib/${libname}.so
}

if [[ ${UNAME} == 'Linux' ]]; then
    LDFLAGS="${LDFLAGS} "'-Wl,-z,origin -Wl,-rpath=\$$ORIGIN'
    CXXFLAGS="${CXXFLAGS} -Wno-attributes"
fi

# libtbb does not support -fvisibility=hidden
CXXFLAGS="${CXXFLAGS//-fvisibility=hidden}"


if [[ $CXX11 == true ]]; then
    rm -rf ${TBB_VERSION}
    tar xf ${TBB_VERSION}_src.tgz
    cd ${TBB_VERSION}
    patch -N -p1 <  ${PATCHES}/tbb_compiler_override.diff || true
    # note: static linking not allowed: http://www.threadingbuildingblocks.org/faq/11
    if [[ $UNAME == 'Darwin' ]]; then
      $MAKE -j${JOBS} tbb_build_prefix=BUILDPREFIX arch=intel64 cpp0x=1 stdlib=libc++ compiler=clang tbb_build_dir=$(pwd)/build
    else
      $MAKE -j${JOBS} tbb_build_prefix=BUILDPREFIX cfg=release arch=intel64 cpp0x=1 tbb_build_dir=$(pwd)/build
    fi

    # custom install
    if [[ ${UNAME} == "Darwin" ]]; then
        cp $(pwd)/build/BUILDPREFIX_release/libtbb.dylib ${BUILD}/lib/
        cp $(pwd)/build/BUILDPREFIX_release/libtbbmalloc.dylib ${BUILD}/lib/
    else
        create_links libtbbmalloc_proxy
        create_links libtbbmalloc
        create_links libtbb
    fi
    cp -r $(pwd)/include/tbb ${BUILD}/include/
else
    echoerr 'skipping libtbb build since we only target c++11 mode'
fi