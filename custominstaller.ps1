$workdir = "C:\installer"

If (Test-Path -Path $workdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $workdir -ItemType directory }

cd $workdir

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$Downloads = Import-Csv -Path C:\Users\grimm\Documents\onlinesoftware.csv

if ($Downloads) {
    Write-Host "CSV file loaded successfully."
} else {
    Write-Host "Failed to load CSV file."
}

$programs = @(
		@{'Name' = 'googlechrome'; 'installer' = 'chocolatey'; 'Taskbar' = 'Yes'},
		@{'Name' = 'notepadplusplus'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'},
		@{'Name' = 'python3'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'},
		@{'Name' = 'firefox'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'},
		@{'Name' = 'vscode'; 'installer' = 'chocolatey'; 'Taskbar' = 'Yes'},
		@{'Name' = 'git'; 'installer' = 'chocolatey'; 'Taskbar' = 'Yes'}
		@{'Name' = 'virtualbox'; 'installer' = 'chocolatey'; 'Taskbar' = 'Yes'}
		@{'Name' = 'cpu-z'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'}
		@{'Name' = 'r'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'}
		@{'Name' = 'rtools'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'}
		@{'Name' = 'r.studio'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'}
		@{'Name' = 'sqlitebrowser'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'}
		@{'Name' = 'discord'; 'installer' = 'chocolatey'; 'Taskbar' = 'No'}
)
foreach ($program in $programs) {  

	Write-Host "Installing: $($program['Name'])" 
	
	IF ($program['installer'] -eq 'chocolatey') {
		#Write-Host "This will be chocolate installed"
		#choco install $($program['Name']) -y
	} ELSEIF ($program['installer'] -eq 'download') {
		foreach ($Download in $Downloads) {
			if ($program['Name'] -eq $Download.Name) {
			$Outfile = ("{0}\{1}.{2}" -f $workdir, $Download.Name, $Download.FileType)
			Invoke-WebRequest $Download.Link -OutFile $Outfile
			Write-Host "$($Download.Name), $($Download.Link), $($Download.FileType)"
			Write-Host $Outfile
			}
		}
	}
	
	IF ($program['Taskbar'] -eq 'Yes') {
		#Write-Host "This will have a taskbar"
	} ELSEIF ($program['Taskbar'] -eq 'No') {
		#Write-Host  "This will not have a taskbar"
	} 
	
} 

SET PATH=%PATH%;C:\Program Files\Oracle\VirtualBox