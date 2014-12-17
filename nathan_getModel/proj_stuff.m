clc

fprintf('Loading and intitializing...\n');

%load our data
load('xt_train.mat');
% load('nathanTryT.mat');
%variables that can be altered for the script
%X is n-by-d
% X = [1,2,3;4,5,6;1,3,5;7,8,9;2,7,0];
X = master_xVect(1:5860,:);
%t is n-by-e
% t = [2,5;12,3;6,4;23,68;1,1];
t = master_tVect(1:5860,:);
K = 10;
max_deg = 3;
lambdas = [0 0.01 0.1 1 10 100 1000];

%computed variables
[X_n, muX, sigX] = normalizeData(X);
[t, muT, sigT] = normalizeData(t);

n = size(X_n,1);
d = size(X_n,2);
e = size(t,2);
num_lam = size(lambdas, 2);
ind = n/K;  %make sure this is an integer

w_ML = cell(num_lam, max_deg, 1);
rmse_cell = cell(num_lam, max_deg, 1);

%weights, rmse, deg, lam
minimums_cell = cell(e,4,1);
%note: f,2,1 for f > 1 is empty
minimums_cell{1,2,1} = inf(e,1);

for lam = 1:num_lam
    lambda = lambdas(lam);

    for deg = 1:max_deg
        fprintf('Performing %i-fold cross-validation for lambda = %g and degree = %i...\n', K, lambda, deg);
        
        rmse = zeros(e,1);
        %cross-validation
        test_X_deg = zeros(ind,(deg*d));
        for ii = 1:K
            test_X = X_n((((ii-1)*ind)+1):(ii*ind),:);
            test_t = t((((ii-1)*ind)+1):(ii*ind),:); 
            if ii == 1
                train_X = X_n(ind+1:end,:);
                train_t = t(ind+1:end,:);
            end
            if ii > 1
                train_X = [X_n(1:((ii-1)*ind),:); X_n(((ii*ind)+1):end,:)];
                train_t = [t(1:((ii-1)*ind),:); t(((ii*ind)+1):end,:)];
            end          
            w_ML_temp = poly_regress_once(train_X, train_t, deg, lambda);
            for jj = 1:deg
                test_X_deg(:,(((jj-1)*d)+1):(jj*d)) = (test_X.^jj);
            end
            rmse = rmse + test_once(w_ML_temp, test_X_deg, test_t, ind);     
        end

   %     w_ML{lam,deg,1} = poly_regress_once(X_n, t, deg, lambda);
   %     rmse_cell{lam,deg,1} = rmse;
        
        ismin = rmse < minimums_cell{1,2,1};
        for ee = 1:e
            if ismin(ee)
                w_ML = poly_regress_once(X_n, t, deg, lambda);
                minimums_cell{ee,1,1} = w_ML(:,ee);
                minimums_cell{1,2,1}(ee) = rmse(ee);               
                minimums_cell{ee,3,1} = deg;
                minimums_cell{ee,4,1} = lambda;
            end
        end
        
    end

end

fprintf('Program complete!\nCheck minimums_cell for weights.\nAnd thank you for flying Nathaniel Airlines.  We hope your data had a nice trip!');