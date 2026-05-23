#include <R.h>
#include <Rinternals.h>
#include <Rmath.h>

/* 
 * as_of_indices: For each value in x_idx, find the largest index in y_idx 
 * such that y_idx[j] <= x_idx[i].
 * Assumes both x_idx and y_idx are sorted (which they are for xts).
 */
SEXP as_of_indices(SEXP x_idx, SEXP y_idx) {
    if (TYPEOF(x_idx) != REALSXP || TYPEOF(y_idx) != REALSXP) {
        // Fallback or error; xts indices are typically REALSXP
        error("xts indices must be REALSXP");
    }
    
    int nx = length(x_idx);
    int ny = length(y_idx);
    
    double *rx = REAL(x_idx);
    double *ry = REAL(y_idx);
    
    SEXP res = PROTECT(allocVector(INTSXP, nx));
    int *ires = INTEGER(res);
    
    int j = 0;
    for (int i = 0; i < nx; i++) {
        double current_x = rx[i];
        
        // Advance j while the NEXT element in y is still <= current_x
        // We use j+1 to peek ahead.
        while (j < ny && ry[j] <= current_x) {
            j++;
        }
        
        // At this point, ry[j] > current_x (or j == ny).
        // So the largest index <= current_x is j - 1.
        if (j == 0) {
            // All elements in y are > current_x
            ires[i] = NA_INTEGER;
        } else {
            // Convert to 1-based index for R
            ires[i] = j; // Since j advanced past the valid element, j is the 1-based index of the valid element (j-1 + 1)
        }
    }
    
    UNPROTECT(1);
    return res;
}
