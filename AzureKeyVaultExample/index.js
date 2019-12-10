async function getKV() {
  const AzureKeyVault = require("azure-keyvault");
  const MsRestAzure = require("ms-rest-azure");
  const config = require("./config");
  // option 1: with service principal secret.
  // const credentials = await MsRestAzure.loginWithServicePrincipalSecret(
  //   config.security.keyVaultAppId,
  //   process.env["mysecretkey"], // keyvault secret
  //   config.security.keyVaultTenantId
  // );
  // // option 2 : with interactive login
  const credentials = await MsRestAzure.interactiveLogin();
  const key = "azurevault"; // some random key
  const keyVaultClient = {
    // A key that identifies this client instance
    key,
    // The client itself
    client: new AzureKeyVault.KeyVaultClient(credentials),
    // The configuration that has been used to create the client
    configuration: config.security
  };

  const secretName = config.security.KeyVaultSecretName;
  const keyVaultBaseUrl = config.security.keyVaultBaseUrl;
  const secretVersions = await keyVaultClient.client.getSecretVersions(
    keyVaultBaseUrl,
    secretName
  );

  console.log(`${JSON.stringify(secretVersions)}`);
  const secretVersion = secretVersions[0].id.match(/[a-zA-Z0-9]{30,}/)[0];

  const secretValue = await keyVaultClient.client.getSecret(
    keyVaultBaseUrl,
    secretName,
    secretVersion
  );
  console.log(`${JSON.stringify(secretValue)}`);
}

getKV()
  .then(x => console.log("done"))
  .catch(e => console.log(e));
