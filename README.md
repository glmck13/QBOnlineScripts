# QBO-scripts
Simple shell scripts for interfacing with QuickBooks Online API

## Updated for Oauth 2.0!
I've been putting the OAuth 2.0 upgrade... until things broke this monring!  My tokens expired this morning, so I used the process outlined below - which has been working solidly for several years now! - to renew my credentials.  Everything worked as expected, until I tried executing my qbo.sh script and started getting authorization failures.  Despite many attempts at a workaround, and pouring over the latest documentation at Quickbooks Online, I decided the besr recourse was to make the jump to OAuth 2.0.  It turned out to be not that difficult after all! 

## Acquiring OAuth Tokens
1. Install the callback.cgi script on your local webserver. Record the directory where you placed the file within the OAUTH\_VERIFIER variable in qboTokens.conf.
2. Create an app on the QBO website. Retrieve the app's "OAuth Consumer Key" and "OAuth Consumer Secret" listed under the "Keys" tab.  Populate these values within the OAUTH\_CONSUMER\_KEY and OAUTH\_CONSUMER\_SECRET variables within qboTokens.conf
3. Run reqToken.sh
4. Open a web browser, and goto: https://appcenter.intuit.com/Connect/Begin?oauth_token=???", replacing "???" with the oauth\_token value returned by the above script.
5. Follow the instructions on the QBO web site. Login to your developer account, choose a company, and authorize your app to access the selected company.  If all goes well, you will be redirected to the callback.cgi script on your server.  The script populates a file that is referenced by the OAUTH\_VERIFIER variable in qboTokens.conf.
6. Run accToken.sh
7. If all goes well, the last script will return final OAUTH\_TOKEN and OAUTH\_TOKEN\_SECRET values.  The script automatically populates these variables within qboTokens.conf.
8. Populate the ID value for the company selected in step #5 in the QBO\_REALMID variable within qboTokens.conf.

## Calling QBO APIs
The qbo.sh script is used to invoke QuickBooks APIs.  Its syntax is:
> qbo.sh _GET|POST API-name params..._

The script reads API input from stdin (applies only to POST calls), and writes output to stdout.  The API input & output format are specified by the QBO\_FORMAT variable within qboTokens.conf (either json or xml). The QBO\_REALMID value can be used as part of the _API-name_ to reference the app's associated company.  If desired, you can maintain separate conf files for your sandbox & production environments.  The sandbox conf file is simply referenced as ${QBO\_SANDBOX}qboTokens.conf.  So in order to switch to the sandbox environment, simply export QBO\_SANDBOX to the appropriate prefix string, e.g. "sandbox-" before calling qbo.sh.

## Examples
> qbo.sh GET '/company/$QBO_REALMID/query' 'query=select * from Deposit'  
  
> qbo.sh POST '/company/$QBO_REALMID/deposit' 'operation=delete' <<EOF  
{ "Id":"??", "SyncToken":99 }  
EOF  
