# BFX-lending-bot
Bitfinex lending bot

This is lending bot written in MATLAB which automatically lends free funds in deposit wallet.  
More info how it works can be found on my blog http://mmquant.net/liquidity-lending-on-bitfinex/.  

Contents:  
SizeCorrectionwget.sh - Downloads script to get tick data .csv with correct size.  
threshold_calc.m - Calculates volume threshold.  
lending_script.m - Lends unused funds.  

How to use?  
1. Read http://mmquant.net/liquidity-lending-on-bitfinex/ .  
2. Download BFX-lending-bot repository and add it to MATLAB path with subfolders.  
3. Generate API key/secret on BFX platform and add them to BFX-lending-bot/tradesman/key_secret.m  
4. Add cron entries (don't forget to change path to your SizeCorrectionwget.sh). For debugging purposes you can  
   comment out output to /dev/null 2>&1 .  
    */11    *       *       *       *       /usr/local/bin/matlab -nodesktop -nosplash -r lending_script > /dev/null 2>&1
    5       0       *       *       *       /usr/local/bin/matlab -nodesktop -nosplash -r threshold_calc > /dev/null 2>&1
    55      23      *       *       *       BFX-lending-bot/SizeCorrectionwget.sh

5. Set path in SizeCorrectionwget.sh .  
6. Set paths in threshold_calc.m . see %% I/O section.  
7. Set paths in lending_script.m . see %% I/O section.  
8. Check your loans on BFX platform.  
