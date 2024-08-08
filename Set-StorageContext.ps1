$startTime = Get-Date
$endTime   = $startTime.AddYears(3)

$tokenParams = @{
    StartTime  = $startTime
    ExpiryTime = $endTime
    Container  = 'files'
    Blob       = 'FalconSensorAuditPolicy.zip'
    Permission = 'r'
    Context    = $context
    FullUri    = $true
}
$contentUri = New-AzStorageBlobSASToken @tokenParams