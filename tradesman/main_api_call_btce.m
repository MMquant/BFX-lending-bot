% main function BTC-E
function [response,status]=main_api_call_btce(method,params)
default_method_names={'info','ticker','depth','trades','getInfo','buy','sell','ActiveOrders','OrderInfo','CancelOrder','TradeHistory','TransHistory'};
default_method_types={@btce_info,@btce_ticker,@btce_depth,@btce_trades,@btce_getInfo,@btce_buy,@btce_sell,@btce_ActiveOrders,@btce_OrderInfo,@btce_CancelOrder,@btce_TradeHistory,@btce_TransHistory};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for btce, please try: info, ticker, depth, trades, getInfo, buy, sell, ActiveOrders, OrderInfo, CancelOrder, TradeHistory or TransHistory')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% info function
function [response,status]=btce_info(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
[response,status] = urlread2('https://btc-e.com/api/3/info/','GET',{},header_1);
end
% ticker function
function [response,status]=btce_ticker(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: btc_usd or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    url=['https://btc-e.com/api/3/ticker/',pair,'/'];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end
% depth function
function [response,status]=btce_depth(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
limit_loc=find(strcmp('limit',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: btc_usd or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
if isempty(limit_loc)
    url=['https://btc-e.com/api/3/depth/',pair,'/?limit=150'];
    disp('limit is not defined, used default as 150')
else
    limit=params{limit_loc+1};
    if limit>2000
        url=['https://btc-e.com/api/3/depth/',pair,'/?limit=150'];
        disp('max limit is 2000, instead used default as 150')
    else
        url=['https://btc-e.com/api/3/depth/',pair,'/?limit=',num2str(limit)];
    end
end
[response,status] = urlread2(url,'GET',{},header_1);
end
end
% trades function
function [response,status]=btce_trades(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: btc_usd or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    url=['https://btc-e.com/api/3/trades/',pair,'/'];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end

% requests with authentication
% header & parameters
function [response,status]=btce_authenticated(method,parameter)
    url='https://btc-e.com/tapi';
    % nonce
    nonce = strrep(num2str(now*1000000-7.34E11), '.', '');
    nonce = nonce(1:10);
    [key,secret]=key_secret('btce');
    % post-parameters
    postparams=['method=' method '&nonce=' num2str(nonce) parameter];
    % HMAC-SHA512
    Signature = crypto(postparams, secret, 'HmacSHA512');
    header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
    header_2=http_createHeader('Key', key);
    header_3=http_createHeader('Sign', Signature);
    header=[header_1 header_2 header_3];
    [response,status] = urlread2(url,'POST',postparams,header);
end

% getInfo function
function [response,status]=btce_getInfo(~)
parameter='';
method='getInfo';
[response,status]=btce_authenticated(method,parameter);
end

% buy function
function [response,status]=btce_buy(params)
pair_loc=find(strcmp('pair',params),1);
rate_loc=find(strcmp('rate',params),1);
amount_loc=find(strcmp('amount',params),1);
if isempty(pair_loc)||isempty(rate_loc)||isempty(amount_loc)
    disp('pair, rate or amount is missing please check')
    response='error';
    status='error';
else
pair=['pair=',num2str(params{pair_loc+1})];
type='type=buy';
rate=['rate=',num2str(params{rate_loc+1})];
amount=['amount=',num2str(params{amount_loc+1})];
method='Trade';
parameter=['&',pair,'&',type,'&',rate,'&',amount];
[response,status]=btce_authenticated(method,parameter);
end
end

% sell function
function [response,status]=btce_sell(params)
pair_loc=find(strcmp('pair',params),1);
rate_loc=find(strcmp('rate',params),1);
amount_loc=find(strcmp('amount',params),1);
if isempty(pair_loc)||isempty(rate_loc)||isempty(amount_loc)
    disp('pair, rate or amount is missing please check')
    response='error';
    status='error';
else
pair=['pair=',num2str(params{pair_loc+1})];
type='type=sell';
rate=['rate=',num2str(params{rate_loc+1})];
amount=['amount=',num2str(params{amount_loc+1})];
method='Trade';
parameter=['&',pair,'&',type,'&',rate,'&',amount];
[response,status]=btce_authenticated(method,parameter);
end
end

% ActiveOrders function
function [response,status]=btce_ActiveOrders(params)
pair_loc=find(strcmp('pair',params),1);
method='ActiveOrders';
if isempty(pair_loc)
    disp('pair missing, default show all pair orders')
    parameter='';
[response,status]=btce_authenticated(method,parameter);
else
pair=['pair=',num2str(params{pair_loc+1})];
parameter=['&',pair];
[response,status]=btce_authenticated(method,parameter);
end
end

% OrderInfo function
function [response,status]=btce_OrderInfo(params)
order_id_loc=find(strcmp('order_id',params),1);
method='OrderInfo';
if isempty(order_id_loc)
    disp('order_id missing')
    response='error';
    status='error';
else
order_id=['order_id=',num2str(params{order_id_loc+1})];
parameter=['&',order_id];
[response,status]=btce_authenticated(method,parameter);
end
end

% CancelOrder function
function [response,status]=btce_CancelOrder(params)
order_id_loc=find(strcmp('order_id',params),1);
method='CancelOrder';
if isempty(order_id_loc)
    disp('order_id missing')
    response='error';
    status='error';
else
order_id=['order_id=',num2str(params{order_id_loc+1})];
parameter=['&',order_id];
[response,status]=btce_authenticated(method,parameter);
end
end

% TradeHistory function
function [response,status]=btce_TradeHistory(params)
paramsss={'from','count','from_id','end_id','order','since','end','pair'};
paramsss_def={'from missing: trade ID, from which the display starts default 0','count missing: the number of trades for display default 1000','from_id missing: trade ID, from which the display starts default 0','end_id missing: trade ID on which the display ends default inf','order missing: Sorting (ASD or DESC) default DESC','since missing: the time to start the display default 0','end missing: the time to end the display default inf','pair missing: pair to be displayed default all pairs' };
parameter='';
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
    else
        parameter=[parameter '&' params{asd} '=' num2str(params{asd+1})];
    end
end
method='TradeHistory';
[response,status]=btce_authenticated(method,parameter);
end

% TransHistory function
function [response,status]=btce_TransHistory(params)
paramsss={'from','count','from_id','end_id','order','since','end'};
paramsss_def={'from missing: trade ID, from which the display starts default 0','count missing: the number of trades for display default 1000','from_id missing: trade ID, from which the display starts default 0','end_id missing: trade ID on which the display ends default inf','order missing: Sorting (ASD or DESC) default DESC','since missing: the time to start the display default 0','end missing: the time to end the display default inf'};
parameter='';
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
    else
        parameter=[parameter '&' params{asd} '=' num2str(params{asd+1})];
    end
end
method='TransHistory';
[response,status]=btce_authenticated(method,parameter);
end