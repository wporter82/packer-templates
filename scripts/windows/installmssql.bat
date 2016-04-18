@echo off

echo Installing SQL Server 2014 Express, it will take a while...
C:\Users\vagrant\SQLEXPR_x64_ENU.exe /Q /ACTION=INSTALL /INDICATEPROGRESS /IACCEPTSQLSERVERLICENSETERMS /FEATURES="SQLEngine,Conn" /TCPENABLED=True /SECURITYMODE=SQL /SAPWD="vagrant!@3" /UPDATEENABLED=True /ERRORREPORTING=False /SQLSYSADMINACCOUNTS=vagrant /INSTANCENAME="SQLServer"
echo Done!

echo Reverting server back to Core...
powershell -Command Remove-WindowsFeature -Restart User-Interfaces-Infra

echo Disabling firewall
netsh advfirewall set allprofiles state off

echo Setting SQL Port to 1433
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPALL" /v TcpPort /t REG_SZ /d 1433 /f 
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPALL" /v TcpDynamicPorts /t REG_SZ /d "" /f 
