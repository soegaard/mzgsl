#lang scheme/base

(require (planet schematics/schemeunit:3/test))
(require "gsl-matrix.ss")

(define/provide-test-suite gsl-matrix-tests

  (test-case
   "gsl-matrix set and get"
   (let ([m (gsl_matrix_calloc 4 4)])
     (after
      (check-equal? (gsl_matrix_get m 2 2) 0.0)
      (gsl_matrix_set m 2 2 10.0)
      (check-equal? (gsl_matrix_get m 2 2) 10.0)

      (gsl_matrix_free m))))
  )