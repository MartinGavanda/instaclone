<#
    .NOTES
    ===========================================================================
     Created by:    Martin Gavanda
     Date:          Apr 29, 2018
     WWW:           www.learnvmware.online
    ===========================================================================
    .SYNOPSIS
        Sample script to cleanup environment from previous Insta Clone VMs
    .DESCRIPTION
        Destroy 20 new Inte Clone VMs deployed by deploy-clone.ps1
#>

Connect-VIServer -server 172.16.1.100 -user "administrator@vsphere.local" -password "MyPassword"
foreach ($i in 1..20){

$newVM="InstaClone"+$i


### DO NOT EDIT BEYOND HERE ###

Get-VM -name "$newVM" | Stop-VM -Confirm:$false
}

foreach ($i in 1..20){

$newVM="InstaClone"+$i
Remove-VM $newVM -DeleteFromDisk -Confirm:$false
}
Disconnect-VIServer -Confirm:$false
