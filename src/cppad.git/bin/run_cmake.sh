#! /bin/bash -e
# -----------------------------------------------------------------------------
# CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-18 Bradley M. Bell
#
# CppAD is distributed under the terms of the
#              Eclipse Public License Version 2.0.
#
# This Source Code may also be made available under the following
# Secondary License when the conditions for such availability set forth
# in the Eclipse Public License, Version 2.0 are satisfied:
#       GNU General Public License, Version 2.0 or later.
# -----------------------------------------------------------------------------
if [ ! -e "bin/run_cmake.sh" ]
then
    echo "bin/run_cmake.sh: must be executed from its parent directory"
    exit 1
fi
# -----------------------------------------------------------------------------
# bash function that echos and executes a command
echo_eval() {
    echo $*
    eval $*
}
# -----------------------------------------------------------------------------
addr_t_size_t='no'
verbose='no'
standard='c++11'
profile_speed='no'
clang='no'
no_adolc='no'
no_colpack='no'
no_eigen='no'
no_ipopt='no'
no_documentation='no'
testvector='boost'
debug_which='debug_all'
while [ "$1" != "" ]
do
    if [ "$1" == '--help' ]
    then
        cat << EOF
usage: bin/run_cmake.sh: \\
    [--help] \\
    [--addr_t_size_t] \\
    [--verbose] \\
    [--c++98] \\
    [--profile_speed] \\
    [--callgrind] \\
    [--clang ] \\
    [--no_adolc] \\
    [--no_colpack] \\
    [--no_eigen] \\
    [--no_ipopt] \\
    [--no_sacado] \\
    [--no_documentation] \\
    [--<package>_vector] \\
    [--debug_<which>]
The --help option just prints this message and exits.
The value <package> above must be one of: cppad, boost, or eigen.
The value <which> must be one of: odd, even, all, none.

EOF
        exit 0
    fi
    case "$1" in

        --addr_t_size_t)
        addr_t_size_t='yes'
        ;;

        --verbose)
        verbose='yes'
        ;;

        --c++98)
        standard='c++98'
        ;;

        --profile_speed)
        profile_speed='yes'
        ;;

        --callgrind)
        callgrind='yes'
        ;;

        --clang)
        clang='yes'
        ;;

        --no_adolc)
        no_adolc='yes'
        ;;

        --no_colpack)
        no_colpack='yes'
        ;;

        --no_eigen)
        no_eigen='yes'
        ;;

        --no_ipopt)
        no_ipopt='yes'
        ;;

        --no_sacado)
        no_sacado='yes'
        ;;

        --no_documentation)
        no_documentation='yes'
        ;;

        --cppad_vector)
        testvector='cppad'
        ;;

        --boost_vector)
        testvector='boost'
        ;;

        --eigen_vector)
        testvector='eigen'
        ;;

        --debug_odd)
        debug_which='debug_odd'
        ;;

        --debug_even)
        debug_which='debug_even'
        ;;

        --debug_all)
        debug_which='debug_all'
        ;;

        --debug_none)
        debug_which='debug_none'
        ;;

        *)
        echo "$1 is an invalid option, try bin/run_cmake.sh --help"
        exit 1
    esac
    shift
done
# ---------------------------------------------------------------------------
if [ "$standard" == 'c++98' ]
then
    if [ "$no_adolc" == 'no' ]
    then
        echo 'run_cmake.sh: --no_adolc required when --c++98 present'
        exit 1
    fi
    if [ "$no_sacado" == 'no' ]
    then
        echo 'run_cmake.sh: --no_sacado required when --c++98 present'
        exit 1
    fi
fi
# ---------------------------------------------------------------------------
if [ ! -e build ]
then
    echo_eval mkdir build
fi
echo_eval cd build
if [ -e CMakeCache.txt ]
then
    echo_eval rm CMakeCache.txt
