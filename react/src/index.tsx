import ReactDOM from "react-dom"
import { App } from './App'
import { Auth0Provider } from "@auth0/auth0-react"
import React from "react"

ReactDOM.render(
  <Auth0Provider
    domain="dev-mv5giriq.jp.auth0.com"
    clientId="799eM9mz8995T6svTxYSpKVz1vHSbCcz"
    redirectUri={window.location.origin}
    audience="https://dev-mv5giriq.jp.auth0.com/api/v2/"
    scope="read:current_user update:current_user_metadata"
  >
    <React.StrictMode>
      <App />
    </React.StrictMode>
  </Auth0Provider>,
  document.getElementById('app')
)
