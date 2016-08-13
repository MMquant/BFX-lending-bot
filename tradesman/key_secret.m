function [key,secret,username]=key_secret(server)

% please type your key and secrets for each server or server you will use.
% % % % % % % % % % % % BTC-E
BTCE_KEY = '';
BTCE_SECRET = '';
BTCE_USERNAME=''; %this is empty no need for username
% % % % % % % % % % % % CEX.IO
CEXIO_KEY = '';
CEXIO_SECRET = '';
CEXIO_USERNAME=''; %this is needed in header
% % % % % % % % % % % % BITSTAMP no need atm. will be updated
BITSTAMP_KEY = '';
BITSTAMP_SECRET = '';
BITSTAMP_USERNAME=''; %this is empty no need for username
% % % % % % % % % % % % BITFINEX
BITFINEX_KEY = '';
BITFINEX_SECRET = '';
BITFINEX_USERNAME=''; %this is empty no need for username
% % % % % % % % % % % % KRAKEN
KRAKEN_KEY = '';
KRAKEN_SECRET = '';
KRAKEN_USERNAME=''; %this is empty no need for username
% % % % % % % % % % % % HUOBI no need atm. will be updated
HUOBI_KEY = '';
HUOBI_SECRET = '';
HUOBI_USERNAME=''; %this is empty no need for username

keys={BTCE_KEY,CEXIO_KEY,BITSTAMP_KEY,BITFINEX_KEY,KRAKEN_KEY,HUOBI_KEY};
secrets={BTCE_SECRET,CEXIO_SECRET,BITSTAMP_SECRET,BITFINEX_SECRET,KRAKEN_SECRET,HUOBI_SECRET};
usernames={BTCE_USERNAME,CEXIO_USERNAME,BITSTAMP_USERNAME,BITFINEX_USERNAME,KRAKEN_USERNAME,HUOBI_USERNAME};
server_names={'btce','cexio','bitstamp','bitfinex','kraken','huobi'};
server_loc=find(strcmp(server,server_names),1);
key=keys{server_loc};
secret=secrets{server_loc};
username=usernames{server_loc};
end
