
carga <- function(a,m) {

  #cargamos librerías dependientes
  library("XML")

  #calculamos la fecha inicial y final (intervalo de fechas según intervalo definido por usuario)
  d <- "01"
  fecha_ini <- as.Date(paste(a,m,d, sep="-"),format="%Y-%m-%d")
  mes_siguiente <- seq(fecha_ini, length=2, by='1 month')[2] 
  fecha_fin <- seq(mes_siguiente, length=2, by='-1 day')[2] 
  
  #preparamos los parámetros para la consulta
  param_d <- format(as.Date(fecha_fin,format="%Y-%m-%d"), "%d")
  param_ndias <- param_d
  param_a <- a
  param_m <- m
  
  #leemos la información de la web
  url <- paste("http://www.ogimet.com/cgi-bin/gsynres?ord=REV&decoded=yes&ndays=", param_ndias, "&ano=", param_a, "&mes=", param_m, "&day=", param_d, "&hora=23&ind=08221", sep="")
  datos_bruto <- readHTMLTable(url)

  #preparamos los datos (nos quedamos con la información que nos interesa conocer)
  longitud <- length(datos_bruto[[1]][,1])-1
  datos_bruto <- datos_bruto[[1]][4:longitud,]
  datos_fecha <- datos_bruto$V1
  datos_hora <- datos_bruto$V2
  datos_fecha_hora <- paste(datos_fecha, datos_hora, sep=" ")
  #datos_fecha_hora <- as.Date(datos_fecha_hora, "%d/%m/%Y %h:%m")
  datos_temperatura <- datos_bruto$V3
  datos_dir_viento <- datos_bruto$V7
  datos_Vel_viento <- datos_bruto$V8

  #obtenemos el data frame con los datos recopilados
  datos <- data.frame(fecha = datos_fecha_hora, temperatura = datos_temperatura, dir_viento = datos_dir_viento, vel_viento = datos_Vel_viento)
  return(datos)
}


main <- function() {
  for (mes in 1:12){
    if (mes == 1) {
      res_datos <- carga(2008,mes)
    } else {
      res_datos <- rbind(res_datos, carga(2008,mes))
    }
  }
  return(res_datos)
}


resultado <- main()