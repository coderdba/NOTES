@echo off

:: ########################################################
:: # Setting up Company Proxy
:: ########################################################

set proxy=http://proxyservername.company.com:3128
set no_proxy=127.0.0.1,localhost,company.com,headquarters.company.com,stores.company.com,email.company.com
set HTTP_PROXY=%proxy%
set HTTPS_PROXY=%proxy%
set NO_PROXY=%no_proxy%
set VAGRANT_HTTP_PROXY=%proxy%
set VAGRANT_HTTPS_PROXY=%proxy%
set VAGRANT_NO_PROXY=%no_proxy%
