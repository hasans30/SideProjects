async function getKV() {
  const AzureKeyVault = require("azure-keyvault");
  const MsRestAzure = require("ms-rest-azure");
  const config = require("../../tmp/int");
  const credentials = await MsRestAzure.loginWithServicePrincipalSecret(
    config.security.keyVaultAppId,
    process.env["mysecretkey"], // keyvault secret
    config.security.keyVaultTenantId
  );
  const key = "azurevault";
  const keyVaultClient = {
    // A key that identifies this client instance
    key,
    // The client itself
    client: new AzureKeyVault.KeyVaultClient(credentials),
    // The configuration that has been used to create the client
    configuration: config.security
  };

  console.log(`keyVClient = ${JSON.stringify(keyVaultClient)}`);

  //   const secretName = config.portal.testUserPassword;
  //   const keyVaultBaseUrl = keyVaultClient.configuration.keyVaultBaseUrl;
  //   const secretVersions = await keyVaultClient.client.getSecretVersions(
  //     keyVaultBaseUrl,
  //     secretName
  //   );

  console.log(`secretVersions = ${secretVersions}`);
}

getKV()
  .then(x => console.log("done"))
  .catch(e => console.log(e));
