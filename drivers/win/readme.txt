Use the install.bat batch file to pre-install arduino non-FTDI drivers.
It can also be used to remove the specific driver by passing 
"/U <INF_FILE_NAME>" paramters. Examples:
.\install.bat - pre-install all the drivers (no option to pick specific one)
.\install.bat /U "Arduino UNO.inf" - uninstall Arduino UNO driver
