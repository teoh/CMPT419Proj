%{
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 25, 2014
Email:      mteoh@sfu.ca
%}

% this script will get all of the json files from the appropriate
% directories, extract the data, and put it into mat files. 

% there are 13 groups specify the range of groups you wanna extract the
% data from. specify a start and an end group to operate on.

startGroup=2;
endGroup=13;

currentDir = pwd;

for ii=startGroup:1:endGroup
    if ii < 10
        groupNumStr=['0' num2str(ii)];
    else
        groupNumStr=num2str(ii);
    end
    matFileName=['group',groupNumStr];
    printWhichGroup=sprintf('Getting data from .json files in: %s\n',matFileName);
    fprintf(printWhichGroup);
    
    % go into the directory containing the group you want
    jsonFilesGroupDir=['.\json\',matFileName];
    cd(jsonFilesGroupDir);
    
    % get all info for all the files in this group's directory
    files=dir('*.json');
    numFiles=size(files,1);
    
    % intialize cell that will hold all the data generated for each json
    % file parsed 
    groupData=cell(numFiles,1);
    times=zeros(numFiles,1);
    
    printProgress=sprintf('\n');
    fprintf(printProgress);
    for kk=1:numFiles %change this to numFiles later on
        tic;
        % get json file name
        jsonFile=files(kk); 
        jsonFileName=jsonFile.name;
        
        % load the data
        data=loadjson(jsonFileName);

        % record the time taken to get data
        times(kk)=toc;
        % set up the progress message to print and print progres
        numToBackspace=numel(printProgress);
        fprintf(repmat('\b',1,numToBackspace));
        printProgress=sprintf('\t%s: done %d/%d\n',matFileName,kk,numFiles);
        fprintf(printProgress);
        
        % put the data into the cell array
        groupData(kk)={data};
    end
    
    cd(currentDir);
    save(matFileName,'groupData','times');
    clear groupData;% not matFileName; will be the name of the data
end

























