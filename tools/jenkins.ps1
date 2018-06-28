# Launch the tests suit on Windows.

# Stop the execution on the first error
$ErrorActionPreference = "Stop"

# Imports
Import-Module BitsTransfer

function check_vars {
	# Check required variables
	if (-Not ($Env:PYTHON_DRIVE_VERSION)) {
		Write-Output ">>> PYTHON_DRIVE_VERSION not defined. Aborting."
		ExitWithCode 1
	} elseif (-Not ($Env:WORKSPACE)) {
		Write-Output ">>> WORKSPACE not defined. Aborting."
		ExitWithCode 1
	}
	if (-Not ($Env:WORKSPACE_DRIVE)) {
		if (Test-Path "$($Env:WORKSPACE)\sources") {
			$Env:WORKSPACE_DRIVE = "$($Env:WORKSPACE)\sources"
		} elseif (Test-Path "$($Env:WORKSPACE)\watchdog3") {
			$Env:WORKSPACE_DRIVE = "$($Env:WORKSPACE)\watchdog3"
		} else {
			$Env:WORKSPACE_DRIVE = $Env:WORKSPACE
		}
	}
	if (-Not ($Env:PYTHON_DIR)) {
		$Env:PYTHON_DIR = 'C:\Python37-32'
	}

	$Env:STORAGE_DIR = (New-Item -ItemType Directory -Force -Path "$($Env:WORKSPACE)\deploy-dir").FullName

	Write-Output "    PYTHON_DRIVE_VERSION = $Env:PYTHON_DRIVE_VERSION"
	Write-Output "    PYTHON_DIR           = $Env:PYTHON_DIR"
	Write-Output "    WORKSPACE            = $Env:WORKSPACE"
	Write-Output "    WORKSPACE_DRIVE      = $Env:WORKSPACE_DRIVE"
	Write-Output "    STORAGE_DIR          = $Env:STORAGE_DIR"

	Set-Location "$Env:WORKSPACE_DRIVE"
}

function ExitWithCode($retCode) {
	$host.SetShouldExit($retCode)
	exit
}

function install_python {
	if (-Not (Test-Path "$Env:STORAGE_DIR\Scripts\activate.bat")) {
		Write-Output ">>> Setting-up the Python virtual environment"

		& $Env:PYTHON_DIR\python.exe -m pip install virtualenv
		if ($lastExitCode -ne 0) {
			ExitWithCode $lastExitCode
		}

		# Fix a bloody issue with our slaves ... !
		New-Item -Path $Env:STORAGE_DIR -Name Scripts -ItemType directory
		Copy-Item $Env:PYTHON_DIR\vcruntime140.dll $Env:STORAGE_DIR\Scripts

		& $Env:PYTHON_DIR\python.exe -m virtualenv --always-copy "$Env:STORAGE_DIR"
		if ($lastExitCode -ne 0) {
			ExitWithCode $lastExitCode
		}
	}

	& $Env:STORAGE_DIR\Scripts\activate.bat
	if ($lastExitCode -ne 0) {
		ExitWithCode $lastExitCode
	}
}

function launch_tests {
	# Launch the tests suite
	& $Env:STORAGE_DIR\Scripts\python.exe -b -Wall setup.py test
	if ($lastExitCode -ne 0) {
		ExitWithCode $lastExitCode
	}
}

function main {
	# Launch operations
	check_vars
	install_python
	launch_tests
}

main
