#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy

module add gmp
module add mpfr
module add mpc
module add ncurses
module add gcc/${GCC_VERSION}
module add torque/2.5.13-gcc-${GCC_VERSION}

echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}
echo "All tests have passed, will now build into ${SOFT_DIR}-gcc-${GCC_VERSION}"
echo "Configuring the deploy"
FC=`which gfortran` CC=`which gcc` CXX=`which g++` ./configure --prefix=${SOFT_DIR}-gcc-${GCC_VERSION} --enable-heterogeneous --enable-mpi-thread-multiple --with-tm=${TORQUE_DIR}

make install
echo "Creating the modules file directory ${LIBRARIES_MODULES}"
mkdir -p ${LIBRARIES_MODULES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}
module add gmp
module add mpfr
module add mpc
module add ncurses
module add gcc/${GCC_VERSION}
module add torque/2.5.13-${GCC_VERSION}

module-whatis   "$NAME $VERSION."
setenv       OPENMPI_VERSION       $VERSION
setenv       OPENMPI_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}

prepend-path 	 PATH            $::env(OPENMPI_DIR)/bin
prepend-path    PATH            $::env(OPENMPI_DIR)/include
prepend-path    PATH            $::env(OPENMPI_DIR)/bin
prepend-path    MANPATH         $::env(OPENMPI_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(OPENMPI_DIR)/lib
MODULE_FILE
) > ${LIBRARIES_MODULES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}


# Testing module
module avail
module list
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
echo "PATH is : $PATH"
echo "LD_LIBRARY_PATH is $LD_LIBRARY_PATH"
# confirm openmpi
which mpirun
