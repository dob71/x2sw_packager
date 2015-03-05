Use the install.bat batch file to pre-install arduino non-FTDI drivers.
It can also be used to remove the specific driver by passing 
"/U <INF_FILE_NAME>" paramters. 
The installer now comes with only one INF (from Arduino 1.0.6 distribution) 
supporting multiple Arduino boards.
Examples:
.\install.bat - pre-install all INF files (no option to pick specific one)
.\install.bat /U "Arduino.inf" - uninstall Arduino all-in-one diver
