% main function BITFINEX
function [response,status]=main_api_call_bitfinex(method,params)
default_method_names={'pubticker','stats','lendbook','book',...
    'trades','lends','symbols','symbols_details','new_deposit','new_order',...
    'multiple_new_orders','cancel_order','cancel_multiple_orders',...
    'cancel_all_orders','replace_order','order_status','orders','positions',...
    'history','history_movements','mytrades','new_offer','cancel_offer','offer_status','offers',...
    'credits','taken_swaps','close_swap','balances','account_infos','margin_infos'};
default_method_types={@bitfinex_pubticker,@bitfinex_stats,...
    @bitfinex_lendbook,@bitfinex_book,@bitfinex_trades,...
    @bitfinex_lends,@bitfinex_symbols,@bitfinex_symbols_details,...
    @bitfinex_new_deposit,@bitfinex_new_order,@bitfinex_multiple_new_orders,...
    @bitfinex_cancel_order,@bitfinex_cancel_multiple_orders,@bitfinex_cancel_all_orders,...
    @bitfinex_replace_order,@bitfinex_order_status,@bitfinex_orders,@bitfinex_positions...
    @bitfinex_history,@bitfinex_history_movements,@bitfinex_mytrades,@bitfinex_new_offer,...
    @bitfinex_cancel_offer,@bitfinex_offer_status,@bitfinex_offers,@bitfinex_credits,...
    @bitfinex_taken_swaps,@bitfinex_close_swap,@bitfinex_balances,@bitfinex_account_infos,...
    @bitfinex_margin_infos};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for bitfinex, please try: pubticker, stats, lendbook, book, trades, lends, symbols','symbols_details')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% pubticker function
