$computers = "REVSOL2J45273","REVSOL5TQD573" #,"REVSOL8R5L6D3","REVSOLFTFD473"

foreach ($computer in $computers)

 
 {
  robocopy "\\eas.ds.ky.gov\dfs\ds_share\efs-d2\deploy\COMMON\Altova\XMLSpy 2020 R2 SP1 Enterprise XML Editor\32bit" "\\$computer\c$\source\Altova\XMLSpy 2020 R2 SP1 Enterprise XML Editor\32Bit" /s
  invoke-command -cn $computer {& cmd /c "C:\Source\Altova\XMLSpy 2020 R2 SP1 Enterprise XML Editor\32Bit\XMLSpyEnt2018.exe" ALLUSERS=1 CREATE_DESKTOP_SHORTCUT=No /qn /l+*vx C:\Windows\Temp\XMLSpy2018_Install.log}
 
 }
