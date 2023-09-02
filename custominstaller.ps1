$installdir = "C:\installer"

If (Test-Path -Path $installdir -PathType Container)
{ Write-Host "$workdir already exists" -ForegroundColor Red}
ELSE
{ New-Item -Path $installdir -ItemType directory }

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$Downloads = Import-Csv -Path ./downloadfiles.csv 

if ($Downloads) {
    Write-Host "CSV file loaded successfully."
} else {
    Write-Host "Failed to load CSV file."
}

$programs = @(
		@{'Name' = 'googlechrome'; 'installer' = 'chocolatey'},
		@{'Name' = 'notepadplusplus'; 'installer' = 'chocolatey'},
		@{'Name' = 'python3'; 'installer' = 'chocolatey'},
		@{'Name' = 'firefox'; 'installer' = 'chocolatey'},
		@{'Name' = 'vscode'; 'installer' = 'chocolatey'},
		@{'Name' = 'git'; 'installer' = 'chocolatey'}
		@{'Name' = 'virtualbox'; 'installer' = 'chocolatey'}
		@{'Name' = 'cpu-z'; 'installer' = 'chocolatey'}
		@{'Name' = 'r'; 'installer' = 'chocolatey'}
		@{'Name' = 'rtools'; 'installer' = 'chocolatey'}
		@{'Name' = 'r.studio'; 'installer' = 'chocolatey'}
		@{'Name' = 'sqlitebrowser'; 'installer' = 'chocolatey'}
		@{'Name' = 'discord'; 'installer' = 'chocolatey'}
)
foreach ($program in $programs) {  

	Write-Host "Installing: $($program['Name'])" 
	
	IF ($program['installer'] -eq 'chocolatey') {
		
		# This will be chocolate installed
		choco install $($program['Name']) -y
		
	} ELSEIF ($program['installer'] -eq 'download') {
		#
		foreach ($Download in $Downloads) {
			if ($program['Name'] -eq $Download.Name) {
			$Outfile = ("{0}\{1}.{2}" -f $installdir, $Download.Name, $Download.FileType)
			Invoke-WebRequest $Download.Link -OutFile $Outfile
			Write-Host $Outfile
			}
		}
	}
	
} 

$env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox" #For VBoxManage commands
$env:PATH = $env:PATH + ";C:\Program Files\Git\bin" #For Git