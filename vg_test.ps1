[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

# Define the base URI for the API
$baseUri = 'https://192.168.1.7:9440/PrismGateway/services/rest/v2.0'

# Define the credentials for the OAuth2 token
$username = 'admin'
$password = 'nx2Tech001!'

# Get the OAuth2 token
$tokenResponse = Invoke-RestMethod -Uri 'https://any_cvm_ip:9440/api/oauth2/token' -Method POST -Body @{
    'grant_type'='password'
    'username'=$username
    'password'=$password
}

# Extract the token from the response
$token = $tokenResponse.access_token

# Specify the UUID of the source volume group
$uuid = '12345678-1234-1234-1234-123456789abc'

# Specify the data for the request body
$data = @{
    'created_by' = 'John Doe'
    'enabled_authentications' = @(
        @{
            'auth_type' = 'NONE'
        }
    )
    'iscsi_target' = 'iqn.2000-01.com.example:volume.group.target'
    'iscsi_target_prefix' = 'iqn.2000-01.com.example'
    'load_balance_vm_attachments' = $true
    'logical_timestamp' = (Get-Date).Ticks
    'name' = 'Cloned Volume Group'
    'source_volume_group_uuid' = $uuid
    'uuid' = [Guid]::NewGuid().ToString()
}

# Convert the data to JSON
$json = $data | ConvertTo-Json

# Define the URI for the clone endpoint
$uri = "$baseUri/volume_groups/$uuid/clone"

# Send the POST request with the OAuth2 token
$response = Invoke-RestMethod -Uri $uri -Method POST -Body $json -ContentType 'application/json' -Headers @{
    'Authorization' = "Bearer $token"
}

# Print the task_uuid from the response
Write-Output "Task UUID: $($response.task_uuid)"
