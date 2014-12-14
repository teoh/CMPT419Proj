%{ 
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 28, 2014
Email:      mteoh@sfu.ca
%}

%{
This script will get the review texts from the training data for each of
the 13 groups. 
%}

clc

startGroup=1;
endGroup=13;

outputDirect='.\splitTrainTest_getText\';
outputDir_train='train\';

dir_inputMatFiles=[outputDirect,outputDir_train];

% for each group
for ii=startGroup:1:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    
    matFileName=['part4_group',groupNumStr,'_train'];
    fprintf('\tLoading data from %s... ',matFileName);
    tic;
    load([dir_inputMatFiles,matFileName,'.mat'])
    t=toc;
    fprintf('Done in %d seconds\n',t);
    
    %get number of hotels 
    numHtls=size(groupData_train,1);
    totalNum_reviews=0;
    
    for kk=1:numHtls
        totalNum_reviews=totalNum_reviews+groupData_train(kk).numReviews;
    end
    
    reviewArr_forFile = cell(totalNum_reviews,1);
    totalReview_ctr=1;
    
    % loop across all hotels
    for kk=1:numHtls
        % loop across all reviews
        for pp=1:groupData_train(kk).numReviews
            reviewArr_forFile{totalReview_ctr}=...
                groupData_train(kk).Reviews{pp}.Content;
            totalReview_ctr=totalReview_ctr+1;
        end
    end
    
    
    reviewTextOut_dir=[outputDirect,outputDir_train,...
        'reviewTexts_group',groupNumStr,'\'];
    reviewTextOut_path=[reviewTextOut_dir,'reviewTexts_group',...
        groupNumStr,'.txt'];
    fprintf('\tPrinting the reviews to: %s...',reviewTextOut_path);
    tic;    
    fid=fopen(reviewTextOut_path,'wt');
    fprintf(fid, '%s\n', reviewArr_forFile{:});
    fclose(fid);
    t=toc;
    fprintf(' Done in %d seconds!\n',t);
    
    
    
end


