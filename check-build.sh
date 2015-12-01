#!/bin/bash -e
. /etc/profile.d/modules.sh

module load ci
echo "About to make the modules"
cd $WORKSPACE/$NAME-$VERSION
ls
echo $?

echo "running make check"
make check

echo "running make install"
make install # DESTDIR=$SOFT_DIR

mkdir -p ${REPO_DIR}

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds OpenMPI 1.8.8 to your environment"
}

module load torque/2.5.13
module load gcc/$GCC_VERSION

module-whatis   "$NAME $VERSION."
setenv       OPENMPI_VERSION       $VERSION
setenv       OPENMPI_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path 	 PATH            $::env(OPENMPI_DIR)/bin
prepend-path    PATH            $::env(OPENMPI_DIR)/include
prepend-path    PATH            $::env(OPENMPI_DIR)/bin
prepend-path    MANPATH         $::env(OPENMPI_DIR)/man
prepend-path    LD_LIBRARY_PATH $::env(OPENMPI_DIR)/lib
MODULE_FILE
) > modules/$VERSION-gcc-$GCC_VERSION
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION-gcc-$GCC_VERSION $LIBRARIES_MODULES/$NAME/$VERSION-gcc-$GCC_VERSION

# Testing module
module avail
module list
module load $NAME/$VERSION-gcc-$GCC_VERSION
# confirm openmpi
which mpirun
