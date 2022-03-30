// authProvider.js
import { MsalAuthProvider, LoginType } from 'react-aad-msal';

// Msal Configurations
const config = {
  auth: {
    authority: 'https://login.microsoftonline.com/0473845-fa1a-42e7-9cf1-eb416c396f2d',  // --> Directory (tenant) ID of the Azure app registration
    clientId: '453c58ff-1854-41fb-b2e3-05779f34d581/.default',  // --> APPLICATION (CLIENT) ID of the Azure app registration
    postLogoutRedirectUri: window.location.origin, // use windows.location.origin to redirect back to the calling page 
    redirectUri: window.location.origin,
    validateAuthority: true,
    // After being redirected to the "redirectUri" page, should user
    // be redirected back to the Url where their login originated from?
    navigateToLoginRequestUrl: true
  },
  cache: {
    cacheLocation: "localStorage",
    storeAuthStateInCookie: true
  }
};

// Authentication Parameters
const authenticationParameters = {
  scopes: [
    '453c58ff-1854-41fb-b2e3-05779f34d581/.default'  // --> APPLICATION (CLIENT) ID of the Azure app registration
    //'user.read',
    //'https://05d75c05-fa1a-42e7-9cf1-eb416c396f2d.onmicrosoft.com/564c69ff-2965-41fb-b2e3-05779f34d581/.default>'
  ]
}

// Options
const options = {
  loginType: LoginType.Popup,
  tokenRefreshUri: window.location.origin + '/auth.html'
}

export const authProvider = new MsalAuthProvider(config, authenticationParameters, options)
