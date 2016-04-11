echo "Installing .NET Framework 3.5 and 4.0"
powershell -Command Install-WindowsFeature -Restart -Name Net-Framework-Core,AS-Net-Framework
