%{
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 28, 2014
Email:      mteoh@sfu.ca
%}


%{
This script will split each of the files into x and t based on the date:
    - in x, the reviews contained will be before 24-Sep-2008, which we
    decided will be our cutoff date
    - in t, the reviews contained will be after 24-Sep-2008 

the serial for this cut off date is: 733675

NOTE: over all of the training/testing data, it seems like the reviews
span from 29-May-2001 to 11-May-2012, with 24-Sep-2008 in between
(obviously)
%}

clc

fitCutoffBetweenQ1Q3 = true

startGroup=1;
endGroup=13;

%need input and output directories for TRAINING
dir_inputMat_train='.\splitTrainTest_getText\train\';
dir_outputMat_train='.\splitXfromT\train\';

%need input and output directories for TEST
dir_inputMat_test='.\splitTrainTest_getText\test\';
dir_outputMat_test='.\splitXfromT\test\';

% the magic date that we're cutting things off at: 24-Sep-2008
cutoffSerial = 733675;

%{ 
within groupData_****, split the following fields into x and t:
    - Reviews
    - rev_dates
    - rev_dates_serial
adjust because of the split, then put into the x and t:
    - numReviews

either training or testing. x data should have:
    - Reviews (before cutoff)
    - numReviews (before cutoff)
    - rev_dates (before cutoff)
    - rev_dates_serial (before cutoff)
    - HotelInfo
    - listedPrices (only keep if not NaN; also correct that stuff because
    commas!!)
    - max_diff      (you'll have to adjust this!!)
    - ind_max_aft   (you'll have to adjust this!!)
    - ind_max_bef   (you'll have to adjust this!!)
    - masterList_ratingTags (include "business service" and "check in")
    - masterList_reviewTags

either training or testing. t data should have:
    - Reviews (after cutoff)
    - numReviews (before cutoff)
    - rev_dates (after cutoff)
    - rev_dates_serial (after cutoff)
    - HotelInfo
    - masterList_ratingTags (include "business service" and "check in")
    - masterList_reviewTags

either training or testing, generate the following (spans whole group):
    - intersection of all the 

we dont need these anymore:
    - perc_rev_dates_serial
    - perc_rev_dates
%}

for ii = startGroup:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    
    fprintf('Operating on group: %s\n',groupNumStr);
    
    trainPath=[dir_inputMat_train,'part4_group',groupNumStr,'_train.mat'];
    testPath=[dir_inputMat_test,'part4_group',groupNumStr,'_test.mat'];
    
    % open the mat files
    fprintf('\tOpening part4_group%s_train.mat...',groupNumStr)
    tic
    trainingMat=load(trainPath);
    t=toc;
    fprintf(' done in %d seconds\n',t);
    fprintf('\tOpening part4_group%s_test.mat...',groupNumStr);
    tic
    testingMat=load(testPath);
    t=toc;
    fprintf(' done in %d seconds\n',t);
    
    % STEP 1: get rid of hotels in each of TRAIN and TEST that have NaN
    % prices
    % how many hotels in each of train and test
    numHotl_train=size(trainingMat.groupData_train,1);
    numHotl_test=size(testingMat.groupData_test,1);
    
    % get the hotel prices
    hotlPrices_train={trainingMat.groupData_train(:).listedPrices}';
    hotlPrices_test={testingMat.groupData_test(:).listedPrices}';
    
    % get mean prices look for that NaN
    avgHotlPrcs_train = zeros(numHotl_train,1);
    avgHotlPrcs_test = zeros(numHotl_test,1);
    
    for kk=1:numHotl_train
        avgHotlPrcs_train(kk)=mean(hotlPrices_train{kk});
    end
    
    for kk=1:numHotl_test
        avgHotlPrcs_test(kk)=mean(hotlPrices_test{kk});
    end
    
    numNan_train=sum(isnan(avgHotlPrcs_train));
    numNan_test=sum(isnan(avgHotlPrcs_test));
    
    fprintf('%s: %d/%d are NaN\n',groupNumStr,numNan_train,numHotl_train);
    fprintf('%s: %d/%d are NaN\n',groupNumStr,numNan_test,numHotl_test);
        
    % get a vector containing the indices of hotels that do NOT have NaN
    % values for prices
    notNanHotl_train=find(~isnan(avgHotlPrcs_train));
    notNanHotl_test=find(~isnan(avgHotlPrcs_test));
    
    % for each of test and train get a new struct array that contains ONLY
    % the hotels we want to split (ie NO NAN VALUES FOR PRICES)
    hotlGrp_train=trainingMat.groupData_train(notNanHotl_train);
    numHotl_train=numHotl_train-numNan_train;
    hotlGrp_test=testingMat.groupData_test(notNanHotl_test);
    numHotl_test=numHotl_test-numNan_test;
    
    if fitCutoffBetweenQ1Q3

        quartContainCutoff_train = zeros(numHotl_train,1);
        quartContainCutoff_test = zeros(numHotl_test,1);

        for kk=1:numHotl_train
            perc_serial=hotlGrp_train(kk).perc_rev_dates_serial;
            if (perc_serial(2) < cutoffSerial)&&(cutoffSerial < perc_serial(4))
                quartContainCutoff_train(kk)=1;
            end
        end
        for kk=1:numHotl_test
            perc_serial=hotlGrp_test(kk).perc_rev_dates_serial;
            if (perc_serial(2) < cutoffSerial)&&(cutoffSerial < perc_serial(4))
                quartContainCutoff_test(kk)=1;
            end
        end

        keep_quartCutoff_train=sum(quartContainCutoff_train);
        keep_quartCutoff_test=sum(quartContainCutoff_test);

        fprintf('\t%s: %d/%d have cutoff between Q1Q3. We keep this many\n',...
            groupNumStr,keep_quartCutoff_train,numHotl_train);
        fprintf('\t%s: %d/%d have cutoff between Q1Q3. We keep this many\n',...
            groupNumStr,keep_quartCutoff_test,numHotl_test);
        
        hotlGrp_train=hotlGrp_train(find(quartContainCutoff_train));
        numHotl_train=keep_quartCutoff_train;
        hotlGrp_test=hotlGrp_test(find(quartContainCutoff_test));
        numHotl_test=keep_quartCutoff_test;
    
    end
    
    if numHotl_train~=size(hotlGrp_train,1)...
            || numHotl_test~=size(hotlGrp_test,1)
        error('Error: sizes for your hotels are inconsistent!')
    end

    % step 2: for test and train split reviews according to x and t get a
    % cell array with #hotels entries where each entry is two rows where
    % 1st row (#reviews long) contains 1s where you want reviews for x, and
    % 2nd row has 1s where you want reviews for t
    revArrMarker_train=cell(numHotl_train,1);
    revArrMarker_test=cell(numHotl_test,1);
    
    % get for training 
    for kk=1:numHotl_train
        revArrMarker_train{kk}=[...
            (hotlGrp_train(kk).rev_dates_serial<cutoffSerial)';...
            (hotlGrp_train(kk).rev_dates_serial>=cutoffSerial)'];
    end
    
    % get for testing 
    for kk=1:numHotl_test
        revArrMarker_test{kk}=[...
            (hotlGrp_test(kk).rev_dates_serial<cutoffSerial)';...
            (hotlGrp_test(kk).rev_dates_serial>=cutoffSerial)'];
    end
    
    % step 3: for the training and testing, split Review, rev_dates,
    % rev_dates_serial into x and t categories
    
    % for training
    hotlGrpX_train = hotlGrp_train;
    hotlGrpT_train = hotlGrp_train;
    
    hotlGrpX_train(:)=rmfield(hotlGrpX_train(:),{'perc_rev_dates',...
        'perc_rev_dates_serial'});
    hotlGrpT_train(:)=rmfield(hotlGrpT_train(:),{'perc_rev_dates',...
        'perc_rev_dates_serial','max_diff','ind_max_aft','ind_max_bef'});
    for kk=1:numHotl_train
        X_ind=find(revArrMarker_train{kk}(1,:));
        T_ind=find(revArrMarker_train{kk}(2,:));
        % Reviews
        hotlGrpX_train(kk).Reviews...
            =hotlGrp_train(kk).Reviews(X_ind);
        hotlGrpT_train(kk).Reviews...
            =hotlGrp_train(kk).Reviews(T_ind);
        % rev_dates
        hotlGrpX_train(kk).rev_dates...
            =hotlGrp_train(kk).rev_dates(X_ind);
        hotlGrpT_train(kk).rev_dates...
            =hotlGrp_train(kk).rev_dates(T_ind);
        % rev_dates_serial
        hotlGrpX_train(kk).rev_dates_serial...
            =hotlGrp_train(kk).rev_dates_serial(X_ind);
        hotlGrpT_train(kk).rev_dates_serial...
            =hotlGrp_train(kk).rev_dates_serial(T_ind);
    end
    
    % for testing 
    hotlGrpX_test = hotlGrp_test;
    hotlGrpT_test = hotlGrp_test;
    
    hotlGrpX_test(:)=rmfield(hotlGrpX_test(:),{'perc_rev_dates',...
        'perc_rev_dates_serial'});
    hotlGrpT_test(:)=rmfield(hotlGrpT_test(:),{'perc_rev_dates',...
        'perc_rev_dates_serial','max_diff','ind_max_aft','ind_max_bef'});
    for kk=1:numHotl_test
        X_ind=find(revArrMarker_test{kk}(1,:));
        T_ind=find(revArrMarker_test{kk}(2,:));
        % Reviews
        hotlGrpX_test(kk).Reviews...
            =hotlGrp_test(kk).Reviews(X_ind);
        hotlGrpT_test(kk).Reviews...
            =hotlGrp_test(kk).Reviews(T_ind);
        % rev_dates 
        hotlGrpX_test(kk).rev_dates...
            =hotlGrp_test(kk).rev_dates(X_ind);
        hotlGrpT_test(kk).rev_dates...
            =hotlGrp_test(kk).rev_dates(T_ind);
        % rev_dates_serial
        hotlGrpX_test(kk).rev_dates_serial...
            =hotlGrp_test(kk).rev_dates_serial(X_ind);
        hotlGrpT_test(kk).rev_dates_serial...
            =hotlGrp_test(kk).rev_dates_serial(T_ind);
    end
    
    % step 4: for training and testing, adjust numReviews the max_diff,
    % ind_max_bef, ind_max_aft, and listPrices for the x data.
    
    % for training
    for kk=1:numHotl_train
        % numReviews
        hotlGrpX_train(kk).numReviews=...
            size(hotlGrpX_train(kk).Reviews,2);
        hotlGrpT_train(kk).numReviews=...
            size(hotlGrpT_train(kk).Reviews,2);
        % max_diff, ind_max_bef, ind_max_aft: X only
        backwdTimeDiff=hotlGrpX_train(kk).rev_dates_serial(1:end-1)...
            -hotlGrpX_train(kk).rev_dates_serial(2:end);
        [hotlGrpX_train(kk).max_diff,...
            ind_max_aft]=max(backwdTimeDiff);
        hotlGrpX_train(kk).ind_max_aft=ind_max_aft;
        hotlGrpX_train(kk).ind_max_bef=ind_max_aft+1;
        % listedPrices: X only
        if size(hotlGrpX_train(kk).listedPrices,2)>2
            cellarr_listedPrices=regexp(...
                strrep(hotlGrpX_train(kk).HotelInfo.Price,',','')...
                ,'(\d+)','tokens');
            listedPrices=str2double([cellarr_listedPrices{:}]);
            hotlGrpX_train(kk).listedPrices=listedPrices;
%             fprintf('\t%sTrainingX: New price at index kk=%d\n',groupNumStr,kk);
        end
    end
    
    % for test
    for kk=1:numHotl_test
        % numReviews
        hotlGrpX_test(kk).numReviews=...
            size(hotlGrpX_test(kk).Reviews,2);
        hotlGrpT_test(kk).numReviews=...
            size(hotlGrpT_test(kk).Reviews,2);
        % max_diff, ind_max_bef, ind_max_aft: X only
        backwdTimeDiff=hotlGrpX_test(kk).rev_dates_serial(1:end-1)...
            -hotlGrpX_test(kk).rev_dates_serial(2:end);
        [hotlGrpX_test(kk).max_diff,...
            ind_max_aft]=max(backwdTimeDiff);
        hotlGrpX_test(kk).ind_max_aft=ind_max_aft;
        hotlGrpX_test(kk).ind_max_bef=ind_max_aft+1;
        % listedPrices: X only
        if size(hotlGrpX_test(kk).listedPrices,2)>2
            cellarr_listedPrices=regexp(...
                strrep(hotlGrpX_test(kk).HotelInfo.Price,',','')...
                ,'(\d+)','tokens');
            listedPrices=str2double([cellarr_listedPrices{:}]);
            hotlGrpX_test(kk).listedPrices=listedPrices;
%             fprintf('\t%stestingX: New price at index kk=%d\n',groupNumStr,kk);
        end
    end
    
    5;
    % step 5: for the training and testing, and each of x and t, adjust the
    % Reviews struct so that the field names in the ratings contain
    % 'businessService' and 'checkIn' instead of those weird characters
    
    
    % for training
    fprintf('meep\n')
    for kk=1:numHotl_train
        % over x
        for qq=1:hotlGrpX_train(kk).numReviews
            fn=fieldnames(hotlGrpX_train(kk).Reviews{qq}.Ratings);
            for rr=1:size(fn,1)
                f=fn(rr);
                if ~isempty(strfind(f{:},'Business'))
                    hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings.('BusinessService')=...
                        hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpX_train(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Check'))
                    hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings.('CheckIn')=...
                        hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpX_train(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Sleep'))
                    hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings.('SleepQuality')=...
                        hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpX_train(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpX_train(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
            end
        end
        % over t
        for qq=1:hotlGrpT_train(kk).numReviews
            fn=fieldnames(hotlGrpT_train(kk).Reviews{qq}.Ratings);
            for rr=1:size(fn,1)
                f=fn(rr);
                if ~isempty(strfind(f{:},'Business'))
                    hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings.('BusinessService')=...
                        hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpT_train(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Check'))
                    hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings.('CheckIn')=...
                        hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpT_train(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Sleep'))
                    hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings.('SleepQuality')=...
                        hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpT_train(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpT_train(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
            end
        end
    end
    
    % for testing 
    fprintf('moop\n')
    for kk=1:numHotl_test
        % over x
        for qq=1:hotlGrpX_test(kk).numReviews
            fn=fieldnames(hotlGrpX_test(kk).Reviews{qq}.Ratings);
            for rr=1:size(fn,1)
                f=fn(rr);
                if ~isempty(strfind(f{:},'Business'))
                    hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings.('BusinessService')=...
                        hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpX_test(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Check'))
                    hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings.('CheckIn')=...
                        hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpX_test(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Sleep'))
                    hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings.('SleepQuality')=...
                        hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpX_test(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpX_test(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
            end
        end
        % over t
        for qq=1:hotlGrpT_test(kk).numReviews
            fn=fieldnames(hotlGrpT_test(kk).Reviews{qq}.Ratings);
            for rr=1:size(fn,1)
                f=fn(rr);
                if ~isempty(strfind(f{:},'Business'))
                    hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings.('BusinessService')=...
                        hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpT_test(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Check'))
                    hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings.('CheckIn')=...
                        hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpT_test(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
                if ~isempty(strfind(f{:},'Sleep'))
                    hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings.('SleepQuality')=...
                        hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings.(f{:});
                    hotlGrpT_test(kk).Reviews{qq}.Ratings=...
                        rmfield(hotlGrpT_test(kk).Reviews...
                        {qq}.Ratings,f{:});
                    continue
                end
            end
        end
    end
    
    5;
    % step 6: put it all into mat files and save
    
    % for training
    if fitCutoffBetweenQ1Q3
        xPath_train=[dir_outputMat_train,'x\','part5_QuartileConstraint_group',groupNumStr,'x_train'];
        tPath_train=[dir_outputMat_train,'t\','part5_QuartileConstraint_group',groupNumStr,'t_train'];
    else
        xPath_train=[dir_outputMat_train,'x\','part5_group',groupNumStr,'x_train'];
        tPath_train=[dir_outputMat_train,'t\','part5_group',groupNumStr,'t_train'];
    end
    fprintf('Saving: %s...',xPath_train)
    save(xPath_train,'hotlGrpX_train');
    fprintf(' done!\n')
    fprintf('Saving: %s...',tPath_train)
    save(tPath_train,'hotlGrpT_train');
    fprintf(' done!\n')
    
    % for testing
    if fitCutoffBetweenQ1Q3
        xPath_test=[dir_outputMat_test,'x\','part5_QuartileConstraint_group',groupNumStr,'x_test'];
        tPath_test=[dir_outputMat_test,'t\','part5_QuartileConstraint_group',groupNumStr,'t_test'];
    else
        xPath_test=[dir_outputMat_test,'x\','part5_group',groupNumStr,'x_test'];
        tPath_test=[dir_outputMat_test,'t\','part5_group',groupNumStr,'t_test'];
    end
    fprintf('Saving: %s...',xPath_test);
    save(xPath_test,'hotlGrpX_test');
    fprintf(' done!\n');
    fprintf('Saving: %s...',tPath_test);
    save(tPath_test,'hotlGrpT_test');
    fprintf(' done!\n');
    
end




