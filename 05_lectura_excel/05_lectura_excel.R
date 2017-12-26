
load <- function() {
  #lectura de ficheros Excel
  install.packages("readxl")
  library(readxl)
  library("tools")
}


get_year <- function(p_file_excel) {
  #extraemos el año del nombre del fichero
  year_f <- gsub("[^0-9]","",p_file_excel)
  #realizamos verificaciones y ajustes en el formato del año
  if (nchar(year_f) == 2) {
    year_f <- as.numeric(year_f)
    if (year_f >= 90) {year_f <- 1900 + year_f} else {year_f <- 2000 + year_f}
  } else if (nchar(year_f) > 0) {
    year_f <- as.numeric(year_f)
  } else {
    year_f <- 0
  }
  return(year_f)
}


get_first_row <- function(p_year_f) {
  #buscamos el año entre las excepciones
  i <- first_row_data_exceptions[as.character(p_year_f)]
  #si el año no es una excepción, devolveremos el valor por defecto
  if (is.na(i) == TRUE) { i <- first_row_data_default} else { i <- as.numeric(i) }
  return(i)
}


read_population <- function (p_file_excel, p_year_f) {
  #obtenemos el índice de la primera fila del fichero
  fil0 <- get_first_row(p_year_f) - 1
  #leemos el contenido del fichero
  data_f <- as.data.frame(read_excel(p_file_excel, sheet = 1, col_names = TRUE, skip = fil0))
  #ajustes de selección de columnas
  if (ncol(data_f) == 6) {
    data_f <- data_f[,c(1,2,4)]
  } else {
    data_f <- data_f[,c(1,3,5)]
  }
  #ajustes de selección de filas
  data_f <- data_f[ !is.na(data_f[1]) || !is.na(data_f[2]) || !is.na(data_f[3]) ,   ]
  return(data_f)
}


read <- function() {
  #cargamos las librerías necesarias
  load()
  #establecemos otros párametros iniciales
  #rutas y ficheros
  url <- "http://www.ine.es/pob_xls/pobmun.zip"
  path <- file.path("~", "datos/")
  file <- "pobmun.zip"
  file_result <- "resultado.csv"
  #índice de la fila de inicio
  first_row_data_default <- 3
  first_row_data_exceptions <- c(2,3,4,4,4,4)
  names(first_row_data_exceptions) <- c(1998,1999,2012,2013,2014,2015)
  #descargamos y descomprimimos el fichero
  pathf <- file.path(path, file)
  print(paste("Descargando el fichero: ", pathf))
  download.file(url, pathf)
  print(paste("Descomprimiendo el fichero: ", pathf))
  unzip(pathf, files = NULL, list = FALSE, overwrite = TRUE, junkpaths = FALSE, exdir = path, unzip = "internal", setTimes = FALSE)
  #procesamos cada fichero descomprimido
  ficheros <- dir(path)
  for (i in 1:length(ficheros)) {
    #fichero a procesar
    file <- ficheros[i]
    #sólo procesaremos ficheros con extexiones: "xls" o "xlsx"
    ext_file <- file_ext(file)
    if (ext_file == "xls" || ext_file == "xlsx") {
      file <- file.path(path, ficheros[i])
      print(paste("Procesando el fichero: ", file))
      #obtenemos el año del fichero
      year_f <- get_year(file)
      #leemos el contenido del fichero
      dat <- read_population(file, year_f)
      #añadimos el año procesado
      years <- matrix(rep(year_f,each=nrow(dat)), nrow=nrow(dat), byrow=TRUE)
      dat <- cbind(years, dat)
      names(dat) <- c("Año", "Cód. provincia", "Cód. población", "Población")
      #incorporamos la información al dataframe que almacena todos los resultados
      if (i == 1) {
          res_data <- dat
        } else {
          res_data <- rbind(res_data, dat)
      }
    }
    #borramos el fichero procesado
    if (file.exists(file)) file.remove(file)
    i <- i + 1
  }
  #borramos el fichero zip descargado
  print("Limpiando el entorno")
  unlink(pathf, recursive=TRUE)
  if (file.exists(pathf)) file.remove(pathf)
  #guaramos el dataframe
  print("Guardando resultados")
  write.csv(res_data, file = file.path(path, file_result),row.names=FALSE)
  print(paste("Resultados guardados en el fichero: ", file.path(path, file_result)))
  print("OPERACIONES FINALIZADAS CORRECTAMENTE")
}


read()
