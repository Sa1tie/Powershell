# Define SSD drive letter 
$ssd = "D:"

# Define folder paths
$folder1 = "$ssd\Folder1"
$folder2 = "$ssd\Folder2"

# Check if Folder1 and Folder2 need updates
If ((Get-Item $folder1).LastWriteTime -lt (Get-Date).AddDays(-7)) {
  $updateFolder1 = $true
}
If ((Get-Item $folder2).LastWriteTime -lt (Get-Date).AddDays(-7)) {
  $updateFolder2 = $true 
}

# Download latest install packages
If ($updateFolder1) {
  Invoke-WebRequest -Uri "http://update.com/folder1.zip" -OutFile "$env:Temp\folder1.zip"
}
If ($updateFolder2) {
  Invoke-WebRequest -Uri "http://update.com/folder2.zip" -OutFile "$env:Temp\folder2.zip"
}

# Install updates
If ($updateFolder1) {
  Remove-Item $folder1 -Recurse -Force
  Expand-Archive "$env:Temp\folder1.zip" -DestinationPath $folder1
}
If ($updateFolder2) {
  Remove-Item $folder2 -Recurse -Force 
  Expand-Archive "$env:Temp\folder2.zip" -DestinationPath $folder2  
}

# Verify installs
If ($updateFolder1) {
  Write-Output "Folder1 updated successfully"
}
If ($updateFolder2) {
  Write-Output "Folder2 updated successfully" 
}

# Delete temp files
Remove-Item "$env:Temp\folder1.zip"
Remove-Item "$env:Temp\folder2.zip"