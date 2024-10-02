@echo off
echo Creando archivo 'mytext.txt' con la cadena "Hola Mundo"...
echo Hola Mundo > mytext.txt
echo.
echo Desplegando contenido de 'mytext.txt':
type mytext.txt
pause

echo Creando subdirectorio 'backup'...
mkdir backup
pause

echo Copiando 'mytext.txt' a la carpeta 'backup'...
copy mytext.txt backup
pause

echo Listando contenido del subdirectorio 'backup':
dir backup
pause

echo Eliminando archivo 'mytext.txt' de la carpeta 'backup'...
del backup\mytext.txt
pause

echo Eliminando el subdirectorio 'backup'...
rmdir backup
pause

echo Script finalizado.
