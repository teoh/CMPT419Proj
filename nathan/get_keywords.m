%Usage: Make sure that the mat files are in the same directory as this script or otherwise point to them
%Outputs adj_key, adv_key, and ger_key which are many-by-2 matrices of the form [words, count]
% Written by: Nathan Samcheck on December 6 2014

clc
%load mat files
fprintf('Loading files...\n');

%note: make sure these are the right file names
load('sorted01.mat');
load('sorted02.mat');
load('sorted03.mat');
load('sorted06.mat');
load('sorted457to13.mat');

fprintf('Files loaded.  Getting pairwise intersects...\n');

%note: make sure that sorted_stuff_stuff_num are the correct variable names
%they should be right but if you run into problems check them
%also words should be the second column
%also yes this is ugly...but it only actually does 30 intersections :P (10 per word type)
for ii = 1:4
	for jj = 2:5
		if ii < jj
			if ii == 1
				if jj == 2
					%note: these should be column vectors...
					adj_inter_12 = intersect(sorted_adj_cnt_01(:,2), sorted_adj_cnt_02(:,2));
					adv_inter_12 = intersect(sorted_adv_cnt_01(:,2), sorted_adv_cnt_02(:,2));
					ger_inter_12 = intersect(sorted_ger_cnt_01(:,2), sorted_ger_cnt_02(:,2));
				end
				if jj == 3
					adj_inter_13 = intersect(sorted_adj_cnt_01(:,2), sorted_adj_cnt_03(:,2));
					adv_inter_13 = intersect(sorted_adv_cnt_01(:,2), sorted_adv_cnt_03(:,2));
					ger_inter_13 = intersect(sorted_ger_cnt_01(:,2), sorted_ger_cnt_03(:,2));
				end
				if jj == 4
					adj_inter_14 = intersect(sorted_adj_cnt_01(:,2), sorted_adj_cnt_06(:,2));
					adv_inter_14 = intersect(sorted_adv_cnt_01(:,2), sorted_adv_cnt_06(:,2));
					ger_inter_14 = intersect(sorted_ger_cnt_01(:,2), sorted_ger_cnt_06(:,2));
				end
				if jj == 5
					adj_inter_15 = intersect(sorted_adj_cnt_01(:,2), sorted_adj_cnt_457to13(:,2));
					adv_inter_15 = intersect(sorted_adv_cnt_01(:,2), sorted_adv_cnt_457to13(:,2));
					ger_inter_15 = intersect(sorted_ger_cnt_01(:,2), sorted_ger_cnt_457to13(:,2));
				end
			end
			if ii == 2
				if jj == 3
					adj_inter_23 = intersect(sorted_adj_cnt_02(:,2), sorted_adj_cnt_03(:,2));
					adv_inter_23 = intersect(sorted_adv_cnt_02(:,2), sorted_adv_cnt_03(:,2));
					ger_inter_23 = intersect(sorted_ger_cnt_02(:,2), sorted_ger_cnt_03(:,2));
				end
				if jj == 4
					adj_inter_24 = intersect(sorted_adj_cnt_02(:,2), sorted_adj_cnt_06(:,2));
					adv_inter_24 = intersect(sorted_adv_cnt_02(:,2), sorted_adv_cnt_06(:,2));
					ger_inter_24 = intersect(sorted_ger_cnt_02(:,2), sorted_ger_cnt_06(:,2));
				end
				if jj == 5
					adj_inter_25 = intersect(sorted_adj_cnt_02(:,2), sorted_adj_cnt_457to13(:,2));
					adv_inter_25 = intersect(sorted_adv_cnt_02(:,2), sorted_adv_cnt_457to13(:,2));
					ger_inter_25 = intersect(sorted_ger_cnt_02(:,2), sorted_ger_cnt_457to13(:,2));
				end
			end
			if ii == 3
				if jj == 4
					adj_inter_34 = intersect(sorted_adj_cnt_03(:,2), sorted_adj_cnt_06(:,2));
					adv_inter_34 = intersect(sorted_adv_cnt_03(:,2), sorted_adv_cnt_06(:,2));
					ger_inter_34 = intersect(sorted_ger_cnt_03(:,2), sorted_ger_cnt_06(:,2));
				end
				if jj == 5
					adj_inter_35 = intersect(sorted_adj_cnt_03(:,2), sorted_adj_cnt_457to13(:,2));
					adv_inter_35 = intersect(sorted_adv_cnt_03(:,2), sorted_adv_cnt_457to13(:,2));
					ger_inter_35 = intersect(sorted_ger_cnt_03(:,2), sorted_ger_cnt_457to13(:,2));
				end
			end
			if ii == 4
				if jj == 5
					adj_inter_45 = intersect(sorted_adj_cnt_06(:,2), sorted_adj_cnt_457to13(:,2));
					adv_inter_45 = intersect(sorted_adv_cnt_06(:,2), sorted_adv_cnt_457to13(:,2));
					ger_inter_45 = intersect(sorted_ger_cnt_06(:,2), sorted_ger_cnt_457to13(:,2));
				end
			end
		end
	end
