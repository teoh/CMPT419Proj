function rmse = test_once(w_ML, X_n, t, n)

%predicted value (e-by-n) + (e-by-d)*(d-by-n) = (e-by-n)
    pred = repmat(w_ML(1,:)',1,n) + w_ML((2:end),:)'*X_n';
    
    %square of the difference between predicted and target for all n examples
    mat_se = ((pred - t').^2);
    
    %row sum over examples to get squared error for each target type
    se = sum(mat_se, 2);
	
    %rmse is e-by-1
    rmse = (se./n).^(0.5);
end