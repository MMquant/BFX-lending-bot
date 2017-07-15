function [bids_matrix,asks_matrix] = lendbook2mat(curr,limit_bid,limit_ask,conn_to)
%lendbook2mat(curr,limit_bid,limit_ask,conn_iter) Returns lendbook in matrix
% Written by Maple Mapleson
% Input:
%   curr - currency('btc','usd')
%   limit_bid,limit_ask - number of returned bids or asks
%   connto - how many times function tries to connect before exit
% Function returns lendbook from Bitfinex.Two matrices are returned.
% Rows of matrices are as follows: rate,amount,period,timestamp,cumulative.

if nargin < 4
    disp('Not enough input arguments!');
    return
end

status.isGood=0;

% Call for fresh lend book bid and ask
while status.isGood~=1
    conn_to=conn_to-1;
    pause(1)
    [response,status]=main_api_call('bitfinex','lendbook',{'coin',curr,...
        'limit_bids',limit_bid,'limit_asks',limit_ask});
    if status.isGood ~=1 && conn_to<1
        display('Failed to retrieve lendbook, check internet connection.');
        return
    end
end

% Formatting the response string
bidask_cell=strsplit(response,'],','CollapseDelimiters',true);
% Bids processing, output is matrix
bids=bidask_cell(1);
bids=strsplit(bids{1},':[','CollapseDelimiters',true);
bids(1)=[];
bids=strsplit(bids{1},'},{','CollapseDelimiters',true);
bids=strrep(bids,'{','');
bids=strrep(bids,'}','');
bids=strrep(bids,'"','');
bids=strrep(bids,':',',');
bids_matrix=nan(size(bids,2),4); % Columns are rate,amount,period,timestamp.
for row = 1:size(bids_matrix,1)
    bids_matrix(row,:)=(cell2mat(textscan(bids{row},...
        '%*s%f','Delimiter',',')))';
end
% Columns are rate,amount,period,timestamp,cumulative.
bids_matrix(:,5)=cumsum(bids_matrix(:,2),1);


% Asks processing, output is matrix
asks=bidask_cell(2);
asks=strsplit(asks{1},':[','CollapseDelimiters',true);
asks(1)=[];
asks=strsplit(asks{1},'},{','CollapseDelimiters',true);
asks=strrep(asks,'{','');
asks=strrep(asks,'}','');
asks=strrep(asks,'"','');
asks=strrep(asks,':',',');
asks_matrix=nan(size(asks,2),4); % Columns are rate,amount,period,timestamp.
for row = 1:size(asks_matrix,1)
    asks_matrix(row,:)=(cell2mat(textscan(asks{row},...
        '%*s%f','Delimiter',',')))';
end
% Columns are rate,amount,period,timestamp,cumulative.
asks_matrix(:,5)=cumsum(asks_matrix(:,2),1);

end

