#!/bin/bash

# Directorio original donde están todos tus proyectos
BASE_DIR="$HOME/Repository"

# 1. LISTA DE ELEMENTOS A SINCRONIZAR
# Aquí agregas a futuro cualquier carpeta, subcarpeta o archivo suelto.
ELEMENTOS=(
    "Fortran"
    "CPP"
    "Cobol"
    # Ejemplos a futuro:
    # "binance-scrapper.py"
    # "Java/DDoS-Methods"
)

echo "🔄 Sincronizando archivos desde $BASE_DIR..."

# 2. BUCLE RSYNC AUTOMATIZADO
for item in "${ELEMENTOS[@]}"; do
    if [ -d "$BASE_DIR/$item" ]; then
        # Es un directorio: crea la estructura si no existe y sincroniza
        mkdir -p "./$item"
        rsync -a --delete "$BASE_DIR/$item/" "./$item/"
    elif [ -f "$BASE_DIR/$item" ]; then
        # Es un archivo suelto: crea su carpeta padre (si aplica) y sincroniza
        mkdir -p "$(dirname "./$item")"
        rsync -a "$BASE_DIR/$item" "./$item"
    else
        echo "dvertencia: No se encontró '$BASE_DIR/$item'. Omitiendo..."
    fi
done

# 3. PREPARAR LOS CAMBIOS EN GIT
git add .

# 4. COMPROBAR SI REALMENTE HAY CAMBIOS
# git status --porcelain devuelve texto solo si hay modificaciones.
if [ -z "$(git status --porcelain)" ]; then
    echo "No hay cambios nuevos. Todo está al día."
    exit 0
fi

# 5. DETECTAR QUÉ CARPETAS O ARCHIVOS FUERON MODIFICADOS
# - git diff --name-only --cached: lista los archivos preparados.
# - awk -F'/' '{print $1}': extrae solo la carpeta o archivo principal (ej: de "CPP/main.cpp" saca "CPP").
# - sort -u: elimina duplicados.
# - paste -sd ", ": los une en una sola línea separados por coma.
CARPETAS_MODIFICADAS=$(git diff --name-only --cached | awk -F'/' '{print $1}' | sort -u | paste -sd ", " -)

# 6. CALCULAR NÚMERO DE COMMIT
# Cuenta los commits actuales. Si da error (porque es el primer commit de la historia), usa 0.
CANTIDAD_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo 0)
NUEVO_NUMERO=$((CANTIDAD_COMMITS + 1))

# 7. COMMIT Y PUSH
MENSAJE="Cambios N° $NUEVO_NUMERO asociado a $CARPETAS_MODIFICADAS"

echo "📦 Creando commit: \"$MENSAJE\""
git commit -m "$MENSAJE"

echo "🚀 Subiendo a GitHub..."
git push origin main

echo "🎉 ¡Sincronización completada exitosamente!"
