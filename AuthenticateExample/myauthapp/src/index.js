import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import App from "./App";
import * as serviceWorker from "./serviceWorker";
import { runWithAdal } from "react-adal";
import { AuthenticationContext } from "react-adal";

export const adalConfig = {
  tenant: "yourtenantid",
  clientId: "yourappid",
  endpoints: {
    api: ""
  },
  cacheLocation: "localStorage"
};

export const authContext = new AuthenticationContext(adalConfig);

runWithAdal(authContext, () => {
  console.log({ ...authContext });
  console.log(authContext._user.userName);
  ReactDOM.render(
    <App name={authContext._user.userName} logout={logout} />,
    document.getElementById("root")
  );
});

// If you want your app to work offline and load faster, you can change
// unregister() to register() below. Note this comes with some pitfalls.
// Learn more about service workers: https://bit.ly/CRA-PWA
serviceWorker.unregister();

function logout() {
  authContext.logOut();
}
