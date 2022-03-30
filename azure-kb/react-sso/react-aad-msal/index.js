import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import App from './App';
import 'bootstrap/dist/css/bootstrap.min.css';
import { BrowserRouter, HashRouter } from "react-router-dom";

//---------------
import { AzureAD } from 'react-aad-msal'; // for azure-ad authentication
import { authProvider } from './auth/authProviderReactAadMsal'; // for azure-ad authentication

ReactDOM.render(
  <AzureAD provider={authProvider} forceLogin={true}>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </AzureAD>,
  document.getElementById('root')
);
