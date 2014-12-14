%{
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 30, 2014
Email:      mteoh@sfu.ca
%}

clc

startGroup=1;
endGroup=13;

% for training
dir_inputMat_xTrain='.\splitXfromT\train\x\';
dir_inputMat_tTrain='.\splitXfromT\train\t\';

% for testing 
dir_inputMat_xTest='.\splitXfromT\test\x\';
dir_inputMat_tTest='.\splitXfromT\test\t\';

masterLabels_xTrain={};
masterLabels_tTrain={};

masterLabels_xTest={};
masterLabels_tTest={};

ct=1;
for ii=startGroup:endGroup
	if ii < 10
        groupNumStr=['0' num2str(ii)];
	else
        groupNumStr=num2str(ii);
	end

    filePrefix=['part5_group',groupNumStr];

    fprintf('Loading %s training data\n',groupNumStr);
    load([dir_inputMat_xTrain,filePrefix,'x_train'])
    load([dir_inputMat_tTrain,filePrefix,'t_train'])
    fprintf('Loading %s testing data\n',groupNumStr);
	load([dir_inputMat_xTest,filePrefix,'x_test'])
    load([dir_inputMat_tTest,filePrefix,'t_test'])

    grpMasterLabels_xTrain={};
    for kk=1:size(hotlGrpX_train,1)
        htlRatingTags=grabHtlRatingTags(hotlGrpX_train(kk));
        if kk==1
        	grpMasterLabels_xTrain=htlRatingTags;
		else
        	grpMasterLabels_xTrain=intersect(grpMasterLabels_xTrain,htlRatingTags);
        end
        if max(size(grpMasterLabels_xTrain))==1
            fprintf('warning!! xTrain kk= %d: common tag list has shrunken to 1!\n',kk);
        end
    end

	if ct==1
    	masterLabels_xTrain=grpMasterLabels_xTrain;
	else
    	masterLabels_xTrain=intersect(grpMasterLabels_xTrain,masterLabels_xTrain);
	end

	grpMasterLabels_tTrain={};
    for kk=1:size(hotlGrpT_train,1)
        htlRatingTags=grabHtlRatingTags(hotlGrpT_train(kk));
        if kk==1
        	grpMasterLabels_tTrain=htlRatingTags;
		else
        	grpMasterLabels_tTrain=intersect(grpMasterLabels_tTrain,htlRatingTags);
        end
        if max(size(grpMasterLabels_tTrain))==1
            fprintf('warning!! tTrain kk= %d: common tag list has shrunken to 1!\n',kk);
        end
    end

	if ct==1
    	masterLabels_tTrain=grpMasterLabels_tTrain;
	else
    	masterLabels_tTrain=intersect(grpMasterLabels_tTrain,masterLabels_tTrain);
	end

	% for test
	grpMasterLabels_xTest={};
    for kk=1:size(hotlGrpX_test,1)
        htlRatingTags=grabHtlRatingTags(hotlGrpX_test(kk));
        if kk==1
        	grpMasterLabels_xTest=htlRatingTags;
		else
        	grpMasterLabels_xTest=intersect(grpMasterLabels_xTest,htlRatingTags);
        end
        if max(size(grpMasterLabels_xTest))==1
            fprintf('warning!! xTest kk= %d: common tag list has shrunken to 1!\n',kk);
        end
    end

	if ct==1
    	masterLabels_xTest=grpMasterLabels_xTest;
	else
    	masterLabels_xTest=intersect(grpMasterLabels_xTest,masterLabels_xTest);
	end

	grpMasterLabels_tTest={};
    for kk=1:size(hotlGrpT_test,1)
        htlRatingTags=grabHtlRatingTags(hotlGrpT_test(kk));
        if kk==1
        	grpMasterLabels_tTest=htlRatingTags;
		else
        	grpMasterLabels_tTest=intersect(grpMasterLabels_tTest,htlRatingTags);
        end
        if max(size(grpMasterLabels_tTest))==1
            fprintf('warning!! tTest kk= %d: common tag list has shrunken to 1!\n',kk);
        end
    end

	if ct==1
    	masterLabels_tTest=grpMasterLabels_tTest;
	else
    	masterLabels_tTest=intersect(grpMasterLabels_tTest,masterLabels_tTest);
	end

    ct=ct+1;
end