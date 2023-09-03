<#
.SYNOPSIS
    PowerShell script designed to automate the installation of multiple software packages on a Windows machine.
.DESCRIPTION
    The script leverages the popular package manager Chocolatey, as well as direct download links where necessary, to streamline the setup process. This script is particularly useful for setting up new machines, or in environments where multiple machines need to have the same set of applications installed. 
.NOTES
    File Name      : custominstaller.ps1
    Author         : Cam Wilson
    Date           : 09/02/2023
    Last Modified  : 09/02/2023
    Version        : 1.0.1-beta
#>

#Creates "custom_installers" folder in root directory (e.g. C:\custom_installers)
$installerdir = "$env:SystemDrive\custom_installers"

If (Test-Path -Path $installerdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $installerdir -ItemType directory }

#Downloads and Runs PowerShell script to install Chocolatey Package Manager
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

#Loads softwareinstallers.csv file. This lists software name, type of installation, and link. 
$Softwares = Import-Csv -Path ./softwareinstallers.csv 

if ($Softwares) {
    Write-Host "CSV file loaded successfully."
} else {
    Write-Host "Failed to load CSV file."
}

#Iterates through csv, either installing via chocolatey or downloading installer for manual download. 
foreach ($Software in $Softwares) {  
	
	IF ($Software.Installer -eq 'chocolatey') {
		Write-Host "Installing: $($Software.Name)"
		Write-Host $($Software.Link) will be chocolate installed.
		choco install $Software.Name -y
		
	} ELSEIF ($Software.Installer -eq 'download') {
		$Link = $Software.Link
		$FileName = $Link.split("/")[-1]
		$Outfile = "$($installerdir)\$($FileName)"
		
		#Checks if file exists
		If (Test-Path $Outfile) {
			Write-Host "Installer already exists: $FileName"
		} ELSE {
			Invoke-WebRequest $Software.Link -OutFile $Outfile
			If (Test-Path $Outfile) {
			Write-Host "$($FileName) successfully downloaded for manual install."
				}
			}
		}
	} 

#Sets new programs to system PATH.
$env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox" #For VBoxManage commands
$env:PATH = $env:PATH + ";C:\Program Files\Git\bin" #For Git