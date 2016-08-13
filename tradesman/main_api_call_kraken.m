% main function KRAKEN
function [response,status]=main_api_call_kraken(method,params)
default_method_names={'pubticker','getOHLC'};
default_method_types={@kraken_pubticker,@kraken_getOHLC};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
    disp('wrong method name for kraken, please try: pubticker, stats, lendbook, book, trades, lends, symbols','symbols_details')
    response='error';
    status='error';
else
    [response,status]=default_method_types{method_select}(params);
end
end

% requests w/o authentication
% pubticker function
% [response,status]=main_api_call('kraken','pubticker',{'pair','XBTEUR'});
function [response,status]=kraken_pubticker(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: btcusd or else')
    response='error';
    status='error';
else
    url=['https://api.kraken.com/0/public/Ticker?pair=',params{pair_loc+1}];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end

% Get OHLC data
% [response,status]=main_api_call('kraken','getOHLC',{'pair','XBTEUR','interval',60,'since','1443657600'});
function [response,status]=kraken_getOHLC(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
interval_loc=find(strcmp('interval',params),1);
since_loc=find(strcmp('since',params),1);

if isempty(pair_loc)
    disp('pair missing,try: XBTEUR or else')
    response='error';
    status='error';
else
    if isempty(interval_loc)
        parameter_1='interval=1';
        disp('interval (minutes): Optional. Time frame interval in minutes.')
    else
        parameter_1=['interval=',num2str(params{interval_loc+1})];
    end
    if isempty(since_loc)
        parameter_2='';
        disp('since (int): Optional. Returns committed OHLC data since given id.')
    else
        parameter_2=['&since=',num2str(params{since_loc+1})];
    end
    % https://api.kraken.com/0/public/OHLC?pair=XBTEUR&interval=60
    url=['https://api.kraken.com/0/public/OHLC','?','pair=',params{pair_loc+1},'&',parameter_1,parameter_2];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end