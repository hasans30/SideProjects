# set below three environment variable for emailing
# EMAILUSER - user name for Gmail account you want to send email from
# EMAILHELP - password for Gmail account
# EMAILTO - email will be sent to this address

# change authentication token. get it from network tab of chrome dev tool or fiddler
$authtoken="authtoken in guid form available from fiddler or network trace"
#change apnabazar email address
$apnaemail="apnabazar user email address"


function sendemail($body){
write-host "$body"
write-host $body

$password = ConvertTo-SecureString $Env:EMAILHELP -AsPlainText -Force
$smtpCred= New-Object System.Management.Automation.PSCredential ($Env:EMAILUSER, $password) ;
Write-Host "credential $($smtpCred)"
#Send-MailMessage -From $Env:EMAILUSER -To $env:EMAILTO -Subject "Apnabazar Status" -Body $body -DeliveryNotificationOption OnFailure -SmtpServer 'smtp.gmail.com' -Credential $smtpCred -Port 587 -UseSsl -BodyAsHtml

}


function checkAvailability(){

try
{



$resp=Invoke-WebRequest -Uri "https://partnersapi.gethomesome.com/user/basket" -Headers @{"Pragma"="no-cache"; "Cache-Control"="no-cache"; "User-Agent"="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Safari/537.36"; "authToken"=$authtoken; "location"="EC86C6F7-F8ED-4D0C-B74C-3B39028967CF"; "Accept"="application/json, text/plain, */*"; "Sec-Fetch-Dest"="empty"; "apikey"="BAB01330-662C-4A7E-883C-A9635792747B"; "emailid"=$apnaemail; "Origin"="https://www.apnabazarstores.com"; "Sec-Fetch-Site"="cross-site"; "Sec-Fetch-Mode"="cors"; "Referer"="https://www.apnabazarstores.com/cart/checkout"; "Accept-Encoding"="gzip, deflate, br"; "Accept-Language"="en-US,en;q=0.9,pt;q=0.8,ar;q=0.7"}
$msg='failed to capture any status'

if($resp.StatusCode -eq 200){
$checkout=$resp.Content|ConvertFrom-Json
$availableCount=$checkout.orderFee.pickup.availableTimes.Count
$unavlableReason=$checkout.orderFee.pickup.unavailable.reason

$msg=$("pickup availability count= $availableCount unavailable reason=$unavlableReason ");

$availableCount=$checkout.orderFee.delivery.availableTimes.Count
$unavlableReason=$checkout.orderFee.delivery.unavailable.reason

$msg=$("$msg. delivery availability count= $availableCount unavailable reason=$unavlableReason ");

} else {
    $msg="server returns status code:" + $resp.StatusCode
}

} catch {
$msg=$_.Exception.Message
Write-Output $("Some error happened $msg")
}
return $msg
}

function cleanup {

Param ($fileName)
if ( Test-Path $fileName ) {
    Write-Output "Cleaning up file $($fileName)"
    Remove-Item $fileName -Force
} else {
    Write-Output "$($fileName) doesnt exists";
}

}


# get web page
$htmlFile="_tmp.html";
touch $htmlFile
$body=checkAvailability ;
$filebody=$(gc $htmlFile)
if( $body -eq $filebody){
    Write-Output "no change in delivery status"
} else {
    $body | Out-File $htmlFile 
    Write-Output "delivery status changed sending email "
    sendemail($body)
}


#send email;

