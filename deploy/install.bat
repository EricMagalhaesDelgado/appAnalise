@echo off
chcp 65001

SET APPNAME=appAnalise

set MATLAB=%PROGRAMFILES%\MATLAB\R2024a
set MATLAB_RUNTIME=%PROGRAMFILES%\MATLAB\MATLAB Runtime\R2024a

set ZIP_FILE=%APPNAME%.zip
set INSTALL_DIR=%APPDATA%\ANATEL\%APPNAME%

set EXE_FILE=%INSTALL_DIR%\%APPNAME%.exe
set SHORTCUT_DIR=%USERPROFILE%\Desktop\%APPNAME%.lnk

:: Verifica prévia instalação do MATLAB
if not exist "%MATLAB%" if not exist "%MATLAB_RUNTIME%" (
    echo Erro: MATLAB Runtime R2024a ou MATLAB R2024a não encontrados.
    echo Instale o MATLAB Runtime R2024a para continuar.
    exit /b 1
)

:: Verifica se o arquivo ZIP de instalação existe
if not exist "%ZIP_FILE%" (
    echo Erro: Arquivo %ZIP_FILE% não encontrado. Operação cancelada.
    exit /b 1
)

:: Verifica se já existe versão antiga do app
if exist "%INSTALL_DIR%" (
    echo A pasta %INSTALL_DIR% já existe. Renomeando para %APPNAME%_old...
    if exist "%INSTALL_DIR%_old" (
        rmdir /s /q "%INSTALL_DIR%_old"
    )        
    ren "%INSTALL_DIR%" "%APPNAME%_old"
) else (
    echo A pasta %INSTALL_DIR% não existe. Criando a pasta...
    mkdir "%INSTALL_DIR%"
)

:: Descompacta o arquivo ZIP
echo Descompactando %ZIP_FILE%...
powershell -command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%'"
echo Movendo o conteúdo para %INSTALL_DIR%...

:: Verifica se o atalho já existe
if exist "%SHORTCUT_DIR%" (
    del "%SHORTCUT_DIR%"
    echo Atalho antigo deletado.
)

:: Criação do atalho na área de trabalho
echo Criando atalho na área de trabalho...
powershell -command ^
    $WshShell = New-Object -ComObject WScript.Shell; ^
    $Shortcut = $WshShell.CreateShortcut('%SHORTCUT_DIR%'); ^
    $Shortcut.TargetPath = '%EXE_FILE%'; ^
    $Shortcut.IconLocation = '%EXE_FILE%'; ^
    $Shortcut.Save()
echo Atalho criado com sucesso.

echo Operação concluída.
pause