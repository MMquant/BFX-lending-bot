% main function CEX.IO
function [response,status]=main_api_call_cexio(method,params)
default_method_names={'ticker','last_price','convert','price_stats','order_book','trade_history','balance','open_orders','archived_orders','cancel_order','buy','sell','hashrate','workers'};
default_method_types={@cexio_ticker,@cexio_last_price,@cexio_convert,@cexio_price_stats,@cexio_order_book,@cexio_trade_history,@cexio_balance,@cexio_open_orders,@cexio_archived_orders,@cexio_cancel_order,@cexio_buy,@cexio_sell,@cexio_hashrate,@cexio_workers};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for cexio, please try: ticker, last_price, convert, price_stats, order_book, trade_history, balance, open_orders, archived_orders, cancel_order, place_order, hashrate or workers')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% ticker function
function [response,status]=cexio_ticker(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
header_2=http_createHeader('User-agent','bot-cex.io');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    url=['https://cex.io/api/ticker/',pair,'/'];
    [response,status] = urlread2(url,'GET',{},[header_1 header_2]);
end
end
% last_price function
function [response,status]=cexio_last_price(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
header_2=http_createHeader('User-agent','bot-cex.io');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    url=['https://cex.io/api/last_price/',pair,'/'];
    [response,status] = urlread2(url,'GET',{},[header_1 header_2]);
end
end
% convert function
function [response,status]=cexio_convert(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
header_2=http_createHeader('User-agent','bot-cex.io');
pair_loc=find(strcmp('pair',params),1);
amnt_loc=find(strcmp('amnt',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    url=['https://cex.io/api/convert/',pair,'/'];
    if isempty(amnt_loc)
        disp('amnt missing, use example: ''amnt'', 2.5')
        response='error';
        status='error';
    else
    [response,status] = urlread2(url,'POST',['amnt=',num2str(params{amnt_loc+1})],[header_1 header_2]);
    end
end
end
% price_stats function
function [response,status]=cexio_price_stats(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
header_2=http_createHeader('User-agent','bot-cex.io');
pair_loc=find(strcmp('pair',params),1);
lastHours_loc=find(strcmp('lastHours',params),1);
maxRespArrSize_loc=find(strcmp('maxRespArrSize',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    url=['https://cex.io/api/price_stats/',pair,'/'];
    if isempty(lastHours_loc)
        disp('lastHours missing, use example: ''lastHours'', 24')
        response='error';
        status='error';
    else
        if isempty(maxRespArrSize_loc)
            disp('maxRespArrSize missing, use example: ''maxRespArrSize'', 100')
            response='error';
            status='error';
        else
            [response,status] = urlread2(url,'POST',['lastHours=',num2str(params{lastHours_loc+1}),'&maxRespArrSize=',num2str(params{maxRespArrSize_loc+1})],[header_1 header_2]);
        end
    end
end
end
% order_book function
function [response,status]=cexio_order_book(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
header_2=http_createHeader('User-agent','bot-cex.io');
pair_loc=find(strcmp('pair',params),1);
depth_loc=find(strcmp('depth',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    if isempty(depth_loc)
    url=['https://cex.io/api/order_book/',pair,'/?depth=10'];
    disp('depth missing, used default ''depth'' as 10')
    else
    url=['https://cex.io/api/order_book/',pair,'/?depth=',num2str(params{depth_loc+1})];
    end
    [response,status] = urlread2(url,'GET',{},[header_1 header_2]);
end
end
% trade_history function
function [response,status]=cexio_trade_history(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
header_2=http_createHeader('User-agent','bot-cex.io');
pair_loc=find(strcmp('pair',params),1);
since_loc=find(strcmp('since',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
    pair=params{pair_loc+1};
    if isempty(since_loc)
    url=['https://cex.io/api/trade_history/',pair,'/'];
    disp('since missing')
    else
    url=['https://cex.io/api/trade_history/',pair,'/?since=',num2str(params{since_loc+1})];
    end
    [response,status] = urlread2(url,'GET',{},[header_1 header_2]);
end
end

% requests with authentication
% header & parameters
function [response,status]=cexio_authenticated(url_ext,parameter)
    url='https://cex.io/api/';
    % nonce
    nonce = strrep(num2str(now*1000000-7.34E11), '.', '');
    nonce = nonce(1:10);
    [key,secret,username]=key_secret('cexio');
    url=[url url_ext];
    string=[nonce username key];
    Signature = crypto(string, secret, 'HmacSHA256');
    % post-parameters
    postparams=['key=' key '&signature=' char(Signature) '&nonce=' nonce parameter];
    header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
    header_2=http_createHeader('User-agent',['bot-cex.io-' username]);
    header=[header_1 header_2];
    [response,status] = urlread2(url,'POST',postparams,header);
end

% balance function
function [response,status]=cexio_balance(~)
url_ext='balance/';
parameter='';
[response,status]=cexio_authenticated(url_ext,parameter);
end

% open_orders function
function [response,status]=cexio_open_orders(params)
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
pair=upper(params{pair_loc+1});
url_ext=['open_orders/' pair];
parameter='';
[response,status]=cexio_authenticated(url_ext,parameter);    
end
end

% archived_orders function
function [response,status]=cexio_archived_orders(params)
pair_loc=find(strcmp('pair',params),1);
paramsss={'limit','dateTo','dateFrom'};
paramsss_def={'limit missing:limit – limit the number of entries in response (1 to 100)','dateTo missing: dateTo – end date for orders filtering (timestamp is optional)','dateFrom missing: dateFrom – start date for order filtering'};
parameter='';
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
    else
        parameter=[parameter '&' params{asd} '=' num2str(params{asd+1})];
    end
end
if isempty(pair_loc)
    disp('pairs missing,try: BTC/USD or else')
    response='error';
    status='error';
else
pair=upper(params{pair_loc+1});
url_ext=['archived_orders/' pair];
[response,status]=cexio_authenticated(url_ext,parameter);
end
end

% cancel_order function
function [response,status]=cexio_cancel_order(params)
id_loc=find(strcmp('id',params),1);
if isempty(id_loc)
    disp('id missing')
    response='error';
    status='error';
else
id=params{id_loc+1};
url_ext='cancel_order/';
parameter=['&id=' num2str(id)];
[response,status]=cexio_authenticated(url_ext,parameter);
end
end

% buy function
function [response,status]=cexio_buy(params)
pair_loc=find(strcmp('pair',params),1);
amount_loc=find(strcmp('amount',params),1);
price_loc=find(strcmp('price',params),1);
if isempty(amount_loc)
    disp('amount missing')
    response='error';
    status='error';
else if isempty(price_loc)
    disp('price missing')
    response='error';
    status='error';
    else if isempty(pair_loc)
                disp('pair missing')
                response='error';
                status='error';
        else
        pair=upper(params{pair_loc+1});
        url_ext=['place_order/' pair];
        parameter=['&type=buy&amount=' num2str(params{amount_loc+1}) '&price=' num2str(params{price_loc+1})];
        [response,status]=cexio_authenticated(url_ext,parameter); 
        end
    end
end
end

% sell function
function [response,status]=cexio_sell(params)
pair_loc=find(strcmp('pair',params),1);
amount_loc=find(strcmp('amount',params),1);
price_loc=find(strcmp('price',params),1);
if isempty(amount_loc)
    disp('amount missing')
    response='error';
    status='error';
else if isempty(price_loc)
    disp('price missing')
    response='error';
    status='error';
    else if isempty(pair_loc)
                disp('pair missing')
                response='error';
                status='error';
        else
        pair=upper(params{pair_loc+1});
        url_ext=['place_order/' pair];
        parameter=['&type=sell&amount=' num2str(params{amount_loc+1}) '&price=' num2str(params{price_loc+1})];
        [response,status]=cexio_authenticated(url_ext,parameter); 
        end
    end
end
end

% hashrate function
function [response,status]=cexio_hashrate(~)
url_ext='ghash.io/hashrate';
parameter='';
[response,status]=cexio_authenticated(url_ext,parameter);
end

% workers function
function [response,status]=cexio_workers(~)
url_ext='ghash.io/workers';
parameter='';
[response,status]=cexio_authenticated(url_ext,parameter);
end