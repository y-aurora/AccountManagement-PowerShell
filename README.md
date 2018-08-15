# AccountManagement-PowerShell
This is the script example working with System.DirectoryServices.AccountManagement in PowerShell


System.DirectoryServices.AccountManagement provides uniform access and manipulation of user, computer, and group security principals across the multiple principal stores: Active Directory Domain Services (AD DS), active Directory Lightweight Directory Services (AD LDS), and Machine SAM (MSAM). 

In 1.Get-LocalAdminUserInfo.ps1 we domonstrated how to verify if a particular local user account is a member of administrators group of a list of remote servers.

Usage: .\Get-LocalAdminUserInfo.ps1 -InputFile .\Computers.csv -AccountName someuser
Remeber to run the script with an administrative account which should have admin access to remote servers.