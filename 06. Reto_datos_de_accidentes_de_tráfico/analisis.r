
load <- function() {
  #instalación de paquetes
  install.packages("readxl")
  install.packages("ggplot2")
  install.packages("dplyr")
}

set_params <- function() {
  #carga de librerías
  library(readxl)
  library(ggplot2)
  library("dplyr")
  #establecimiento de parámetros
  #ruta de trabajo
  path <- paste(getwd(), "dat", sep = "/")
  #fallecidos por año
  file_fallecidos <- "Series-1993-2016_fallecidos-30-dias.xlsx"
  file_fallecidos_sheet <- "M_I-U_Meses"
  #parque automobilístico
  file_parque <- "series_parque_2016.xlsx"
  file_parque_sheet <- "parque_tipos"
}

evolucion_fallecidos <- function() {
  #cargamos los datos de fallecidos
  path_file <- paste(path, file_fallecidos, sep = "/")  
  ds_fallecidos <- read_excel(path_file, sheet = file_fallecidos_sheet, col_names = TRUE, col_types = NULL, skip = 2)
  ds_fallecidos <- data.frame("ano" = ds_fallecidos$Años,  "fallecidos" = ds_fallecidos$Total)
  #limpiamos el ds
  ds_fallecidos$fallecidos[is.na(ds_fallecidos$fallecidos)] <- 0
  #creamos la representación gráfica
  gra_fallecidos_ano <- ggplot(ds_fallecidos, aes(x = ds_fallecidos$ano, y = ds_fallecidos$fallecidos))
  gra_fallecidos_ano + geom_point() + geom_line() + labs(x = "Año", y = "Fallecidos") + labs(title = "Evolución de fallecidos por año", subtitle = "Datos: DGT")
}

evolucion_fallecidos_y_parque <- function() {
 }


                

#load()
set_params()
#evolucion_fallecidos()
#evolucion_fallecidos_y_parque()


#cargamos los datos de fallecidos
path_file_fallecidos <- paste(path, file_fallecidos, sep = "/")  
ds_fallecidos <- read_excel(path_file_fallecidos, sheet = file_fallecidos_sheet, col_names = TRUE, col_types = NULL, skip = 2)
ds_fallecidos <- data.frame("ano" = ds_fallecidos$Años,  "fallecidos" = ds_fallecidos$Total)
#cargamos los datos del parque
path_file_parque <- paste(path, file_parque, sep = "/")  
ds_parque <- read_excel(path_file_parque, sheet = file_parque_sheet, col_names = TRUE, col_types = NULL, skip = 2)
ds_parque <- data.frame("ano" = ds_parque$Años,  "fallecidos" = ds_parque$TOTAL)
#combinamos todos los datos en un único ds
ds_fallecidos_parque <- merge(x = ds_fallecidos, y = ds_parque, by = "ano", all = TRUE)
colnames(ds_fallecidos_parque) <- c("ano","fallecidos","parque")
#limpiamos el ds
ds_fallecidos_parque$fallecidos[is.na(ds_fallecidos_parque$fallecidos)] <- 0
ds_fallecidos_parque$parque[is.na(ds_fallecidos_parque$parque)] <- 0

ds_fallecidos_parque

mutate(ds_fallecidos, rate = ds_fallecidos_parque$fallecidos/ds_fallecidos_parque$parque)

#creamos la representación gráfica


##gra_fallecidos_ano <- ggplot(ds_fallecidos, aes(x = ds$ano, y = ds$fallecidos))
##gra_fallecidos_ano + geom_point() + geom_line() + labs(x = "Año", y = "Fallecidos") + labs(title = "Evolución de fallecidos por año", subtitle = "Datos: DGT")