end

fprintf('Pairwise intersections complete.  Unioning all intersects...\n');

%these should be column vectors...
adj_key = union(union(union(union(union(union(union(union(union(adj_inter_12, adj_inter_13), adj_inter_14), adj_inter_15), adj_inter_23), adj_inter_24), adj_inter_25), adj_inter_34), adj_inter_35), adj_inter_45);
adv_key = union(union(union(union(union(union(union(union(union(adv_inter_12, adv_inter_13), adv_inter_14), adv_inter_15), adv_inter_23), adv_inter_24), adv_inter_25), adv_inter_34), adv_inter_35), adv_inter_45);
ger_key = union(union(union(union(union(union(union(union(union(ger_inter_12, ger_inter_13), ger_inter_14), ger_inter_15), ger_inter_23), ger_inter_24), ger_inter_25), ger_inter_34), ger_inter_35), ger_inter_45);

fprintf('Unions complete.  Counting adjectives...\n');

%note: not 100% sure this section will work...make sure to double check
%I assume the vectors are column vectors
%also make sure the whole find stuff works right

%and sorry it's so ugly again...
num_adj = size(adj_key, 1);
num_adv = size(adv_key, 1);
num_ger = size(ger_key, 1);
adj_cnt_vec = zeros(num_adj,1);
adv_cnt_vec = zeros(num_adv,1);
ger_cnt_vec = zeros(num_ger,1);

for kk = 1:num_adj
	word_cnt = 0;
	word_ind = find(ismember(sorted_adj_cnt_01(:,2), adj_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adj_cnt_01(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adj_cnt_02(:,2), adj_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adj_cnt_02(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adj_cnt_03(:,2), adj_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adj_cnt_03(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adj_cnt_06(:,2), adj_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adj_cnt_06(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adj_cnt_457to13(:,2), adj_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adj_cnt_457to13(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	adj_cnt_vec(kk) = word_cnt;
end

fprintf('Counting adverbs...\n');

for kk = 1:num_adv
	word_cnt = 0;
	word_ind = find(ismember(sorted_adv_cnt_01(:,2), adv_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adv_cnt_01(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adv_cnt_02(:,2), adv_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adv_cnt_02(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adv_cnt_03(:,2), adv_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adv_cnt_03(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adv_cnt_06(:,2), adv_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adv_cnt_06(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_adv_cnt_457to13(:,2), adv_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_adv_cnt_457to13(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	adv_cnt_vec(kk) = word_cnt;
end

fprintf('Counting gerunds...\n');

for kk = 1:num_ger
	word_cnt = 0;
	word_ind = find(ismember(sorted_ger_cnt_01(:,2), ger_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_ger_cnt_01(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_ger_cnt_02(:,2), ger_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_ger_cnt_02(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_ger_cnt_03(:,2), ger_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_ger_cnt_03(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_ger_cnt_06(:,2), ger_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_ger_cnt_06(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	word_ind = find(ismember(sorted_ger_cnt_457to13(:,2), ger_key(kk)));
	if ~isempty(word_ind)
		addby=sorted_ger_cnt_457to13(word_ind, 1);
		word_cnt=word_cnt+addby{1};
	end
	ger_cnt_vec(kk) = word_cnt;
end

fprintf('Concatenating words and counts...\n');

%note this should concatenate two column vectors side by side
adj_key = [adj_key(:), num2cell(adj_cnt_vec)];
adv_key = [adv_key(:), num2cell(adv_cnt_vec)];
ger_key = [ger_key(:), num2cell(ger_cnt_vec)];

fprintf('Program complete!\nCheck adj_key, adv_key, and ger_key for keywords.\nAnd thank you for flying Nathaniel Airlines.  We hope your words had a nice trip!\n');