



clear
clc
close all
% % Please Read First. Hello everyone, I'm Volkan and studying Engineering
% management master program in M.E.T.U., this is a research for one of my
% projects. This submit is inspired by
% http://www.mathworks.com/matlabcentral/fileexchange/44890-btc-e-trade-api
% very nice example to show how matlab can handle this situation. Please
% check his submit too and find some answers regarding certificate errors. 
% I've tried to hide error definitions inside the functions to simplify 
% examples script so please type one of the below functions to see the error
% definition. All servers are fully operational without authentication and
% BTC-E, Bitfinex and CEX.IO is operational with authentication. Before
% starting with authentication operations please try all non authenticated
% examples and be sure all working. If any problems regarding non
% authenticated connections, please check your SSL certificate as mentioned
% above. Cex.io requires username for authentication, case sensitive, no
% need for username for the rest. Crypto.m is from doHMAC_SHA512.m function
% only changed its behaviour to operate for all types, submited by "wout" also.
% urlread2 and http_createHeader functions are "Jim Hokanson" 's work. I
% deeply appreciate these guys work they are awesome. I will try
% to update rest and maybe add more servers to the list. Please enjoy. If
% you have any requests please contact me by email e134855@metu.edu.tr .
% this is my bitcoin adress if anyone willing to donate: 1PkY2H2LbBMqjqYeDkAB5vT4JSiNvoREyU


%% % % % % % % % % % REQUESTS WITHOUT AUTHENTICATION
%% % % % % % % % % % % BTC-E
%% btce_info
% [response,status]=main_api_call('btce','info',{});
%% btce_ticker
% [response,status]=main_api_call('btce','ticker',{'pair','btc_usd'});
%% btce_depth
% [response,status]=main_api_call('btce','depth',{'pair','btc_usd','limit',150});
%% btce_trades
% [response,status]=main_api_call('btce','trades',{'pair','btc_usd'});

%% % % % % % % % % % % CEX.IO
%% cexio_ticker
% [response,status]=main_api_call('cexio','ticker',{'pair','BTC/USD'});
%% cexio_last_price
% [response,status]=main_api_call('cexio','last_price',{'pair','BTC/USD'});
%% cexio_convert
% [response,status]=main_api_call('cexio','convert',{'pair','BTC/USD','amnt',2.5});
%% cexio_price_stats
% [response,status]=main_api_call('cexio','price_stats',{'pair','BTC/USD','lastHours',24,'maxRespArrSize',100});
%% cexio_order_book
% [response,status]=main_api_call('cexio','order_book',{'pair','BTC/USD','depth',1});
%% cexio_trade_history
% [response,status]=main_api_call('cexio','trade_history',{'pair','BTC/USD','since','275467'});

%% % % % % % % % % % % % BITSTAMP
%% bitstamp_ticker
% [response,status]=main_api_call('bitstamp','ticker',{});
%% bitstamp_order_book
% [response,status]=main_api_call('bitstamp','order_book',{});
%% bitstamp_transactions
% [response,status]=main_api_call('bitstamp','transactions',{'time','min'});
%% bitstamp_eur_usd
% [response,status]=main_api_call('bitstamp','eur_usd',{});

%% % % % % % % % % % % % BITFINEX
%% bitfinex_pubticker
% [response,status]=main_api_call('bitfinex','pubticker',{'pair','btcusd'});
%% bitfinex_stats
% [response,status]=main_api_call('bitfinex','stats',{'pair','btcusd'});
%% bitfinex_lendbook
% [response,status]=main_api_call('bitfinex','lendbook',{'coin','btc','limit_bids',10,'limit_asks',10});
%% bitfinex_book
% [response,status]=main_api_call('bitfinex','book',{'pair','btcusd','limit_bids',50,'limit_asks',50,'group',1});
%% bitfinex_trades
% [response,status]=main_api_call('bitfinex','trades',{'pair','btcusd','timestamp',1423567523,'limit_trades',50});
%% bitfinex_lends
% [response,status]=main_api_call('bitfinex','lends',{'coin','btc','timestamp',1423567523,'limit_lends',50});
%% bitfinex_symbols
% [response,status]=main_api_call('bitfinex','symbols',{});
%% bitfinex_symbols_details
% [response,status]=main_api_call('bitfinex','symbols_details',{});

%% % % % % % % % % % % % % % % HUOBI
%% huobi_ticker
% [response,status]=main_api_call('huobi','ticker',{'coin','ltc'});
%% huobi_ticker
% [response,status]=main_api_call('huobi','depth',{'coin','ltc','limit',1});
%% huobi_kline
% [response,status]=main_api_call('huobi','kline',{'coin','btc','period','005'});
%% huobi_detail
% [response,status]=main_api_call('huobi','detail',{'coin','ltc'});


%% % % % % % % % % % % % % REQUESTS WITH AUTHENTICATION
%caution if first time using this part please try each with a small coins.
%And be sure you generate authentication keys and secret for exchange
%server you're using. 
% Almost every server put "Bitcoin and Litecoin trading is a high-risk 
% activity with volatile price movements. We strongly advise you to
% carefully consider your risk tolerance before investing." advise on their
% site so be carefull.

