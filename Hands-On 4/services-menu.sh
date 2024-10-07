#!/bin/bash

# Colores
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

# Función para mostrar el menú con colores
mostrar_menu() {
    echo -e "${CYAN}=============================${NC}"
    echo -e "${CYAN}     Menú de Servicios      ${NC}"
    echo -e "${CYAN}=============================${NC}"
    echo -e "${YELLOW}1)${NC} Listar el contenido de un fichero (carpeta)"
    echo -e "${YELLOW}2)${NC} Crear un archivo de texto con una línea de texto"
    echo -e "${YELLOW}3)${NC} Comparar dos archivos de texto"
    echo -e "${YELLOW}4)${NC} Mostrar contenido usando 'awk'"
    echo -e "${YELLOW}5)${NC} Buscar texto en un archivo usando 'grep'"
    echo -e "${YELLOW}6)${NC} Salir"
    echo -e "${CYAN}=============================${NC}"
}

# Función para listar contenido de una carpeta
listar_contenido() {
    read -p "Introduce la ruta absoluta de la carpeta: " ruta
    if [ -d "$ruta" ]; then
        echo -e "${GREEN}Contenido de $ruta:${NC}"
        ls "$ruta"
    else
        echo -e "${RED}Error: La ruta no es una carpeta válida.${NC}"
    fi
}

# Función para crear un archivo de texto con una línea
crear_archivo() {
    read -p "Introduce el nombre del archivo a crear: " archivo
    read -p "Introduce la cadena de texto para almacenar: " texto
    echo "$texto" > "$archivo"
    echo -e "${GREEN}Archivo '$archivo' creado con éxito. Contenido: ${NC}$texto"
}

# Función para comparar dos archivos de texto
comparar_archivos() {
    read -p "Introduce la ruta del primer archivo: " archivo1
    read -p "Introduce la ruta del segundo archivo: " archivo2
    if [ -f "$archivo1" ] && [ -f "$archivo2" ]; then
        echo -e "${GREEN}Comparando archivos...${NC}"
        diff "$archivo1" "$archivo2"
    else
        echo -e "${RED}Error: Uno o ambos archivos no son válidos.${NC}"
    fi
}

# Función para mostrar contenido usando awk
usar_awk() {
    read -p "Introduce la ruta del archivo para usar awk: " archivo
    if [ -f "$archivo" ]; then
        echo -e "${GREEN}Mostrando contenido con 'awk' (primer campo):${NC}"
        awk '{print $1}' "$archivo"
    else
        echo -e "${RED}Error: El archivo no es válido.${NC}"
    fi
}

# Función para buscar texto usando grep
usar_grep() {
    read -p "Introduce la palabra o texto a buscar: " texto
    read -p "Introduce la ruta del archivo donde buscar: " archivo
    if [ -f "$archivo" ]; then
        echo -e "${GREEN}Buscando '${texto}' en '${archivo}':${NC}"
        grep "$texto" "$archivo"
    else
        echo -e "${RED}Error: El archivo no es válido.${NC}"
    fi
}

# Bucle del menú
while true; do
    mostrar_menu
    read -p "Elige una opción: " opcion
    case $opcion in
        1) listar_contenido ;;
        2) crear_archivo ;;
        3) comparar_archivos ;;
        4) usar_awk ;;
        5) usar_grep ;;
        6) echo -e "${GREEN}Saliendo...${NC}"; exit 0 ;;
        *) echo -e "${RED}Opción no válida, por favor elige de nuevo.${NC}" ;;
    esac
done
