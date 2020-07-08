async function getKV(interactiveLogin) {
  const AzureKeyVault = require("azure-keyvault");
  const MsRestAzure = require("ms-rest-azure");
  const config = require("./config");
  // option 1: with service principal secret.
  const credentials = interactiveLogin
    ? await MsRestAzure.interactiveLogin()
    : await MsRestAzure.loginWithServicePrincipalSecret(
        config.security.keyVaultAppId,
        process.env[config.security.keyVaultAppIdSecretEnvironmentVariable], // keyvault secret
        config.security.keyVaultTenantId
      );
  const key = "azurevault"; // some random key
  const keyVaultClient = {
    // A key that identifies this client instance
    key,
    // The client itself
    client: new AzureKeyVault.KeyVaultClient(credentials),
    // The configuration that has been used to create the client
    configuration: config.security,
  };

  const secretName =
    config.security.KeyVaultSecretName || process.argv[3] || process.argv[2];
  const keyVaultBaseUrl = config.security.keyVaultBaseUrl;
  const secretVersions = await keyVaultClient.client.getSecretVersions(
    keyVaultBaseUrl,
    secretName
  );

  // console.log(`${JSON.stringify(secretVersions)}`);

  let recentDate = new Date("Jan-01-1970");
  let recentSecretValue;
  for (let i = 0; i < secretVersions.length; i++) {
    const secretVersion = secretVersions[i].id.match(/[a-zA-Z0-9]{30,}$/)[0];
    // console.log(`querying for secrev version ${secretVersion}`);

    const secretValue = await keyVaultClient.client.getSecret(
      keyVaultBaseUrl,
      secretName,
      secretVersion
    );
    let thisDate = new Date(secretValue.attributes.updated);
    if (recentDate < thisDate) {
      recentDate = thisDate;
      recentSecretValue = secretValue;
    }
  }

  console.log(`${recentSecretValue.value}`);
}
var myArgs = process.argv.slice(2);

getKV(myArgs.length > 0 && myArgs[0].match("int"))
  .then((x) => x)
  .catch((e) => console.log(e));
