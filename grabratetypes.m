%{
CMPT 419: TripAdvisor Project

Name:       Mathew Teoh
Date:       November 22, 2014
Email:      mteoh@sfu.ca
%}

% get the unique tags "fields" or whatever youc all it
% be in: C:\Users\Mathew\myStuff\school\sem10_Fall2014\cmpt419\proj
files = dir('.\json\*.json');
numfiles=size(files,1);

max_files = 110;
timesfortags=zeros(max_files,1);
filename = cell(max_files,1);
rev_masterlist={};
rating_masterlist={};

for i=1:max_files
    file=files(i);
%     file.name
    filename(i) = cellstr(file.name);
    data=loadjson(file.name);
    num_reviews = size(data.Reviews,2);
    for jj=1:num_reviews
        rev_names=fieldnames(data.Reviews{jj})';
        rev_masterlist=[rev_masterlist,rev_names(find(~ismember(rev_names,rev_masterlist)))];
        
        rating_names = fieldnames(data.Reviews{jj}.Ratings)';
        rating_masterlist = [rating_masterlist,rating_names(find(~ismember(rating_names,rating_masterlist)))];
    end
end