fi
if [ -e CMakeFiles ]
then
    echo_eval rm -r CMakeFiles
fi
# ---------------------------------------------------------------------------
# clean all variables in cmake cache
cmake_args='-U .+'
#
if [ "$verbose" == 'yes' ]
then
    # echo each command that make executes
    cmake_args="$cmake_args  -D CMAKE_VERBOSE_MAKEFILE=YES"
fi
# -----------------------------------------------------------------------------
# cppad_prefix
cmake_args="$cmake_args  -D cppad_prefix=$HOME/prefix/cppad"
#
# cmake_install_includedirs
if [ -d '/usr/include' ]
then
    cmake_args="$cmake_args -D cmake_install_includedirs=include"
fi
#
# cmake_install_datadir
if [ -d '/usr/share' ]
then
    cmake_args="$cmake_args -D cmake_install_datadir=share"
fi
#
# cmake_install_docdir
if [ -d '/usr/share' ] && [ "$no_documentation" == 'no' ]
then
    cmake_args="$cmake_args -D cmake_install_docdir=share/doc"
fi
#
# cmake_install_libdirs
if [ -d '/usr/lib64' ]
then
    cmake_args="$cmake_args -D cmake_install_libdirs='lib64;lib'"
elif [ -d '/usr/lib' ]
then
    cmake_args="$cmake_args -D cmake_install_libdirs='lib;lib64'"
fi
#
# {package}_prefix
package_list='fadbad'
if [ "$no_adolc" == 'no' ]
then
    package_list="$package_list adolc"
fi
if [ "$no_colpack" == 'no' ]
then
    package_list="$package_list colpack"
fi
if [ "$no_eigen" == 'no' ]
then
    package_list="$package_list eigen"
fi
if [ "$no_ipopt" == 'no' ]
then
    package_list="$package_list ipopt"
fi
if [ "$no_sacado" == 'no' ]
then
    package_list="$package_list sacado"
fi
for package in $package_list
do
    dir=$HOME/prefix/$package
    if [ -d "$dir" ]
    then
        cmake_args="$cmake_args  -D ${package}_prefix=$dir"
    fi
done
#
# cppad_cxx_flags
cppad_cxx_flags="-Wall -pedantic-errors -std=$standard -Wshadow"
cppad_cxx_flags="$cppad_cxx_flags -Wfloat-conversion -Wconversion"
if [ "$callgrind" == 'yes' ]
then
    if [ "$debug_which" != 'debug_none' ]
    then
        echo 'run_cmake.sh: --callgrind requires --debug_none'
        exit 1
    fi
    cppad_cxx_flags="$cppad_cxx_flags -g"
fi
cmake_args="$cmake_args -D cppad_cxx_flags='$cppad_cxx_flags'"
#
# clang
if [ "$clang" == 'yes' ]
then
    cmake_args="$cmake_args -D CMAKE_C_COMPILER=clang"
    cmake_args="$cmake_args -D CMAKE_CXX_COMPILER=clang++"
fi
#
# profile
if [ "$profile_speed" == 'yes' ]
then
    cmake_args="$cmake_args -D cppad_profile_flag=-pg"
fi
#
# simple options
cmake_args="$cmake_args -D cppad_testvector=$testvector"
cmake_args="$cmake_args -D cppad_debug_which=$debug_which"
cmake_args="$cmake_args -D cppad_max_num_threads=48"
if [ "$addr_t_size_t" == 'yes' ]
then
    cmake_args="$cmake_args -D cppad_tape_id_type='size_t'"
    cmake_args="$cmake_args -D cppad_tape_addr_type=size_t"
else
    cmake_args="$cmake_args -D cppad_tape_id_type='int32_t'"
    cmake_args="$cmake_args -D cppad_tape_addr_type=int32_t"
fi
#
echo_eval cmake $cmake_args ..
#
# ----------------------------------------------------------------------------
echo "$0: OK"
exit 0
