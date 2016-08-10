%% threshold_calc.m
% Script for volume threshold calculation
% 
% Written by Petr Javorik

%% I/O 
input = 'path/to/your/lastSwapsUSD.csv'; % SET BEFORE USE !
output = 'path/to/your/threshold.mat'; % SET BEFORE USE !

%% Data processing
T = readtable(input,...
    'Format','%*s %s %*f %f32 %*[^\n]',...
    'Delimiter',',',...
    'ReadVariableNames',false...
    );
DateVector = datevec(T.Var1,'"yyyy-mm-dd HH:MM:SS"');
AmountVector = T.Var2;
% We want analyze n days old data
n = 10;
[~,~,subs] = unique(DateVector(:,1:3),'rows');
date_count = max(subs);
first_date_id = find(subs == (date_count-n+1),1,'first');
if isempty(first_date_id)
    first_date_id = 1;
end
DateVector = DateVector(first_date_id:end,:);
AmountVector = AmountVector(first_date_id:end,1);
%% Accumulate by day
%[unDates,~,subs]=unique(DateVector(:,1:3),'rows');
%daily=[unDates,accumarray(subs,AmountVector,[],@sum)]; % computes daily sum

%% Accumulate by hour
%[unDatesHours,~,subs]=unique(DateVector(:,1:4),'rows');
%hourly=[unDatesHours,accumarray(subs,AmountVector,[],@sum)]; % computes hourly sum

%% Accumulate by interval < 1h
interval = 30; % interval in minutes for which we want to sum amounts
DateVector2 = DateVector(:,1:5);
DateVector2(:,5) = floor(DateVector(:,5)/interval);
[unDatesHoursMinutes,~,subs] = unique(DateVector2(:,1:5),'rows');
perinterval = [unDatesHoursMinutes,accumarray(subs,AmountVector,[],@sum)]; % computes interval sum

%% Results
perinterval2 = perinterval(:,6);
perinterval2 = perinterval2(perinterval2 < 300000); % remove outliers
prctil = (quantile(perinterval2,0.01:0.01:0.5))';
% Bernoulli's formula
% Exactly one event in 2 tries
p1 = 2 * prod([(0.5:0.01:0.99)',1-(0.5:0.01:0.99)'],2);
% Exactly two events in 2 tries
p2 = (0.5:0.01:0.99)'.^2;
% At least one event in two tries
p3 = p1 + p2;

results = [prctil,1-(0.01:0.01:0.5)',flipud(p3)];

%% Export threshold with desired probability
prob = 0.85;
threshold_id = find(results(:,3) > prob,1,'last');
threshold = results(threshold_id,1);
save (output,'threshold');
%exit;