%{
CMPT 419:   TripAdvisor Project

Name:       Mathew Teoh
Date:       November 30, 2014
Email:      mteoh@sfu.ca
%}

clc

load('.\nathan\adj-adv-ger.mat');

sor_adjkey=sortrows(adj_key,-2);
sor_advkey=sortrows(adv_key,-2);
sor_gerkey=sortrows(ger_key,-2);

all_sortedAdj=sor_adjkey(~ismember(sor_adjkey(:,1),'*****'),:);
all_sortedAdv=sor_advkey(~ismember(sor_advkey(:,1),'*****'),:);
all_sortedGer=sor_gerkey(~ismember(sor_gerkey(:,1),'*****'),:);

prop=316/14785;

numChosenAdj=ceil(size(all_sortedAdj,1)*prop);
chosenAdj=all_sortedAdj((1:numChosenAdj),1);

numChosenAdv=ceil(size(all_sortedAdv,1)*prop);
chosenAdv=all_sortedAdv((1:numChosenAdv),1);

numChosenGer=ceil(size(all_sortedGer,1)*prop);
chosenGer=all_sortedGer((1:numChosenGer),1);

save('chosen_AdjAdvGer','chosenAdj','chosenAdv','chosenGer');