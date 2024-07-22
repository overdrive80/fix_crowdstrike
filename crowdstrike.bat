@echo off
chcp 65001 > nul
setlocal
Title Reset_CrowdStrike_v1.1 (GATI)

:rightsadmin
	SET "pulse_tecla=Pulse una tecla para continuar."
	set /a time_wait=5
	
	whoami /groups | find "S-1-5-32-544" >nul 2>&1
	
	IF %errorlevel% equ 0 (
		goto :checkSecureMode
	) ELSE (
	   COLOR 47
	   echo ######## ########  ########   #######  ########  
	   echo ##       ##     ## ##     ## ##     ## ##     ## 
	   echo ##       ##     ## ##     ## ##     ## ##     ## 
	   echo ######   ########  ########  ##     ## ########  
	   echo ##       ##   ##   ##   ##   ##     ## ##   ##   
	   echo ##       ##    ##  ##    ##  ##     ## ##    ##  
	   echo ######## ##     ## ##     ##  #######  ##     ## 
	   echo.
	   echo.
	   echo ####### ERROR: SE REQUIEREN PERMISOS DE ADMINISTRADOR #########
	   echo.
	   echo %pulse_tecla% & timeout %time_wait% >nul
	   goto bye
	)
	@echo ON

:checkdir
if not exist "%dirCrowd%" (
	echo No existe la ruta %dirCrowd%. %pulse_tecla%
	pause>nul
	goto bye
)

:checkSecureMode
reg query "HKLM\SYSTEM\CurrentControlSet\Control\Safeboot\Option" >nul 2>&1

if %errorlevel% neq 0 (
	echo El sistema no está en modo seguro. %pulse_tecla%
	pause>nul
    
    goto askmodesecure
)

:main
	set "dirCrowd=C:\Windows\System32\drivers\CrowdStrike"

	:checkfiles
	set "files=C-00000291*.sys"

	if not exist "%files%" (
		echo No se encontraron archivos con patrón "%files%". %pulse_tecla%
		pause>nul
		goto askreboot
	)
		
	:delefiles
	del /F /Q "%dirCrowd%\%files%" >nul
	
	echo Los archivos se eliminaron correctamente. %pulse_tecla%
	pause>nul
	goto askreboot


::--------------------------------------------------------------::

:askreboot
	set /p "restart=¿Quiere reiniciar el equipo? (S/N): "
	
	if /i "%restart%"=="s" (
		shutdown -r -f -t 0
		goto bye
	)
	
	if /i "%restart%"=="n" (
		goto bye
	) else (
		echo Solo se aceptan valores S o N. %pulse_tecla%
		pause>nul
		cls & goto askreboot
	)

:askmodesecure
	set /p "modesecure=¿Quiere reiniciar en modo seguro? (S/N): "
	
	if /i "%modesecure%"=="s" (
		shutdown -r -o -t 0
		goto bye
	)
	
	if /i "%modesecure%"=="n" (
		goto bye
	) else (
		echo Solo se aceptan valores S o N. %pulse_tecla%
		pause>nul
		cls & goto askmodesecure
	)
	
:bye
exit /b