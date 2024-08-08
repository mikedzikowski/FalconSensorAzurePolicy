Configuration FalconSensorAuditPolicy
{
    Import-DscResource -ModuleName PSDscResources

    Node localhost {
        Service "CSFalconService"
        {
            Name = "CSFalconService"
            Ensure = 'Present'
            State = "Running"
        }
    }
}

FalconSensorAuditPolicy