TempDrive
--
### A self cleaning tempdrive for all your not so important files.

### What is it?
TempDrive will create a drive mapped to a folder somewhere on your harddrive.
It will remove all files which exceed a certain retention period on a daily basis. Empty folders are removed as well.

### Why do I need it?
If you download temporary files, documents and apps on a regular basis.
And you don't like having old irrelevant files cluttering your desktop or download folder. 

Then this is for you.

It enables you to just download files to lets say the T: drive, do what you need to do and then forget about it. 
A specified period later, let's say two weeks, the files will be deleted from the tempdrive automatically.

Navigating to this temp-drive is as simple as ```t:\```

### How do i set it up?

Pull the repo or download as a zipfile.
Open Windows Powershell and paste the following command.


```PowerShell
.\InstallTempDrive.ps1 -tempFolder c:\Temp\TempDrive -driveLetter 'T' -retention ([TimeSpan]::FromDays(14))  
````

## Make sure Tempdrive is visible for root and non-root users


Read the article describing in [PowershellMagazine](http://www.powershellmagazine.com/2015/04/08/user-account-control-and-admin-approval-mode-the-impact-on-powershell/):



> The preferred workaround is to Enable Linked Connections registry setting. When this setting is enabled, drive mappings are mirrored between the filtered access token and full control token. Because the drive mappings are being mirrored, the drives that are mapped in a non-elevated console will be visible in an elevated console and vice-versa. A restart is usually required to make this registry setting active.

The fix described in this article can be applied using the .reg file [here](https://github.com/sietsevdschoot/CreateTempDrive/blob/master/tools/EnableLinkedConnections.reg).

```PowerShell
.\tools\EnableLinkedConnections.reg
````



