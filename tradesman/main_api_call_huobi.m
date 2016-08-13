% main function HUOBI 'http://api.huobi.com/staticmarket/ticker_btc_json.js', 'http://api.huobi.com/staticmarket/depth_btc_5.js', 'http://api.huobi.com/staticmarket/btc_kline_005_json.js', 'http://api.huobi.com/staticmarket/detail_btc_json.js'
function [response,status]=main_api_call_huobi(method,params)
default_method_names={'ticker','depth','kline','detail'};
default_method_types={@huobi_ticker,@huobi_depth,@huobi_kline,@huobi_detail};
method_select=find(strcmp(method,default_method_names), 1);
if isempty(method_select)
disp('wrong method name for huobi, please try: ticker, depth, btc_kline, detail')
response='error';
status='error';
else
[response,status]=default_method_types{method_select}(params);
end
end
% requests w/o authentication
% ticker function
function [response,status]=huobi_ticker(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
coin_loc=find(strcmp('coin',params),1);
if isempty(coin_loc)
disp('coin missing,try: btc or ltc')
response='error';
status='error';
else
    if strcmp(params{coin_loc+1},'btc')
        url='http://api.huobi.com/staticmarket/ticker_btc_json.js';
        [response,status] = urlread2(url,'GET',{},header_1);
    else if strcmp(params{coin_loc+1},'ltc')
            url='http://api.huobi.com/staticmarket/ticker_ltc_json.js';
            [response,status] = urlread2(url,'GET',{},header_1);
        else
            disp('wrong coin type, try: btc or ltc')
            response='error';
            status='error';
        end
    end
end
end
% depth function
function [response,status]=huobi_depth(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
coin_loc=find(strcmp('coin',params),1);
limit_loc=find(strcmp('limit',params),1);
if isempty(limit_loc)
parameter_1='json';
disp('limit is 150 by default, try ''limit'',(1-150)')
else
parameter_1=num2str(params{limit_loc+1});
end
if isempty(coin_loc)
disp('coin missing,try: btc or ltc')
response='error';
status='error';
else
    if strcmp(params{coin_loc+1},'btc')
        url=['http://api.huobi.com/staticmarket/depth_btc_',parameter_1,'.js'];
        [response,status] = urlread2(url,'GET',{},header_1);
    else if strcmp(params{coin_loc+1},'ltc')
            url=['http://api.huobi.com/staticmarket/depth_ltc_',parameter_1,'.js'];
            [response,status] = urlread2(url,'GET',{},header_1);
        else
            disp('wrong coin type, try: btc or ltc')
            response='error';
            status='error';
        end
    end
end
end
% kline function
function [response,status]=huobi_kline(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
coin_loc=find(strcmp('coin',params),1);
period_loc=find(strcmp('period',params),1);
if isempty(period_loc)
parameter_1='005';
disp('period is ''005'' by default (period of 5 minutes please check https://www.huobi.com/help/index.php?a=market_help for intervals), try ''period'',(''001'',''005'',''015'',''030'',''060'',''100'',''200'',''300'' or ''400'' as string)')
else
parameter_1=params{period_loc+1};
end
if isempty(coin_loc)
disp('coin missing,try: btc or ltc')
response='error';
status='error';
else
    if strcmp(params{coin_loc+1},'btc')
        url=['http://api.huobi.com/staticmarket/btc_kline_',parameter_1,'_json.js'];
        [response,status] = urlread2(url,'GET',{},header_1);
    else if strcmp(params{coin_loc+1},'ltc')
            url=['http://api.huobi.com/staticmarket/ltc_kline_',parameter_1,'_json.js'];
            [response,status] = urlread2(url,'GET',{},header_1);
        else
            disp('wrong coin type, try: btc or ltc')
            response='error';
            status='error';
        end
    end
end
end
% detail function
function [response,status]=huobi_detail(params)
header_1=http_createHeader('Content-Type','application/x-www-form-urlencoded');
coin_loc=find(strcmp('coin',params),1);
if isempty(coin_loc)
disp('coin missing,try: btc or ltc')
response='error';
status='error';
else
    if strcmp(params{coin_loc+1},'btc')
        url='http://api.huobi.com/staticmarket/detail_btc_json.js';
        [response,status] = urlread2(url,'GET',{},header_1);
    else if strcmp(params{coin_loc+1},'ltc')
            url='http://api.huobi.com/staticmarket/detail_ltc_json.js';
            [response,status] = urlread2(url,'GET',{},header_1);
        else
            disp('wrong coin type, try: btc or ltc')
            response='error';
            status='error';
        end
    end
end
end