cls
$computer = Read-Host "Computer"

invoke-command -cn $computer

{

 Get-ChildItem -Path Registry::HKEY_USERS | Where-Object {$_.PSChildName -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -and $_.PSChildName -notmatch '_Classes$'} | 
  
  ForEach-Object {

    $sid = $_.PSChildName
    $PrinterNames = ((Get-ItemProperty "Registry::HKEY_USERS\$sid\printers\connections\*").PSChildName)
    $remotepaths = (Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*").remotepath 
    $drives =  (Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*").pschildname
    $profilePath = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ProfileImagePath
 
   if ($profilePath -and (Test-Path $profilePath)) {
       
       $users =  [PSCustomObject]@{
            #SID = $sid
            UserName = $profilePath
            Printer     = $printernames
            ShareName  =  $remotepaths
            Drive      = $drives
        } # END CustomObject
      
      } #END If
}

} #END Invoke-Command