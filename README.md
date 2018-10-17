TempDrive
--
### A self cleaning tempdrive for all your not so important files.

### What is it?
TempDrive creates a drive mapped to a folder somewhere on your harddrive.
It will remove all files which exceed a retention period. Empty folders are cleaned up as well.

### Why do I need it in my life?
If you are like me and you download temporary files, documents, apps on a regular basis.
And you hate having old irrelevant files cluttering your desktop or download folder. 

Then this is for you.

It enables you to just download files to lets say the T: drive, do what you have to do and then forget about it. 
Then two weeks or a month later the files will be deleted from the tempdrive.

### How do i set it up?

Pull the repo or download as a zipfile.
Open Windows Powershell and paste the following command.


```PowerShell
.\InstallTempDrive.ps1 -tempFolder c:\Temp\TempDrive -driveLetter 'T' -retention ([TimeSpan]::FromDays(14))  
````