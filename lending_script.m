%% Bitfinex swaps lending script
%
% Copyright (C) 2015  Petr Javorik  maple@mmquant.net
%
%       This program is free software: you can redistribute it and/or modify
%       it under the terms of the GNU General Public License as published by
%       the Free Software Foundation, either version 3 of the License, or
%       any later version.
%
%       This program is distributed in the hope that it will be useful,
%       but WITHOUT ANY WARRANTY; without even the implied warranty of
%       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%       GNU General Public License for more details.
%
%       You should have received a copy of the GNU General Public License
%       along with this program. If not, see <http://www.gnu.org/licenses/>.
%
%
%% Description:
% This script autolends unused funds in Bitfinex deposit wallet.
% Script is meant to be executed regularly according to the user needs.
% You can use cron scheduling tool.
% How does it work?
% 1. Set script options.
% 2. Check if there are any active offers, if so, cancel all of them.
% (We want offers at fresh rates)
% 3. Calculate unused funds(unused_funds = deposit_balance - total_funds_lent).
% 4. If unused funds > threshold_bal, script makes new offer at given rate.
%
% Options:
% threshold_bal(USD) - If unused funds in the deposit wallet
% are > threshold_bal, they are lent. Note that minimum offer amount
% on bitfinex is $50.
threshold_bal = 52;
% Loan expiration (days)
expiration = 2;

%% I/O
input = 'path/to/threshold.mat'; % SET BEFORE USE
logfile = 'path/to/logfile.log'; % SET BEFORE USE


%%
load(input);
vol_threshold = threshold;

%% Script
% Check if there are any active offers, if so, cancel all of them.
[offers_ids,offers_status] = main_api_call('bitfinex','offers',{});
if length(offers_ids) > 2
    offers_ids = strsplit(offers_ids,'},{'); % Response parse
    offers_ids = strrep(offers_ids,'"',''); % Response parse
    offers_ids = strrep(offers_ids,':',','); % Response parse
    offers_ids_mat = nan(size(offers_ids,2),1);
    % Fill offers_id_array with particular id's.
    for row = 1:length(offers_ids_mat);
        offers_ids_mat(row,1) = cell2mat(textscan(offers_ids{row},'%*s%d%*[^\n]','Delimiter',','));
    end
    for row=1:length(offers_ids_mat);
        [response,status] = main_api_call('bitfinex','cancel_offer',{offers_ids_mat(row)});
    end
end
% Balances
[balances,bal_status] = main_api_call('bitfinex','balances',{});
if bal_status.isGood ~=1
    disp('Balances retrieval error, check internet connection.')
    return
end
deposit_bal = strsplit(balances,'},{'); % Response parse
deposit_bal = deposit_bal(2); % Response parse
deposit_bal = strrep(deposit_bal,'"',''); % Response parse
deposit_bal = strrep(deposit_bal,':',','); % Response parse
% Deposit balance class double.
deposit_bal = cell2mat(textscan(deposit_bal{1},...
    '%*s%*s%*s%*s%*s%f','Delimiter',','));
% Active funds in swaps(lent funds).
[credits,cred_status] = main_api_call('bitfinex','credits',{});
if cred_status.isGood ~=1
    disp('Credits retrieval error, check internet connection.')
    return
end
credit_bal = strsplit(credits,'},{'); % Response parse
credit_bal = strrep(credit_bal,'"',''); % Response parse
credit_bal = strrep(credit_bal,':',','); % Response parse
amount_vector = (nan(size(credit_bal)))'; % Response parse
rate_vector = (nan(size(credit_bal)))';
% Fill amount_vector with particular lend amount.
for row = 1:length(amount_vector);
    amount_vector(row)=cell2mat(textscan(credit_bal{row},...
    '%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%f','Delimiter',','));
    rate_vector(row)=cell2mat(textscan(credit_bal{row},...
    '%*s%*s%*s%*s%*s%*s%*s%f%*s%*s%*s%*f','Delimiter',','));
end
rate_wmean = sum(prod([amount_vector,rate_vector],2))/sum(amount_vector);
total_funds_lent = sum(amount_vector);
unused_funds = deposit_bal-total_funds_lent;
%% Lend unused funds(there shouldn't be any active offers already).
if unused_funds > threshold_bal
    % If unused funds > threshold_bal, script lends to the rate where first
    % cumulative is < vol_threshold
    % Rate,amount,days,timestamp,cumulative
    %  ...      ...   ...     ...           ...
    % 23.3599  156.23  2  1438979827   9750.83631547
    % 23.3599  156.23  2  1438979826   9907.06631547
    % 23.3599   64.73  2  1438980013   9971.79631547 <<< this will be set(if vol_threshold is 10000)
    % 23.3599   57.98  2  1438979886  10029.77631547
    % 23.3599   57.98  2  1438979887  10087.75631547
    %   ...     ...  ...     ...           ...
    % If all cumulatives > vol_threshold then rate will be set to the 
    % first rate from lendbook(lowest rate).
    [~,asks_matrix] = lendbook2mat('usd',1,50,1);
    rate_id = find(asks_matrix(:,5) < vol_threshold,1,'last');
    if isempty(rate_id) % If the lowest ask is > vol_threshold.
        rate_id = 1;
    end
    % All lends with rate > 20% are offered to 30 days
    if asks_matrix(rate_id,1) >= 20
        expiration = 30;
    end
    [new_offers,new_offers_status] = main_api_call('bitfinex','new_offer',...
        {'currency','usd','amount',unused_funds-0.1,...
        'rate',asks_matrix(rate_id,1),'period',expiration,'direction','lend'});
    if new_offers_status.isGood ~=1
        disp('Placing new offer failed, check internet connection.')
        return
    end
end
% Output to log file
fid = fopen(logfile,'a');
if unused_funds > threshold_bal
    formatSpec =...
        'Date:%s, Offer placed-Amount:%8.2f, rate:%5.2f(%6.4f), period:%d, ratewmean:%5.2f(%5.2f)\n';
    fprintf(fid,formatSpec,datestr(now,'yyyymmdd,HHMM'),unused_funds,...
        asks_matrix(rate_id,1),asks_matrix(rate_id,1)/365,expiration,...
        rate_wmean,rate_wmean*0.85);
else
    formatSpec = 'Date:%s, Unused funds:%8.2f, threshold:%8.2f, ratewmean:%5.2f(%5.2f)\n';
    fprintf(fid,formatSpec,datestr(now,'yyyymmdd,HHMM'),unused_funds,...
        vol_threshold,rate_wmean,rate_wmean*0.85);
end
fclose(fid);
% Uncomment when running in shell
exit;
