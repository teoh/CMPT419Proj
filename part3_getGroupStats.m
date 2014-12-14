%{ 
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 27, 2014
Email:      mteoh@sfu.ca
%}

%{
This script will further process the stuff from part 2, getting stats that
span an entire group. Stats include: percentiles for dates of the reviews
across all the hotels kept, number of hotels kept/discarded (wrt this
step3), num discarded step 2, and master lists of rev and rating tags
across the entire group.

Discarding the hotels will be based on their earliest and latest review
dates.
%}

clc

% there are 13 groups specify the range of groups you wanna extract the
% data from. specify a start and an end group to operate on.

startGroup=1;
endGroup=13;

currentDir = pwd;
outputDirect='.\getGroupStats\';
dir_inputMatFiles='.\processHotelsGroup\';

for ii=startGroup:1:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    
    matFileName=['part2_group',groupNumStr];
    printWhichGroup=...
        sprintf('Getting data from .mat files in: %s\n',matFileName);
    fprintf(printWhichGroup);
    
    fprintf('\tLoading data from %s... ',matFileName);
    tic;
    load([dir_inputMatFiles,matFileName,'.mat'])
    t=toc;
    fprintf('Done in %d seconds\n',t);
    
    struArr_hotels=cell2mat(kept_HotelandRevData);  % save this for part 3
    num_hotl = size(struArr_hotels,1);              
    clear kept_HotelandRevData                      % we don't need this anymore
%     nums_reviews=[struArr_hotels.numReviews]';
    
%     figure(1);
%     hist(nums_reviews,100);
%     title('Histogram of number of reviews')

    % cut off for discarding more hotels is 7.336e5. That is, keep
    % only the hotels so that 7.336e5 is between the hotel's start and end
    % review date
    datesQuart=reshape...
        ([struArr_hotels.perc_rev_dates_serial],...
        [5,num_hotl]);                              % save this for part 3 using 'keep'
    cutoffH=7.337e5;%7.336e5;
    cutoffL=7.3365e5;
    goodhtls=(datesQuart(1,:)<cutoffL)&(cutoffH<datesQuart(5,:));
    keep=find(goodhtls);                            % use this to save hotels we want
                                                    
    numKeep = size(keep,2);                         % save this for part 3 
    numDiscar = num_hotl-numKeep;                   % save this for part 3 
    
    % get plot of the review dates: high/low, high/med/low, high/Q3/Q1/low
    % high/low
    figure(ii*10);
    plot(keep,datesQuart([1,5],keep));
    legend('L','H');
    title(['from:',matFileName,' HL; kept: ',num2str(numKeep),...
        '; discard: ', num2str(numDiscar)]);
    % high/med/low
    figure(ii*10+1);
    plot(keep,datesQuart([1,5,3],keep))
    legend('L','M','H');
    title(['from:',matFileName,' HML; kept: ',num2str(numKeep),...
        '; discard: ', num2str(numDiscar)]);
    % high/Q3/Q1/low
    figure(ii*10+2);
    plot(keep,datesQuart([1,5,2,4],keep));
    legend('L','Q1','Q3','H');
    title(['from:',matFileName,' HQQL; kept: ',num2str(numKeep),...
        '; discard: ', num2str(numDiscar)]);
    
    % save the figures
    savefilename=['part3_group',groupNumStr,'_HL'];
    savefig(figure(ii*10),[outputDirect,'HL\',savefilename]);
    savefilename=['part3_group',groupNumStr,'_HML'];
    savefig(figure(ii*10+1),[outputDirect,'HML\',savefilename]);
    savefilename=['part3_group',groupNumStr,'_HQQL'];
    savefig(figure(ii*10+2),[outputDirect,'HQQL\',savefilename]);
    
    % get GROUP master list of rating tags, and review tags
    group_masterList_ratingTags = {};               % save this for part 3
    group_masterList_reviewTags = {};               % save this for part 3
    
    for kk=1:num_hotl
        % get any tag you have not seen before
        group_masterList_ratingTags=union(group_masterList_ratingTags,...
            struArr_hotels(kk).masterList_ratingTags);
        group_masterList_reviewTags=union(group_masterList_reviewTags,...
            struArr_hotels(kk).masterList_reviewTags);
    end
    
    close all;
    
    % collect all the things you wanna save for the group
    groupData=struArr_hotels(keep);
    numKeep;
    numDiscar_part3=numDiscar;
    numDiscarded_part2 = numDiscarded;
    reviewDates_quartiles=datesQuart(:,keep);
    group_masterList_ratingTags;
    group_masterList_reviewTags;
    
    
    % save all this group data

    outputPath = [outputDirect,'\part3_group',groupNumStr];
    fprintf('\t\tSaving to %s...',outputPath);
    tic
    save(outputPath,'groupData','numKeep','numDiscar_part3',...
        'numDiscarded_part2','reviewDates_quartiles',...
        'group_masterList_ratingTags','group_masterList_reviewTags');
    t=toc;
    fprintf('Done in %d seconds!\n',t);
    clear groupData struArr_hotels reviewDates_quartiles datesQuart;
    
end






