%% BTC-E
%% getInfo
% [response,status]=main_api_call('btce','getInfo',{});
%% buy
% [response,status]=main_api_call('btce','buy',{'pair','btc_usd','rate',200,'amount',0.1});
%% sell
% [response,status]=main_api_call('btce','sell',{'pair','btc_usd','rate',300,'amount',0.1});
%% ActiveOrders
% [response,status]=main_api_call('btce','ActiveOrders',{'pair','btc_usd'});
%% OrderInfo
% [response,status]=main_api_call('btce','OrderInfo',{'order_id','3132132'});
%% CancelOrder
% [response,status]=main_api_call('btce','CancelOrder',{'order_id','3132132'});
%% TradeHistory
% [response,status]=main_api_call('btce','TradeHistory',{});
%% TradeHistory
% [response,status]=main_api_call('btce','TransHistory',{});

%% CEX.IO
%% balance
% [response,status]=main_api_call('cexio','balance',{});
%% open_orders
% [response,status]=main_api_call('cexio','open_orders',{'pair','BTC/usd'});
%% archived_orders
% [response,status]=main_api_call('cexio','archived_orders',{'pair','BTC/usd','limit',5});
%% cancel_order
% [response,status]=main_api_call('cexio','cancel_order',{'id',3244206125});
%% buy
% [response,status]=main_api_call('cexio','buy',{'amount',0.01,'price',200,'pair','btc/usd'});
%% sell
% [response,status]=main_api_call('cexio','sell',{'amount',0.01,'price',300,'pair','btc/usd'});
%% hashrate
% [response,status]=main_api_call('cexio','hashrate',{});
%% workers
% [response,status]=main_api_call('cexio','workers',{});

%% BITSTAMP
%% balance
% [response,status]=main_api_call('bitstamp','balance',{});
%% user_transactions
% [response,status]=main_api_call('bitstamp','user_transactions',{'offset',1,'limit',100,'sort','desc'});
%% open_orders
% [response,status]=main_api_call('bitstamp','open_orders',{});
%% cancel_order
% [response,status]=main_api_call('bitstamp','cancel_order',{'id',2});
%% buy
% [response,status]=main_api_call('bitstamp','buy',{'amount',2,'price',2,'limit_price',2});
%% sell
% [response,status]=main_api_call('bitstamp','sell',{'amount',2,'price',2,'limit_price',2});

%% BITFINEX
%% new_deposit
% [response,status]=main_api_call('bitfinex','new_deposit',{'currency','BTC','method','bitcoin','wallet_name','exchange'});
%% new_order
% [response,status]=main_api_call('bitfinex','new_order',{'symbol','btcusd','amount',0.01,'price',250,'exchange','bitfinex','side','buy','type','exchange limit','is_hidden','true'});
%% multiple_new_orders
% [response,status]=main_api_call('bitfinex','multiple_new_orders',{{'symbol','btcusd','amount',0.01,'price',250,'exchange','bitfinex','side','buy','type','exchange limit'},{'symbol','btcusd','amount',0.01,'price',250,'exchange','bitfinex','side','buy','type','exchange limit'}});
%% cancel_order
% [response,status]=main_api_call('bitfinex','cancel_order',{221168336});
%% cancel_multiple_orders
% [response,status]=main_api_call('bitfinex','cancel_multiple_orders',{221907161,221908844});
%% cancel_all_orders
% [response,status]=main_api_call('bitfinex','cancel_all_orders',{});
%% replace_order
% [response,status]=main_api_call('bitfinex','replace_order',{'order_id',223053622,'symbol','btcusd','amount',0.01,'price',175,'exchange','bitfinex','side','buy','type','exchange limit','is_hidden','true'});
%% order_status
% [response,status]=main_api_call('bitfinex','order_status',{222827275});
%% orders
% [response,status]=main_api_call('bitfinex','orders',{});
%% positions
% [response,status]=main_api_call('bitfinex','positions',{});
%% claim_positions
% [response,status]=main_api_call('bitfinex','claim_positions',{222827275});
%% history
% [response,status]=main_api_call('bitfinex','history',{'currency','btc','until',floor((now-datenum('1970', 'yyyy'))*8640000000),'limit',500,'wallet','exchange'});
%% history_movements
% [response,status]=main_api_call('bitfinex','history_movements',{'currency','btc','until',floor((now-datenum('1970', 'yyyy'))*8640000000),'limit',500,'method','bitcoin'});
%% mytrades
% [response,status]=main_api_call('bitfinex','mytrades',{'symbol','BTCUSD','timestamp','142745712563700'});
%% new_offer
% [response,status]=main_api_call('bitfinex','new_offer',{'currency','btc','amount',0.01,'rate',0.001,'period','2','direction','lend'});
%% cancel_offer
% [response,status]=main_api_call('bitfinex','cancel_offer',{5049021});
%% offer_status
% [response,status]=main_api_call('bitfinex','offer_status',{221168336});
%% offers
% [response,status]=main_api_call('bitfinex','offers',{});
%% credits
% [response,status]=main_api_call('bitfinex','credits',{});
%% taken_swaps
% [response,status]=main_api_call('bitfinex','taken_swaps',{});
%% close_swap
% [response,status]=main_api_call('bitfinex','close_swap',{5049021});
%% balances
% [response,status]=main_api_call('bitfinex','balances',{});
%% account_infos
% [response,status]=main_api_call('bitfinex','account_infos',{});
%% margin_infos
% [response,status]=main_api_call('bitfinex','margin_infos',{});