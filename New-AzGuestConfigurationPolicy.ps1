$PolicyConfig      = @{
    PolicyId      = New-Guid
    ContentUri    = $contentUri
    DisplayName   = 'CrowdStrike Falcon Sensor Service Audit'
    Description   = 'CrowdStrike Falcon Sensor Service Audit'
    Path          = './CrowdStrikeFalconSensorAudit.json'
    Platform      = 'Windows'
    PolicyVersion = '1.0.0'
    Mode          = 'Audit'
  }

  New-GuestConfigurationPolicy @PolicyConfig -Verbose