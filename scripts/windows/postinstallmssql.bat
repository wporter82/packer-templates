@echo off

echo Disabling firewall
netsh advfirewall set allprofiles state off

echo Setting SQL Port to 1433
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPALL" /v TcpPort /t REG_SZ /d 1433 /f 
reg add "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL12.SQLSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPALL" /v TcpDynamicPorts /t REG_SZ /d "" /f 

echo Reverting server back to Core...
powershell -Command Remove-WindowsFeature -Restart User-Interfaces-Infra
