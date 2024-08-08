$connectionString = 'wGHm3h+5dZFX1rg9kIR5/iokxwM2qNv8TyNAND6pk89Emc1Ci1SA/IXZUA6qt1uJIQKrv5WWeJj1+ASt8UqyRw=='
$context = New-AzStorageContext -ConnectionString $connectionString
$getParams = @{
    Context   = $context
    Container = 'files'
    Blob      = 'FalconSensorAuditPolicy.zip'
}
$blob = Get-AzStorageBlob @getParams
$contentUri = $blob.ICloudBlob.Uri.AbsoluteUri