##  Latest one
cls
invoke-command -cn HFPPL016CLHXP73 {$hkusids = Get-Item "Registry::HKEY_USERS\*\" | Where-Object {$_.PSChildName -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -and $_.PSChildName -notmatch '_Classes$'}
  #$hkusids |  ForEach-Object {
  #$hkusids = Get-Item "Registry::HKEY_USERS\*\" | Where-Object {$_.PSChildName -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -and $_.PSChildName -notmatch '_Classes$'}
  $hkusids |  ForEach-Object {
  

    $sid = $_.PSChildName
    $PrinterNames = ((Get-ItemProperty "Registry::HKEY_USERS\$sid\printers\connections\*").PSChildName)
    $printers = @(($PrinterNames.trim(",")).split(","))
    $remotepaths = (Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*").remotepath 
    $drives =  (Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*").pschildname
    $profilePath = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ProfileImagePath
    
   if ($profilePath -and (Test-Path $profilePath)) 
   
  {
         $profile = [PSCustomObject]@{
            SID = $sid
            ProfilePath = $profilePath
            Printer     = $printers
            RemotePath =  $remotepaths
            DriveLetter = ($drives).toupper()+":"
        } # END CustomObject

        $profile
      
      } #END If

    } # END ForEach Object

} # END InvokeCommand