/* --------------------------------------------------------------------------
CppAD: C++ Algorithmic Differentiation: Copyright (C) 2003-18 Bradley M. Bell

CppAD is distributed under the terms of the
             Eclipse Public License Version 2.0.

This Source Code may also be made available under the following
Secondary License when the conditions for such availability set forth
in the Eclipse Public License, Version 2.0 are satisfied:
      GNU General Public License, Version 2.0 or later.
---------------------------------------------------------------------------- */

// CPPAD_HAS_* defines
# include <cppad/configure.hpp>

// system include files used for I/O
# include <iostream>

// C style asserts
# include <cassert>

// for thread_alloc
# include <cppad/utility/thread_alloc.hpp>

// test runner
# include <cppad/utility/test_boolofvoid.hpp>

// external complied tests
extern bool base2ad(void);
extern bool checkpoint(void);
extern bool eigen_cholesky(void);
extern bool eigen_mat_inv(void);
extern bool eigen_mat_mul(void);
extern bool extended_ode(void);
extern bool for_sparse_hes(void);
extern bool for_sparse_jac(void);
extern bool forward(void);
extern bool get_started(void);
extern bool mat_mul(void);
extern bool mul_level(void);
extern bool norm_sq(void);
extern bool ode(void);
extern bool reciprocal(void);
extern bool rev_sparse_hes(void);
extern bool rev_sparse_jac(void);
extern bool reverse(void);
extern bool set_sparsity(void);
extern bool tangent(void);

// main program that runs all the tests
int main(void)
{   std::string group = "example/atomic";
    size_t      width = 20;
    CppAD::test_boolofvoid Run(group, width);

    // This line is used by test_one.sh

    // external compiled tests
    Run( base2ad,             "base2ad"        );
    Run( checkpoint,          "checkpoint"     );
    Run( extended_ode,        "extended_ode"   );
    Run( for_sparse_hes,      "for_sparse_hes" );
    Run( for_sparse_jac,      "for_sparse_jac" );
    Run( forward,             "forward"        );
    Run( get_started,         "get_started"    );
    Run( mat_mul,             "mat_mul"        );
    Run( mul_level,           "mul_level"      );
    Run( norm_sq,             "norm_sq"        );
    Run( ode,                 "ode"            );
    Run( reciprocal,          "reciprocal"     );
    Run( rev_sparse_hes,      "rev_sparse_hes" );
    Run( rev_sparse_jac,      "rev_sparse_jac" );
    Run( reverse,             "reverse"        );
    Run( set_sparsity,        "set_sparsity"   );
    Run( tangent,             "tangent"        );
# if CPPAD_HAS_EIGEN
    Run( eigen_cholesky,      "eigen_cholesky" );
    Run( eigen_mat_inv,       "eigen_mat_inv"  );
    Run( eigen_mat_mul,       "eigen_mat_mul"  );
# endif
    // check for memory leak
    bool memory_ok = CppAD::thread_alloc::free_all();
    // print summary at end
    bool ok = Run.summary(memory_ok);
    //
    return static_cast<int>( ! ok );
}
