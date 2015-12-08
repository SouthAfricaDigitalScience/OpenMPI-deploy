#!/bin/bash -e
. /etc/profile.d/modules.sh
module load ci
# add prerequistes
module add gmp
module add mpfr
module add mpc
module add ncurses
module load gcc/${GCC_VERSION}
module add torque/2.5.13-gcc-${GCC_VERSION}
echo "About to make the modules"
cd ${WORKSPACE}/${NAME}-${VERSION}
ls
echo $?

echo "Installing into CI (apprepo)"
make install

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds OpenMPI 1.8.8 to your environment"
}
module add gmp
module add mpfr
module add mpc
module add ncurses
module add gcc/${GCC_VERSION}
module add torque/2.5.13

module-whatis   "$NAME $VERSION."
setenv       OPENMPI_VERSION       $VERSION
setenv       OPENMPI_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION-gcc-${GCC_VERSION}

prepend-path 	 PATH            $::env(OPENMPI_DIR)/bin
prepend-path    PATH            $::env(OPENMPI_DIR)/include
prepend-path    PATH            $::env(OPENMPI_DIR)/bin
prepend-path    MANPATH         $::env(OPENMPI_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(OPENMPI_DIR)/lib
MODULE_FILE
) > modules/${VERSION}-gcc-${GCC_VERSION}
mkdir -p ${LIBRARIES_MODULES}/${NAME}
cp modules/${VERSION}-gcc-${GCC_VERSION} ${LIBRARIES_MODULES}/${NAME}/${VERSION}-gcc-${GCC_VERSION}

# Testing module
module avail
module list
module add ${NAME}/${VERSION}-gcc-${GCC_VERSION}
echo "PATH is : $PATH"
echo "LD_LIBRARY_PATH is $LD_LIBRARY_PATH"
# confirm openmpi
which mpirun
