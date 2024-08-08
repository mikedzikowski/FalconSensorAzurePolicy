
$params = @{
    Name          = 'FalconSensorAuditPolicy'
    Configuration = './FalconSensorAuditPolicy.mof'
    Type          = 'Audit'
    Force         = $true
}
New-GuestConfigurationPackage @params
