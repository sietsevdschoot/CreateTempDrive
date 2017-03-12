# Install TempDrive 

Creates a drive mapped to a folder.
All files which exceed the retention period are removed, daily at 11am.
Empty folders are removed as well.
 
	
## Installation

Either execute with the default settings, or modify statement

```PowerShell
.\InstallTempDrive.ps1 -tempFolder c:\Temp\TempDrive -driveLetter 'T' -retention ([TimeSpan]::FromDays(14))  
````
