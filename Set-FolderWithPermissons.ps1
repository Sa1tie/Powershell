<#
.SYNOPSIS
   Creates a folder called "PSTest" at the root of C: and sets NTFS permissions to Everyone with Full Control.

.EXAMPLE
   Set-FolderPermissions -FolderPath "C:\PSTest"
   # Creates a folder called "PSTest" at the root of C: and sets NTFS permissions to Everyone with Full Control. It provides a summary of the changes made and requires the user to press Enter to exit.
 

.INPUTS
   [string] FolderPath

.OUTPUTS
   None

#>
function Set-FolderPermissions {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath
    )

    # Create the folder if it doesn't exist
    if (-not (Test-Path -Path $FolderPath)) {
        New-Item -Path $FolderPath -ItemType Directory | Out-Null
}

    # Set NTFS permissions to Everyone with Full Control
    $acl = Get-Acl -Path $FolderPath
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Everyone", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
    $acl.SetAccessRule($rule)
    Set-Acl -Path $FolderPath -AclObject $acl

    # Display a summary of the changes made
    Write-Host "Folder PSTest was created and NTFS Permission set."
}

# Usage example
Set-FolderPermissions -FolderPath "C:\PSTest"