#!/bin/bash
# Imprimir en pantalla "Hello World"
echo "Hello World"

# Listar el contenido del directorio actual
ls

# Crear un directorio llamado Test si no existe
if [ ! -d "Test" ]; then
  echo "Creando directorio Test..."
  mkdir Test
fi

# Cambiarse al directorio Test
echo "Cambiando al directorio Test..."
cd Test || { echo "Error: No se pudo cambiar al directorio Test"; exit 1; }

# Listar el contenido del directorio Test (debería estar vacío)
echo "Listando el contenido de Test:"
ls
