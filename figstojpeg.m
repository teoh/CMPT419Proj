cd C:\Users\Mathew\myStuff\school\sem10_Fall2014\cmpt419\proj\getGroupStats;

dirs={'HL', 'HML', 'HQQL'};

for hh = 1:3

	cd(dirs{hh})
    figs = dir('.\*.fig');

	numfigs = size(figs,1);

	for ii=1:numfigs
        handle=openfig(figs(ii).name);
%         jpgname=sprintf('%s\b\b\b\b',figs(ii).name);
        saveas(figure(handle),figs(ii).name(1:end-4),'jpg');
        close
	end

	cd('..')

end

cd('..')