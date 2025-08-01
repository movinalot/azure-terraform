<#
    .DESCRIPTION
        Manage Entra ID TAPs (Temporary Access Passes) for users in Microsoft Entra ID.

    .NOTES
        AUTHOR: jmcdonough@fortinet.com
        LAST EDIT: July 24, 2025
    .SYNOPSIS
        Get-AzTap.ps1 - A PowerShell script to manage Temporary Access Passes in Microsoft Entra ID.
#>

param(
    [CmdletBinding()]

    [Parameter(Mandatory = $true)]
    [string] $UsernamePrefix,

    [Parameter(Mandatory = $true)]
    [int] $NumberOfAccounts,

    [Parameter(Mandatory = $true)]
    [int] $StartingUserNumber,

    [Parameter(Mandatory = $true)]
    [string] $UserPrincipalDomain,

    [Parameter(Mandatory = $false)]
    [datetime] $StartDateTime = (Get-Date),
    
    [Parameter(Mandatory = $false)]
    [int] $DurationDays = 3
)


$clientCredentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $env:ARM_CLIENT_ID, $(ConvertTo-SecureString -String $env:ARM_CLIENT_SECRET -AsPlainText -Force)

Connect-MgGraph -TenantId $env:ARM_TENANT_ID -ClientSecretCredential $clientCredentials -NoWelcome

($StartingUserNumber)..($StartingUserNumber + $NumberOfAccounts - 1) | ForEach-Object { Write-Host "$UsernamePrefix$_@$UserPrincipalDomain," (New-MgUserAuthenticationTemporaryAccessPassMethod -UserId $UsernamePrefix$_@$UserPrincipalDomain  -LifetimeInMinutes ($DurationDays * 1440) -StartDateTime $StartDateTime).TemporaryAccessPass }

Disconnect-MgGraph > $null