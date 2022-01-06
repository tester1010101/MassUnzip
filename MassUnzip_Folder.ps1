############################
# ~ FolderUnzipper v1.2 ~  # 
#  ~~~~~~~~~~~~~~~~~~~~~~  #
#  Made by: tester1010101  # 
# ._.       ~.~        ._. #
#                          #
#  Step 1: Specify .zip    #
#  folder (add .zips in).  #
#                          #
#  Step 2*: If the files   #
#  are OK, type YES when   #
#  asked & wait as it      #
#  extracts them to same   #
#  directory specified in  #
#  Step 1. *Can't specify  #
#  DestinationPath, will   #
#  use specified one and   #
#  extract in it. (cd)     #
#  Feature may be added    #
#  in a future update.     #
#                          #
#  Note: if a Remove-Item  #
#  error pops-up, path     #
#  specified is too long,  #
#  PowerShell won't be     #
#  able to extract files.  #
#  Try again with a short  #
#  path like D:\TestUnzip. #
#                          #
# github.com/tester1010101 #
############################

#########################################################################
# Read users' folder containing .zips >>
Write-Host -ForegroundColor Green "Step 1: Set-Location for the .zip work directory `ne.g.: D:\UnzipFolder"
$FolderPath = Read-Host
sl $FolderPath
mkdir $ENV:USERPROFILE\0xFF\MassUnzip\ -ErrorAction SilentlyContinue 

#########################################################################
# Determine if .zips are presents, adds them to a file/variable >>
dir *.zip | Format-Table -Property Name | Out-File $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzip.txt
Get-Content $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzip.txt | Where-Object {$_ -match ".zip"} | Set-Content $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzipClean.txt
$Files = Get-Content $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzipClean.txt

#########################################################################
# Clean the files created & delete them >>
Write-Host "Clean files created? [Y/N]" -ForegroundColor Red -BackgroundColor Yellow
$CleanAnswer = Read-Host
if ($CleanAnswer -match "Y")
{
    Set-Content $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzip.txt $null
    Remove-Item $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzip.txt
    Set-Content $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzipClean.txt $null
    Remove-Item $env:USERPROFILE\0xFF\MassUnzip\FilesToUnzipClean.txt
    Write-Host "Files deleted. Proceeding..." -ForegroundColor Red -BackgroundColor Yellow
} 
elseif ($CleanAnswer -match "N")
{
    Write-Host "Files NOT deleted. Open folder?" -ForegroundColor Red -BackgroundColor Yellow
    $FilesAnswer = Read-Host
    if ($FilesAnswer -match "Y")
    {
        Write-Host "Proceeding to extraction..." -ForegroundColor Red -BackgroundColor Yellow
        explorer $env:USERPROFILE\0xFF\MassUnzip\

    }
    elseif ($FilesAnswer -match "N")
    {
        Write-Host "Files NOT deleted. Files will stay in: $env:USERPROFILE\0xFF\MassUnzip\" -ForegroundColor Red -BackgroundColor Yellow
        Write-Host "Proceeding to extraction..." -ForegroundColor Red -BackgroundColor Yellow
    }
    else
    {
        Write-Host "Wrong Selection: Restart the script" -ForegroundColor Red -BackgroundColor Yellow
        pause
        exit
    }
}
else 
{
    Write-Host "Wrong Selection: Restart the script." -ForegroundColor Red -BackgroundColor Yellow
    pause
    exit
}


#########################################################################
# Enumerate files to be unzipped >>
Write-Host -ForegroundColor Cyan 'Files to be unzipped:'
foreach ($item in $Files)
{
    Write-Host -ForegroundColor Green $item
}

#########################################################################
# Step 2: Ask user: start the unzip process or review the .zips folder >>
Write-Host -ForegroundColor Red "Original folders won't be overwritten unless folders already exists with the same names in the directory: $FolderPath."
Write-Host -ForegroundColor Cyan "Best method is to create a fresh folder on the Desktop & move files to extract there; e.g. > C:\Users\Username\Desktop\ZipFolder"
Write-Host -ForegroundColor Yellow "Step 2: Continue with the specified files? Adjust the .zip folder if needed. `nCurrent directory: {$FolderPath} `nEnter YES or NO."
$YesNo = Read-Host

#########################################################################
# If user type YES, the unzip process starts, if not, the program 
# ends & the user can modify their zip-folder files/settings.
if ($YesNo -match "Yes")
{
    foreach ($item in $Files)
    {
        $itempath = ($item -replace '\s')
        Write-Host -ForegroundColor Cyan "Extracting file: $item"
        Expand-Archive -Path $itempath # -Force -ea 0
    }
}


Write-Host "Read if there's any errors, restart/adjust if needed." -ForegroundColor Red -BackgroundColor Yellow
Write-Host "Press enter to exit..."
Read-Host 

$FolderPath = $null
$Files = $null
$item = $null
$YesNo = $null