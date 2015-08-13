module load ci
echo "About to make the modules"
cd $WORKSPACE/$NAME-$VERSION
ls
echo $?

make install # DESTDIR=$SOFT_DIR

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds OpenMPI 1.8.8 to your environment"
}

module load gcc/4.8.2
#module load pbs
#module load slurm

module-whatis   "$NAME $VERSION."
setenv       OPENMPI_VERSION       $VERSION
set          OPENMPI_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path 	PATH            $OPENMPI_DIR/bin
prepend-path    PATH            $OPENMPI_DIR/include
prepend-path    PATH            $OPENMPI_DIR/bin
prepend-path    MANPATH         $OPENMPI_DIR/man
prepend-path    LD_LIBRARY_PATH $OPENMPI_DIR/lib
MODULE_FILE
) > modules/$VERSION
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME/$VERSION

# Testing module
module avail
module list
module add $NAME
# confirm openmpi
which mpirun

# Test installation

