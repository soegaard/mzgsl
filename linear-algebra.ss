#lang scheme/base

(require "low-level/gsl-linear-algebra.ss"
         "gslvector.ss"
         "matrix.ss"
         "permutations.ss")

;;; API

(define matrix-cholesky! gsl_linalg_cholesky_decomp)
(define matrix-cholesky-invert! gsl_linalg_cholesky_invert)

(define (matrix-cholesky m)
  (define m2 (matrix-copy m))
  (matrix-cholesky! m2)
  m2)

(define (matrix-cholesky-invert m)
  (define m2 (matrix-copy m))
  (matrix-cholesky-invert! m2)
  m2)

;; (matrix -> number)
;;
;; Calculate the determinant of a (symmetric positive
;; definite) matrix given its Cholesky decomposition
(define (matrix-cholesky-determinant m)
  (define l (matrix-rows m))
  (define product
    (for/fold ([prod 1])
        ([i (in-range l)])
      (* prod (matrix-ref m i i))))
  (* product product))


(define matrix-lu! gsl_linalg_LU_decomp)
(define matrix-lu-invert! gsl_linalg_LU_invert)

(define (matrix-lu m)
  (define p (make-permutation (matrix-rows m)))
  (define s (box 0))
  (define m2 (matrix-copy m))
  (matrix-lu! m2 p s)
  (values m2 p (unbox s)))

(define (matrix-lu-invert lu p)
  (define m (make-matrix (matrix-rows lu) (matrix-cols lu)))
  (matrix-lu-invert! lu p m)
  m)

(define matrix-lu-determinant gsl_linalg_LU_det)

;; Generic matrix inverse procedure using the LU decomposition
(define (matrix-invert m)
  (define-values (lu p s) (matrix-lu m))
  (matrix-lu-invert lu p))

;; matrix -> (values matrix matrix vector)
(define (matrix-svd m)
  (define c (matrix-cols m))
  (define m2 (matrix-copy m))
  (define v (make-matrix c c))
  (define s (make-gslvector c))
  (define work (make-gslvector c))

  (gsl_linalg_SV_decomp m2 v s work)
  (values m2 s v))

(provide
 matrix-cholesky!
 matrix-cholesky-invert!

 matrix-cholesky
 matrix-cholesky-invert
 
 matrix-cholesky-determinant

 matrix-lu!
 matrix-lu-invert!

 matrix-lu
 matrix-lu-invert
 matrix-lu-determinant

 matrix-invert

 matrix-svd)