# FalconSensorAzurePolicy 

Audit or deploy the CrowdStrike Falcon Sensor to windows endpoints using Azure Policy, PowerShell DSC and Azure Machine Configuration.

> [!IMPORTANT]
> Before running the following steps, please ensure that the guidance has been ollowed for the install/uninstall of the Falcon Sensor through the Falcon APIs on a windows >endpoint. [Falcon Powershell Installation Scripts](https://github.com/CrowdStrike/falcon-scripts/tree/main/powershell/install)

1.Install the machine configuration DSC resource module from PowerShell Gallery. Reference - [Setup up local machine for authoring](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/how-to-set-up-authoring-environment)

```powershell
Install-Module -Name GuestConfiguration
```

2.**Using PowerShell 5.1**, author the DSC coniguration. Reference - [Author a configuration](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/how-to-create-package#author-a-configuration)

```powershell
. .\FalconSensorDeployPolicy.ps1
Rename-Item -Path .\localhost.mof -NewName FalconSensorDeployPolicy.mof -PassThru
```

3.**Using PowerShell 7.3** - create a package that will audit and apply the configuration (Set).

Example

```powershell
# Create a package that will audit and apply the configuration (Set).
$params = @{
    Name          = 'FalconSensorDeployPolicy'
    Configuration = './FalconSensorDeployPolicy.mof'
    Type          = 'AuditAndSet'
    Force         = $true
}
New-GuestConfigurationPackage @params

```

4.Use Set-BlobContext to store the context of your storage account. Reference - [Publish a configuration package](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/how-to-publish-package#publish-a-configuration-package)

5.To test the package run the following:

```powershell
# Get the current compliance results for the local machine
Get-GuestConfigurationPackageComplianceStatus -Path ./FalconSensorDeployPolicy.zip

# Test applying the configuration to local machine
Start-GuestConfigurationPackageRemediation -Path ./FalconSensorDeployPolicy.zip
```

6.To create the policy definition run the following lines of code

```powershell
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
```

7.To import the policy into your Azure environment

```powershell
New-AzPolicyDefinition -Name 'CrowdStrike Falcon Sensor Deployment' -Policy '.\FalconSensorDeployPolicy_DeployIfNotExists.json'
```
