# GPhotos Takeout Standarizer

Pequeño script de PowerShell para normalizar fechas del takeout de Google Photos y gestionar archivos entre directorios.

## Scripts

### GTS.ps1

Este script realiza las siguientes acciones:

1. **Toma la fecha y hora del JSON correspondiente**: Extrae la fecha y hora de los archivos `.json` asociados a las fotos y videos.
2. **Pisa la fecha y hora del nombre de la imagen**: Si es posible, utiliza la fecha y hora del nombre del archivo para mayor precisión.
3. **Elimina todos los archivos `.json` del directorio**: Limpia los archivos JSON una vez que se han utilizado.
4. **Elimina todos los duplicados por nombre**: Elimina archivos duplicados que Google puede haber creado durante la subida y categorización.

#### Uso

1. Ejecuta el script y proporciona la ruta del directorio a procesar cuando se te solicite.
2. El script procesará los archivos en el directorio y realizará las acciones mencionadas.

### PisarArchivos.ps1

Este script permite reemplazar archivos en un directorio A con archivos de un directorio B, basándose en una tolerancia de tamaño especificada.

#### Funcionalidades

1. **Ingresar directorios**: Solicita las rutas de los directorios A (viejos) y B (nuevos).
2. **Validación de directorios**: Verifica que los directorios sean distintos y existan.
3. **Reemplazo de archivos**: Reemplaza archivos en A con archivos de B si el tamaño está dentro del porcentaje de tolerancia especificado.
4. **Reporte de resultados**: Muestra la cantidad de archivos procesados, reemplazados y no reemplazados.
5. **Archivos no matcheados**: Los archivos en B que no coincidan con ningún archivo en A se dejan en el directorio B.

#### Uso

1. Ejecuta el script y proporciona las rutas de los directorios A y B, así como la tolerancia en porcentaje para el tamaño de los archivos.
2. El script procesará los archivos y realizará los reemplazos según las condiciones especificadas.

## TODO

- Incluir la data de GPS en el procesamiento de los archivos.
