param (
    [string]$genauth = 0
 )
 

# 0 - Install the MSAL assembly in a subdirectory if it's not already there -- as long as it's not
# deleted, this is a no-op -- the assembly stay here across PowerShell sessions, reboots, etc.
# The installation is really just a package download from nuget.org and an unzip into the subdirectory 'lib'.
if ( ! (Get-Item  .\lib\Microsoft.Identity.Client.* -erroraction ignore) ) {
    install-package -Source nuget.org -ProviderName nuget -SkipDependencies Microsoft.Identity.Client -Destination $psscriptroot/lib -force -forcebootstrap | out-null
}

# 1 - Load the MSAL assembly -- needed once per PowerShell session
[System.Reflection.Assembly]::LoadFrom((Get-Item  .\lib\Microsoft.Identity.Client.*).fullname) | out-null

function Get-GraphAccessTokenFromMSAL {
    [cmdletbinding()]
    param($appId = 'f0ec1fb8-2dd9-4b44-8d70-e69257d2031d', $redirectUri = 'https://login.microsoftonline.com/common/oauth2/nativeclient', $graphScopes = 'https://analysis.windows.net/powerbi/api/App.Read.All', $logonEndpoint = 'https://login.microsoftonline.com/common/oauth2/v2.0' )

    # 2 - Get the MSAL public client auth context object
    $authContext = [Microsoft.Identity.Client.PublicClientApplication]::new($appId, $logonEndpoint, $null)

    # 3a - Invoke the AcquireTokenTokenAsync method
    $asyncResult = $authContext.AcquireTokenAsync([System.Collections.Generic.List[string]] $graphScopes)

    # 3b Wait for the method to complete
    $token = $asyncResult.Result
	write-host $token

    if ( $asyncResult.Status -eq 'Faulted' ) {
        write-error $asyncResult.Exception
    } else {
        $token.AccessToken
    }
}


function Get-PBIToken($bearer){
$auth="Bearer $bearer"


$pbitoken=Invoke-WebRequest -Uri "https://api.powerbi.com/v1.0/myorg/GenerateToken" -Method "POST" -Headers @{"method"="POST"; "authority"="api.powerbi.com"; "scheme"="https"; "path"="/v1.0/myorg/GenerateToken"; "pragma"="no-cache"; "cache-control"="no-cache"; "authorization"=$auth; "sec-fetch-dest"="empty"; "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"; "accept"="*/*"; "origin"="https://docs.microsoft.com"; "sec-fetch-site"="cross-site"; "sec-fetch-mode"="cors"; "referer"="https://docs.microsoft.com/en-us/rest/api/power-bi/embedtoken/generatetoken"; "accept-encoding"="gzip, deflate, br"; "accept-language"="en-US,en;q=0.9,pt;q=0.8,ar;q=0.7"} -ContentType "application/json" -Body ([System.Text.Encoding]::UTF8.GetBytes("{$([char]10)  `"datasets`": [$([char]10)    {$([char]10)      `"id`": `"2478bd4f-cc1b-4e3a-8566-922aa78865ab`"$([char]10)    }$([char]10)  ],$([char]10)  `"reports`": [$([char]10)    {$([char]10)      `"allowEdit`": true,$([char]10)      `"id`": `"6afe69fc-354b-40cc-a735-2eccb7dc5d6c`"$([char]10)    }  ]$([char]10)}$([char]10)"))

$(" export const pbiToken = $pbitoken") | out-file -Encoding utf8  C:\gitrepo\Aria\honolulu-client\src\features\power-bi-poc\config.js
}

# main 
$file="_auth_"
touch $file
$atk=(gc $file)

if( $genauth -ne 0){
$atk=Get-GraphAccessTokenFromMSAL
$atk|out-file $file
Get-PBIToken($atk)
} else {

try {
Get-PBIToken($atk)


} catch {

$atk=Get-GraphAccessTokenFromMSAL
$atk|out-file $file
Get-PBIToken($atk)


}



}

