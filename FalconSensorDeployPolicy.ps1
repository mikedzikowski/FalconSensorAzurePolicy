<#
.SYNOPSIS
Downloads and install the CrowdStrike Falcon Sensor for Windows using Azure Policy, Machine Configuration and PowerShell DSC.
.DESCRIPTION
Using Azure Policy, Machine Configuration and PowerShell DSC to deploy the Falcon Sensor at Scale for windows endpoints. 

.PARAMETER FalconInstallScriptUri
The URI of the falcon installation script
.PARAMETER FalconScriptPath
The location of the script
.PARAMETER CustomerId
The FalconClientId, this aligns to the CrowdStrike Falcon OAuth2 API Client Id
.PARAMETER CustomerAuthentication
The FalconClientSecret, this aligns to the CrowdStrike Falcon OAuth2 API Client Secret
#>

Configuration FalconSensorDeployPolicy
{
    param
    (
        [String]
        [parameter(Mandatory = $false)]
        $FalconInstallScriptUri = "https://raw.githubusercontent.com/CrowdStrike/falcon-scripts/main/powershell/install/falcon_windows_install.ps1",
        [String]
        [parameter(Mandatory = $false)]
        $FalconScriptPath = "C:\Windows\temp\falcon_windows_install.ps1",
        [String]
        [parameter(Mandatory = $true)]
        $CustomerId,
        [String]
        [parameter(Mandatory = $true)]
        $CustomerAuthentication
    )

    $customerEnvironment = @(
        @{
            "cid"    = $CustomerId
            "secret" = $CustomerAuthentication
        }
    );

    Import-DscResource -ModuleName PSDscResources

    Node localhost {

        Script "FalconInstallerScript" {
            SetScript  = { Invoke-WebRequest $using:FalconInstallScriptUri -OutFile $using:FalconScriptPath }
            TestScript = { Test-Path $using:FalconScriptPath }
            GetScript  = { @{ Result = (Get-ChildItem -Path $using:FalconScriptPath) } }
        }
        Script "FalconSensorInstall" {
            SetScript  = {
                $cid = $using:customerEnvironment.cid;
                $secret = $using:customerEnvironment.secret;
                Start-Process -FilePath PowerShell.exe -ArgumentList @($using:FalconScriptPath, "-FalconClientId $using:cid", "-FalconClientSecret $using:secret") -NoNewWindow -Wait -PassThru
            }
            TestScript = {
                if (Get-CimInstance -Class Win32_Product | Where-Object { $_.name -like "CrowdStrike Sensor*" }) {
                    Write-Verbose "Falcon Sensor is Installed"
                    $true
                }
                else {
                    Write-Verbose "Falcon Sensor is not Installed"
                    $false
                }
            }
            GetScript  = { @{ Result = (Test-Path -Path 'HKLM:\SOFTWARE\CrowdStrike') } }
            DependsOn  = "[Script]FalconInstallerScript"
        }
        Service "CSFalconService" {
            Name      = "CSFalconService"
            Ensure    = 'Present'
            State     = "Running"
            DependsOn = "[Script]FalconSensorInstall"
        }
    }
}
FalconSensorDeployPolicy