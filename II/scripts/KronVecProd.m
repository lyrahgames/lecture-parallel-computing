function [y] = KronVecProd(A,B,x)
%KRONVECPROD Kronecker Vector Product
%   KronVecProd(A,B,x) computes the matrix-vector product in which the
%   matrix is the Kronecker product of the matrices A and B and x is some
%   given vector. Rather than using the mathematically equivalent
%   implementation y = kron(A,B)*x, this implementation is based on the
%   reformulation in terms of a matrix-matrix-matrix product.

% Author: H. Martin Buecker, buecker@acm.org
% Date: 04/16/2015

[m,n] = size(A);
[p,q] = size(B);
y = reshape(B*reshape(x,q,n)*A.',p*m,1);
end

