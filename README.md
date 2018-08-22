# OpenMPI-deploy

[![Build Status](https://ci.sagrid.ac.za/job/OpenMPI/badge/icon)](https://ci.sagrid.ac.za/job/OpenMPI/)

A repository containing openmpi installation used by Jenkins

## Versions

We build version

  * 3.1

## Dependencies

This project depends on :

  * torque
  * gcc


## Contents of the repo

This repo contains three scripts

  1. `build.sh`
  2. `check-build.sh`
  1. `deploy.sh`

These define basically two test phases, the **build** and **functional** test phases respectively.

### Build Test Phase

The build phase does the following things

  1. Set up the build environment variables, loads gcc-4.9/5.2 and torque-2.5.13
  2. Downloads the source code using `wget`
  3. Configure the build with option `--enable-heterogeneous`, `--enable-mpi-thread-mutliple`, `--with-tm`
  4. Compile the source into an executable form.
  5. Create a modulefile which loads the dependencies and sets the environment variables needed to execute the application.

The build phase should pass iff the expected libraries and executable files are present. **It is your responsibility to define where these files are, on a case-by-case basis**.

### Functional test phase

The test phase does the following things :

  1. Loads the modulefile created by `check-build.sh`
  2. Installs the libraries into the `$SOFT_DIR` directory
  3. Does a small test

## When things go wrong

If you have a legitimate error, or need support, please [open an issue](../../issues)
