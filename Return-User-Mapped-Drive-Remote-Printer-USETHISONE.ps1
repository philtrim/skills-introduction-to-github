# HFAT024LDD2VP73
cls
write-host "**** Return Mapped Drives and Network Printers ****"
write-host ""
$computer = read-host "Computer"
write-host ""

invoke-command -cn $computer  {Get-ChildItem -Path Registry::HKEY_USERS | Where-Object {$_.PSChildName -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -and $_.PSChildName -notmatch '_Classes$'} | 
  
  ForEach-Object {

    $sid = $_.PSChildName

    $profilePath = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ProfileImagePath

    if ($profilePath -and (Test-Path $profilePath)) 
   
     {
    
      $PrinterNames = ((Get-ItemProperty "Registry::HKEY_USERS\$sid\printers\connections\*").PSChildName)
      foreach ($printer in $printernames) 
       {    
        $profilepath.Remove(0,9) +" "+($printer.replace(",,","\\")).replace(",","\")
       }

    $remotepaths = (Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*")
     foreach ($path in $remotepaths) 
     {    
      $profilepath.Remove(0,9) +" "+($path.pschildname).toupper() + ":" +" "+ $path.remotepath
     }

   } # END If Profile matches

 } # END Foreach Object

} # END Invoke-Command