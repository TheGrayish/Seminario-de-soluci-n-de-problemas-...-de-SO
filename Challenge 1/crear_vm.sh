#!/bin/bash

# Comprobación de VBoxManage
if ! command -v VBoxManage &> /dev/null; then
    echo -e "🔍 VBoxManage no está disponible. Instala VirtualBox antes de continuar."
    exit 1
fi

# Mostrar banner inicial
function show_banner() {
    clear
    echo "══════════════════════════════════════════"
    echo "        🖥️ VirtualBox VM Creator 🖥️        "
    echo "══════════════════════════════════════════"
    echo ""
}

# Animación de carga
function loading_animation() {
    echo -n "$1"
    for i in $(seq 1 5); do
        echo -n "."
        sleep 0.4
    done
    echo " ¡Completado!"
}

# Validación de enteros
function is_integer() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        return 1
    else
        return 0
    fi
}

# Solicitar configuración de la VM
function request_config() {
    echo "📋 Configurando la nueva máquina virtual..."

    # Nombre de la VM
    read -p "Nombre de la máquina virtual: " VM_NAME
    while [ -z "$VM_NAME" ]; do
        read -p "❗ Por favor, introduce un nombre válido: " VM_NAME
    done

    # Tipo de sistema operativo
    read -p "Sistema Operativo (ej. Ubuntu_64, Fedora_64): " OS_TYPE
    while [ -z "$OS_TYPE" ]; do
        read -p "❗ Por favor, introduce un sistema operativo válido: " OS_TYPE
    done

    # Número de CPUs
    read -p "Número de CPUs (por defecto 2): " CPU_COUNT
    if ! is_integer "$CPU_COUNT"; then CPU_COUNT=2; fi

    # RAM (en GB)
    read -p "Cantidad de RAM en GB (por defecto 4): " RAM_GB
    if ! is_integer "$RAM_GB"; then RAM_GB=4; fi
    RAM_MB=$(($RAM_GB * 1024))

    # VRAM (en MB)
    read -p "Cantidad de VRAM en MB (por defecto 128): " VRAM_MB
    if ! is_integer "$VRAM_MB"; then VRAM_MB=128; fi

    # Tamaño del disco virtual
    read -p "Tamaño del disco duro en GB (por defecto 20): " DISK_SIZE
    if ! is_integer "$DISK_SIZE"; then DISK_SIZE=20; fi

    # Nombre del controlador SATA
    read -p "Nombre del controlador SATA (por defecto SATAController): " SATA_CONTROLLER
    SATA_CONTROLLER=${SATA_CONTROLLER:-SATAController}

    # Nombre del controlador IDE
    read -p "Nombre del controlador IDE (por defecto IDEController): " IDE_CONTROLLER
    IDE_CONTROLLER=${IDE_CONTROLLER:-IDEController}
}

# Crear y configurar la VM
function create_vm() {
    # Crear máquina virtual
    loading_animation "Creando máquina virtual $VM_NAME"
    VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register
    if [ $? -ne 0 ]; then
        echo "❌ Error creando la máquina virtual."
        exit 1
    fi

    # Configurar CPU, RAM y VRAM
    loading_animation "Configurando CPU, RAM y VRAM"
    VBoxManage modifyvm "$VM_NAME" --cpus "$CPU_COUNT" --memory "$RAM_MB" --vram "$VRAM_MB"
    if [ $? -ne 0 ]; then
        echo "❌ Error configurando la máquina virtual."
        exit 1
    fi

    # Crear disco duro virtual
    DISK_FILE="${VM_NAME}_disk.vdi"
    loading_animation "Creando disco duro virtual de ${DISK_SIZE}GB"
    VBoxManage createmedium disk --filename "$DISK_FILE" --size $(($DISK_SIZE * 1024)) --format VDI
    if [ $? -ne 0 ]; then
        echo "❌ Error creando el disco duro virtual."
        exit 1
    fi

    # Crear y asociar el controlador SATA
    loading_animation "Asociando controlador SATA"
    VBoxManage storagectl "$VM_NAME" --name "$SATA_CONTROLLER" --add sata --controller IntelAhci
    VBoxManage storageattach "$VM_NAME" --storagectl "$SATA_CONTROLLER" --port 0 --device 0 --type hdd --medium "$DISK_FILE"
    if [ $? -ne 0 ]; then
        echo "❌ Error configurando el controlador SATA."
        exit 1
    fi

    # Crear y asociar el controlador IDE
    loading_animation "Asociando controlador IDE"
    VBoxManage storagectl "$VM_NAME" --name "$IDE_CONTROLLER" --add ide
    VBoxManage storageattach "$VM_NAME" --storagectl "$IDE_CONTROLLER" --port 1 --device 0 --type dvddrive --medium emptydrive
    if [ $? -ne 0 ]; then
        echo "❌ Error configurando el controlador IDE."
        exit 1
    fi

    # Mostrar la información de la VM
    loading_animation "Finalizando configuración"
    VBoxManage showvminfo "$VM_NAME"
}

# Función principal
function main() {
    show_banner
    request_config
    create_vm
    echo "🎉 ¡Máquina virtual creada exitosamente!"
}

# Ejecutar el script
main
