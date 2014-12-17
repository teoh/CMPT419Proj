function w_ML = poly_regress_once(X_n, t, deg, lambda)
% X_n and t should already be normalized
% X_n is data matrix
%t is target matrix
%deg is degree of polynomial

   Phi = designMatrix(X_n,'polynomial',deg);

   m = size(Phi,2);
    
   %w_ML should be a ((d*i)+1)-by-e matrix
   %for standard regression
   if lambda == 0
     w_ML = pinv(Phi)*t;
   end
   %regularized form
   if lambda > 0
     w_ML = ((lambda*eye(m) + Phi'*Phi)\(Phi'))*t;
   end
end