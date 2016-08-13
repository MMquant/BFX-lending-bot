% main function BITSTAMP
function [response,status]=main_api_call_bitstamp(method,params)
default_method_names={'ticker','order_book','transactions','eur_usd',...
    'balance','user_transactions','open_orders','cancel_order','buy',...
    'sell','withdrawal_requests','bitcoin_withdrawal',...
    'bitcoin_deposit_address','unconfirmed_btc','ripple_withdrawal',...
    'ripple_address'};
default_method_types={@bitstamp_ticker,@bitstamp_order_book,...
    @bitstamp_transactions,@bitstamp_eur_usd,@bitstamp_balance,...
    @bitstamp_user_transactions,@bitstamp_open_orders,...
    @bitstamp_cancel_order,@bitstamp_buy,@bitstamp_sell,...
    @bitstamp_withdrawal_requests,@bitstamp_bitcoin_withdrawal,...
    @bitstamp_bitcoin_deposit_address,@bitstamp_unconfirmed_btc,...
    @bitstamp_ripple_withdrawal,@bitstamp_ripple_address};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for bitstamp, please try: ticker, order_book, transactions, eur_usd, balance, user_transactions, open_orders, cancel_order, buy, sell, withdrawal_requests, bitcoin_withdrawal, bitcoin_deposit_address, unconfirmed_btc, ripple_withdrawal or ripple_address')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% ticker function
