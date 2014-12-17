function Phi = designMatrix(X,basis,varargin)
% Phi = designMatrix(X,basis)
% Phi = designMatrix(X,'polynomial',degree)
% Phi = designMatrix(X,'gaussian',Mu,s)
%
% Compute the design matrix for input data X
% X is n-by-d
% Mu is k-by-d
%
% TO DO:: You need to fill in foo1 and foo2 /// DONE

if strcmp(basis,'polynomial')
  k = varargin{1};
  Phi = foo1(X,k);
%elseif strcmp(basis,'gaussian')
 % Mu = varargin{1};
 % s = varargin{2};
 % Phi = foo2(X,Mu,s);
%else
 % error('Unknown basis type');
 
end

    function Phi1 = foo1(X1,k1)
        %Compute design matrix for polynomial basis functions
        n1 = size(X1,1);
        m1 = size(X1,2);
        Phi1 = ones(n1,((k1*m1)+1));
        
        for ii = 1:k1
            Phi1(:,(((ii-1)*m1)+2):((ii*m1)+1)) = X1.^ii;
        end
    end
    
 %   function Phi2 = foo2(X2,Mu2,s)
	%Compute design matrix for gaussian basis functions
  %      n2 = size(X2,1);
   %     k2 = size(Mu2,1);
    %    Phi2 = zeros(n2,k2);
     %   for i = 1:n2
      %      for j = 1:(k2)
       %         Phi2(i,j) = exp(-dist2(X2(i,:),Mu2(j,:))/(2*(s^2)));
        %    end
        %end
    %end    
  
end
