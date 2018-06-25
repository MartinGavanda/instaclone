<#
    .NOTES
    ===========================================================================
     Created by:    Martin Gavanda
     Date:          Apr 29, 2018
     WWW:           www.learnvmware.online
    ===========================================================================
    .SYNOPSIS
        Sample script to utilize Insta Clone feature of VMware vSphere
    .DESCRIPTION
        Deploys 20 new Inte Clone VMs from master VM with some basics customization
=    .NOTES
        Make sure that you have both a vSphere 6.7 env (VC/ESXi) as well as
        as the latest PowerCLI 10.1 installed which is reuqired to use vSphere 6.7 APIs
#>

import-module ./new-instantclone.psm1

Connect-VIServer -server 172.16.1.100 -user "administrator@vsphere.local" -password "MyPassword"
$sourceVM="SourceCentOS"

$StartTime = Get-Date
Write-Host -ForegroundColor Cyan "Starting Instant Clone setup"

foreach ($i in 1..20){

$newVM="InstaClone"+$i
$octet=$i+100

$ip="10.20.10."+$octet

 $guestCustomizationValues = @{
        "guestinfo.ic.hostname" = $newVM
        "guestinfo.ic.ipaddress" = "$ip"
    }

New-InstantClone -SourceVM $SourceVM -DestinationVM $newVM -CustomizationFields $guestCustomizationValues
}

$EndTime = Get-Date
$duration = [math]::Round((New-TimeSpan -Start $StartTime -End $EndTime).TotalMinutes,2)
Write-Host -ForegroundColor Cyan  "`nStartTime: $StartTime"
Write-Host -ForegroundColor Cyan  "  EndTime: $EndTime"
Write-Host -ForegroundColor Green " Duration: $duration minutes"

Disconnect-VIServer -Confirm:$false
