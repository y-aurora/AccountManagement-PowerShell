 
Param( 
    [Parameter(Mandatory=$True)] 
    [String]$InputFile,

    [Parameter(Mandatory=$True)] 
    [String]$AccountName
) 

$Computers = Import-Csv -Path .\Computers.csv
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
foreach ($Computer in $Computers) {
    $HostName = $Computer.HostName

    try {
        $ctype = [System.DirectoryServices.AccountManagement.ContextType]::Machine
        $context = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList $ctype, $HostName
        $idtype = [System.DirectoryServices.AccountManagement.IdentityType]::SamAccountName
        $group = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($context, $idtype, 'Administrators')
        $user = $group.Members |select * | ? {($_.Name -eq $AccountName) -and ($_.ContextType -eq "Machine")}
        
        if ($user -ne $null){
            Write-Host "Acount Exists in Admin group on $HostName" -ForegroundColor Green
            Add-Content .\Account_Exists.log -Value "Account exists in Admin group on $HostName"
            if ($user.PasswordNeverExpires -eq $true) {
                Write-Host "Password Never Expire on $HostName" -ForegroundColor Green
                Add-Content .\Password_NeverExpire.log -Value "Account Password Never Expire on $HostName"
            }else {
                Write-Host "Password Expires on $HostName" -ForegroundColor Red
                Add-Content .\Password_Expires.log -Value "Account Password Expires on $HostName"
            }
        }else{
            Write-Host "Acount not exists in Admin group on $HostName" -ForegroundColor Red
            Add-Content .\Account_NotExists.log -Value "Acount not exists in Admin group on $HostName"
        }
        } catch {
            Write-Host "Connection to $HostName failed" -ForegroundColor Red
            Add-Content .\Connection_Failed.log -Value "Connection to $HostName failed, detailed failure reason is: $_.Exception.Message"
        }
}


