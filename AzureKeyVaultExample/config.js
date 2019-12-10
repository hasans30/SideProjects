const Config = {
  security: {
    keyVaultAppId: "guid", // client id
    keyVaultAppIdSecretEnvironmentVariable: "", //
    keyVaultBaseUrl: "https://keyvaultname.vault.azure.net/", // DNS Name
    keyVaultTenantId: "guid", // Directory ID
    KeyVaultSecretName: "keyvaultsecret"
  }
};

module.exports = Config;
