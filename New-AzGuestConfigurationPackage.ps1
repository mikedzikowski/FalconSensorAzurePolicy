
$params = @{
    Name          = 'FalconSensorDeployPolicy'
    Configuration = './FalconSensorDeployPolicy.mof'
    Type          = 'AuditAndSet'
    Force         = $true
}
New-GuestConfigurationPackage @params
