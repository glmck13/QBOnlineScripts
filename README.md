# QBO-scripts
Simple shell scripts for interfacing with QuickBooks Online API

## Updated for OAuth 2.0!
I've been putting off the OAuth 2.0 upgrade, until I had no choice this morning.  My OAuth 1.0 tokens expired again this morning, so I followed the OAuth 1.0 process outlined below - which has been working solidly for several years now! - to renew my credentials.  Everything worked as expected, until I tried executing the qbo.sh script, and I started receiving authorization failures.  Despite many attempts at a workaround, and after pouring over the latest documentation at QuickBooks Online, I decided the best recourse was to make the leap to OAuth 2.0.  It turned out not to be so difficult after all.  The qbo.sh interface remains as-is, so only thing that changes is the process for retrieving tokens/credentials.  

## Acquiring OAuth 2.0 tokens (New!)
1. Install the latest callback.cgi script on an https-enabled webserver.  Record the URI for the script under the QuickBooks tab labeled "OAuth 2.0 Keys"   
2. Fetch your app's "Client ID" and "Client Secret" from this same tab.  Record the values within qboTokens.conf.
3. Run o2Token.sh.  The script does little more than print a hyperlink that you need to copy-and-paste into a web browser.
4. If all goes as expected, you'll be redirected to a QuickBooks login page.  Enter your credentials, select your app, and click OK/confirm.  QuickBooks will then invoke your callback.cgi function and supply so-called "refresh" and "access" tokens.  The script will then save these tokens into a local file called oauth.txt.
5. The more important of the two tokens is the "refresh" token, since this one has a 6-month expiration period.  The "refresh" token is used to obtain the "access" token, which only has a lifespan of about 1 hour. It's the "access" token that's needed to invoke QuickBooks API functions. Retreive the value of the "refresh" token from oauth.txt, and assign it to the appropriate vairiable in qboTokens.conf.  At this point can do the same with the "access" token, but it doesn't really matter, since you'll need to renew the "access" token whenever you start a qbo.sh session.
6. Before running qbo.sh, you'll need to first execute o2Refresh.sh if you haven't done so recently.  o2Refresh.sh requests an updated "access" token, and automatically populates it within your local qboTokens.conf file.  From here on out, you can invoke the qbo.sh script just as before!  If you work for longer than an hour, just call o2Refresh.sh again to update your "access" token.  That's all there is to it!

## Acquiring OAuth 1.0 tokens (Deprecated!)
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
