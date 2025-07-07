cls

invoke-command -cn HFAT024LDD2VP73 {Get-ChildItem -Path Registry::HKEY_USERS | Where-Object {$_.PSChildName -match '^S-1-5-21-\d+-\d+-\d+-\d+$' -and $_.PSChildName -notmatch '_Classes$'} | 
  
  ForEach-Object {

    $sid = $_.PSChildName
    $PrinterNames = ((Get-ItemProperty "Registry::HKEY_USERS\$sid\printers\connections\*").PSChildName) 
    $printers = @(($PrinterNames.trim(",")).split(","))
    $remotepaths = @(Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*").remotepath
    $drives =  @(Get-ItemProperty "Registry::HKEY_USERS\$sid\Network\*").pschildname
    $profilePath = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$sid" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ProfileImagePath
 
    if ($profilePath -and (Test-Path $profilePath)) 

     {
  
      $results = [PSCustomObject]@{
              
                  $users = @(
                      Name = $profilePath
                      SID =  $sid
                      )
              
                 $Print = @(
                      Printer = $printers
                      )

                $Drive = @(
                     Paths = $remotepaths
                     Drive = $drives
                      )
      
                    } 
               
             }    
        
         # END CustomObject 
  
  
  #$results
  #$results | Export-Csv -Path "$env:temp\drives-printers.csv" -NoTypeInformation -append

    } # END Foreach Object

} # END Invoke-Command