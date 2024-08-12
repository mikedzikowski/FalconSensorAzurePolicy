$PolicyConfig      = @{
    PolicyId      = New-Guid
    ContentUri    = $contentUri
    DisplayName   = 'CrowdStrike Falcon Sensor Deployment'
    Description   = 'CrowdStrike Falcon Sensor Deployment'
    Path          = './CrowdStrikeFalconSensorDeployment.json'
    Platform      = 'Windows'
    PolicyVersion = '1.0.0'
    Mode          = 'ApplyAndAutoCorrect'
  }

  New-GuestConfigurationPolicy @PolicyConfig -Verbose