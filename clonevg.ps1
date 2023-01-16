#This may be needed to bypass cert errors/checks
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$name = Read-Host "Input Cloned Volume Group Name"

#Build Headers
$headers = @{
    'Content-Type' = 'application/json'
    'Accept' = 'application/json'
    'Authorization' = 'Basic YWRtaW46bngyVGVjaDAwMSE='
}

#Build Body
$body = @{
    'name' = "$name"
    #'uuid' = [Guid]::NewGuid().ToString()

} | ConvertTo-Json

#In later versions of PowerShell, the -SkipCertificateCheck option may need to be added to the Invoke-RestMethod command to fix cert trust errors
$response = Invoke-RestMethod 'https://10.38.4.71:9440/PrismGateway/services/rest/v2.0/volume_groups/9b398ab9-9b4d-45f2-83fd-b1fee2c1e4c4/clone' -Method 'POST' -Headers $headers -Body $body
$response | ConvertTo-Json