function [response,status]=bitfinex_pubticker(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
disp('pairs missing,try: btcusd or else')
response='error';
status='error';
else
    url=['https://api.bitfinex.com/v1/pubticker/',params{pair_loc+1}];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end
% stats function
function [response,status]=bitfinex_stats(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
if isempty(pair_loc)
disp('pairs missing,try: btcusd or else')
response='error';
status='error';
else
    url=['https://api.bitfinex.com/v1/stats/',params{pair_loc+1}];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end
% lendbook function'https://api.bitfinex.com/v1/lendbook/btc/?limit_bids=2&limit_asks=2'
function [response,status]=bitfinex_lendbook(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
coin_loc=find(strcmp('coin',params),1);
limit_bids_loc=find(strcmp('limit_bids',params),1);
limit_asks_loc=find(strcmp('limit_asks',params),1);
if isempty(coin_loc)
disp('coin missing,try: btc or else')
response='error';
status='error';
else
    if isempty(limit_bids_loc)
        parameter_1='limit_bids=50';
        disp('limit_bids (int): Optional. Limit the number of bids (loan demands) returned. May be 0 in which case the array of bids is empty. Default is 50.')
    else
        parameter_1=['limit_bids=',num2str(params{limit_bids_loc+1})];
    end
    if isempty(limit_asks_loc)
        parameter_2='&limit_asks=50';
        disp('limit_asks (int): Optional. Limit the number of asks (loan offers) returned. May be 0 in which case the array of asks is empty. Default is 50.')
    else
        parameter_2=['&limit_asks=',num2str(params{limit_asks_loc+1})];
    end
    url=['https://api.bitfinex.com/v1/lendbook/',params{coin_loc+1},'/?',parameter_1,parameter_2];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end



% book function
function [response,status]=bitfinex_book(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
limit_bids_loc=find(strcmp('limit_bids',params),1);
limit_asks_loc=find(strcmp('limit_asks',params),1);
group_loc=find(strcmp('group',params),1);
if isempty(pair_loc)
disp('pairs missing,try: btcusd or else')
response='error';
status='error';
else
    if isempty(limit_bids_loc)
    parameter_1='limit_bids=50';
    disp('limit_bids (int): Optional. Limit the number of bids returned. May be 0 in which case the array of bids is empty. Default is 50. ')
    else
    parameter_1=['limit_bids=',num2str(params{limit_bids_loc+1})];
    end
            if isempty(limit_asks_loc)
            parameter_2='&limit_asks=50';
            disp('limit_asks (int): Optional. Limit the number of asks returned. May be 0 in which case the array of asks is empty. Default is 50.')
            else
            parameter_2=['&limit_asks=',num2str(params{limit_asks_loc+1})];
            end
                if isempty(group_loc)
                parameter_3='&group=1';
                disp('group (0/1): Optional. If 1, orders are grouped by price in the orderbook. If 0, orders are not grouped and sorted individually. Default is 1')
                else
                parameter_3=['&group=',num2str(params{limit_asks_loc+1})];
                end
        url=['https://api.bitfinex.com/v1/book/',params{pair_loc+1},'/?',parameter_1,parameter_2,parameter_3];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end


% trades function 'https://api.bitfinex.com/v1/trades/btcusd/?timestamp=1423567523&limit_trades=50'
function [response,status]=bitfinex_trades(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
pair_loc=find(strcmp('pair',params),1);
timestamp_loc=find(strcmp('timestamp',params),1);
limit_trades_loc=find(strcmp('limit_trades',params),1);
if isempty(pair_loc)
disp('pairs missing,try: btcusd or else')
response='error';
status='error';
else
    if isempty(timestamp_loc)
    parameter_1='timestamp=1423567523';
    disp('timestamp (time): Optional. Only show data at or after this timestamp.')
    else
    parameter_1=['timestamp=',num2str(params{timestamp_loc+1})];
    end
            if isempty(limit_trades_loc)
            parameter_2='&limit_trades=50';
            disp('limit_trades (int): Optional. Limit the number of trades returned. Must be >= 1. Default is 50.')
            else
            parameter_2=['&limit_trades=',num2str(params{limit_trades_loc+1})];
            end
        url=['https://api.bitfinex.com/v1/trades/',params{pair_loc+1},'/?',parameter_1,parameter_2];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end

% lends function 'https://api.bitfinex.com/v1/lends/BTC/?timestamp=1423492422&limit_lends=50'
function [response,status]=bitfinex_lends(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
coin_loc=find(strcmp('coin',params),1);
timestamp_loc=find(strcmp('timestamp',params),1);
limit_lends_loc=find(strcmp('limit_lends',params),1);
if isempty(coin_loc)
    disp('coin missing,try: btc or else')
    response='error';
    status='error';
else
    if isempty(timestamp_loc)
        parameter_1='timestamp=1423567523';
        disp('timestamp (time): Optional. Only show data at or after this timestamp.')
    else
        parameter_1=['timestamp=',num2str(params{timestamp_loc+1})];
    end
    if isempty(limit_lends_loc)
        parameter_2='&limit_lends=50';
        disp('limit_lends (int): Optional. Limit the number of swaps data returned. Must be >= 1. Default is 50.')
    else
        parameter_2=['&limit_lends=',num2str(params{limit_lends_loc+1})];
    end
    url=['https://api.bitfinex.com/v1/lends/',params{coin_loc+1},'/?',parameter_1,parameter_2];
    [response,status] = urlread2(url,'GET',{},header_1);
end
end

% symbols function
function [response,status]=bitfinex_symbols(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
    url='https://api.bitfinex.com/v1/symbols/';
    [response,status] = urlread2(url,'GET',{},header_1);
end
% symbols function
function [response,status]=bitfinex_symbols_details(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
    url='https://api.bitfinex.com/v1/symbols_details/';
    [response,status] = urlread2(url,'GET',{},header_1);
end

% requests with authentication
% header & parameters
function [response,status]=bitfinex_authenticated(url_ext,parameter)
    url='https://api.bitfinex.com';
    % nonce
    nonce = num2str(floor((now-datenum('1970', 'yyyy'))*8640000000));
    [key,secret]=key_secret('bitfinex');
    url=[url url_ext];
    payload_json=['{"nonce": "' nonce '", "request": "' url_ext '"' parameter '}'];
    payload_uint8=uint8(payload_json);
    payload=char(org.apache.commons.codec.binary.Base64.encodeBase64(payload_uint8))';
    Signature = char(crypto(payload, secret, 'HmacSHA384'));
    header_1=http_createHeader('X-BFX-APIKEY',key);
    header_2=http_createHeader('X-BFX-PAYLOAD',payload);
    header_3=http_createHeader('X-BFX-SIGNATURE',Signature);
    header=[header_1 header_2 header_3];
    [response,status] = urlread2(url,'POST','',header);
end

%new deposit function
function [response,status]=bitfinex_new_deposit(params)
url_ext='/v1/deposit/new';
paramsss={'currency','method','wallet_name'};
paramsss_def={'currency (string) missing: The currency to deposit in ("BTC", "LTC" or "DRK").',...
    'method (string) missing: Method of deposit (methods accepted: "bitcoin", "litecoin", "darkcoin".',...
    'wallet_name (string) missing: Wallet to deposit in (accepted: "trading", "exchange", "deposit"). Your wallet needs to already exist'};
k=0;
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
        k=1;
    else
        parameters{i}=num2str(params{asd+1});
    end
end
if k==1
response='error';
status='error';
else
parameter=[', "currency": "' parameters{1} '", "method": "' parameters{2} '", "wallet_name": "' parameters{3} '"'];
[response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% new_order function
function [response,status]=bitfinex_new_order(params)
url_ext='/v1/order/new';
paramsss={'symbol','amount','price','exchange','side','type'};
paramsss_def={'symbol (string): The name of the symbol (see `/symbols`).',...
    'amount (decimal): Order size: how much to buy or sell.',...
    'price (price): Price to buy or sell at. Must be positive. Use random number for market orders.',...
    'exchange (string): "bitfinex".',...
    'side (string): Either "buy" or "sell".',...
    'type (string): Either "market" / "limit" / "stop" / "trailing-stop" / "fill-or-kill" / "exchange market" / "exchange limit" / "exchange stop" / "exchange trailing-stop" / "exchange fill-or-kill". (type starting by "exchange " are exchange orders, others are margin trading orders)',...
    'is_hidden (bool) true if the order should be hidden. Default is false.'};
k=0;
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
        k=1;
    else
        parameters{i}=num2str(params{asd+1});
    end
end
if k==1
response='error';
status='error';
else
    asd=find(strcmp('is_hidden',params),1);
    if isempty(asd)
parameter=[', "symbol": "' parameters{1} '", "amount": "' parameters{2} '", "price": "' parameters{3} '", "exchange": "' parameters{4} '", "side": "' parameters{5} '", "type": "' parameters{6} '"'];
    else
parameter=[', "symbol": "' parameters{1} '", "amount": "' parameters{2} '", "price": "' parameters{3} '", "exchange": "' parameters{4} '", "side": "' parameters{5} '", "type": "' parameters{6} '", "is_hidden": ' params{asd+1}];
    end
[response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% multiple_new_orders function
function [response,status]=bitfinex_multiple_new_orders(params)
url_ext='/v1/order/new/multi';
paramsss={'symbol','amount','price','exchange','side','type'};
paramsss_def={'symbol (string): The name of the symbol (see `/symbols`).',...
    'amount (decimal): Order size: how much to buy or sell.',...
    'price (price): Price to buy or sell at. Must be positive. Use random number for market orders.',...
    'exchange (string): "bitfinex".',...
    'side (string): Either "buy" or "sell".',...
    'type (string): Either "market" / "limit" / "stop" / "trailing-stop" / "fill-or-kill" / "exchange market" / "exchange limit" / "exchange stop" / "exchange trailing-stop" / "exchange fill-or-kill". (type starting by "exchange " are exchange orders, others are margin trading orders)'};
k=0;
parameter='';
for i=1:length(params);
    if iscell(params{i})
    mattt=params{i};
        for m=1:length(paramsss)
        asd=find(strcmp(paramsss(m),mattt),1);
    if isempty(asd)
        k=1;
        disp(paramsss_def{i})
    else
        parameters{m}=num2str(mattt{asd+1});
    end
        end
        if i==1
        parameter=[', "orders": [{"symbol": "' parameters{1} '", "amount": "' parameters{2} '", "price": "' parameters{3} '", "exchange": "' parameters{4} '", "side": "' parameters{5} '", "type": "' parameters{6} '"}'];
        else
        parameter=[parameter ', {"symbol": "' parameters{1} '", "amount": "' parameters{2} '", "price": "' parameters{3} '", "exchange": "' parameters{4} '", "side": "' parameters{5} '", "type": "' parameters{6} '"}'];
        end
        
    else
        k=1;
        disp('order input is wrong, please try: {{''symbol'',''btcusd'',''amount'',0.01,''price'',250,''exchange'',''bitfinex'',''side'',''buy'',''type'',''limit''},{},{}...,{}}, please remember maximum n=10')
    end
end
if k==1
response='error';
status='error';
else
    parameter=[parameter ']'];
[response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% cancel_order function
function [response,status]=bitfinex_cancel_order(params)
url_ext='/v1/order/cancel';
if isempty(params)
response='error';
status='error';
disp('order id missing')
else
        parameter=[', "order_id": ' num2str(params{1}) ];
        [response,status]=bitfinex_authenticated(url_ext,parameter);
end


end

% cancel_multiple_orders function
function [response,status]=bitfinex_cancel_multiple_orders(params)
url_ext='/v1/order/cancel/multi';
if isempty(params)
response='error';
status='error';
disp('order ids missing')
else
    for i=1:length(params);
        if i==1
        parameter=[', "order_ids": [' num2str(params{i}) ];
        else 
        parameter=[parameter ', ' num2str(params{i}) ];
        end
    end
    parameter=[parameter ']'];
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end


end

% cancel_all_orders function
function [response,status]=bitfinex_cancel_all_orders(~)
url_ext='/v1/order/cancel/all';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% replace_order function
function [response,status]=bitfinex_replace_order(params)
url_ext='/v1/order/cancel/replace';
paramsss={'order_id','symbol','amount','price','exchange','side','type'};
paramsss_def={'order_id (int): The order ID (to be replaced) given by `/order/new`.',...
    'symbol (string): The name of the symbol (see `/symbols`).',...
    'amount (decimal): Order size: how much to buy or sell.',...
    'price (price): Price to buy or sell at. Must be positive. Use random number for market orders.',...
    'exchange (string): "bitfinex".',...
    'side (string): Either "buy" or "sell".',...
    'type (string): Either "market" / "limit" / "stop" / "trailing-stop" / "fill-or-kill" / "exchange market" / "exchange limit" / "exchange stop" / "exchange trailing-stop" / "exchange fill-or-kill". (type starting by "exchange " are exchange orders, others are margin trading orders)',...
    'is_hidden (bool) true if the order should be hidden. Default is false.'};
k=0;
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
        k=1;
    else
        parameters{i}=num2str(params{asd+1});
    end
end
if k==1
response='error';
status='error';
else
    asd=find(strcmp('is_hidden',params),1);
    if isempty(asd)
parameter=[', "order_id": ' parameters{1} ', "symbol": "' parameters{2} '", "amount": "' parameters{3} '", "price": "' parameters{4} '", "exchange": "' parameters{5} '", "side": "' parameters{6} '", "type": "' parameters{7} '"'];
    else
parameter=[', "order_id": ' parameters{1} ', "symbol": "' parameters{2} '", "amount": "' parameters{3} '", "price": "' parameters{4} '", "exchange": "' parameters{5} '", "side": "' parameters{6} '", "type": "' parameters{7} '", "is_hidden": ' params{asd+1}];
    end
[response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% order_status function
function [response,status]=bitfinex_order_status(params)
url_ext='/v1/order/status';
if isempty(params)
response='error';
status='error';
disp('order_id missing')
else
        parameter=[', "order_id": ' num2str(params{1}) ];
        [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% orders function
function [response,status]=bitfinex_orders(~)
url_ext='/v1/orders';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% positions function
function [response,status]=bitfinex_positions(~)
url_ext='/v1/positions';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% claim_positions function
function [response,status]=bitfinex_claim_positions(params)
url_ext='/v1/position/claim';
if isempty(params)
response='error';
status='error';
disp('position_id missing')
else
        parameter=[', "position_id": ' num2str(params{1}) ];
        [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% history function
function [response,status]=bitfinex_history(params)
url_ext='/v1/history';
asd=find(strcmp('currency',params),1);
if isempty(asd)
   disp('currency (string) missing: The currency to look for.')
   response='error';
    status='error';
else
    parameter=[', "currency": "' num2str(params{asd+1}) '"'];
    since_loc=find(strcmp('since',params),1);
    until_loc=find(strcmp('until',params),1);
    limitloc=find(strcmp('limit',params),1);
    wallet_loc=find(strcmp('wallet',params),1);
    if isempty(since_loc)
        disp('since (time): Optional. Return only the history after this timestamp.')
    else
        parameter=[parameter ', "since": "' num2str(params{since_loc+1}) '"'];
    end
    if isempty(until_loc)
        disp('until (time): Optional. Return only the history before this timestamp.')
    else
        parameter=[parameter ', "until": "' num2str(params{until_loc+1}) '"'];
    end
    if isempty(limitloc)
        disp('limit (int): Optional. Limit the number of entries to return. Default is 500.')
    else
        parameter=[parameter ', "limit": ' num2str(params{limitloc+1})];
    end
    if isempty(wallet_loc)
        disp('wallet (string): Optional. Return only entries that took place in this wallet. Accepted inputs are: "trading", "exchange", "deposit".')
    else
        parameter=[parameter ', "wallet": "' num2str(params{wallet_loc+1}) '"'];
    end
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end


% % history_movements function
function [response,status]=bitfinex_history_movements(params)
url_ext='/v1/history/movements';
asd=find(strcmp('currency',params),1);
if isempty(asd)
   disp('currency (string) missing: The currency to look for.')
   response='error';
    status='error';
else
    parameter=[', "currency": "' num2str(params{asd+1}) '"'];
    since_loc=find(strcmp('since',params),1);
    until_loc=find(strcmp('until',params),1);
    limitloc=find(strcmp('limit',params),1);
    method_loc=find(strcmp('method',params),1);
    if isempty(since_loc)
        disp('since (time): Optional. Return only the history after this timestamp.')
    else
        parameter=[parameter ', "since": "' num2str(params{since_loc+1}) '"'];
    end
    if isempty(until_loc)
        disp('until (time): Optional. Return only the history before this timestamp.')
    else
        parameter=[parameter ', "until": "' num2str(params{until_loc+1}) '"'];
    end
    if isempty(limitloc)
        disp('limit (int): Optional. Limit the number of entries to return. Default is 500.')
    else
        parameter=[parameter ', "limit": ' num2str(params{limitloc+1})];
    end
    if isempty(method_loc)
        disp('method (string): Optional. The method of the deposit/withdrawal (can be "bitcoin", "litecoin", "darkcoin", "wire", "egopay").')
    else
        parameter=[parameter ', "method": "' num2str(params{method_loc+1}) '"'];
    end
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% % mytrades function
function [response,status]=bitfinex_mytrades(params)
url_ext='/v1/mytrades';
paramsss={'symbol','timestamp'};
paramsss_def={'symbol (string): The pair traded (BTCUSD, LTCUSD, LTCBTC).',...
    'timestamp (time): Trades made before this timestamp wont be returned.',...
    'limit_trades (int): Optional. Limit the number of trades returned. Default is 50.'};
k=0;
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
        k=1;
    else
        parameters{i}=num2str(params{asd+1});
    end
end
if k==1
    response='error';
    status='error';
else
    asd=find(strcmp('limit_trades',params),1);
    if isempty(asd)
        parameter=[', "symbol": "' parameters{1} '", "timestamp": "' parameters{2} '"'];
    else
        parameter=[', "symbol": "' parameters{1} '", "timestamp": "' parameters{2} '", "limit_trades": ' params{asd+1}];
    end
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% new_offer function
function [response,status]=bitfinex_new_offer(params)
url_ext='/v1/offer/new';
paramsss={'currency','amount','rate','period','direction'};
paramsss_def={'currency	[string]	The name of the currency.',...
    'amount	[decimal]	Offer size: how much to lend or borrow.',...
    'rate	[decimal]	Rate to lend or borrow at. In percentage per 365 days.',...
    'period	[integer]	Number of days of the loan (in days)',...
    'direction	[string]	Either "lend" or "loan".'};
k=0;
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
        k=1;
    else
        parameters{i}=num2str(params{asd+1});
    end
end
if k==1
    response='error';
    status='error';
else
    
    parameter=[', "currency": "' parameters{1} '", "amount": "' parameters{2} '", "rate": "' parameters{3} '", "period": ' parameters{4} ', "direction": "' parameters{5} '"'];
    
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end


% cancel_offer function
function [response,status]=bitfinex_cancel_offer(params)
url_ext='/v1/offer/cancel';
if isempty(params)
    response='error';
    status='error';
    disp('offer id missing')
else
    parameter=[', "offer_id": ' num2str(params{1}) ];
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end


% offer_status function
function [response,status]=bitfinex_offer_status(params)
url_ext='/v1/offer/status';
if isempty(params)
    response='error';
    status='error';
    disp('offer id missing')
else
    parameter=[', "offer_id": ' num2str(params{1}) ];
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% offers function
function [response,status]=bitfinex_offers(~)
url_ext='/v1/offers';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% credits function
function [response,status]=bitfinex_credits(~)
url_ext='/v1/credits';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% taken_swaps function
function [response,status]=bitfinex_taken_swaps(~)
url_ext='/v1/taken_swaps';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% close_swap function
function [response,status]=bitfinex_close_swap(params)
url_ext='/v1/swap/close';
if isempty(params)
    response='error';
    status='error';
    disp('swap_id missing')
else
    parameter=[', "swap_id": ' num2str(params{1}) ];
    [response,status]=bitfinex_authenticated(url_ext,parameter);
end
end

% balances function
function [response,status]=bitfinex_balances(~)
url_ext='/v1/balances';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% account_infos function
function [response,status]=bitfinex_account_infos(~)
url_ext='/v1/account_infos';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end

% margin_infos function
function [response,status]=bitfinex_margin_infos(~)
url_ext='/v1/margin_infos';
parameter='';
[response,status]=bitfinex_authenticated(url_ext,parameter);
end