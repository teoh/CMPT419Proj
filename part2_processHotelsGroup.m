%{
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 26, 2014
Email:      mteoh@sfu.ca
%}

%{ 
This script will get the following information:
    For each hotel: (hotel discarded if number reviews <= 10)
        - same data extracted from the json files
        - # reviews
        - array with the dates, and array with their serial date numbers
        - lower, Q1, median, Q3, upper values of the dates
        - the (two) indices between the largest time gap occurs
        - price range (get string for now; use regular expressions for
        later)
        - master list of all rating tags
        - master list of all review tags

    For each group:
        - # discarded
        - # not discarded
        - the rest of the data that we collected for each hotel
        ::: I got too tired to do the rest, so I'll do it another time
        - array of ____ review dates (you could have just one big matrix):
            - lower
            - Q1
            - median
            - Q3
            - upper
        - over all hotels in the group, master list of all rating tags 
        - over all hotels in the group, master list of all review tags
        - array with #s of reviews
%}

clc

% there are 13 groups specify the range of groups you wanna extract the
% data from. specify a start and an end group to operate on.

startGroup=1;
endGroup=13;

currentDir = pwd;
outputDirect='.\processHotelsGroup';
dir_matFilesToProc='.\json_to_mat\';

discard_threshold=10;

% go through all the groups and get this information
for ii=startGroup:1:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    % file and directory info of INPUT .mat files
    matFileName=['group',groupNumStr];
    printWhichGroup=sprintf('Getting data from .mat files in: %s\n',matFileName);
    fprintf(printWhichGroup);
    
    % inform user that we're reading the file and when we're done
    fprintf('\tLoading data from %s... ',matFileName);
    tic;
    load([dir_matFilesToProc,matFileName,'.mat'])
    t=toc;
    fprintf('Done in %d seconds\n',t);
    
    clear times
    
    % start time to see how long it takes to generate the data for the
    % group
    tic;
    
    prtHotelGrpProg='..\n';
    fprintf(prtHotelGrpProg);
    
    % for each hotel in this group, ignore it if the number of reviews is
    % not greater than 10, and get all the information listed above
    numHotelsInGrp=size(groupData,1);
    keepHotel=zeros(numHotelsInGrp,1);
    HotelandRevData=cell(numHotelsInGrp,1);
    for kk=1:numHotelsInGrp
        numToBcksp=numel(prtHotelGrpProg);
        fprintf(repmat('\b',1,numToBcksp));
        prtHotelGrpProg=sprintf('\n\t\tWorking on hotel %d/%d...\n',kk,numHotelsInGrp);
        fprintf(prtHotelGrpProg);
        
        % if the hotel has more than 10 ('discard_threshold') reviews, keep
        % it (i.e. edit keepHotel to say that you wanna use it). if not,
        % move to the next one
        numReviews=size(groupData{kk}.Reviews,2);       % add to hotel's info
        if numReviews <= discard_threshold
            continue;
        else
            keepHotel(kk)=1;
        end
        hotelRevs=[groupData{kk}.Reviews{1,:}];
        %review dates and their corresponding serials
        rev_dates={hotelRevs.Date}';                    % add to hotel's info
        rev_dates_serial=datenum(rev_dates);            % add to hotel's info
        
        % lower, Q1, median, Q3, upper values. note some of these values may
        % not exist in the arrays above
        perc_rev_dates_serial...
            =quantile(rev_dates_serial,[0 0.25 0.50...
            0.75 1]);                                   % add to hotel's info
        perc_rev_dates...
            =datestr(perc_rev_dates_serial);     % add to hotel's info
        
        backwd_timediff=rev_dates_serial(1:end-1)-rev_dates_serial(2:end);
        [max_diff, ind_max_aft]=max(backwd_timediff);   % add to hotel's info
        ind_max_bef=ind_max_aft+1;                      % add to hotel's info
        
        % get the price range, or single price if there happens to be one
        % (could be 0,1,2 values listed there. if 0 values, will have 'NaN')
        cellarr_listedPrices=regexp(...
            groupData{kk}.HotelInfo.Price,'(\d+)','tokens');
        listedPrices=str2double...
            ([cellarr_listedPrices{:}]);                % add to hotel's info
        
        % unfortunately to make master lists for the rating and review
        % tags, i have to loop over all the reviews
        hotelRatings={hotelRevs(:).Ratings}';
        masterList_ratingTags={};                       % add to hotel's info
        masterList_reviewTags={};                       % add to hotel's info
        
        for mm=1:numReviews
            ratingTags=fieldnames(hotelRatings{mm});
            reviewtags=fieldnames(hotelRevs(mm));
            
            masterList_ratingTags=union(masterList_ratingTags,ratingTags);
            masterList_reviewTags=union(masterList_reviewTags,reviewtags);
        end
        
        % lump it all into one struct and put it in the tempHotelandRevData
        HotelandRevData(kk)={struct('Reviews',{groupData{kk}.Reviews},'HotelInfo',...
            groupData{kk}.HotelInfo,'numReviews',numReviews,...
            'rev_dates',{rev_dates},'rev_dates_serial',{rev_dates_serial},...
            'perc_rev_dates_serial',{perc_rev_dates_serial},'perc_rev_dates',...
            {perc_rev_dates},'max_diff',max_diff,'ind_max_aft',ind_max_aft,...
            'ind_max_bef',ind_max_bef,'listedPrices',{listedPrices},...
            'masterList_ratingTags',{masterList_ratingTags},...
            'masterList_reviewTags',{masterList_reviewTags})};
    end
    
    % now start piling stuff for all the hotels
    discarded=find(~keepHotel);
    kept=find(keepHotel);
    numDiscarded=size(discarded,1);
    numKept=size(kept,1);
    
    kept_HotelandRevData=HotelandRevData(kept);
    
    timeTaken_generateData=toc;
    
    outputpath=[outputDirect,'\part2_',matFileName,'.mat'];

    save(outputpath,'numDiscarded','numKept','kept_HotelandRevData',...
        'timeTaken_generateData');
    clear kept_HotelandRevData HotelandRevData groupData discarded...
        hotelRatings hotelRevs keepHotel 
    
end



















