#
# Validate VM environment to catch fails early
#

# Check env variables are set
$ccd_key = [Environment]::GetEnvironmentVariable("CcdApiKey", "Machine")
if($ccd_key -eq $null -or $ccd_key -eq ""){
  Write-Host "ERROR: CcdApiKey is not set, Addressables content will fail build"
  $ccd_key = [Environment]::GetEnvironmentVariable("CCD_API_KEY", "Machine")
  if($ccd_key -neq $null -and $ccd_key -neq "")){
    Write-Host "Found env:CCD_API_KEY"
  }
  exit 1
}

$memory = Get-CimInstance -ClassName CIM_ComputerSystem
# Convert memory size to GB and round to two decimal places
$totalMemoryGB = [Math]::Round(($memory.TotalPhysicalMemory / 1GB), 2)
# Output total memory
Write-Host "Total Physical Memory: $totalMemoryGB GB"
if($totalMemoryGB -lt 50){
  Write-Host "ERROR: build started on runner with insufficient RAM, need at least 64GB"
  exit 1
}

# Check cpu count
$CPUCount = (Get-WmiObject -Class Win32_ComputerSystem).NumberOfLogicalProcessors
Write-Host "Number of vCPUs: $CPUCount"
if($CPUCount -gt 8){
  Write-Host "ERROR: build started on runner with >8 vCPUs, docker container is likely to fail"
  exit 1
}





