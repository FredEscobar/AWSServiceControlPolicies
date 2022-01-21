$PolicyContent = Get-Content "$PSScriptRoot/Policies/EC2Instances.json" -Raw

$PolicyName = 'SCPolicyFromAWSPowerShellTools'

#Check if policy already exists
$NewPolicy = Get-ORGPolicyList -Filter SERVICE_CONTROL_POLICY | Where-Object Name -eq $PolicyName | Select-Object -First 1

if($null -eq $NewPolicy){

    Write-Output "Creating SC policy"
    $NewPolicy = New-ORGPolicy -Name "SCPolicyFromAWSPowerShellTools" `
                    -Content $PolicyContent `
                    -Description "A SC policy content created from the AWS Powershell Tools command New-ORGPolicy" `
                    -Type SERVICE_CONTROL_POLICY
}

Write-Output "Querying organization root"
$RootResponse = Get-ORGRoot

$RootId = if($RootResponse.GetType().FullName -eq 'Amazon.Organizations.Model.Root'){
    $RootResponse.Id
} else {
    $RootResponse.Roots[0].Id
}

Write-Output "Adding policy to root"
Add-ORGPolicy -PolicyId $NewPolicy.Id -TargetId $RootId