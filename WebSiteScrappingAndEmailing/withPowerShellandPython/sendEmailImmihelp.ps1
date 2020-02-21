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
cleanup($htmlFile);
$url="https://www.immihelp.com/visa-bulletin-movement/eb1-india/filing";
python $pwd/getTable.py $htmlFile
$body=$(gc $htmlFile|Out-String)
#send email;
$password = ConvertTo-SecureString $Env:EMAILHELP -AsPlainText -Force
$smtpCred= New-Object System.Management.Automation.PSCredential ($Env:EMAILUSER, $password) ;
Write-Host "credential $($smtpCred)"


Send-MailMessage -From $Env:EMAILUSER -To $env:EMAILTO -Subject "immihelp visa bulletin" -Body $body -DeliveryNotificationOption OnFailure -SmtpServer 'smtp.office365.com' -Credential $smtpCred -Port 587 -UseSsl -BodyAsHtml



