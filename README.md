# QBO-scripts
Simple shell scripts for interfacing with QuickBooks Online API

## Acquiring OAUTH Tokens
1. Install the callback.cgi script on your local webserver. Record the directory where you placed the file within the OAUTH\_VERIFIER variable in qboTokens.conf.
2. Create an app on the QBO website. Retrieve the app's "OAuth Consumer Key" and "OAuth Consumer Secret" values listed under the "Keys" tab.  Populate these values within the OAUTH\_CONSUMER\_KEY and OAUTH\_CONSUMER\_SECRET variables within qboTokens.conf
3. Run reqTokens.sh
4. Open a web browser, and goto: https://appcenter.intuit.com/Connect/Begin?oauth_token=???", replacing "???" with the oauth\_token value returned by the
above script.
5. Follow the instructions on the QBO web site. Login to your developer account, choose a company, and authorize your app to access the selected company.  If all goes well, you will be redirected to the callback.cgi script on your server.  The script populates a file that is referenced by the OAUTH\_VERIFIER variable in qboTokens.conf.
6. Run accTokens.sh
7. If all goes well, the last script will return a final set of OAUTH\_TOKEN and OAUTH\_TOKEN\_SECRET values.  The script automatically populates these variables within qboTokens.conf.
8. Populate the ID value for the company selected in step #5 in the QBO\_REALMID variable within qboTokens.conf.

## Calling QBO APIs
The qbo.sh script is used to invoke QuickBook APIs.  Its syntax is:
> qbo.sh _GET|POST API-name params..._

The script reads API input from stdin (applies only to POST calls), and writes output to stdout.  The API input & output format are specified by the QBO\_FORMAT variable within qboTokens.conf. The QBO\_REALMID value can be used as part of the _API-name_ to reference the app's associated company.  If desired, you can maintain separate conf files for your sandbox & production environments.  The sandbox conf file is simply referenced as ${QBO\_SANDBOX}qboTokens.conf.  So in order to switch to the sandbox environment, simply export QBO\_SANDBOX to the appropriate prefix string, e.g. "sandbox-" before calling qbo.sh.

## Examples
> qbo.sh GET '/company/$QBO_REALMID/query' 'query=select * from Deposit'  
<br>
> qbo.sh POST '/company/$QBO_REALMID/deposit' 'operation=delete' <<EOF  
{ "Id":"??", "SyncToken":99 }  
EOF  
