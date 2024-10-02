@echo off & title WIreless Pedal Controller Firmware Flasher 

goto :DOES_PYTHON_EXIST

:DOES_PYTHON_EXIST
python -V | find /v "Python" >NUL 2>NUL && (goto :PYTHON_DOES_NOT_EXIST)
python -V | find "Python"    >NUL 2>NUL && (goto :PYTHON_DOES_EXIST)
goto :EOF

:PYTHON_DOES_NOT_EXIST
echo Python is not installed on your system.
echo Now opeing the download URL.
start "" "https://www.python.org/downloads/windows/"
pause
goto :EOF

:PYTHON_DOES_EXIST
:: This will retrieve Python 3.8.0 for example.
for /f "delims=" %%V in ('python -V') do @set ver=%%V
echo Python is already installed Version is %ver% 
echo:

pip install esptool
echo:

SET mypath=%~dp0Update
pushd %mypath%
echo:
echo File List in %mypath% Directory :
dir /p
echo:


echo +++++++++++++++++++++++++++++++++++++++++++++++++++
echo  Wireless Pedal Tool Flasher 
echo +++++++++++++++++++++++++++++++++++++++++++++++++++
echo:
echo Available Port:
WMIC.exe path  win32_pnpentity  where "PNPClass='Ports'" get  Caption,Service,Manufacturer
echo Please double check in Device Manager 
echo:
set /p Port= Enter Device Port Number : 
echo Port is Set to : %Port% 
if not defined Port set "Port=COM0"
echo:

echo Default Baudrate is 921600 but you can change it 
set /p Baud= Enter Device Serial BAUDRATE : 
if not defined Baud set "Baud=921600"
echo Baud Rate : %Baud% 
echo:
esptool -p %Port% -b %Baud% --before default_reset --after hard_reset --chip esp32 write_flash --flash_mode dio --flash_size detect --flash_freq 40m 0x1000 Pedal_RX.bootloader.bin 0x8000 Pedal_RX.partitions.bin 0x10000 Pedal_RX.bin
pause






