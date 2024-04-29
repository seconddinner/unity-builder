#
# Validate VM environment to catch fails early
#

# Check env variables are set
if(!$Env:CcdApiKey){
  Write-Host "ERROR: CcdApiKey is not set, Addressables content will fail build"
  exit 1
}

# Check storage and RAM are enough for build
$drive = Get-PSDrive -Name C -PSProvider FileSystem
$freeSpaceGB = [math]::Round(($drive.Free / 1GB), 2)
Write-Host "Drive C: $freeSpaceGB GB free"
if($freeSpaceGB -lt 100)
{
  Write-Host "ERROR: insufficient free storage on C: for build, only $freeSpaceGB GB free, need at least 100GB"
  exit 1
}

$memory = Get-CimInstance -ClassName CIM_ComputerSystem
# Convert memory size to GB and round to two decimal places
$totalMemoryGB = [Math]::Round(($memory.TotalPhysicalMemory / 1GB), 2)
# Output total memory
Write-Host "Total Physical Memory: $totalMemoryGB GB"
if($totalMemoryGB -lt 64){
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





