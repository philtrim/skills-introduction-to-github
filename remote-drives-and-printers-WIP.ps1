cls
$global:computer = 'HFAT024LDD2VP73'
invoke-command -cn $computer {$hkusids = Get-Item "Registry::HKEY_USERS\*\" | Where-Object {$_.PSChildName -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -and $_.PSChildName -notmatch '_Classes$'}
    $hkusids |  ForEach-Object {

    $sid = $_.PSChildName
    $Printers = @((Get-ItemProperty "Registry::HKEY_USERS\$sid\printers\connections\*").PSChildName)
    $ServerPaths = @(Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*") #.remotepath 
    $DriveLetters = @(Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*")#.pschildname
    $profilePath = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ProfileImagePath
    write-host "Computer: $using:computer" -ForegroundColor Yellow
   if ($profilePath -and (Test-Path $profilePath)) 
    
     {
      
      write-host "User:"$profilepath -ForegroundColor Green
      
      if ($printers)
        
        {
         foreach ($printer in $printers)
          
          {($printer.replace(",,","\\")).replace(",","\")}
        }
      
      else {write-host "No remote printers!" -ForegroundColor red} 
      
      if ($serverpaths)

        {
         foreach ($server in $serverpaths)

          {$Server.pschildname+": maps to --> "+ $server.remotepath}
        }

      else {write-host "No mapped drives!" -ForegroundColor red} 
      
      write-host ""
            
     } # END IF SID Matches


  }  # END ForeachObject

} # END Invoke-Command