# GPhotos Takeout Standarizer
 Pequeño script de powershell para normalizar fechas del takeout de google photos

GTS.ps1
1) Toma la fecha y hora del json correspondiente
2) Pisa la fecha y hora (si es posible) del nombre de la imagen. (Ya que es mas probable que el nombre contenga la fecha correcta antes que Google)
3) Elimina todos los .json del directorio
4) Elimina todos los duplicados por nombre (cosa que suele hacer google segun como se subieron y categorizaron los archivos)

PisarArchivos.ps1
Te permite ingresar un directorio A, un directorio B y un %+/- para pisar archivos por el del directorio B siempre que el % coincida.
Es util para reemplazar archivos que ya estaban por la nueva version y saber cuales no estaban ya que quedaran en B.
 
TODO
Incluir la data de GPS
