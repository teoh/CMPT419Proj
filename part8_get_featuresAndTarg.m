%{
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 30, 2014
Email:      mteoh@sfu.ca
%}

clc

fitCutoffBetweenQ1Q3 = true
% TO DO: ADD IN STUFF FOR QUARTILE CONSTRAINT SO THAT FILE ACCESS WORKS

% get the words
load('.\get_featuresAndTarg\featureWords\chosen_AdjAdvGer.mat');

fid=fopen('.\get_featuresAndTarg\featureWords\businessService_words.txt');
businessService=textscan(fid,'%s','Delimiter','\n');
businessService=businessService{1};

fid=fopen('.\get_featuresAndTarg\featureWords\checkIn_words.txt');
checkIn=textscan(fid,'%s','Delimiter','\n');
checkIn=checkIn{1};

fid=fopen('.\get_featuresAndTarg\featureWords\cleanliness_words.txt');
cleanliness=textscan(fid,'%s','Delimiter','\n');
cleanliness=cleanliness{1};

fid=fopen('.\get_featuresAndTarg\featureWords\location_words.txt');
location=textscan(fid,'%s','Delimiter','\n');
location=location{1};

fid=fopen('.\get_featuresAndTarg\featureWords\rooms_words.txt');
rooms=textscan(fid,'%s','Delimiter','\n');
rooms=rooms{1};

fid=fopen('.\get_featuresAndTarg\featureWords\service_words.txt');
service=textscan(fid,'%s','Delimiter','\n');
service=service{1};

fid=fopen('.\get_featuresAndTarg\featureWords\value_words.txt');
value=textscan(fid,'%s','Delimiter','\n');
value=value{1};

fclose(fid);

text_features=[businessService; checkIn; chosenAdj; chosenAdv; ...
    chosenGer; cleanliness; location; rooms; service; value];

% choose train or test
getForTrain=false;

inputDir_pref='.\splitXfromT\';

if getForTrain
    whichXT='train';
else
    whichXT='test';
end

% choose groups
startGroup=1;
endGroup=13;

inputDir_X=[whichXT,'\x\'];
inputDir_T=[whichXT,'\t\'];

% info about the vectors
num_featWords=size(text_features,1);
numfeatures=num_featWords+9;
allGrpVect_x = cell(endGroup-startGroup+1,1);
% get for x first
for ii=startGroup:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
	else
        groupNumStr=num2str(ii);
    end
       
    fprintf('X: \tOpening group: %s',groupNumStr);
    load([inputDir_pref,inputDir_X,'part5_group',groupNumStr,'x_',whichXT]);
    fprintf(' done!\n');
    
    if getForTrain
    	hotlGrpX=hotlGrpX_train;
	else
    	hotlGrpX=hotlGrpX_test;
    end
    
    numHotls=size(hotlGrpX,1);
    % this contains all the feature vectors for the group
    featVec_rows=zeros(numHotls,numfeatures);

    progstr='\n';
    % loop through all the hotels
    fprintf(progstr);
    for kk=1:numHotls
        % how many are we done
        bcksp=repmat('\b',[1,numel(progstr)]);
        fprintf(bcksp);
        progstr=sprintf('\nX: \tGroup %s: working on %d/%d hotels\n',...
        groupNumStr,kk,numHotls);
        fprintf(progstr);
        
        num_reviews=hotlGrpX(kk).numReviews;
        review_contents=cell(num_reviews,1);
        review_ratings=zeros(num_reviews,1);
        % loop through all the reviews for that hotel. get all the words
        % and the ratings
        for qq=1:num_reviews
            review_contents(qq)={hotlGrpX(kk).Reviews{qq}.Content};
            review_ratings(qq)=str2double...
                (hotlGrpX(kk).Reviews{qq}.Ratings.Overall);
        end
        megaString=lower(strjoin(review_contents'));
        avgRating=mean(review_ratings);
        % get the feature values for the words
        for qq=1:num_featWords
            stringToSearch=text_features{qq};
            featVec_rows(kk,qq)=size(strfind(megaString,stringToSearch),2)/num_reviews;
        end
        % feature value for the mean rating
        featVec_rows(kk,num_featWords+1)=avgRating;
        
        % quanties of the dates
        featVec_rows(kk,num_featWords+2:end-3)=quantile...
            (hotlGrpX(kk).rev_dates_serial',[0 0.25 0.5 0.75 1]);
        % price avg, #revs, max diff
        max_diff=hotlGrpX(kk).max_diff;
        if isempty(max_diff)
            max_diff=0;
        end
        featVec_rows(kk,end-2:end)=[mean(hotlGrpX(kk).listedPrices)...
            ,num_reviews,max_diff];
    end
    
    allGrpVect_x(ii)={featVec_rows};
    
end

master_xVect=vertcat(allGrpVect_x{:});

% get for t
allGrpVect_t = cell(endGroup-startGroup+1,1);
for ii=startGroup:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
	else
        groupNumStr=num2str(ii);
    end
       
    fprintf('T: \tOpening group: %s',groupNumStr);
    load([inputDir_pref,inputDir_T,'part5_group',groupNumStr,'t_',whichXT]);
    fprintf(' done!\n');
    
    if getForTrain
    	hotlGrpT=hotlGrpT_train;
	else
    	hotlGrpT=hotlGrpT_test;
    end
    
    numHotls=size(hotlGrpT,1);
    % this contains all the feature vectors for the group. 1st column is
    % avg rating. 2nd column is #rev, 3rd is # rev/day
    targVec_rows=zeros(numHotls,3);
    
    progstr='\n';
    % loop through all the hotels
    fprintf(progstr);
    
    for kk=1:numHotls
        % how many are we done
        bcksp=repmat('\b',[1,numel(progstr)]);
        fprintf(bcksp);
        progstr=sprintf('\nT: \tGroup %s: working on %d/%d hotels\n',...
        groupNumStr,kk,numHotls);
        fprintf(progstr);
        
        num_reviews=hotlGrpT(kk).numReviews;
        review_ratings=zeros(num_reviews,1);
        for qq=1:num_reviews
            review_ratings(qq)=str2double...
                (hotlGrpT(kk).Reviews{qq}.Ratings.Overall);
        end
        avgRating=mean(review_ratings);
        % avg rating
        targVec_rows(kk,1)=avgRating;
        % num reviews
        targVec_rows(kk,2)=num_reviews;
        % #revs/day
        targVec_rows(kk,3)=...
            num_reviews/(abs(hotlGrpT(kk).rev_dates_serial(1)-...
            hotlGrpT(kk).rev_dates_serial(end))+1);
        
    end
    
    allGrpVect_t(ii)={targVec_rows};
    
end

master_tVect=vertcat(allGrpVect_t{:});

outputDir=['.\get_featuresAndTarg\',whichXT,'\'];
%save x
save([outputDir,'xt_',whichXT],'master_xVect','master_tVect');



