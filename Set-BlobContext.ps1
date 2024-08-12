$connectionString = <_ YOUR CONNECTION STRING _>
$context = New-AzStorageContext -ConnectionString $connectionString
$getParams = @{
    Context   = $context
    Container = <_ YOUR CONTAINER _>
    File      = './FalconSensorDeployPolicy.zip'
}
$blob = Set-AzStorageBlobContent @getParams
$contentUri = $blob.ICloudBlob.Uri.AbsoluteUri