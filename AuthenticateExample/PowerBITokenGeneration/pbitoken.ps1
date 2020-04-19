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



$file="_auth_"
touch $file
$atk=(gc $file)
 
if( $genauth -ne 0){
$atk=Get-GraphAccessTokenFromMSAL
$atk|out-file $file
}
$auth="Bearer $atk"


$groups=Invoke-WebRequest -Uri "https://api.powerbi.com/v1.0/myorg/groups" -Headers @{"method"="GET"; "authority"="api.powerbi.com"; "scheme"="https"; "path"="/v1.0/myorg/groups"; "pragma"="no-cache"; "cache-control"="no-cache"; "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"; "sec-fetch-dest"="empty"; "authorization"=$auth; "accept"="*/*"; "origin"="https://docs.microsoft.com"; "sec-fetch-site"="cross-site"; "sec-fetch-mode"="cors"; "referer"="https://docs.microsoft.com/en-us/rest/api/power-bi/groups/getgroups"; "accept-encoding"="gzip, deflate, br"; "accept-language"="en-US,en;q=0.9,pt;q=0.8,ar;q=0.7"}

$groups.Content

$datasets=Invoke-WebRequest -Uri "https://api.powerbi.com/v1.0/myorg/groups/e91aaac8-c690-4aba-b69a-fc6228778f14/datasets" -Headers @{"method"="GET"; "authority"="api.powerbi.com"; "scheme"="https"; "path"="/v1.0/myorg/groups/e91aaac8-c690-4aba-b69a-fc6228778f14/datasets"; "pragma"="no-cache"; "cache-control"="no-cache"; "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"; "sec-fetch-dest"="empty"; "authorization"=$auth; "accept"="*/*"; "origin"="https://docs.microsoft.com"; "sec-fetch-site"="cross-site"; "sec-fetch-mode"="cors"; "referer"="https://docs.microsoft.com/en-us/rest/api/power-bi/datasets/getdatasetsingroup"; "accept-encoding"="gzip, deflate, br"; "accept-language"="en-US,en;q=0.9,pt;q=0.8,ar;q=0.7"}

$datasets.Content


$reports=Invoke-WebRequest -Uri "https://api.powerbi.com/v1.0/myorg/groups/e91aaac8-c690-4aba-b69a-fc6228778f14/reports" -Headers @{"method"="GET"; "authority"="api.powerbi.com"; "scheme"="https"; "path"="/v1.0/myorg/groups/7be1f5e2-10aa-4447-9cb3-b9768d5d6d9f/reports"; "pragma"="no-cache"; "cache-control"="no-cache"; "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"; "sec-fetch-dest"="empty"; "authorization"=$auth; "accept"="*/*"; "origin"="https://docs.microsoft.com"; "sec-fetch-site"="cross-site"; "sec-fetch-mode"="cors"; "referer"="https://docs.microsoft.com/en-us/rest/api/power-bi/reports/getreportsingroup"; "accept-encoding"="gzip, deflate, br"; "accept-language"="en-US,en;q=0.9,pt;q=0.8,ar;q=0.7"}

$reports.Content

write-host "try to get embedded token"

$pbitoken=Invoke-WebRequest -Uri "https://api.powerbi.com/v1.0/myorg/GenerateToken" -Method "POST" -Headers @{"method"="POST"; "authority"="api.powerbi.com"; "scheme"="https"; "path"="/v1.0/myorg/GenerateToken"; "pragma"="no-cache"; "cache-control"="no-cache"; "authorization"=$auth; "sec-fetch-dest"="empty"; "user-agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36"; "accept"="*/*"; "origin"="https://docs.microsoft.com"; "sec-fetch-site"="cross-site"; "sec-fetch-mode"="cors"; "referer"="https://docs.microsoft.com/en-us/rest/api/power-bi/embedtoken/generatetoken"; "accept-encoding"="gzip, deflate, br"; "accept-language"="en-US,en;q=0.9,pt;q=0.8,ar;q=0.7"} -ContentType "application/json" -Body ([System.Text.Encoding]::UTF8.GetBytes("{$([char]10)  `"datasets`": [$([char]10)    {$([char]10)      `"id`": `"aa206b8a-9e83-45a8-9a47-3deb3485fd2b`"$([char]10)    }$([char]10)  ],$([char]10)  `"reports`": [$([char]10)    {$([char]10)      `"allowEdit`": true,$([char]10)      `"id`": `"8d8931e1-4491-46fd-80ae-0b5f7c87a7a3`"$([char]10)    }  ]$([char]10)}$([char]10)"))

$pbitoken.Content