function [response,status]=bitstamp_ticker(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url='https://www.bitstamp.net/api/ticker/';
[response,status] = urlread2(url,'GET',{},header_1);
end
% order_book function
function [response,status]=bitstamp_order_book(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url='https://www.bitstamp.net/api/order_book/';
[response,status] = urlread2(url,'GET',{},header_1);
end
% transactions function ?time=hour
function [response,status]=bitstamp_transactions(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
time_loc=find(strcmp('time',params),1);
if isempty(time_loc)
url='https://www.bitstamp.net/api/transactions/?time=hour';
disp('time missing, used default: hour')
else
url=['https://www.bitstamp.net/api/transactions/?time=',params{time_loc+1}];
end
[response,status] = urlread2(url,'GET',{},header_1);
end
% eur_usd function
function [response,status]=bitstamp_eur_usd(~)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
url='https://www.bitstamp.net/api/eur_usd/';
[response,status] = urlread2(url,'GET',{},header_1);
end

% requests with authentication
% header & parameters
function [response,status]=bitstamp_authenticated(url_ext,parameter)
    url='https://www.bitstamp.net/api/';
    % nonce
    nonce = strrep(num2str(now*1000000-7.34E11), '.', '');
    nonce = nonce(1:10);
    [key,secret,username]=key_secret('bitstamp');
    url=[url url_ext];
    string=[nonce username key]; %use username instead client id
    Signature = crypto(string, secret, 'HmacSHA256');
    % post-parameters
    postparams=['key=' key '&signature=' char(Signature) '&nonce=' nonce parameter];
    header=http_createHeader('Content-Type','application/x-www-form-urlencoded');
    [response,status] = urlread2(url,'POST',postparams,header);
end

% balance function
function [response,status]=bitstamp_balance(~)
url_ext='balance/';
parameter='';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end

% user_transactions function
function [response,status]=bitstamp_user_transactions(params)
paramsss={'offset','limit','sort'};
paramsss_def={'offset missing - skip that many transactions before beginning to return results. Default: 0.','limit missing - limit result to that many transactions. Default: 100. Maximum: 1000.','sort - sorting by date and time (asc - ascending; desc - descending). Default: desc.'};
parameter='';
for i=1:length(paramsss)
    asd=find(strcmp(paramsss(i),params),1);
    if isempty(asd)
        disp(paramsss_def{i})
    else
        parameter=[parameter '&' params{asd} '=' num2str(params{asd+1})];
    end
end
url_ext='user_transactions/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end

% open_orders function
function [response,status]=bitstamp_open_orders(~)
parameter='';
url_ext='open_orders/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end
% cancel_order function
function [response,status]=bitstamp_cancel_order(params)

id_loc=find(strcmp('id',params),1);
if isempty(id_loc)
    disp('id missing')
    response='error';
    status='error'; 
else
id=params{id_loc+1};
parameter=['id=',num2str(id)];
url_ext='cancel_order/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end
end

% buy function
function [response,status]=bitstamp_buy(params)
amount_loc=find(strcmp('amount',params),1);
price_loc=find(strcmp('price',params),1);
limit_price_loc=find(strcmp('limit_price',params),1);
if isempty(amount_loc)
    disp('amount missing')
    response='error';
    status='error';
else if isempty(price_loc)
    disp('price missing')
    response='error';
    status='error';
    else if isempty(limit_price_loc)
                disp('limit_price missing')
                response='error';
                status='error';
        else
        amount=params{amount_loc+1};
        price=params{price_loc+1};
        limit_price=params{limit_price_loc+1};
        url_ext='buy/';
        parameter=['amount=' num2str(amount) '&price=' num2str(price) '&limit_price=' num2str(limit_price)];
        [response,status]=bitstamp_authenticated(url_ext,parameter); 
        end
    end
end
end

% sell function
function [response,status]=bitstamp_sell(params)
amount_loc=find(strcmp('amount',params),1);
price_loc=find(strcmp('price',params),1);
limit_price_loc=find(strcmp('limit_price',params),1);
if isempty(amount_loc)
    disp('amount missing')
    response='error';
    status='error';
else if isempty(price_loc)
    disp('price missing')
    response='error';
    status='error';
    else if isempty(limit_price_loc)
                disp('limit_price missing')
                response='error';
                status='error';
        else
        amount=params{amount_loc+1};
        price=params{price_loc+1};
        limit_price=params{limit_price_loc+1};
        url_ext='sell/';
        parameter=['amount=' num2str(amount) '&price=' num2str(price) '&limit_price=' num2str(limit_price)];
        [response,status]=bitstamp_authenticated(url_ext,parameter); 
        end
    end
end
end

% withdrawal_requests function
function [response,status]=bitstamp_withdrawal_requests(~)
parameter='';
url_ext='withdrawal_requests/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end

% bitcoin_withdrawal function
function [response,status]=bitstamp_bitcoin_withdrawal(params)
amount_loc=find(strcmp('amount',params),1);
address_loc=find(strcmp('address',params),1);
if isempty(amount_loc)
    disp('amount missing')
    response='error';
    status='error';
else if isempty(address_loc)
                disp('address missing')
                response='error';
                status='error';
     else
        amount=params{amount_loc+1};
        address=params{address_loc+1};
        url_ext='bitcoin_withdrawal/';
        parameter=['amount=' num2str(amount) '&address=' num2str(address)];
        [response,status]=bitstamp_authenticated(url_ext,parameter); 
     end
end
end

% bitcoin_deposit_address function
function [response,status]=bitstamp_bitcoin_deposit_address(~)
parameter='';
url_ext='bitcoin_deposit_address/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end

% unconfirmed_btc function
function [response,status]=bitstamp_unconfirmed_btc(~)
parameter='';
url_ext='unconfirmed_btc/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end

% ripple_withdrawal function
function [response,status]=bitstamp_ripple_withdrawal(params)
amount_loc=find(strcmp('amount',params),1);
address_loc=find(strcmp('address',params),1);
currency_loc=find(strcmp('currency',params),1);
if isempty(amount_loc)
    disp('amount missing')
    response='error';
    status='error';
else if isempty(address_loc)
    disp('address_loc missing')
    response='error';
    status='error';
    else if isempty(currency_loc)
                disp('currency missing')
                response='error';
                status='error';
        else
        amount=params{amount_loc+1};
        address=params{address_loc+1};
        currency=params{currency_loc+1};
        url_ext='ripple_withdrawal/';
        parameter=['amount=' num2str(amount) '&address=' num2str(address) '&currency=' num2str(currency)];
        [response,status]=bitstamp_authenticated(url_ext,parameter); 
        end
    end
end
end

% ripple_address function
function [response,status]=bitstamp_ripple_address(~)
parameter='';
url_ext='ripple_address/';
[response,status]=bitstamp_authenticated(url_ext,parameter);
end