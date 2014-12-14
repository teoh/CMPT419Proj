%{ 
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 27, 2014
Email:      mteoh@sfu.ca
%}

%{
This script will take a random 30% of the hotels across all 13 groups. This
will be the test data, which will be in a separate .mat file. The 13 other
mat files produced will contain the remaining hotels after the test ones
have been removed. 

Within the groups of training data, for each hotel, there will be 1 text
file that has the all the hotel's reviews
%}

clc

startGroup=1;
endGroup=13;

outputDirect='.\splitTrainTest_getText\';
outputDir_train='train\';
outputDir_test='test\';

dir_inputMatFiles='.\getGroupStats\';

% create cell array that holds all 13 groups, convert to struct array later
cell_13Groups = cell(13,1);

for ii=startGroup:1:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    
    matFileName=['part3_group',groupNumStr];
    fprintf('\tLoading data from %s... ',matFileName);
    tic;
    load([dir_inputMatFiles,matFileName,'.mat'])
    t=toc;
    fprintf('Done in %d seconds\n',t);
    
    % make the struct after loading the data 
    groupMatData={struct('group_masterList_ratingTags',...
        {group_masterList_ratingTags},'group_masterList_reviewTags',...
        {group_masterList_reviewTags},'groupData',{groupData},...
        'numDiscar_part3',{numDiscar_part3},'numDiscarded_part2',...
        {numDiscarded_part2},'numKeep',{numKeep},'reviewDates_quartiles',...
        {reviewDates_quartiles})};
    cell_13Groups(ii)=groupMatData;
    
    clear groupMatData groupData
end

% convert to s struct array, and you don't need the cell one anymore
sa_13Groups=cell2mat(cell_13Groups);
clear cell_13Groups;

totalNumHotl=0;

for ii=startGroup:1:endGroup
    totalNumHotl=totalNumHotl+size(sa_13Groups(ii).groupData,1);
end

allHotel_grpNum_ind=zeros(totalNumHotl,2);

allHtl_ctr = 1;
for ii=startGroup:1:endGroup
    for kk=1:size(sa_13Groups(ii).groupData,1);
        allHotel_grpNum_ind(allHtl_ctr,:)=[ii,kk];
        allHtl_ctr=allHtl_ctr+1;
    end
end

perm=randperm(totalNumHotl);

allHtl_perm=allHotel_grpNum_ind(perm,:);

howManyTest = floor(0.3*totalNumHotl);

takeRandom_forTest=allHtl_perm(1:howManyTest,:);

remaining=allHtl_perm(howManyTest+1:end,:);

trainHotel_grpNum_ind=intersect(allHotel_grpNum_ind,remaining,'rows','stable');
testHotel_grpNum_ind=intersect(allHotel_grpNum_ind,takeRandom_forTest,'rows','stable');

for ii=startGroup:1:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    
    matFileName=['part4_group',groupNumStr];
    
    train_indices = trainHotel_grpNum_ind(find(trainHotel_grpNum_ind(:,1)==ii),2);
    test_indices = testHotel_grpNum_ind(find(testHotel_grpNum_ind(:,1)==ii),2);
    
    group_masterList_ratingTags=sa_13Groups(ii).group_masterList_ratingTags;
    group_masterList_reviewTags=sa_13Groups(ii).group_masterList_reviewTags;
    
    groupData_train = sa_13Groups(ii).groupData(train_indices);
    groupData_test = sa_13Groups(ii).groupData(test_indices);
    %**
    numDiscar_part3=sa_13Groups(ii).numDiscar_part3;
    numDiscarded_part2=sa_13Groups(ii).numDiscarded_part2;
    numKeep=sa_13Groups(ii).numKeep;
    reviewDates_quartiles=sa_13Groups(ii).reviewDates_quartiles;
    % prepare mat files for the TRAINING  
    train_outputPath=[outputDirect,outputDir_train,matFileName,'_train'];
    fprintf('\t\tSaving to %s...',train_outputPath);
    tic
    save(train_outputPath,'group_masterList_ratingTags',...
        'group_masterList_reviewTags','groupData_train','numDiscar_part3',...
        'numDiscarded_part2','numKeep','reviewDates_quartiles');
    t=toc;
    fprintf('Done in %d seconds!\n',t);
    % prepare mat files for the TESTING 
    test_outputPath=[outputDirect,outputDir_test,matFileName,'_test'];
    fprintf('\t\tSaving to %s...',test_outputPath);
    tic
    save(test_outputPath,'group_masterList_ratingTags',...
        'group_masterList_reviewTags','groupData_test','numDiscar_part3',...
        'numDiscarded_part2','numKeep','reviewDates_quartiles');
    t=toc;
    fprintf('Done in %d seconds!\n',t);
    
end
